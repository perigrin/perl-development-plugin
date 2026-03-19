---
name: require-toolchain
description: Shared dependency gate — verifies a Perl toolchain is configured before other skills proceed. Not invoked directly by users.
---

# perl:require-toolchain

Verify that a Perl toolchain is configured for the current project. This
skill is included by all skills that need to run Perl. It is not invoked
directly by users.

## Process

1. Read the project's CLAUDE.md (current directory or ancestor directories).

2. Search for a `<!-- Backend: ... -->` HTML comment. This comment is
   machine-readable and written by `perl:setup`.

3. **If found**, include the corresponding backend skill:

   | Backend value | Skill to include |
   |---|---|
   | `pvm` | `perl:using-pvm` |
   | `custom` | `perl:using-custom` |
   | `plenv` | `perl:using-plenv` (not in v0.1 — suggest PVM or custom) |
   | `perlbrew` | `perl:using-perlbrew` (not in v0.1 — suggest PVM or custom) |

4. **If not found**, stop and report:

   > "No Perl toolchain is configured for this project.
   > Run `perl:setup` to configure one."
   >
   > Do not proceed.

## Notes

- The `<!-- Backend: ... -->` comment is the sole detection mechanism. Do
  not attempt to auto-detect toolchains — that is `perl:setup`'s job.
- If the backend value is unrecognized, report the specific value and
  suggest running `perl:setup` to reconfigure.
- This skill never installs anything. It only reads configuration and
  includes the appropriate backend skill.
