---
name: regression-testing
description: Run tests against a matrix of Perl versions using PVM's binary cache — named matrices, version justifications, failure triage
trigger: When testing across multiple Perl versions for compatibility
---

I'm using the perl:regression-test skill to test across Perl versions.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

This skill requires PVM. The binary cache — pre-compiled Perl binaries
downloadable in seconds — is what makes a 7-version matrix practical.
Perlbrew and plenv require compiling from source (30-60 minutes per version).

## Named Matrices

| Matrix | Versions | Justification |
|---|---|---|
| `pvm-legacy` | 5.26, 5.32 | RHEL 8 (until 2029), RHEL 9 / AL2023 (until 2032) |
| `pvm-stable` | 5.34, 5.36, 5.38 | Ubuntu 22.04, Debian 12, Ubuntu 24.04 |
| `pvm-current` | 5.40, 5.42 | RHEL 10, Debian 13, Docker, Lambda |
| `pvm-modern` | 5.32-5.42 | Broad compatibility excluding RHEL 8 |
| `pvm-full` | 5.26-5.42 (all 7) | Maximum production coverage |
| `pvm-toolchain` | all 7 | CPAN distribution releases |

## Version Justifications

| Version | Platform | Supported until |
|---|---|---|
| 5.26 | RHEL 8 (AlmaLinux / Rocky) | 2029 full / 2032 ELS |
| 5.32 | RHEL 9, Amazon Linux 2023, Debian 11 | 2032 / 2029 / Aug 2026 |
| 5.34 | Ubuntu 22.04, macOS system Perl | 2027 std / 2032 ESM |
| 5.36 | Debian 12 Bookworm | June 2028 |
| 5.38 | Ubuntu 24.04, Alpine 3.20, WSL default | 2029 std / 2036 ESM |
| 5.40 | RHEL 10, Debian 13, Docker maintained | ~2035 |
| 5.42 | Docker latest, Alpine 3.23, Lambda layers | Upstream current |

5.28 and 5.30 excluded — no major distribution ships them in active support.

Watch for **Perl 5.44** (~July 2026): update `pvm-current` to `[5.42, 5.44]`
and move 5.40 to `pvm-stable`.

## Workflow

```bash
# Install matrix (minutes via binary cache)
pvm install 5.26.3 5.32.1 5.34.4 5.36.3 5.38.4 5.40.2 5.42.0

# Run
for version in 5.26.3 5.32.1 5.34.4 5.36.3 5.38.4 5.40.2 5.42.0; do
    result=$(PVM_PERL_VERSION=$version pvx prove -lr t/ 2>&1 | tail -1)
    echo "$version: $result"
done
```

## Failure Triage

1. **Isolate:** `PVM_PERL_VERSION=5.32.1 pvx prove -lv t/failing.t`
2. **Parse:** `psc parse lib/Affected.pm`
3. **Classify:**
   - **Syntax incompatibility** — feature unavailable in that version
   - **Missing module** — not in core (`corelist <Module>`)
   - **Logic failure** — actual bug, version-independent

## Matrix Config (.pvm/pvm.toml)

```toml
[regression]
default_matrix = "pvm-modern"

[regression.custom]
versions = ["5.32.1", "5.38.2", "5.42.0"]
```
