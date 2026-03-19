---
name: detect-version
description: Detect the active Perl version from multiple sources and return the recommended writing skill. Not invoked directly by users.
---

# perl:detect-version

Detect the active Perl version for the current project. This skill is not
invoked directly — it is called by `write-perl.md` and other skills that
need version-aware behavior.

## Detection Cascade

Try each source in order. Stop at the first match.

### 1. Read `.perl-version`

Check the current directory and ancestor directories for a `.perl-version`
file. This is the primary signal — it is explicit and intentional.

### 2. Run the backend's "current version" command

If `perl:require-toolchain` has identified a backend:

| Backend | Command |
|---|---|
| PVM | `pvm current` |
| custom | Use the "Current version" entry from the CLAUDE.md capability table |

### 3. Scan `use VERSION` in source files

Search `lib/**/*.pm` and `*.pl` for `use VERSION` statements:

```
use 5.042;
use 5.040;
use v5.38.0;
```

Take the highest version found. If versions disagree across files, report
the range and ask the user.

### 4. Unknown — ask the user

> "I couldn't detect a Perl version for this project. Which version
> should I target? (Default: highest installed version)"

## Version Conflict Resolution

When `.perl-version` and cpanfile `perl` requirement disagree (e.g.,
`.perl-version` is 5.42.0 but cpanfile says `requires 'perl', 'v5.40.2'`),
warn the user:

> "Version conflict detected:
>   .perl-version:  5.42.0 (your development runtime)
>   cpanfile:        v5.40.2 (project compatibility target)
>
> Which should I target for code generation?
> 1. 5.40.2 (compatibility target — recommended)
> 2. 5.42.0 (development runtime)"

Default to the cpanfile requirement (compatibility target) if the user
doesn't respond. Writing 5.42-specific code (`:writer`, lexical methods)
when the project targets 5.40 would break compatibility.

## Version to Skill Mapping

| Version range | Skill | Notes |
|---|---|---|
| 5.42.x | `perl:write-5.42` | `:writer`, lexical methods, `use utf8` required |
| 5.40.x | `perl:write-5.40` | Minimum reliable `feature 'class'` |
| 5.38.x | `perl:write-5.38` | `Feature::Compat::Class`, explicit builtins |
| 5.36.x | `perl:write-5.36` | Signatures stable, no native class |
| < 5.36 or CPAN dist | `perl:write-toolchain` | Broad compatibility 5.20+ |
| Unknown | Ask; default to `perl:write-5.42` if confirmed | |

## Return Value

This skill returns three pieces of information to the calling skill:

1. **Version string** — e.g., `5.42.0`
2. **Detection source** — e.g., `.perl-version`, `pvm current`, `use VERSION scan`
3. **Recommended skill name** — e.g., `perl:write-5.42`
