---
title: "Asynchronous Programming in Dart: An Introduction"
linkTitle: "Introduction"
description: "Understand synchronous versus asynchronous code in Dart, why apps need async, and how Future, async, await and Stream fit together."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart async"
  - "asynchronous programming"
  - "synchronous vs asynchronous"
  - "non-blocking"
---

## Synchronous code: one thing at a time

Normal code is **synchronous**. Each line finishes before the next starts.

```dart
void main() {
  print('Order coffee');
  print('Make coffee');
  print('Drink coffee');
}
```

That is fine when every step is instant. Now imagine a step that takes three seconds, such as downloading a photo. If the program simply waited, nothing else could happen. In an app, the screen would freeze: no scrolling, no animations, no response to taps.

## Asynchronous code: start it, then carry on

**Asynchronous** code starts a slow operation and moves on immediately. When the operation finishes, the program is notified and deals with the result.

Think of a café. You order, get a receipt, and sit down. You are free to talk or read while the coffee is made, and your name is called when it is ready. The receipt is a promise of a coffee to come.

In Dart, that receipt is called a `Future`.

```dart
Future<String> makeCoffee() {
  // Pretend this takes 2 seconds.
  return Future.delayed(Duration(seconds: 2), () => 'Coffee is ready');
}

void main() {
  print('Order coffee');
  makeCoffee().then((result) => print(result));
  print('Find a table'); // runs straight away, without waiting
}
```

```output
Order coffee
Find a table
Coffee is ready
```

Look at the order. "Find a table" was printed **before** the coffee was ready, even though it comes later in the code.

## The same thing with async and await

Chaining `.then` gets awkward. The `async` and `await` keywords let you write asynchronous code that reads from top to bottom.

```dart
Future<String> makeCoffee() =>
    Future.delayed(Duration(seconds: 2), () => 'Coffee is ready');

Future<void> main() async {
  print('Order coffee');
  final result = await makeCoffee(); // pause here until it is done
  print(result);
  print('Drink coffee');
}
```

```output
Order coffee
Coffee is ready
Drink coffee
```

`await` pauses **this function** until the future completes. It does not freeze the program: other events, such as screen updates, keep being handled in the meantime.

## What takes time?

| Operation | Why it is asynchronous |
| --- | --- |
| HTTP requests | The network is slow and unpredictable |
| Reading and writing files | Disks are slow compared with memory |
| Database queries | They involve disk or network access |
| Timers and delays | Waiting is the whole point |
| User input | You never know when it will come |

## The main building blocks

| Tool | What it represents | Lesson |
| --- | --- | --- |
| `Future<T>` | **One** value that arrives later | [Futures](/async/futures/) |
| `async` / `await` | Readable syntax for working with futures | [async and await](/async/async-await/) |
| `Stream<T>` | **Many** values that arrive over time | [Streams](/async/streams/) |
| `Isolate` | Truly parallel work on another CPU core | [Isolates](/async/isolates/) |

## Asynchronous is not the same as parallel

Dart code runs on a single thread. Asynchronous code does not do two calculations at once. It makes good use of **waiting time**. While a network request is in flight, Dart is free to run other code.

This works brilliantly for input and output, which is mostly waiting. It does **not** help with heavy calculation, such as resizing a huge image, because that keeps the one thread busy. For that you need an isolate.

## Try it yourself

Run the first café example in DartPad. Add a second function `makeToast()` that takes one second, call both without `await`, and predict the order of the output before you run it.
