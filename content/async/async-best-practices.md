---
title: "Best Practices for Asynchronous Programming in Dart"
linkTitle: "Best practices"
description: "A practical checklist for async Dart: await correctly, run work in parallel, handle errors, cancel subscriptions and avoid common pitfalls."
weight: 12
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart async best practices"
  - "async pitfalls"
  - "unawaited futures"
  - "avoid async void"
  - "cancel subscription"
aliases:
  - "/dart--asynchronouse-programming/best-practices-for-asynchronous-programming-in-dart/"
  - "/fr/dart--asynchronouse-programming/best-practices-for-asynchronous-programming-in-dart/"
---

You now know the tools. This lesson collects the habits that separate async code that works on a good day from async code that works always.

## 1. Prefer async and await to then

`await` keeps code flat and lets you use ordinary `try`/`catch`, loops and `if`.

```dart
Future<int> fetchA() async => 2;
Future<int> fetchB(int a) async => a * 10;

// Harder to read and to extend.
Future<int> withThen() => fetchA().then((a) => fetchB(a)).then((b) => b + 1);

// Clear.
Future<int> withAwait() async {
  final a = await fetchA();
  final b = await fetchB(a);
  return b + 1;
}

Future<void> main() async {
  print(await withThen());
  print(await withAwait());
}
```

```output
21
21
```

## 2. Never use async void

A function declared `void f() async` cannot be awaited, and its errors cannot be caught by the caller. Return `Future<void>`.

```dart
// Bad: the caller has no way to wait or to catch errors.
void saveBad() async {
  await Future.delayed(Duration(milliseconds: 100));
}

// Good.
Future<void> saveGood() async {
  await Future.delayed(Duration(milliseconds: 100));
}

Future<void> main() async {
  await saveGood();
  print('Saved');
}
```

The one accepted exception is event handlers such as Flutter's `onPressed`, where the framework expects a `void` callback. Handle errors inside them.

## 3. Do not forget await

An un-awaited future runs in the background. Its result is lost and its errors go unhandled. Enable these lints in `analysis_options.yaml`:

```yaml
linter:
  rules:
    - unawaited_futures
    - discarded_futures
    - avoid_void_async
```

When you skip the wait on purpose, wrap the call in `unawaited(...)` from `dart:async`.

## 4. Run independent work in parallel

```dart
Future<String> load(String what) =>
    Future.delayed(Duration(milliseconds: 300), () => what);

Future<void> main() async {
  // Slow: 900 ms.
  // final a = await load('a');
  // final b = await load('b');
  // final c = await load('c');

  // Fast: 300 ms.
  final (a, b, c) = await (load('a'), load('b'), load('c')).wait;
  print('$a $b $c');
}
```

```output
a b c
```

## 5. Do not use forEach with async callbacks

`forEach` ignores the futures its callback returns, so the code after it runs before the work is done.

```dart
Future<void> process(int n) async {
  await Future.delayed(Duration(milliseconds: 100));
  print('processed $n');
}

Future<void> main() async {
  final items = [1, 2, 3];

  // Bad: prints "Done" first.
  // items.forEach((n) async => await process(n));

  // Good, in order:
  for (final n in items) {
    await process(n);
  }

  // Good, all at once:
  await Future.wait(items.map(process));

  print('Done');
}
```

## 6. Always handle errors, and always time out

Every network call can fail or hang. Wrap it, give it a deadline, and show the user something helpful.

```dart
import 'dart:async';

Future<String> fetchProfile() =>
    Future.delayed(Duration(seconds: 10), () => 'profile');

Future<void> main() async {
  try {
    final profile = await fetchProfile().timeout(Duration(seconds: 1));
    print(profile);
  } on TimeoutException {
    print('This is taking too long. Check your connection.');
  } catch (e) {
    print('Something went wrong: $e');
  }
}
```

## 7. Use return await inside try

If you return a future from inside a `try` block without awaiting it, the function can leave the block before the future fails, and your `catch` does not get the chance to handle the error. Writing `return await` keeps the failure inside the `try`.

```dart
Future<int> risky() async => throw Exception('failed');

Future<int> safeValue() async {
  try {
    return await risky(); // await here, so catch can do its job
  } catch (_) {
    return -1;
  }
}

Future<void> main() async {
  print(await safeValue());
}
```

```output
-1
```

## 8. Clean up streams

- Cancel every `StreamSubscription` when you are done with it.
- Close every `StreamController` you create.
- In Flutter, do both in `dispose()`.

A stream that is never cancelled keeps its listener, and everything the listener refers to, in memory.

## 9. Do not block the event loop

Asynchronous does not mean "on another thread". A heavy calculation freezes the app even inside an `async` function. Move it to an isolate with `Isolate.run`, or `compute` in Flutter.

## 10. Guard against stale results

If the user types quickly in a search box, an older, slower request can finish **after** a newer one and overwrite the right results. Remember which request is the latest and ignore the rest.

```dart
class SearchBox {
  int _latest = 0;

  Future<void> search(String query, int delayMs) async {
    final id = ++_latest;
    await Future.delayed(Duration(milliseconds: delayMs)); // pretend request
    if (id != _latest) {
      print('Ignored stale result for "$query"');
      return;
    }
    print('Showing results for "$query"');
  }
}

Future<void> main() async {
  final box = SearchBox();
  await Future.wait([
    box.search('fl', 400),    // slow, older
    box.search('flutter', 100), // fast, newer
  ]);
}
```

```output
Showing results for "flutter"
Ignored stale result for "fl"
```

In Flutter, also check `mounted` after an `await` before touching the widget's state.

## 11. Keep functions honestly async or honestly sync

- Do not add `async` to a function that never awaits.
- Do not hide long-running work behind a function that looks synchronous.
- Name asynchronous functions by what they do (`fetchUser`, `saveOrder`); the `Future` return type already says they are async.

## Quick checklist

| Check | Why |
| --- | --- |
| Every future is awaited or explicitly `unawaited` | No lost errors |
| Functions return `Future<void>`, not `void` | Callers can wait and catch |
| Independent calls run in parallel | Speed |
| Network calls have `try`/`catch` and a timeout | Reliability |
| Subscriptions cancelled, controllers closed | No leaks |
| Heavy CPU work is in an isolate | Smooth UI |
| Stale responses are ignored | Correct UI |

## Try it yourself

Take any async code you have written during this chapter and review it against the checklist. Fix at least one thing: add a timeout, replace a `forEach`, or run two independent awaits in parallel.
