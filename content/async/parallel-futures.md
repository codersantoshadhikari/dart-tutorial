---
title: "Running Futures in Parallel in Dart: Future.wait and More"
linkTitle: "Parallel futures"
description: "Run several async operations at once in Dart with Future.wait, record wait, Future.any and batching, and handle their errors."
weight: 7
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "Future.wait"
  - "concurrent futures"
  - "parallel async dart"
  - "Future.any"
  - "record wait"
  - "eagerError"
aliases:
  - "/dart--asynchronouse-programming/handling-concurrent-asynchronous-operations/"
  - "/fr/dart--asynchronouse-programming/handling-concurrent-asynchronous-operations/"
---

When several asynchronous tasks do not depend on each other, start them all and wait for them together. The total time is then that of the **slowest** task, not the sum of all of them.

## The slow way

```dart
Future<String> fetch(String name, int ms) =>
    Future.delayed(Duration(milliseconds: ms), () => name);

Future<void> main() async {
  final watch = Stopwatch()..start();

  final user = await fetch('user', 600);
  final posts = await fetch('posts', 600);
  final friends = await fetch('friends', 600);

  print('$user, $posts, $friends');
  print('Took about ${(watch.elapsedMilliseconds / 100).round() / 10}s');
}
```

```output
user, posts, friends
Took about 1.8s
```

Each `await` waits for the one before, although none of them needs the others.

## Future.wait

Give `Future.wait` a list of futures. It returns one future that completes with a list of results, in the **same order** as the input.

```dart
Future<String> fetch(String name, int ms) =>
    Future.delayed(Duration(milliseconds: ms), () => name);

Future<void> main() async {
  final watch = Stopwatch()..start();

  final results = await Future.wait([
    fetch('user', 600),
    fetch('posts', 400),
    fetch('friends', 500),
  ]);

  print(results);
  print('Took about ${(watch.elapsedMilliseconds / 100).round() / 10}s');
}
```

```output
[user, posts, friends]
Took about 0.6s
```

The futures start the moment they are created, in the list. `Future.wait` only collects them.

## Different result types: wait on a record

`Future.wait` needs all futures to share a type. For a mix of types, put the futures in a record and use `.wait`. Each result keeps its own type.

```dart
Future<String> fetchName() =>
    Future.delayed(Duration(milliseconds: 300), () => 'Anjali');
Future<int> fetchAge() => Future.delayed(Duration(milliseconds: 200), () => 27);
Future<List<String>> fetchTags() =>
    Future.delayed(Duration(milliseconds: 100), () => ['dart', 'flutter']);

Future<void> main() async {
  final (name, age, tags) = await (fetchName(), fetchAge(), fetchTags()).wait;

  print('$name, $age, ${tags.length} tags');
}
```

```output
Anjali, 27, 2 tags
```

A list of futures has the same extension: `await [a, b, c].wait`.

## Many items from a list

A typical case is loading details for a list of ids.

```dart
Future<String> fetchProduct(int id) =>
    Future.delayed(Duration(milliseconds: 300), () => 'Product $id');

Future<void> main() async {
  final ids = [1, 2, 3, 4];

  final products = await Future.wait(ids.map(fetchProduct));
  print(products);
}
```

```output
[Product 1, Product 2, Product 3, Product 4]
```

## What happens when one fails

`Future.wait` completes with an error if any future fails. By default it waits for **all** of them to finish first and then reports the first error. Pass `eagerError: true` to fail immediately.

```dart
Future<String> task(String name, {bool fail = false}) async {
  await Future.delayed(Duration(milliseconds: 200));
  if (fail) throw Exception('$name failed');
  return name;
}

Future<void> main() async {
  try {
    await Future.wait([task('a'), task('b', fail: true), task('c')]);
  } catch (e) {
    print('Caught: $e');
  }
}
```

```output
Caught: Exception: b failed
```

The successful results are lost. To keep them, convert each future into one that never throws, as shown in [async error handling](/async/async-error-handling/). With the record or list `.wait` extension, a failure throws a `ParallelWaitError` that carries both the values and the errors.

## Future.any: the first to finish

`Future.any` completes with the result of whichever future finishes first. It is useful for racing several mirrors or adding your own timeout.

```dart
Future<String> server(String name, int ms) =>
    Future.delayed(Duration(milliseconds: ms), () => 'Response from $name');

Future<void> main() async {
  final fastest = await Future.any([
    server('Asia', 300),
    server('Europe', 150),
    server('America', 400),
  ]);
  print(fastest);
}
```

```output
Response from Europe
```

## Do not start too many at once

Launching a thousand requests together can overwhelm a server or get you rate limited. Work through the items in batches.

```dart
Future<String> upload(int id) =>
    Future.delayed(Duration(milliseconds: 200), () => 'file $id uploaded');

Future<void> main() async {
  final ids = List.generate(7, (i) => i + 1);
  const batchSize = 3;

  for (var i = 0; i < ids.length; i += batchSize) {
    final batch = ids.skip(i).take(batchSize);
    final results = await Future.wait(batch.map(upload));
    print(results);
  }
}
```

```output
[file 1 uploaded, file 2 uploaded, file 3 uploaded]
[file 4 uploaded, file 5 uploaded, file 6 uploaded]
[file 7 uploaded]
```

## Starting without waiting

Sometimes you want to kick off a task and not wait for it, such as sending an analytics event. Say so explicitly with `unawaited`, so readers and the linter know it is deliberate, and make sure the task handles its own errors.

```dart
import 'dart:async';

Future<void> logEvent(String name) async {
  try {
    await Future.delayed(Duration(milliseconds: 100));
    print('logged $name');
  } catch (_) {
    // Analytics must never crash the app.
  }
}

void main() {
  unawaited(logEvent('screen_opened'));
  print('Screen shown immediately');
}
```

```output
Screen shown immediately
logged screen_opened
```

## Sequential or parallel?

| Run in sequence when | Run in parallel when |
| --- | --- |
| A later step needs an earlier result | The tasks are independent |
| Order of side effects matters | Only the final results matter |
| You must not overload a service | The service can take the load |

Remember that this is **concurrency**, not multi-core parallelism. All of this runs on one thread, overlapping the waiting time. For heavy calculations, see [isolates](/async/isolates/).

## Try it yourself

Simulate a dashboard that needs the weather (700 ms), the news (500 ms) and the user's calendar (300 ms). Load all three in parallel, print each result, and print the total time. Then make the news fail and still show the other two.
