---
name: debugging-perl
description: Systematic Perl debugging using psc, pvx, and standard diagnostic tools
trigger: When debugging Perl code, test failures, or runtime errors
---

I'm using the perl:debug skill for systematic Perl debugging.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Tool Hierarchy (PVM backend)

Use in this order — start with the least invasive tool:

1. `psc parse <file>` — AST inspection. Reveals syntax structure without running code.
2. `psc analyze lib/` — Dependency analysis. Shows module relationships.
3. `pvx -w <script>` — Run with warnings enabled.
4. `pvx perl -d:Trace <script>` — Execution tracing. Shows every line executed.
5. `pvx perl -MDevel::Cover <script>` — Coverage analysis.

## Process

1. **Reproduce:** Run the failing test in isolation with verbose output:
   ```bash
   pvx prove -lv t/failing.t
   ```

2. **Parse:** Inspect the affected file's structure:
   ```bash
   psc parse lib/Affected.pm
   ```

3. **Inspect:** Add targeted inspection at the suspicious point:
   ```perl
   use Data::Dumper;
   say STDERR Dumper($suspect);
   ```

4. **Warnings:** Run with full warnings:
   ```bash
   pvx perl -w lib/Affected.pm
   ```

5. **Lint:** Run perlcritic at maximum sensitivity:
   ```bash
   perlcritic --severity 1 lib/Affected.pm
   ```

6. **Clean up:** Remove all debug output (`Data::Dumper`, `say STDERR`)
   before committing. Debug output must never be committed.
