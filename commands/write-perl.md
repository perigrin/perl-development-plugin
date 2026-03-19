---
name: write-perl
description: Write Perl code with automatic version detection and skill dispatch — the primary code generation entry point
---

# perl:write-perl

The primary entry point for writing Perl code. Detects the active Perl
version and dispatches to the appropriate version-specific writing skill.

## Process

1. Invoke `perl:require-toolchain` to verify a backend is configured.
2. Invoke `perl:detect-version` to determine the target Perl version.
3. Dispatch to the recommended writing skill:

| Detected version | Skill |
|---|---|
| 5.42.x | `perl:write-5.42` |
| 5.40.x | `perl:write-5.40` |
| 5.38.x | `perl:write-5.38` |
| 5.36.x | `perl:write-5.36` |
| < 5.36 or CPAN dist | `perl:write-toolchain` |

4. Follow the dispatched skill's conventions for all code written in
   this session.

If `perl:detect-version` returns "unknown" and the user confirms a version,
dispatch accordingly. If the user declines to specify, default to
`perl:write-5.42` (highest available).
