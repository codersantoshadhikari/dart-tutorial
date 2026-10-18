---
title: "Single-Subscription vs Broadcast Streams in Dart"
linkTitle: "Single vs broadcast streams"
description: "Understand the two kinds of stream in Dart: single-subscription and broadcast. Learn the differences, when to use each and how to convert."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "broadcast stream"
  - "single subscription stream"
  - "asBroadcastStream"
  - "StreamController.broadcast"
  - "stream already listened"
aliases:
  - "/dart--asynchronouse-programming/single-subscription-vs.-broadcast-streams/"
  - "/fr/dart--asynchronouse-programming/single-subscription-vs.-broadcast-streams/"
---

Dart has two kinds of stream. They share the same API but behave differently when it comes to **who can listen** and **what happens to events nobody hears**.

## Single-subscription streams

This is the default. The stream allows **one** listener for its whole lifetime, and it does not start producing events until that listener arrives. Nothing is lost.

```dart
Stream<int> numbers() async* {
  print('(stream started)');
  yield 1;
  yield 2;
  yield 3;
}

Future<void> main() async {
  final stream = numbers();
  print('Created, not yet listening');

  await for (final n in stream) {
    print(n);
  }
}
```

```output
Created, not yet listening
(stream started)
1
2
3
```

The body of `numbers` did not run until `await for` began listening.

## Listening twice is an error

```dart
void main() {
  final stream = Stream.fromIterable([1, 2, 3]);

  stream.listen(print);

  try {
    stream.listen(print); // second listener
  } on StateError catch (e) {
    print('Error: ${e.message}');
  }
}
```

```output
Error: Stream has already been listened to.
1
2
3
```

This is the most common stream error beginners meet. Single-subscription streams suit data that must arrive completely and in order, such as the contents of a file or the body of an HTTP response.

## Broadcast streams

A broadcast stream allows **any number** of listeners. It behaves like a radio station: it transmits whether or not anyone is tuned in, and a listener only hears what is sent **after** they tune in.

```dart
import 'dart:async';

Future<void> main() async {
  final controller = StreamController<String>.broadcast();

  controller.add('Missed: nobody is listening yet');

  controller.stream.listen((m) => print('A heard: $m'));
  controller.add('First message');
  await Future.delayed(Duration.zero); // let the event be delivered

  controller.stream.listen((m) => print('B heard: $m'));
  controller.add('Second message');

  await controller.close();
}
```

```output
A heard: First message
A heard: Second message
B heard: Second message
```

The first event was lost because there were no listeners. `B` joined late and missed "First message". Broadcast streams suit events where only "what is happening now" matters: button clicks, login state, notifications.

## The differences

| | Single-subscription | Broadcast |
| --- | --- | --- |
| Number of listeners | Exactly one, once | Any number, any time |
| Starts producing | When listened to | Whenever events are added |
| Events with no listener | Held until someone listens | Dropped |
| Typical use | Files, HTTP bodies, `async*` | UI events, app state, notifications |
| Create with | `StreamController()`, `async*` | `StreamController.broadcast()` |

Check which kind you have with `stream.isBroadcast`.

## Converting a stream to broadcast

`asBroadcastStream()` wraps a single-subscription stream so that several listeners can share it.

```dart
import 'dart:async';

Future<void> main() async {
  final ticks = Stream.periodic(Duration(milliseconds: 200), (i) => i + 1)
      .take(3)
      .asBroadcastStream();

  ticks.listen((t) => print('Logger: tick $t'));
  ticks.listen((t) => print('Screen: tick $t'));

  await ticks.last;
}
```

```output
Logger: tick 1
Screen: tick 1
Logger: tick 2
Screen: tick 2
Logger: tick 3
Screen: tick 3
```

## Giving late listeners the latest value

A plain broadcast stream does not remember anything, so a screen that subscribes late shows nothing until the next event. Keep the current value yourself and hand it to new listeners.

```dart
import 'dart:async';

class Counter {
  int _value = 0;
  final _controller = StreamController<int>.broadcast();

  int get value => _value;
  Stream<int> get changes => _controller.stream;

  void increment() {
    _value++;
    _controller.add(_value);
  }

  Future<void> dispose() => _controller.close();
}

Future<void> main() async {
  final counter = Counter();
  counter.increment();
  counter.increment();

  print('Current value on arrival: ${counter.value}');
  counter.changes.listen((v) => print('Changed to $v'));

  counter.increment();
  await counter.dispose();
}
```

```output
Current value on arrival: 2
Changed to 3
```

Packages such as `rxdart` (`BehaviorSubject`) and Flutter state-management libraries do this for you.

## Which should I use?

- Producing a sequence that one consumer will read from start to finish: **single-subscription**. This is what `async*` gives you.
- Announcing events that several parts of an app care about: **broadcast**.
- Not sure? Start with single-subscription. It is the safer default, because it cannot silently drop data.

Either way, close your controllers and cancel your subscriptions when you are done.

## Try it yourself

Create a broadcast `StreamController<String>` for chat messages. Add two listeners, one that prints every message and one that only prints messages containing "urgent". Send a few messages, cancel the first listener, and send one more.
