---
name: reviewing-perl
description: Static analysis and code review with perltidy, perlcritic, and version-aware idiom checking
trigger: When reviewing Perl code for quality, style, or correctness
---

I'm using the perl:review skill for Perl static analysis.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Commands

```bash
perltidy -b lib/**/*.pm t/**/*.t    # Format in-place
perlcritic --severity 3 lib/         # Standard review
perlcritic --severity 1 lib/         # Pre-release deep review
```

## Standard .perlcriticrc

```ini
severity = 3
theme = core

[-Perl::Critic::Policy::Documentation::RequirePodAtEnd]
[-Perl::Critic::Policy::Documentation::RequirePodSections]
[-Perl::Critic::Policy::Modules::RequireVersionVar]
[-Perl::Critic::Policy::ClassHierarchies::ProhibitExplicitISA]
```

## What to Flag

Version-aware idiom checking — flag these patterns based on the project's
target Perl version:

| Pattern | Flag when | Replacement |
|---|---|---|
| `@_` extraction in subs | `method` keyword available (5.38+) | Use signatures |
| `Test::More` in tests | Any version | Migrate to `Test2::V0` |
| `print` instead of `say` | 5.10+ | Use `say` |
| `1`/`0` for booleans | 5.40+ (`true`/`false` available) | Use `true`/`false` |
| Missing `use utf8` | 5.42 files with non-ASCII | Add `use utf8` |
| `Feature::Compat::Class` | 5.38+ code | Use native `feature 'class'` (5.40+ preferred) |
| Operator overloading | Performance-sensitive paths | Prefer explicit methods |
| `@$ref` dereferencing | 5.20+ | Use `$ref->@*` |
