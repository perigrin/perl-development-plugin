---
name: managing-perl-deps
description: Install and manage CPAN dependencies via cpanfile and PVM module commands
trigger: When installing, updating, or managing Perl module dependencies
---

I'm using the perl:manage-deps skill to manage Perl dependencies.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## PVM Module Commands

```bash
pvm module install Mojolicious      # Install a specific module
pvm module install                  # Install all from cpanfile
pvm module list | grep Module       # Check if installed
```

## cpanfile Format

```perl
requires 'perl', '5.036';
requires 'Mojolicious', '9.0';
recommends 'Cpanel::JSON::XS';

on test => sub {
    requires 'Test2::V0';
    requires 'Test2::Suite';
};

on develop => sub {
    requires 'Perl::Critic';
    requires 'Perl::Tidy';
    requires 'Devel::Cover';
};
```

## Feature::Compat::Class Versions

Only for projects targeting < 5.38:

- `requires 'Feature::Compat::Class', '0.07'` — for `:reader` support
- `requires 'Feature::Compat::Class', '0.08'` — for `:writer` support

Do not add `Feature::Compat::Class` to projects targeting 5.40+ — native
`feature 'class'` is reliable there.

## Dist::Zilla Coexistence

When a project uses `dist.ini` (Dist::Zilla) instead of cpanfile, the two
can coexist. Dist::Zilla reads cpanfile via the `[Prereqs::FromCPANfile]`
plugin.

If the project has `dist.ini` but no cpanfile:

1. Offer to create a cpanfile alongside dist.ini
2. Explain: "cpanfile and dist.ini coexist — add `[Prereqs::FromCPANfile]`
   to dist.ini and Dist::Zilla will read dependencies from cpanfile."
3. If the user declines, note that dependency management will be limited
   to what `[AutoPrereqs]` detects from source.

## Checking Core Modules

Before adding a dependency, check if it's in core:

```bash
corelist Module::Name
```

Core modules don't need to be in cpanfile `requires` (though listing them
with a minimum version is acceptable for clarity).
