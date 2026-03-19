# CLAUDE.md

This is the `perl-development` Claude Code plugin. It provides Perl
development skills, not application code. The deliverables are markdown
skill files, not compiled binaries.

For project structure, skill conventions, and testing approach, see
[CONTRIBUTING.md](CONTRIBUTING.md).

## What This Project Produces

Markdown skill files in `skills/` and command files in `commands/` that
Claude Code loads as a plugin. Each skill teaches Claude how to perform
a specific Perl development task correctly.

## How to Work Here

- Read [CONTRIBUTING.md](CONTRIBUTING.md) for the project structure
- The plugin PRD is at https://github.com/perigrin/git-zhi/blob/pu/docs/PRD/pvm-plugin-prd.md
- Skills are markdown with YAML frontmatter — no compilation step
- Test skills by invoking them against the validation repos (Chalk, Iterum, Blawd, Registry)
- PVM is the reference toolchain backend — see `skills/using-pvm/`

## Conventions

- Every skill file starts with YAML frontmatter (`name`, `description`)
- Skills announce themselves: "I'm using the perl:<name> skill..."
- Runtime skills include `perl:require-toolchain` as a prerequisite
- Writing skills are version-specific — the `write-perl.md` command dispatches
- Test2::V0 everywhere — never Test::More in new code
- Real-data tests, not toy examples

## Related Projects

- [git-zhi](https://github.com/perigrin/git-zhi) — the task graph this plugin is tracked in
- [crochet](https://github.com/perigrin/crochet) — intelligence layer for git-zhi
- [PVM](https://github.com/perigrin/pvm) — the reference Perl version manager
