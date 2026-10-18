---
title: "Future in Dart: Working with Values That Arrive Later"
seoTitle: "Dart Future Tutorial: then, async await and Errors with Examples"
linkTitle: "Futures"
description: "Learn the Future class in Dart: states of a future, then, catchError, whenComplete, Future.value, Future.delayed and chaining futures."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart future"
  - "Future.delayed"
  - "then catchError"
  - "whenComplete"
  - "Future.value"
aliases:
  - "/dart--asynchronouse-programming/future-in-dart/"
  - "/fr/dart--asynchronouse-programming/future-in-dart/"
---

A `Future<T>` is an object that represents a value of type `T` that will be available at some point. It is the return type of nearly every asynchronous function in Dart.

## The three states

A future is always in one of these states:

1. **Uncompleted**: the work is still going on.
2. **Completed with a value**: it succeeded and holds the result.
3. **Completed with an error**: it failed and holds an exception.

Once completed, a future never changes again.

## Creating futures

```dart
Future<void> main() async {
  // Already finished with a value.
  var ready = Future.value(42);

  // Finishes after a delay.
  var later = Future.delayed(Duration(seconds: 1), () => 'done');

  // Runs a function a little later and completes with its result.
  var computed = Future(() => 2 + 2);

  print(await ready);
  print(await later);
  print(await computed);
}
```

```output
42
done
4
```

In practice you rarely create futures yourself. You receive them from libraries: `http.get(...)`, `file.readAsString()`, `database.query(...)`.

## A function that returns a future

```dart
Future<String> fetchUserName(int id) {
  return Future.delayed(Duration(seconds: 1), () => 'user_$id');
}

void main() {
  var future = fetchUserName(7);
  print(future); // not the name, just the pending future

  future.then((name) => print('Got $name'));
}
```

```output
Instance of 'Future<String>'
Got user_7
```

Printing the future does not give you the name. A very common beginner bug is forgetting to wait for the value.

## then: do something with the result

`then` registers a function to run when the future succeeds. It returns a **new** future, so calls can be chained.

```dart
Future<int> fetchPrice() => Future.delayed(Duration(milliseconds: 500), () => 100);

void main() {
  fetchPrice()
      .then((price) => price * 1.13)          // add tax
      .then((total) => total.toStringAsFixed(2))
      .then((text) => print('Total: Rs. $text'));
}
```

```output
Total: Rs. 113.00
```

## catchError and whenComplete

```dart
Future<String> loadProfile(bool online) {
  return Future.delayed(Duration(milliseconds: 300), () {
    if (!online) throw Exception('No internet');
    return 'Profile loaded';
  });
}

void main() {
  loadProfile(false)
      .then((value) => print(value))
      .catchError((error) => print('Failed: $error'))
      .whenComplete(() => print('Hide loading spinner'));
}
```

```output
Failed: Exception: No internet
Hide loading spinner
```

- `catchError` is like `catch`. It handles a failure from anywhere earlier in the chain.
- `whenComplete` is like `finally`. It runs either way.

## The same code with async and await

Everything above is easier to read with `async`/`await`, covered in the next lesson. Use that style by default.

```dart
Future<String> loadProfile(bool online) {
  return Future.delayed(Duration(milliseconds: 300), () {
    if (!online) throw Exception('No internet');
    return 'Profile loaded';
  });
}

Future<void> main() async {
  try {
    print(await loadProfile(false));
  } catch (error) {
    print('Failed: $error');
  } finally {
    print('Hide loading spinner');
  }
}
```

## `Future<void>`

A function that does asynchronous work but has no result returns `Future<void>`. The caller can still wait for it to finish.

```dart
Future<void> saveSettings() async {
  await Future.delayed(Duration(milliseconds: 200));
  print('Settings saved');
}

Future<void> main() async {
  await saveSettings();
  print('Back to the home screen');
}
```

```output
Settings saved
Back to the home screen
```

## Useful constructors and methods

| Member | Purpose |
| --- | --- |
| `Future.value(x)` | A future that is already complete |
| `Future.error(e)` | A future that has already failed |
| `Future.delayed(d, fn)` | Complete after a duration |
| `Future.wait([...])` | Wait for several futures; see [running futures in parallel](/async/parallel-futures/) |
| `future.timeout(d)` | Fail if it takes longer than `d` |
| `future.then(fn)` | Use the value |
| `future.catchError(fn)` | Handle a failure |
| `future.whenComplete(fn)` | Run clean-up either way |

## Try it yourself

Write `Future<int> slowSquare(int n)` that waits one second and returns `n * n`. Call it with `.then` and print the result. Then make it throw when `n` is negative and handle that with `catchError`.
