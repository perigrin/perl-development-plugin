---
name: using-custom
description: Manual capability table for bespoke or corporate Perl setups — prompts user to fill in commands, writes result to CLAUDE.md
---

# perl:using-custom

For bespoke or corporate Perl setups where PVM, plenv, and perlbrew are not
in use. During `perl:setup`, if the user selects "Other", this skill prompts
them to fill in the capability table manually. The result is written to the
project's CLAUDE.md.

## Process

Present this table and ask the user to fill in each capability with the
concrete command their setup uses:

```markdown
## Toolchain: Custom

Fill in commands for your Perl setup:

| Capability | Command |
|---|---|
| Install Perl version | ___________________ |
| Switch Perl version | ___________________ |
| Current version | ___________________ |
| Install CPAN module | ___________________ |
| Run script | ___________________ |
| Run tests | ___________________ |
| Parse source | ___________________ |
```

If the user leaves a capability blank, record it as "N/A" — not all setups
support all capabilities (e.g., a corporate setup may not allow installing
new Perl versions).

## CLAUDE.md Injection

Once the table is filled in, append this block to the project's CLAUDE.md:

```markdown
## Perl Development

<!-- Backend: custom -->

### Toolchain Commands

| Capability | Command |
|---|---|
| Install Perl version | {user-provided} |
| Switch Perl version | {user-provided} |
| Current version | {user-provided} |
| Install CPAN module | {user-provided} |
| Run script | {user-provided} |
| Run tests | {user-provided} |
| Parse source | {user-provided} |
```

The `<!-- Backend: custom -->` comment is machine-readable —
`perl:require-toolchain` reads it to determine which capability map to use.
