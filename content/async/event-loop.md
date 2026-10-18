---
title: "The Dart Event Loop: Microtasks and Events Explained"
linkTitle: "Event loop"
description: "Understand how Dart runs asynchronous code on one thread: the event loop, event queue, microtask queue, and the order code executes."
weight: 9
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart event loop"
  - "microtask queue"
  - "event queue"
  - "scheduleMicrotask"
  - "Future.microtask"
  - "execution order"
aliases:
  - "/dart--asynchronouse-programming/microtasks-and-event-loops-in-dart/"
  - "/fr/dart--asynchronouse-programming/microtasks-and-event-loops-in-dart/"
---

Dart runs your code on a **single thread**, yet it handles taps, timers and network responses without getting stuck. The mechanism behind this is the **event loop**. Knowing how it works explains the order in which asynchronous code runs, and why an app can freeze.

## One thread, two queues

Dart keeps two queues of work waiting to run:

- The **event queue** holds things from the outside world: timers, I/O results, user input, messages from isolates, and callbacks from `Future(...)` and `Future.delayed(...)`.
- The **microtask queue** holds very short internal jobs that must run as soon as possible: completions of already-finished futures, and anything scheduled with `scheduleMicrotask` or `Future.microtask`.

## The loop

1. Run `main()` from start to finish. All synchronous code runs first.
2. Run **every** microtask, until the microtask queue is empty.
3. Take **one** event from the event queue and run its handler.
4. Go back to step 2.
5. When both queues are empty and nothing is pending, the program ends.

The key rule: **microtasks always run before the next event.**

## See the order for yourself

```dart
import 'dart:async';

void main() {
  print('1. sync start');

  Future(() => print('5. event queue'));
  Future.delayed(Duration.zero, () => print('6. event queue (zero delay)'));

  scheduleMicrotask(() => print('3. microtask'));
  Future.microtask(() => print('4. microtask'));

  print('2. sync end');
}
```

```output
1. sync start
2. sync end
3. microtask
4. microtask
5. event queue
6. event queue (zero delay)
```

Nothing asynchronous runs until `main` has finished. Then both microtasks run, then the events, in the order they were queued.

## Where then and await fit in

Callbacks registered with `then`, and the code after an `await`, run as microtasks once the future they depend on has completed.

```dart
void main() {
  print('A');

  Future(() => print('D: event'))
      .then((_) => print('E: then, right after its event'));

  Future.value('ready').then((_) => print('C: then on a finished future'));

  print('B');
}
```

```output
A
B
C: then on a finished future
D: event
E: then, right after its event
```

`C` runs in the microtask phase because its future was already complete. `E` runs straight after `D`, before any other event, because completing `D` queued it as a microtask.

## Async functions run synchronously until the first await

```dart
Future<void> work() async {
  print('2. inside work, before await');
  await null;
  print('4. inside work, after await');
}

void main() {
  print('1. before work');
  work();
  print('3. after work');
}
```

```output
1. before work
2. inside work, before await
3. after work
4. inside work, after await
```

## Why apps freeze

While one piece of code is running, **nothing else can**. No taps are handled and, in Flutter, no frames are drawn. A long synchronous calculation blocks the loop.

```dart
void main() {
  Future.delayed(Duration(milliseconds: 100), () => print('Timer fired'));

  final watch = Stopwatch()..start();
  var x = 0;
  while (watch.elapsedMilliseconds < 1000) {
    x++; // one second of busy work
  }
  print('Busy work done after ${watch.elapsedMilliseconds} ms');
}
```

```output
Busy work done after 1000 ms
Timer fired
```

The timer was due after 100 ms, but it could not run until the loop was free, a full second later. Marking the function `async` would not help: it is still one thread doing the work. Heavy work belongs in an [isolate](/async/isolates/).

## Starving the event queue

Because all microtasks run before the next event, a microtask that keeps scheduling more microtasks stops events from ever being handled. Use microtasks rarely and keep them tiny.

## Practical guidance

- You almost never need `scheduleMicrotask`. Use `await` and futures.
- `await Future.delayed(Duration.zero)` lets pending events, such as a screen redraw, run before your code continues.
- Keep each piece of synchronous work short. In a Flutter app at 60 frames per second you have about 16 ms per frame.
- A long loop over a big list can be split into chunks with an `await` between them, or moved to an isolate.

## Summary

| | Microtask queue | Event queue |
| --- | --- | --- |
| Priority | Runs first, drained completely | One item at a time, after microtasks |
| Filled by | `then` callbacks, code after `await`, `scheduleMicrotask`, `Future.microtask` | Timers, I/O, user input, `Future(...)`, `Future.delayed(...)` |
| Use it for | Short follow-up work | Everything else |

## Try it yourself

Without running it, write down the order in which this prints, then check: a `print` at the start of `main`, a `Future.delayed(Duration.zero)`, a `Future.microtask`, a `Future.value(1).then(...)`, a plain `Future(...)` and a final `print`.
