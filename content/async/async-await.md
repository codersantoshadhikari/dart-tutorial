---
title: "async and await in Dart"
seoTitle: "Dart async await Tutorial with Examples"
linkTitle: "async and await"
description: "Learn how async and await work in Dart: write asynchronous code that reads like normal code, return futures, and avoid common mistakes."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart async await"
  - "await keyword"
  - "async function"
  - "sequential vs parallel await"
aliases:
  - "/dart--asynchronouse-programming/async-and-await-in-dart/"
  - "/fr/dart--asynchronouse-programming/async-and-await-in-dart/"
---

`async` and `await` are two keywords that let you work with futures as if the code were synchronous. They do not add new abilities. They make asynchronous code readable.

## The two rules

1. Mark a function `async` to be allowed to use `await` inside it. An `async` function **always** returns a `Future`.
2. Put `await` before a future to pause the function until that future completes, and get its value.

```dart
Future<String> fetchGreeting() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Namaste'; // automatically wrapped in a Future<String>
}

Future<void> main() async {
  print('Loading...');
  final greeting = await fetchGreeting();
  print(greeting);
}
```

```output
Loading...
Namaste
```

Inside `fetchGreeting` you return a plain `String`. Because the function is `async`, the caller receives a `Future<String>`.

## Compared with then

```dart
Future<int> fetchUserId() => Future.delayed(Duration(milliseconds: 300), () => 7);
Future<String> fetchName(int id) =>
    Future.delayed(Duration(milliseconds: 300), () => 'User $id');
Future<int> fetchOrderCount(String name) =>
    Future.delayed(Duration(milliseconds: 300), () => 12);

// With then: nested and hard to follow.
void withThen() {
  fetchUserId().then((id) {
    fetchName(id).then((name) {
      fetchOrderCount(name).then((count) {
        print('$name has $count orders');
      });
    });
  });
}

// With await: reads top to bottom.
Future<void> withAwait() async {
  final id = await fetchUserId();
  final name = await fetchName(id);
  final count = await fetchOrderCount(name);
  print('$name has $count orders');
}

Future<void> main() async {
  await withAwait();
}
```

```output
User 7 has 12 orders
```

## What await really does

`await` pauses only the function it is in. Control goes back to the caller, which keeps running.

```dart
Future<void> task() async {
  print('2. task started');
  await Future.delayed(Duration(seconds: 1));
  print('4. task finished');
}

void main() {
  print('1. main started');
  task(); // not awaited
  print('3. main reached its last line');
}
```

```output
1. main started
2. task started
3. main reached its last line
4. task finished
```

`task` runs synchronously until its first `await`. Then it steps aside, `main` continues, and `task` resumes a second later.

## Forgetting await

Leave out `await` and you get the future itself, not the value.

```dart
Future<int> fetchCount() async => 5;

Future<void> main() async {
  var wrong = fetchCount();
  var right = await fetchCount();

  print(wrong);
  print(right);
}
```

```output
Instance of 'Future<int>'
5
```

Dart's type checker usually catches this, because a `Future<int>` cannot be used as an `int`. Turn on the `unawaited_futures` lint to be warned when a future is ignored inside an `async` function.

## Sequential or parallel

Each `await` waits for the previous one. That is right when the second call **needs** the first result. When the calls are independent, start them all first and then wait.

```dart
Future<String> fetch(String what) =>
    Future.delayed(Duration(seconds: 1), () => '$what loaded');

Future<void> main() async {
  var watch = Stopwatch()..start();

  // One after another: about 2 seconds.
  final a = await fetch('profile');
  final b = await fetch('settings');
  print('$a, $b in ${watch.elapsed.inSeconds}s');

  watch.reset();

  // Together: about 1 second.
  final (c, d) = await (fetch('profile'), fetch('settings')).wait;
  print('$c, $d in ${watch.elapsed.inSeconds}s');
}
```

```output
profile loaded, settings loaded in 2s
profile loaded, settings loaded in 1s
```

More on this in [running futures in parallel](/async/parallel-futures/).

## await in loops

```dart
Future<String> download(String file) =>
    Future.delayed(Duration(milliseconds: 200), () => '$file ok');

Future<void> main() async {
  for (final file in ['a.png', 'b.png', 'c.png']) {
    print(await download(file)); // one at a time, in order
  }
}
```

```output
a.png ok
b.png ok
c.png ok
```

Do not use `forEach` with an `async` callback. It does not wait for the callbacks, so the code after it runs too early. Use a `for-in` loop.

## Async all the way

A function that awaits must be `async`, so its caller must await it, and so on upwards. That is normal. `main` itself can be `async`.

## Rules of thumb

- Return type of an async function is `Future<T>`, or `Future<void>` when there is no result.
- `await` works on any future, including ones from libraries.
- Use `try`/`catch` around `await` to handle failures. See [async error handling](/async/async-error-handling/).
- Do not mark a function `async` if it contains no `await`. Just return the future.

## Try it yourself

Write three functions that each wait half a second: `login()` returns a token, `fetchProfile(token)` returns a name, and `fetchPosts(name)` returns a list of titles. Call them in order with `await` and print how many posts the user has.
