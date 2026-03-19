---
name: testing-perl
description: Write and run Perl tests using Test2::V0 — TDD workflow, real-data testing, Test::More migration
trigger: When writing or running Perl tests
---

I'm using the perl:test skill to write Perl tests.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Standard Boilerplate

```perl
use Test2::V0;

# ... tests

done_testing;
```

## Key Test2::V0 Patterns

| Pattern | Purpose |
|---|---|
| `is($got, $expected)` | Deep comparison — replaces `is` and `is_deeply` |
| `like($got, qr/pattern/)` | Regex or structural matching |
| `ok($condition)` | Boolean assertion |
| `dies_ok { ... }` | Expect code to die (replaces Test::Exception) |
| `lives_ok { ... }` | Expect code to survive |
| `warnings_like { ... }` | Check warning output (replaces Test::Warn) |
| `mock()` | Scoped auto-cleaning mocking |
| `subtest 'name' => sub { ... }` | Grouped tests |
| `done_testing` | No plan required |

## Running Tests (PVM backend)

```bash
pvx prove -lr t/                    # Run all tests
pvx prove -lv t/unit/specific.t     # Run one test verbose
pvx yath t/                         # Alternative runner
```

## TDD Workflow

1. Write failing test first
2. Write minimal implementation to pass
3. Run — expect pass
4. Refactor
5. Run full suite

## Test Theater Warning

Tests must use **real inputs**, not toy examples. A parser should parse
actual files. A serializer should round-trip real data. 100% coverage
with synthetic inputs is false confidence — real inputs expose bugs that
synthetic ones miss. Always validate against production-representative
data before considering a test suite complete.

## Parallel Review Pattern

After each significant implementation phase, run three parallel review agents:

1. **Correctness reviewer** — does it match requirements?
2. **Test coverage reviewer** — are tests comprehensive and using real data?
3. **Performance reviewer** — scaling issues, unnecessary allocations?

## Migration from Test::More

| Test::More | Test2::V0 |
|---|---|
| `is_deeply($a, $b)` | `is($a, $b)` |
| `isa_ok($obj, 'Class')` | `isa_ok($obj, ['Class'], 'message')` |
| `plan tests => N` | Remove; keep `done_testing` |
| `use Test::Exception` | Built-in: `dies_ok`, `lives_ok` |
| `use Test::Warn` | Built-in: `warnings_like` |
