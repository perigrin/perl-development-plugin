---
name: writing-perl-5.44
description: Write modern Perl 5.44 code with native feature class, named signature parameters, lexical methods, and auto-exported builtins
trigger: When perl:detect-version identifies Perl 5.44.x as the target version
---

I'm using the perl:write-5.44 skill to write modern Perl code.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured. If
5.44 is not installed, the backend's "Install latest stable" capability
installs it (ask the user first; it can fall back to a source build).

## Standard Boilerplate

```perl
use v5.44;
use utf8;
```

`use v5.44` enables strict, warnings, the feature bundle,
`source::encoding 'ascii'`, and the `:5.40` builtin bundle. Always add
`use utf8`: without it, non-ASCII characters in a source file are a
compile error. (`perl -e` one-liners are not checked, so test in a file.)

The `:5.44` feature bundle is identical to `:5.42`. Everything below
works on 5.42 except sections marked **(5.44)**.

## Key Features

### Native `feature 'class'`

`class` is experimental and **not** in the version bundle. Enable it:

```perl
use v5.44;
use utf8;
use experimental 'class';

class Point {
    field $x :param :reader :writer;
    field $y :param :reader = 0;

    ADJUST {
        die "x must be non-negative" if $x < 0;
    }

    method magnitude () {
        return sqrt($x**2 + $y**2);
    }
}

class Point3D :isa(Point) {
    field $z :param :reader;
}
```

- `:param` takes the field from the constructor; it is required unless the field has a default
- `:param(name)`, `:reader(name)`, `:writer(name)` rename the parameter or accessor
- `:writer` generates `set_<field>`, which returns the object
- `ADJUST` runs during construction, after fields are initialized; multiple blocks run in order
- Not available: roles (`:does`), `:common`, multiple inheritance, method modifiers, `BUILD`
- Do NOT use `Feature::Compat::Class` — native class is correct on 5.44

### Lexical Methods

```perl
class Parser {
    my method _tokenize ($input) { ... }

    method parse ($input) {
        my @tokens = $self->&_tokenize($input);
        ...
    }
}
```

`my method` is private to the class. Call it with `->&`; `$self->_tokenize`
does a normal method lookup and won't find it.

### Class-Level Data

There is no `:common`. Use a lexical at class scope and a `sub`:

```perl
class Counter {
    my $count = 0;
    ADJUST { $count++ }
    sub count { $count }
}
```

### Named Parameters in Signatures (5.44)

```perl
use experimental 'signature_named_parameters';

sub open_db ($host, :$port = 5432, :$timeout = 30) { ... }

open_db('db.local', timeout => 5);
```

A named parameter without a default is required; an unknown name is an
error. Prefer this to `sub f ($x, %opts)` when the option names are fixed.

### Multi-variable `foreach` with Ref Aliases (5.44)

```perl
use experimental qw(refaliasing declared_refs);

for my ($name, \@items) (%groups) {
    say "$name: @items";
}
```

### Auto-exported Builtins

`true`, `false`, `blessed`, `refaddr`, `reftype`, `ceil`, `floor`, `trim`,
`indexed`, `is_tainted`, `is_weak`, `weaken`, `unweaken`.

Still experimental, needing `use builtin qw(...)`: `is_bool`, `inf`, `nan`,
`load_module`, `export_lexically`, `created_as_string`, `created_as_number`,
`stringify`.

`any` and `all` are keywords: `use experimental qw(keyword_any keyword_all);`

### Signatures, try/catch, Postfix Dereferencing

```perl
method process ($input, $options = {}) {
    try { ... }
    catch ($e) { ... }
}

my @items = $arrayref->@*;
my @slice = $hashref->@{qw(foo bar)};
```

Signatures are stable. `try`/`catch` is stable; `finally` is still
experimental. Use postfix dereference consistently.

## Disabled by the Bundle

These features still exist but `use v5.44` turns them off. Don't
re-enable them: `smartmatch` (`~~` is a syntax error),
`apostrophe_as_package_separator`, `indirect`, `multidimensional`,
`bareword_filehandles`, `switch` (`given`/`when`).

## Changes in 5.44 That Can Break Code

These apply whatever `use VERSION` the code declares:

- `goto` into a loop or block from outside is fatal
- Under `/xx`, an unescaped `#` or literal vertical space inside `[...]` is deprecated; write `\#` and `\n`
- With `use utf8`, about 160 `\w` characters Unicode excludes from identifiers (circled letters, some Arabic ligatures) are rejected after the first character of an identifier or regex group name

## What NOT to Do

- Do not write `class` without `use experimental 'class'`
- Do not use `Feature::Compat::Class`
- Do not use `@_` extraction — use signatures
- Do not use `1`/`0` for booleans — use `true`/`false`
- Do not use `print` — use `say`
- Do not use `@$ref` — use `$ref->@*`
- Do not use named parameters or ref-alias `foreach` if the project targets 5.42
- Avoid operator overloading in performance-sensitive code — it carries
  real runtime cost. Prefer explicit methods.
