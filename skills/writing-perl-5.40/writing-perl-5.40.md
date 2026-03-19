---
name: writing-perl-5.40
description: Write Perl 5.40 code with experimental feature class, auto-exported builtins, and signatures — minimum reliable version for native class syntax
trigger: When perl:detect-version identifies Perl 5.40.x as the target version
---

I'm using the perl:write-5.40 skill to write Perl 5.40 code.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Standard Boilerplate

```perl
use 5.040;
no warnings 'experimental::class';
```

Or equivalently:

```perl
use 5.040;
use experimental qw(class);
```

Both forms suppress the experimental warning. Either is acceptable — be
consistent within a project.

## Key Differences from 5.42

- No `:writer` field attribute (added in 5.42) — write manual setters
- No lexical methods `my method` (added in 5.42) — use naming conventions
  for private methods (e.g., `_internal_method`)
- No `source::encoding 'ascii'` default — `use utf8` not required unless
  source contains non-ASCII
- `:5.40` builtin bundle auto-exports builtins (same as 5.42)

## Native `feature 'class'`

5.40 is the minimum reliable version for native class syntax. 5.38 had
segfault bugs with same-file parent/subclass and refaliasing with field
variables, both fixed in 5.40.

```perl
use 5.040;
no warnings 'experimental::class';

class Point {
    field $x :param :reader;
    field $y :param :reader;

    method set_x ($new_x) { $x = $new_x }
    method set_y ($new_y) { $y = $new_y }

    method magnitude () {
        return sqrt($x**2 + $y**2);
    }
}
```

- `:reader` works (generates accessor)
- `:param` works (constructor parameter)
- No `:writer` — write explicit setter methods
- Do NOT use `Feature::Compat::Class` on 5.40 — native class is reliable

## Auto-exported Builtins

Same as 5.42 — `true`, `false`, `blessed`, `refaddr`, `trim`, etc.
are auto-exported by the `:5.40` bundle. No explicit import needed.

## Signatures

Stable and non-experimental. Use for all subs and methods.

## Postfix Dereferencing

Stable. Use `$ref->@*` consistently.

## What NOT to Do

- Do not use `:writer` field attribute — not available until 5.42
- Do not use `my method` — not available until 5.42
- Do not use `Feature::Compat::Class` — native class is reliable on 5.40
- Do not use `@_` extraction — use signatures
- Do not use `1`/`0` for booleans — use `true`/`false`
