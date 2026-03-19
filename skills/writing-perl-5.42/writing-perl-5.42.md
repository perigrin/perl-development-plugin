---
name: writing-perl-5.42
description: Write modern Perl 5.42 code with native feature class, :writer/:reader field attributes, lexical methods, and auto-exported builtins
trigger: When perl:detect-version identifies Perl 5.42.x as the target version
---

I'm using the perl:write-5.42 skill to write modern Perl code.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Standard Boilerplate

```perl
use 5.42.0;
use utf8;
```

`use utf8` is required — Perl 5.42 defaults to ASCII source encoding. Without
it, non-ASCII characters in source code produce errors.

## Key Features (5.42)

### Native `feature 'class'`

```perl
use 5.42.0;
use utf8;
no warnings 'experimental::class';

class Point {
    field $x :param :reader :writer;
    field $y :param :reader :writer;

    method magnitude () {
        return sqrt($x**2 + $y**2);
    }
}
```

- `:reader` generates a read accessor named after the field (minus `$`)
- `:writer` generates a write accessor (new in 5.42)
- `:param` allows setting the field via constructor
- `no warnings 'experimental::class'` is required until the feature stabilizes
- Do NOT use `Feature::Compat::Class` — native class syntax is correct on 5.42

### Lexical Methods (new in 5.42)

```perl
class Parser {
    my method _tokenize ($input) {
        # Private to this class — not visible to subclasses or external code
        ...
    }

    method parse ($input) {
        my @tokens = $self->_tokenize($input);
        ...
    }
}
```

`my method` declares a lexically-scoped method. Use for implementation
details that should not be part of the public or inherited API.

### Auto-exported Builtins

The `:5.42` bundle auto-exports builtins. No explicit import needed:

```perl
my $val = true;
my $name = blessed($obj);
my $addr = refaddr($ref);
my $trimmed = trim($input);
```

Available: `true`, `false`, `blessed`, `refaddr`, `ceil`, `floor`,
`trim`, `indexed`, `is_bool`, `is_weak`, `weaken`, `unweaken`.

### Signatures

```perl
method process ($input, $options = {}) {
    ...
}

sub transform ($data, @rest) {
    ...
}
```

Signatures are stable and non-experimental in 5.42. Use them for all
subs and methods.

### Postfix Dereferencing

```perl
my @items = $arrayref->@*;
my %lookup = $hashref->%*;
my @slice = $hashref->@{qw(foo bar)};
```

Use postfix dereference consistently. Do not mix `@$ref` and `$ref->@*`
in the same codebase.

## What NOT to Do

- Do not use `Feature::Compat::Class` — native class is correct on 5.42
- Do not use `@_` extraction — use signatures
- Do not use `1`/`0` for booleans — use `true`/`false`
- Do not use `print` — use `say`
- Do not use `@$ref` — use `$ref->@*`
- Avoid operator overloading in performance-sensitive code — it carries
  real runtime cost. Prefer explicit methods.

## Corrections from superpowers `writing-perl-5.42.0`

This skill migrates from the superpowers `writing-perl-5.42.0` skill with
these corrections applied:

- `Feature::Compat::Class` is not used on 5.42 — native class is correct
- Operator overloading runtime cost is documented
- `no warnings 'experimental::class'` is explicitly required
- `use utf8` requirement is emphasized (5.42 ASCII source default)
- `:writer` field attribute documented (new in 5.42)
- Lexical methods `my method` documented (new in 5.42)
