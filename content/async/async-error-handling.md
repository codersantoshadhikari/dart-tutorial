---
title: "Error Handling in Asynchronous Dart Code"
linkTitle: "Async error handling"
description: "Handle errors in async Dart code with try and catch, catchError, timeouts and retries, and avoid unhandled future errors."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart async error handling"
  - "try catch await"
  - "future timeout"
  - "TimeoutException"
  - "retry dart"
  - "unhandled exception future"
aliases:
  - "/dart--asynchronouse-programming/error-handling-in-asynchronous-dart/"
  - "/fr/dart--asynchronouse-programming/error-handling-in-asynchronous-dart/"
---

Asynchronous operations fail more often than ordinary code, because they depend on networks, files and other services. The good news: with `await`, you handle those failures with the same `try`/`catch` you already know.

## try and catch with await

```dart
Future<String> fetchWeather(String city) async {
  await Future.delayed(Duration(milliseconds: 300));
  if (city.isEmpty) throw ArgumentError('City is required');
  if (city == 'Atlantis') throw Exception('City not found');
  return '$city: 24 degrees';
}

Future<void> show(String city) async {
  try {
    print(await fetchWeather(city));
  } on ArgumentError catch (e) {
    print('Invalid input: ${e.message}');
  } catch (e) {
    print('Could not load weather: $e');
  } finally {
    print('Request for "$city" finished');
  }
}

Future<void> main() async {
  await show('Pokhara');
  await show('Atlantis');
  await show('');
}
```

```output
Pokhara: 24 degrees
Request for "Pokhara" finished
Could not load weather: Exception: City not found
Request for "Atlantis" finished
Invalid input: City is required
Request for "" finished
```

## The mistake that makes catch useless

`try`/`catch` only catches errors from futures you **await** inside it. Without `await`, the future fails later, after the `try` block has already ended.

```dart
Future<void> risky() async {
  await Future.delayed(Duration(milliseconds: 100));
  throw Exception('Boom');
}

Future<void> main() async {
  try {
    risky(); // missing await: the error escapes
  } catch (e) {
    print('Never printed');
  }
}
```

This program ends with an "Unhandled exception" message that the `catch` never sees. Add `await` and it works:

```dart
Future<void> risky() async {
  await Future.delayed(Duration(milliseconds: 100));
  throw Exception('Boom');
}

Future<void> main() async {
  try {
    await risky();
  } catch (e) {
    print('Caught: $e');
  }
}
```

```output
Caught: Exception: Boom
```

If you really want to start a future without waiting for it, attach a handler so its error has somewhere to go: `risky().catchError((e) => print(e));`.

## Timeouts

Never wait forever. `timeout` fails the future with a `TimeoutException` if it takes too long.

```dart
import 'dart:async';

Future<String> slowServer() =>
    Future.delayed(Duration(seconds: 5), () => 'response');

Future<void> main() async {
  try {
    final result = await slowServer().timeout(Duration(seconds: 1));
    print(result);
  } on TimeoutException {
    print('The server took too long. Please try again.');
  }
}
```

```output
The server took too long. Please try again.
```

You can also supply a fallback: `.timeout(d, onTimeout: () => 'cached value')`.

## Retrying

Temporary failures often succeed on a second attempt. Wait a little longer each time.

```dart
var _calls = 0;

Future<String> flakyRequest() async {
  _calls++;
  await Future.delayed(Duration(milliseconds: 100));
  if (_calls < 3) throw Exception('Network glitch');
  return 'Success on attempt $_calls';
}

Future<T> retry<T>(Future<T> Function() action, {int attempts = 3}) async {
  for (var i = 1; ; i++) {
    try {
      return await action();
    } catch (e) {
      if (i == attempts) rethrow;
      print('Attempt $i failed, retrying...');
      await Future.delayed(Duration(milliseconds: 200 * i));
    }
  }
}

Future<void> main() async {
  print(await retry(flakyRequest));
}
```

```output
Attempt 1 failed, retrying...
Attempt 2 failed, retrying...
Success on attempt 3
```

Note the `return await` inside `try`. Without `await`, the future would be returned before it failed, and the `catch` would be skipped.

## Errors with then-style code

If you use `.then`, add `.catchError` at the end of the chain. You can limit it to one type with `test`.

```dart
Future<int> parseLater(String text) =>
    Future.delayed(Duration(milliseconds: 100), () => int.parse(text));

void main() {
  parseLater('12x')
      .then((n) => print(n))
      .catchError(
        (e) => print('Not a number'),
        test: (e) => e is FormatException,
      );
}
```

```output
Not a number
```

## Errors when running several futures

`Future.wait` fails as soon as one of its futures fails, with that future's error. The other futures keep running but their results are discarded. If you need every outcome, catch inside each one.

```dart
Future<String> load(String name, {bool fail = false}) async {
  await Future.delayed(Duration(milliseconds: 100));
  if (fail) throw Exception('$name failed');
  return '$name ok';
}

Future<String> safe(Future<String> future) async {
  try {
    return await future;
  } catch (e) {
    return 'error: $e';
  }
}

Future<void> main() async {
  final results = await Future.wait([
    safe(load('users')),
    safe(load('orders', fail: true)),
    safe(load('stock')),
  ]);
  results.forEach(print);
}
```

```output
users ok
error: Exception: orders failed
stock ok
```

## Checklist

- Await every future you care about, or attach `catchError`.
- Catch specific exception types first, general ones last.
- Put a timeout on network calls.
- Use `finally` to hide spinners and close resources.
- Show users a helpful message, and log the technical details.
- Do not swallow errors silently. An empty `catch` hides bugs for months.

## Try it yourself

Write `Future<String> fetchWithFallback()` that calls a function which randomly fails, retries it up to three times, applies a two-second timeout to each attempt, and returns `'offline data'` if every attempt fails.
