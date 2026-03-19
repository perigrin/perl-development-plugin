---
name: setup
description: Scaffold a Perl project for agentic development — toolchain selection, version setup, dependency file, CLAUDE.md injection, legacy skill migration
trigger: User says "set up Perl", "initialize this Perl project", or any skill fails because no toolchain is configured
---

# perl:setup

Configure a Perl project for agentic development with the perl-development
plugin.

## Phase 1: Toolchain Selection

Check for evidence of an existing toolchain:

- Is `pvm` on `$PATH`?
- Is `plenv` on `$PATH`?
- Is `perlbrew` on `$PATH`?
- Is there a `.perl-version` file?

If a backend is clearly in use, confirm:

> "I can see PVM is installed. Should I configure this project to use PVM?
> (Other options: plenv, perlbrew, custom)"

If nothing detected or ambiguous, ask:

> "Which Perl toolchain would you like to use?
>
> 1. PVM (default, recommended)
> 2. plenv
> 3. perlbrew
> 4. Other (configure manually)"

## Phase 2: Backend Setup

Delegate entirely to the selected backend skill:

- **PVM selected:** invoke `perl:using-pvm` — handles installation if
  needed, PATH checking, symlink creation, and verification
- **plenv selected:** invoke `perl:using-plenv` (not in v0.1 — explain
  and offer PVM or custom instead)
- **perlbrew selected:** invoke `perl:using-perlbrew` (not in v0.1 — same)
- **Other:** invoke `perl:using-custom` — prompt user to fill in capability
  table

## Phase 3: Perl Version Setup

Check for `.perl-version`. If absent:

1. Scan for `use VERSION` in existing `.pm` or `.pl` files
2. If none found, ask which Perl version to target
3. Install if needed (`perl:using-pvm` handles this via `pvm install`)
4. Write `.perl-version`

## Phase 4: Dependency File Setup

If no `cpanfile` exists, create one:

```perl
# cpanfile
requires 'perl', '5.036';

on test => sub {
    requires 'Test2::V0';
};
```

Adjust `perl` version to match `.perl-version`.

## Phase 5: CLAUDE.md Injection

Append the Perl development block if absent:

```markdown
## Perl Development

<!-- Backend: pvm -->
<!-- Include the perl:using-pvm skill for toolchain commands -->

### Version Detection

Before writing Perl code, detect the active version:

1. Read `.perl-version` if present
2. Run `pvm current` (or backend equivalent) if absent
3. Check for `use VERSION` in existing source files

Select the appropriate writing skill:
- Perl 5.42.x -> `perl:write-5.42`
- Perl 5.40.x -> `perl:write-5.40`
- Perl 5.38.x -> `perl:write-5.38`
- Perl 5.36.x -> `perl:write-5.36`
- Perl 5.20-5.34 or CPAN dist -> `perl:write-toolchain`
```

The `<!-- Backend: pvm -->` comment is machine-readable —
`perl:require-toolchain` reads it to determine which capability map to
include.

## Phase 6: Migrate from Superpowers Writing Skills

Check for legacy `writing-perl-*` skills:

```bash
ls ~/.claude/skills/writing-perl-* 2>/dev/null
```

If found, offer to remove them:

> "I found legacy Perl writing skills in ~/.claude/skills/:
>   writing-perl-5.42.0, writing-perl-5.38.0, writing-perl-toolchain
>
> The perl-development plugin supersedes these with corrected versions.
> Remove the old skills? (They can be reinstalled from superpowers if needed.)"

On confirmation, remove the old skill directories.
