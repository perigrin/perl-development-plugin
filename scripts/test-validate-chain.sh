#!/usr/bin/env bash
# ABOUTME: Tests that validate-chain.sh catches broken conditions.
# ABOUTME: Creates a bad issue, runs validation expecting failure, then cleans up.

set -euo pipefail

PASS=0
FAIL=0

check() {
    local desc="$1"
    local expected="$2"
    local actual="$3"
    if [ "$actual" = "$expected" ]; then
        echo "PASS: $desc"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $desc (expected $expected, got $actual)"
        FAIL=$((FAIL + 1))
    fi
}

# Test 1: Create an issue with no acceptance criteria, verify validation catches it
echo "--- Test: missing AC detection ---"
ISSUE_ID=$(printf -- '---\ntitle: "TESTBAD: no acceptance criteria"\n---\n\nThis issue has no AC section.\n' \
    | git zhi issue add --milestone plugin-infrastructure 2>/dev/null \
    | grep -oP '019[a-f0-9-]+' | head -1)

if [ -z "$ISSUE_ID" ]; then
    echo "FAIL: Could not create test issue"
    FAIL=$((FAIL + 1))
else
    # Run validation — should fail
    if ./scripts/validate-chain.sh > /dev/null 2>&1; then
        check "validate-chain catches missing AC" "fail" "pass"
    else
        check "validate-chain catches missing AC" "fail" "fail"
    fi

    # Clean up: purge the test issue
    git zhi issue edit "$ISSUE_ID" --purge --yes 2>/dev/null || true
fi

# Summary
echo ""
echo "=== Test Summary ==="
echo "Pass: $PASS"
echo "Fail: $FAIL"

if [ "$FAIL" -gt 0 ]; then
    exit 1
else
    exit 0
fi
