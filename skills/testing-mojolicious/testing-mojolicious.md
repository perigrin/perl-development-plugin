---
name: testing-mojolicious
description: Test Mojolicious web applications with Test::Mojo — HTTP, JSON, DOM, HTMX assertions
trigger: When testing a Mojolicious application
---

I'm using the perl:test-mojolicious skill for Mojolicious testing.

## Prerequisites

Include `perl:require-toolchain` to verify a backend is configured.

## Testing Strategy

| Test type | Tool |
|---|---|
| HTTP / JSON / API | `Test::Mojo` |
| DOM + HTMX | `Test::Mojo` CSS selector assertions |
| JavaScript execution | `agent-browser` or Playwright CLI |
| Visual / layout | Playwright CLI screenshot |

`Test::Mojo` is the Mojolicious-maintained testing tool that ships with the
framework. Prefer it over third-party alternatives like `Test2::MojoX`
(last updated 2021) unless the project already uses it.

## Standard Patterns

```perl
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('MyApp');

# Basic GET
$t->get_ok('/')
  ->status_is(200)
  ->content_like(qr/Welcome/);

# JSON API
$t->get_ok('/api/items')
  ->status_is(200)
  ->json_is('/0/name' => 'Widget');

# Form POST
$t->post_ok('/login' => form => {user => 'alice', pass => 'secret'})
  ->status_is(302)
  ->header_is(Location => '/dashboard');

# DOM assertions
$t->get_ok('/dashboard')
  ->status_is(200)
  ->element_exists('h1.title')
  ->text_like('h1.title' => qr/Dashboard/);

# HTMX partial
$t->get_ok('/fragment' => {'HX-Request' => 'true'})
  ->status_is(200)
  ->element_exists('[hx-swap]');

done_testing;
```

## Test::More Exception

`Test::Mojo` uses `Test::More` internally. This is the one exception to the
"Test2 everywhere" principle — Mojolicious's test infrastructure is tightly
coupled to `Test::More` and works correctly as-is. Do not attempt to replace
it with Test2 equivalents.

## WebSocket Testing

```perl
$t->websocket_ok('/ws')
  ->send_ok('ping')
  ->message_ok
  ->message_is('pong')
  ->finish_ok;
```
