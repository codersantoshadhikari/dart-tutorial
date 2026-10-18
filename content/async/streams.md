---
title: "Streams in Dart: Handling a Sequence of Async Events"
seoTitle: "Dart Streams Tutorial: listen, async* and StreamController"
linkTitle: "Streams"
description: "Learn Stream in Dart: listen to events over time, use await for, create streams with async* and StreamController, and transform them."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart stream"
  - "await for"
  - "async*"
  - "yield"
  - "StreamController"
  - "stream listen"
  - "stream transform"
aliases:
  - "/dart--asynchronouse-programming/stream-in-dart/"
  - "/fr/dart--asynchronouse-programming/stream-in-dart/"
---

A `Future` delivers **one** value later. A `Stream` delivers **many** values over time: zero, five, or an endless flow. If a future is a parcel on its way to you, a stream is a conveyor belt.

Streams are everywhere: keystrokes, WebSocket messages, download progress, sensor readings, database changes, and the chunks of a large file.

## Reading a stream with await for

`await for` is a loop that waits for each event. It ends when the stream closes.

```dart
Stream<int> countDown(int from) async* {
  for (var i = from; i >= 1; i--) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i; // send one value to the listener
  }
}

Future<void> main() async {
  await for (final n in countDown(3)) {
    print(n);
  }
  print('Lift off!');
}
```

```output
3
2
1
Lift off!
```

## Creating a stream with async*

A function marked `async*` returns a `Stream`. Each `yield` emits one value. This is the simplest way to make your own stream.

```dart
Stream<String> loadPages(int count) async* {
  for (var page = 1; page <= count; page++) {
    await Future.delayed(Duration(milliseconds: 300));
    yield 'Page $page of $count';
  }
}

Future<void> main() async {
  await for (final status in loadPages(3)) {
    print(status);
  }
}
```

```output
Page 1 of 3
Page 2 of 3
Page 3 of 3
```

## Listening with listen

`listen` registers callbacks and returns straight away, so your code continues while events arrive. It gives you a `StreamSubscription` that you can pause or cancel.

```dart
import 'dart:async';

Future<void> main() async {
  final ticks = Stream.periodic(Duration(milliseconds: 300), (i) => i + 1);

  late StreamSubscription<int> subscription;
  subscription = ticks.listen(
    (tick) {
      print('Tick $tick');
      if (tick == 3) subscription.cancel(); // stop listening
    },
    onError: (e) => print('Error: $e'),
    onDone: () => print('Stream closed'),
  );

  print('Listening...');
}
```

```output
Listening...
Tick 1
Tick 2
Tick 3
```

Always cancel subscriptions you no longer need. In Flutter that means in `dispose()`. A forgotten subscription is a memory leak.

| | `await for` | `listen` |
| --- | --- | --- |
| Code after it runs | When the stream ends | Immediately |
| Stop early | `break` | `subscription.cancel()` |
| Best for | Processing every event in order | Long-lived event handlers |

## Other ways to create streams

```dart
Future<void> main() async {
  final fromList = Stream.fromIterable(['a', 'b', 'c']);
  final fromFuture = Stream.fromFuture(Future.value('single'));
  final single = Stream.value(99);

  print(await fromList.toList());
  print(await fromFuture.first);
  print(await single.first);
}
```

```output
[a, b, c]
single
99
```

## StreamController: push events by hand

When events come from somewhere else, such as button presses, use a `StreamController`. You add events to its `sink` and others listen to its `stream`.

```dart
import 'dart:async';

Future<void> main() async {
  final controller = StreamController<String>();

  controller.stream.listen(
    (message) => print('Received: $message'),
    onError: (e) => print('Problem: $e'),
    onDone: () => print('No more messages'),
  );

  controller.add('Hello');
  controller.add('How are you?');
  controller.addError(Exception('Connection hiccup'));
  controller.add('Bye');
  await controller.close(); // always close when finished
}
```

```output
Received: Hello
Received: How are you?
Problem: Exception: Connection hiccup
Received: Bye
No more messages
```

An error does not end the stream. With an `onError` handler in place, later events keep arriving. Without one, the error is reported as unhandled.

## Transforming streams

Streams have the same methods as iterables: `map`, `where`, `take`, `skip`, `expand`, and more. Each returns a new stream.

```dart
Future<void> main() async {
  final numbers = Stream.fromIterable([1, 2, 3, 4, 5, 6, 7, 8]);

  final result = numbers
      .where((n) => n.isEven)
      .map((n) => n * n)
      .take(3);

  await for (final n in result) {
    print(n);
  }
}
```

```output
4
16
36
```

## Getting a single answer from a stream

These return a `Future`, because the stream has to be read first.

```dart
Future<void> main() async {
  Stream<int> numbers() => Stream.fromIterable([4, 8, 15, 16]);

  print(await numbers().first);
  print(await numbers().last);
  print(await numbers().length);
  print(await numbers().contains(15));
  print(await numbers().reduce((a, b) => a + b));
  print(await numbers().firstWhere((n) => n > 10));
}
```

```output
4
16
4
true
43
15
```

Each call uses a fresh stream, because an ordinary stream can only be listened to once. That is the subject of the [next lesson](/async/stream-types/).

## Errors in await for

```dart
Stream<int> risky() async* {
  yield 1;
  yield 2;
  throw Exception('Sensor disconnected');
}

Future<void> main() async {
  try {
    await for (final value in risky()) {
      print(value);
    }
  } catch (e) {
    print('Stopped: $e');
  }
}
```

```output
1
2
Stopped: Exception: Sensor disconnected
```

## Try it yourself

Write `Stream<int> fibonacci(int count)` using `async*` that emits one Fibonacci number every 200 milliseconds. Listen with `await for`, keep only the even numbers with `where`, and print them.
