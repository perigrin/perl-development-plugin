---
name: using-pvm
description: PVM install procedure and capability map — the reference Perl toolchain backend for all perl-development skills
---

# perl:using-pvm

PVM is the reference Perl toolchain backend. This skill is self-contained:
it knows how to install PVM and how to use all four PVM components once
installed. All other skills that need to run Perl include this capability map.

## Installation

### Step 1: Detect platform

```bash
OS=$(uname -s | tr '[:upper:]' '[:lower:]')   # linux or darwin
ARCH=$(uname -m)                               # x86_64 or arm64/aarch64
```

Normalize architecture:

```bash
case "$ARCH" in
  x86_64)           ARCH="amd64" ;;
  arm64|aarch64)    ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1 ;;
esac
```

Supported platforms:

| `uname -s` | `uname -m` | Binary name |
|---|---|---|
| `linux` | `x86_64` | `pvm-linux-amd64` |
| `linux` | `arm64` / `aarch64` | `pvm-linux-arm64` |
| `darwin` | `x86_64` | `pvm-darwin-amd64` |
| `darwin` | `arm64` | `pvm-darwin-arm64` |

Windows (PowerShell) is out of scope for v0.1.

### Step 2: Confirm with user

> "PVM is not installed. I'll download `pvm-${OS}-${ARCH}` from GitHub
> releases and place it in `~/.local/bin/`. Install now?"

Wait for confirmation before proceeding.

### Step 3: Download and install

```bash
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Resolve the latest release tag (including pre-releases) via GitHub API.
VERSION=$(curl -fsSL "https://api.github.com/repos/perigrin/pvm/releases" \
  | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"\(.*\)".*/\1/')
VERSION_NUM=${VERSION#v}

ASSET="pvm-${VERSION_NUM}-${OS}-${ARCH}.tar.gz"
URL="https://github.com/perigrin/pvm/releases/download/${VERSION}/${ASSET}"

curl -fsSL "$URL" -o "/tmp/${ASSET}"
tar -xzf "/tmp/${ASSET}" -C /tmp
# The tarball contains a binary named pvm-<version>-<os>-<arch>.
BINARY=$(ls /tmp/pvm-*-${OS}-${ARCH} 2>/dev/null | head -1)
chmod +x "$BINARY"
mv "$BINARY" "${INSTALL_DIR}/pvm"

rm -f "/tmp/${ASSET}"
```

### Step 4: PATH check

```bash
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "$INSTALL_DIR is not in your PATH."
    echo "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    echo "Then reload your shell or run: export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
```

### Step 5: Create symlinks

```bash
pvm self symlinks create
```

This creates `pvx`, `pvi`, and `psc` alongside the `pvm` binary.

### Step 6: Verify

```bash
pvm version
pvx --version
psc --version
```

All must succeed. If any fail, report the specific error — do not silently
continue.

## Capability Map

Once installed, use these commands:

| Capability | Command |
|---|---|
| Install Perl version | `pvm install <version>` |
| Switch Perl version | `PVM_PERL_VERSION=<ver>` or `.perl-version` file |
| Current version | `pvm current` |
| Installed versions | `pvm versions` |
| Install CPAN module | `pvm module install <Module>` |
| Install from cpanfile | `pvm module install` |
| Run script isolated | `pvx <script>` |
| Run tests | `pvx prove -lr t/` |
| Parse source / AST | `psc parse <file>` |
| Analyze dependencies | `psc analyze lib/` |
| Regression matrix | `PVM_PERL_VERSION=<ver> pvx prove -lr t/` |
