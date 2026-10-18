---
title: "Completer in Dart: Creating Futures You Complete Yourself"
linkTitle: "Completer"
description: "Learn how to use Completer in Dart to build a Future by hand, wrap callback-based APIs, and complete with a value or an error."
weight: 8
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart completer"
  - "complete future manually"
  - "callback to future"
  - "completeError"
  - "isCompleted"
aliases:
  - "/dart--asynchronouse-programming/using-completer-in-dart/"
  - "/fr/dart--asynchronouse-programming/using-completer-in-dart/"
---

Normally an `async` function creates and completes its future for you. A `Completer` lets you create a future and complete it **yourself**, later, from anywhere. It is a low-level tool for the few cases `async`/`await` cannot express.

## The basics

A completer has two sides:

- `completer.future` is what you give to the code that waits.
- `completer.complete(value)` or `completer.completeError(error)` is what you call when the result is known.

```dart
import 'dart:async';

Future<void> main() async {
  final completer = Completer<String>();

  // Somewhere else, later:
  Timer(Duration(seconds: 1), () {
    completer.complete('The result');
  });

  print('Waiting...');
  final value = await completer.future;
  print(value);
}
```

```output
Waiting...
The result
```

## Main use: wrapping a callback-style API

Some older libraries and platform APIs report results by calling a function you pass in. A completer turns that into a future you can `await`.

```dart
import 'dart:async';

// An old-style API we cannot change.
void legacyDownload(
  String url, {
  required void Function(String data) onSuccess,
  required void Function(String error) onError,
}) {
  Timer(Duration(milliseconds: 300), () {
    if (url.startsWith('https')) {
      onSuccess('contents of $url');
    } else {
      onError('insecure URL');
    }
  });
}

// A modern wrapper.
Future<String> download(String url) {
  final completer = Completer<String>();

  legacyDownload(
    url,
    onSuccess: completer.complete,
    onError: (message) => completer.completeError(Exception(message)),
  );

  return completer.future;
}

Future<void> main() async {
  print(await download('https://example.com/a.txt'));

  try {
    await download('http://example.com/b.txt');
  } catch (e) {
    print('Failed: $e');
  }
}
```

```output
contents of https://example.com/a.txt
Failed: Exception: insecure URL
```

## Waiting for an event that happens elsewhere

A completer can act as a one-time signal between two parts of a program.

```dart
import 'dart:async';

class Connection {
  final _ready = Completer<void>();

  Future<void> get ready => _ready.future;

  void open() {
    Timer(Duration(milliseconds: 500), () {
      print('Connection established');
      _ready.complete();
    });
  }
}

Future<void> main() async {
  final connection = Connection()..open();

  print('Waiting for the connection');
  await connection.ready;
  print('Sending data');
}
```

```output
Waiting for the connection
Connection established
Sending data
```

Any number of callers can await `connection.ready`, before or after it completes.

## A completer can be completed only once

Calling `complete` twice throws a `StateError`. Check `isCompleted` when more than one path might finish it.

```dart
import 'dart:async';

Future<void> main() async {
  final completer = Completer<String>();

  // Whichever happens first wins.
  Timer(Duration(milliseconds: 200), () {
    if (!completer.isCompleted) completer.complete('answer arrived');
  });
  Timer(Duration(milliseconds: 500), () {
    if (!completer.isCompleted) completer.complete('gave up waiting');
  });

  print(await completer.future);
}
```

```output
answer arrived
```

## Pitfalls

- **Forgetting to complete it.** If some path through your code never calls `complete` or `completeError`, whoever awaits the future waits forever. Make sure every path, including errors, finishes the completer.
- **Using one where async is enough.** This is the most common misuse.

```dart
import 'dart:async';

// Unnecessary.
Future<int> doubleLaterWithCompleter(int n) {
  final completer = Completer<int>();
  Future.delayed(Duration(milliseconds: 100)).then((_) {
    completer.complete(n * 2);
  });
  return completer.future;
}

// Same behaviour, simpler and safer.
Future<int> doubleLater(int n) async {
  await Future.delayed(Duration(milliseconds: 100));
  return n * 2;
}

Future<void> main() async {
  print(await doubleLaterWithCompleter(4));
  print(await doubleLater(4));
}
```

```output
8
8
```

## When a Completer is the right tool

| Situation | Use |
| --- | --- |
| Calling futures and returning a value | `async` / `await` |
| Wrapping a callback-based API | `Completer` |
| Signalling "this one-time event has happened" | `Completer` |
| Many events over time | `StreamController` |

## Try it yourself

Write `Future<String> waitForAnswer()` using a completer. Start two timers: one completes it with `'yes'` after 300 ms, the other with an error after 1 second. Guard both with `isCompleted`, and print the result.
