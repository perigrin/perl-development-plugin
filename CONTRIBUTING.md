# Contributing to perl-development

## What This Is

A Claude Code plugin providing agentic Perl development skills — version-aware
code generation, testing, debugging, dependency management, static analysis,
and regression testing across Perl's production version matrix.

## Project Structure

```
.claude-plugin/
  plugin.json           plugin metadata
skills/
  setup/                project scaffolding and toolchain selection
  detect-version/       active Perl version detection
  require-toolchain/    shared dependency gate for runtime skills
  using-pvm/            PVM backend: install procedure + capability map
  using-custom/         manual capability table for non-PVM setups
  writing-perl-5.42/    modern Perl 5.42 code generation
  writing-perl-5.40/    Perl 5.40 code generation
  writing-perl-5.38/    Perl 5.38 code generation
  writing-perl-5.36/    Perl 5.36 code generation
  writing-perl-toolchain/  CPAN/toolchain code targeting 5.20+
  testing-perl/         Test2::V0 testing patterns
  testing-mojolicious/  Mojolicious-specific testing (Test::Mojo, Test2::MojoX)
  debugging-perl/       systematic debugging with PSC and toolchain
  managing-perl-deps/   CPAN dependency management via cpanfile
  reviewing-perl/       perlcritic, perltidy, static analysis
  regression-testing/   version matrix testing via PVM binary cache
commands/
  setup.md              → perl:setup
  write-perl.md         → perl:detect-version + appropriate write skill
  test-perl.md          → perl:test
  test-mojolicious.md   → perl:test-mojolicious
  debug-perl.md         → perl:debug
  manage-deps.md        → perl:manage-deps
  review-perl.md        → perl:review
  regression-test.md    → perl:regression-test
```

## Developing Skills

Each skill is a markdown file in `skills/<name>/<name>.md` with YAML frontmatter:

```yaml
---
name: skill-name
description: One-line description of what the skill does
---
```

Skills follow these conventions:

- **Self-announcing:** Each skill prints "I'm using the perl:<name> skill..." at invocation
- **Prerequisites:** Runtime skills include `perl:require-toolchain` to verify a backend is configured
- **Version-aware:** Writing skills are version-specific; the `write-perl.md` command handles dispatch

## Testing Skills

Skills are tested by invoking them against the four validation repositories:

| Repo | Perl version | Key stress |
|------|-------------|------------|
| Chalk (bootstrap branch) | 5.42 | class syntax, XS target |
| Iterum | 5.40 | Feature::Compat::Class, terminal UI |
| Blawd | older Perl | legacy Dist::Zilla, sparse history |
| Registry (Tamarou/Registry) | 5.40+ | Mojolicious, HTMX, PostgreSQL |

## Adding a New Toolchain Backend

See the plugin PRD's "Community Contribution Path" section. The key steps:

1. Create `skills/using-<backend>/using-<backend>.md` with install procedure and capability table
2. Update `perl:setup` to offer it as an option
3. Update `perl:require-toolchain` to recognize `<!-- Backend: <backend> -->`

## License

Artistic License 2.0
