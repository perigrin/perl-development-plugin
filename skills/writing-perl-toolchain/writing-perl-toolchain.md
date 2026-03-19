---
name: writing-perl-toolchain
description: Write broadly compatible Perl for CPAN distributions and toolchain modules targeting Perl 5.20+ — conservative features, maximum portability
trigger: When perl:detect-version identifies < 5.36, or the project is a CPAN distribution
---

I'm using the perl:write-toolchain skill to write broadly compatible Perl code.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Standard Boilerplate

```perl
use strict;
use warnings;
```

Or with a minimum version:

```perl
use 5.020;
use warnings;
```

`use 5.020` enables `strict` and `signatures` (experimental on 5.20-5.34).
Add `no warnings 'experimental::signatures'` if using signatures on < 5.36.

## Design Principles

- **Minimize non-core dependencies.** Check before adding: `corelist <Module>`
- **Test2::V0 is acceptable** — it supports Perl 5.8.1+ despite being non-core
- **Feature::Compat::Class for class syntax** — works on 5.14+ via Object::Pad
  polyfill. Only use for < 5.38 targets; 5.40+ should use native class.
- **Prefer core modules** — `Scalar::Util`, `List::Util`, `File::Spec`,
  `File::Path`, `JSON::PP`, `HTTP::Tiny`, `Getopt::Long`

## Signatures

On 5.20–5.34, signatures are experimental:

```perl
use feature 'signatures';
no warnings 'experimental::signatures';

sub process ($input, $options = {}) { ... }
```

On 5.36+, signatures are stable — no experimental warning needed.

For maximum compatibility (targeting < 5.20), use `@_`:

```perl
sub process {
    my ($input, $options) = @_;
    $options //= {};
    ...
}
```

## OO Options

### For 5.14+ targets: Feature::Compat::Class

```perl
use Feature::Compat::Class 0.07;

class MyModule {
    field $name :param :reader;
    method greet () { say "Hello, $name" }
}
```

### For broad targets: blessed hash refs

```perl
sub new {
    my ($class, %args) = @_;
    return bless \%args, $class;
}
```

## Testing

Use `Test2::V0` even for toolchain code:

```perl
use Test2::V0;

is($result, $expected, 'description');
done_testing;
```

`Test2::V0` supports Perl 5.8.1+ and is the modern testing standard.
Only fall back to `Test::More` if the project explicitly requires zero
non-core test dependencies.

## Distribution Build Systems

- **Dist::Zilla** — full-featured, many plugins. `dist.ini` config.
- **Minilla** — minimal, convention-over-configuration. `minil.toml`.
- **ExtUtils::MakeMaker** — core module, maximum compatibility.
- **Module::Build** — core (deprecated in newer Perls).

## cpanfile

Even Dist::Zilla projects benefit from a cpanfile — it can coexist with
`dist.ini` via `[Prereqs::FromCPANfile]`:

```
requires 'perl', '5.020';

on test => sub {
    requires 'Test2::V0';
};
```

## What NOT to Do

- Do not assume signatures are available without checking version
- Do not use `true`/`false` builtins — not available before 5.36
- Do not use postfix deref `$ref->@*` on targets < 5.20
- Do not use `Feature::Compat::Class` on 5.40+ — use native class
- Do not add non-core deps without checking `corelist` first
