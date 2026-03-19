#!/usr/bin/env bash
# ABOUTME: Validates the git-zhi issue chain for structural correctness.
# ABOUTME: Checks AC presence, dependency resolution, milestone assignment, and cycle detection.

set -euo pipefail

ISSUES_JSON=$(git zhi issue list --all --format json 2>/dev/null)
if [ -z "$ISSUES_JSON" ] || [ "$ISSUES_JSON" = "[]" ]; then
    echo "ERROR: No issues found in chain"
    exit 1
fi

echo "$ISSUES_JSON" | python3 -c "
import json, sys

issues = json.load(sys.stdin)
errors = []
warnings = []

print(f'INFO:  Found {len(issues)} issues')

# Check 1: All issues have acceptance criteria
print('INFO:  Checking acceptance criteria...')
for i in issues:
    body = i.get('body', '')
    if '## Acceptance Criteria' not in body and '- [ ]' not in body:
        errors.append(f'Missing acceptance criteria: {i[\"title\"][:60]}')

# Check 2: Dependencies resolve
print('INFO:  Checking dependency resolution...')
all_ids = set(i['id'] for i in issues)
for i in issues:
    for dep in i.get('blocked_by', []):
        if dep not in all_ids:
            errors.append(f'Unresolved dependency in \"{i[\"title\"][:40]}\": {dep[:12]}')
    for dep in i.get('blocks', []):
        if dep not in all_ids:
            errors.append(f'Unresolved dependency in \"{i[\"title\"][:40]}\": {dep[:12]}')

# Check 3: All issues assigned to a milestone
print('INFO:  Checking milestone assignment...')
for i in issues:
    ms = i.get('milestone', '')
    if not ms:
        errors.append(f'No milestone assigned: {i[\"title\"][:60]}')

# Check 4: No circular dependencies
print('INFO:  Checking for circular dependencies...')
graph = {i['id']: i.get('blocked_by', []) for i in issues}

def has_cycle(node, visited, stack):
    visited.add(node)
    stack.add(node)
    for dep in graph.get(node, []):
        if dep in stack:
            return True
        if dep not in visited and has_cycle(dep, visited, stack):
            return True
    stack.discard(node)
    return False

visited = set()
for node in graph:
    if node not in visited:
        if has_cycle(node, visited, set()):
            errors.append('Circular dependency detected in chain')
            break

# Report
for e in errors:
    print(f'ERROR: {e}')
for w in warnings:
    print(f'WARN:  {w}')

print()
print('=== Validation Summary ===')
print(f'Issues:   {len(issues)}')
print(f'Errors:   {len(errors)}')
print(f'Warnings: {len(warnings)}')

if errors:
    print('FAILED')
    sys.exit(1)
else:
    print('PASSED')
"
