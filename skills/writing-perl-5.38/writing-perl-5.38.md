---
name: writing-perl-5.38
description: Write Perl 5.38 code with Feature::Compat::Class (not native class), explicit builtin imports, and signatures
trigger: When perl:detect-version identifies Perl 5.38.x as the target version
---

I'm using the perl:write-5.38 skill to write Perl 5.38 code.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Standard Boilerplate

```perl
use 5.038;
use builtin qw(true false blessed refaddr trim);
no warnings 'experimental::builtin';
```

## Key Differences from 5.40

- **No auto-exported builtins** — explicit `use builtin qw(...)` required
- **`feature 'class'` has known segfault bugs** — same-file parent/subclass
  and refaliasing with field variables can segfault on 5.38. Use
  `Feature::Compat::Class` instead of native `feature 'class'`.
- 5.40 is the minimum reliable version for native class support.

## Class Syntax: Use Feature::Compat::Class

Do NOT use native `feature 'class'` on 5.38 — it has segfault bugs.
Use `Feature::Compat::Class` instead:

```perl
use 5.038;
use Feature::Compat::Class 0.07;  # 0.07 for :reader
use builtin qw(true false blessed);
no warnings 'experimental::builtin';

class Point {
    field $x :param :reader;
    field $y :param :reader;

    method magnitude () {
        return sqrt($x**2 + $y**2);
    }
}
```

`Feature::Compat::Class` provides the core-syntax subset of the class
feature via `Object::Pad` as a polyfill. It is forward-compatible — code
written with it works unchanged on 5.40+ with native class.

### Feature::Compat::Class versions

- `0.07` — adds `:reader` support
- `0.08` — adds `:writer` support

## Builtins Require Explicit Import

```perl
use builtin qw(true false blessed refaddr ceil floor trim indexed);
no warnings 'experimental::builtin';
```

Available builtins: `true`, `false`, `blessed`, `refaddr`, `ceil`, `floor`,
`trim`, `indexed`, `is_bool`, `is_weak`, `weaken`, `unweaken`.

## Signatures

Stable and non-experimental on 5.38. Use for all subs and methods.

## Postfix Dereferencing

Stable. Use `$ref->@*` consistently.

## What NOT to Do

- Do NOT use native `feature 'class'` — use `Feature::Compat::Class`
- Do not assume builtins are auto-exported — import them explicitly
- Do not use `@_` extraction — use signatures
