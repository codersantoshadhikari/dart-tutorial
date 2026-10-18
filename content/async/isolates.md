---
title: "Isolates in Dart: Running Code in Parallel"
linkTitle: "Isolates"
description: "Learn isolates in Dart: run heavy work on another CPU core with Isolate.run, pass messages with ports, and keep your app responsive."
weight: 10
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart isolate"
  - "Isolate.run"
  - "parallel dart"
  - "compute flutter"
  - "SendPort ReceivePort"
  - "multithreading dart"
aliases:
  - "/dart--asynchronouse-programming/isolates-in-dart/"
  - "/fr/dart--asynchronouse-programming/isolates-in-dart/"
---

`async` and `await` let Dart do other things while it **waits**. They do not help when the processor itself is **busy**, for example parsing a 50 MB JSON file or applying a filter to a photo. That work blocks the single thread and freezes the app.

The answer is an **isolate**: a separate worker with its own thread, its own memory and its own event loop.

> Isolates are not available on the web, so these examples will not run in DartPad. Run them with `dart run`.

## Why "isolate"?

Isolates **share no memory**. One isolate cannot read or change another's variables. They communicate only by sending messages. This removes the locks, race conditions and corrupted data that make threads difficult in other languages.

Your program always has one isolate to begin with, called the main isolate.

## Isolate.run: the easy way

Give `Isolate.run` a function. It starts a new isolate, runs the function there, sends back the result, and shuts the isolate down.

```dart
import 'dart:isolate';

int countPrimes(int limit) {
  var count = 0;
  for (var n = 2; n <= limit; n++) {
    var isPrime = true;
    for (var d = 2; d * d <= n; d++) {
      if (n % d == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime) count++;
  }
  return count;
}

Future<void> main() async {
  print('Starting heavy work...');

  final result = await Isolate.run(() => countPrimes(5000000));

  print('Primes below 5,000,000: $result');
}
```

```output
Starting heavy work...
Primes below 5,000,000: 348513
```

While the count runs on another core, the main isolate stays free. In Flutter, animations keep moving and buttons keep responding.

## Proof that the main isolate stays free

```dart
import 'dart:async';
import 'dart:isolate';

int slowSum(int n) {
  var total = 0;
  for (var i = 0; i < n; i++) {
    total += i % 7;
  }
  return total;
}

Future<void> main() async {
  final ticker = Timer.periodic(
    Duration(milliseconds: 200),
    (_) => print('  main isolate is still responsive'),
  );

  final total = await Isolate.run(() => slowSum(2000000000));

  ticker.cancel();
  print('Result: $total');
}
```

The "still responsive" line keeps printing while the sum is calculated. Call `slowSum` directly instead and the ticks stop until it finishes.

## Several isolates at once

```dart
import 'dart:isolate';

int fib(int n) => n < 2 ? n : fib(n - 1) + fib(n - 2);

Future<void> main() async {
  final watch = Stopwatch()..start();

  final results = await Future.wait([
    Isolate.run(() => fib(38)),
    Isolate.run(() => fib(38)),
    Isolate.run(() => fib(38)),
  ]);

  print(results);
  print('Finished in ${watch.elapsedMilliseconds} ms');
}
```

On a multi-core machine the three run side by side, so the total time is close to that of one.

## What you can send between isolates

Arguments and results are **copied** when they cross from one isolate to another. Numbers, strings, booleans, lists, maps and most plain Dart objects are fine. Objects tied to system resources, such as open sockets, are not.

One trap: the function you pass must not capture objects that cannot be sent. Pass plain data in, and get plain data back.

## Long-lived isolates with ports

For a worker that stays alive and handles many messages, use `Isolate.spawn` with a `ReceivePort` and `SendPort`. A port is a one-way mailbox.

```dart
import 'dart:isolate';

// Runs in the new isolate.
void worker(SendPort toMain) {
  final inbox = ReceivePort();
  toMain.send(inbox.sendPort); // tell main how to reach us

  inbox.listen((message) {
    if (message == 'stop') {
      inbox.close();
      return;
    }
    toMain.send('"$message" has ${(message as String).length} characters');
  });
}

Future<void> main() async {
  final fromWorker = ReceivePort();
  await Isolate.spawn(worker, fromWorker.sendPort);

  late SendPort toWorker;
  var replies = 0;

  await for (final message in fromWorker) {
    if (message is SendPort) {
      toWorker = message;
      toWorker.send('hello');
      toWorker.send('isolates');
    } else {
      print(message);
      if (++replies == 2) {
        toWorker.send('stop');
        fromWorker.close();
      }
    }
  }
}
```

```output
"hello" has 5 characters
"isolates" has 8 characters
```

This is more work. Use it only when starting a fresh isolate per task would be too slow, or when you need a continuing conversation.

## In Flutter

Flutter provides `compute(function, argument)`, which behaves like `Isolate.run` and also works on the web, where it runs on the main thread.

## When to use an isolate

| Task | Use |
| --- | --- |
| HTTP request, database query, reading a file | `async` / `await`. It is waiting, not computing |
| Parsing or encoding large JSON | Isolate |
| Image or video processing | Isolate |
| Encryption, compression, hashing big data | Isolate |
| Sorting or searching very large lists | Isolate |
| A quick calculation | Neither. Just run it |

Starting an isolate takes time and memory, and copying large data across costs too. For work that takes less than a few milliseconds, an isolate is slower than doing it directly. A good test: if the work makes your interface stutter, move it.

## Try it yourself

Write a function that sums the square roots of the numbers from 1 to 50,000,000. Run it once directly and once with `Isolate.run`, while a periodic timer prints a dot every 100 ms. Compare what happens to the dots.
