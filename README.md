# perl-development

Agentic Perl development skills for Claude Code. Version-aware code
generation, Test2 testing, dependency management, static analysis, and
regression testing across the production version matrix.

PVM is the reference toolchain backend. Alternative backends (plenv,
perlbrew, custom) are a community contribution path.

## Installation

```
/plugin marketplace add perigrin/claude-plugins-marketplace
/plugin install perl-development
```

## Quick Start

```
perl:setup          # Configure toolchain and Perl version
perl:write-perl     # Write version-appropriate Perl code
perl:test-perl      # Write and run Test2::V0 tests
perl:review-perl    # Static analysis with perlcritic
```

## Skills

| Skill | Command | Purpose |
|---|---|---|
| `perl:setup` | `perl:setup` | Select backend, scaffold project |
| `perl:using-pvm` | (injected by setup) | PVM install + capability map |
| `perl:require-toolchain` | (internal) | Verify backend configured |
| `perl:detect-version` | (internal) | Detect active Perl version |
| `perl:write-5.42` | `perl:write-perl` (dispatched) | Modern Perl 5.42 |
| `perl:write-5.40` | `perl:write-perl` (dispatched) | Perl 5.40 |
| `perl:write-5.38` | `perl:write-perl` (dispatched) | Perl 5.38 |
| `perl:write-5.36` | `perl:write-perl` (dispatched) | Perl 5.36 |
| `perl:write-toolchain` | `perl:write-perl` (dispatched) | CPAN / toolchain 5.20+ |
| `perl:test` | `perl:test-perl` | Test2::V0, prove, real-data testing |
| `perl:test-mojolicious` | `perl:test-mojolicious` | Test::Mojo |
| `perl:debug` | `perl:debug-perl` | Source analysis, debugging |
| `perl:manage-deps` | `perl:manage-deps` | Module install, cpanfile |
| `perl:review` | `perl:review-perl` | perlcritic, perltidy |
| `perl:regression-test` | `perl:regression-test` | Matrix testing via binary cache |

## Community Contribution Path

To add a new toolchain backend (e.g. plenv):

1. Create `skills/using-plenv/using-plenv.md` with install procedure and
   capability table
2. Update `perl:setup` to offer plenv as an option
3. Update `perl:require-toolchain` to recognize `<!-- Backend: plenv -->`
4. Document any limitations clearly

The writing, testing, and review skills require no changes — they work
through the capability abstraction.

## License

Artistic License 2.0
