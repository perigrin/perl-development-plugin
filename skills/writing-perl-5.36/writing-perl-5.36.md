---
name: writing-perl-5.36
description: Write Perl 5.36 code with stable signatures, no native class — use Moo/Moose/Object::Pad or Feature::Compat::Class for OO
trigger: When perl:detect-version identifies Perl 5.36.x as the target version
---

I'm using the perl:write-5.36 skill to write Perl 5.36 code.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Standard Boilerplate

```perl
use 5.036;
```

`use 5.036` enables: `strict`, `warnings`, `signatures`, `say`,
`state`, `current_sub`, `unicode_strings`, `unicode_eval`,
`evalbytes`, `fc`, `postderef_qq`.

## Key Differences from 5.38

- **No `feature 'class'`** — not available at all in 5.36
- **No builtins** — `use builtin` not available
- `use warnings` is auto-enabled by `use 5.036`
- Signatures are stable — use them

## OO Options

5.36 has no native class syntax. Choose based on project context:

### Option 1: Feature::Compat::Class (recommended for forward compatibility)

```perl
use 5.036;
use Feature::Compat::Class 0.07;  # 0.07 for :reader; 0.08 for :writer

class Point {
    field $x :param :reader;
    field $y :param :reader;

    method magnitude () {
        return sqrt($x**2 + $y**2);
    }
}
```

`Feature::Compat::Class` works on 5.14+ via `Object::Pad` polyfill.
Code written with it migrates to native class on 5.40+ with no changes.

### Option 2: Moo (lightweight)

```perl
use 5.036;
use Moo;

has x => (is => 'ro', required => 1);
has y => (is => 'ro', required => 1);

sub magnitude ($self) {
    return sqrt($self->x**2 + $self->y**2);
}
```

### Option 3: Moose (full-featured)

```perl
use 5.036;
use Moose;

has x => (is => 'ro', isa => 'Num', required => 1);
has y => (is => 'ro', isa => 'Num', required => 1);

sub magnitude ($self) {
    return sqrt($self->x**2 + $self->y**2);
}

__PACKAGE__->meta->make_immutable;
```

### Option 4: Blessed hash refs (no dependencies)

```perl
use 5.036;

sub new ($class, %args) {
    return bless { x => $args{x}, y => $args{y} }, $class;
}

sub x ($self) { $self->{x} }
sub y ($self) { $self->{y} }

sub magnitude ($self) {
    return sqrt($self->x**2 + $self->y**2);
}
```

## Signatures

Stable and non-experimental. Use for all subs.

```perl
sub process ($input, $options = {}) { ... }
```

## What NOT to Do

- Do not use `feature 'class'` — not available on 5.36
- Do not use `use builtin` — not available on 5.36
- Do not use `true`/`false` — use `1`/`0` or import from a module
- Do not use `@_` extraction — use signatures
