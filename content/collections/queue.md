---
title: "Queue in Dart: Adding and Removing from Both Ends"
linkTitle: "Queue"
description: "Learn the Queue class from dart:collection. Add and remove items at both ends efficiently, and build FIFO queues and stacks."
weight: 10
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart queue"
  - "dart:collection"
  - "FIFO"
  - "stack dart"
  - "addFirst removeFirst"
  - "deque"
aliases:
  - "/dart-collections/queue-in-dart/"
  - "/fr/dart-collections/queue-in-dart/"
---

A `Queue` is a collection built for adding and removing items at **both ends**. Removing the first item of a `List` is slow because every other item has to shift down. A queue does it instantly.

`Queue` lives in the `dart:collection` library, so it needs an import.

## Creating a queue

```dart
import 'dart:collection';

void main() {
  var queue = Queue<String>();

  queue.add('Asha');       // same as addLast
  queue.addLast('Bimal');
  queue.addFirst('Chandra');

  print(queue);
  print(queue.first);
  print(queue.last);
  print(queue.length);
}
```

```output
{Chandra, Asha, Bimal}
Chandra
Bimal
3
```

## Removing from either end

```dart
import 'dart:collection';

void main() {
  var queue = Queue.of([10, 20, 30, 40]);

  print(queue.removeFirst());
  print(queue.removeLast());
  print(queue);
}
```

```output
10
40
{20, 30}
```

Both methods throw a `StateError` on an empty queue, so check `isNotEmpty` first.

## First in, first out

The everyday meaning of a queue: whoever arrives first is served first. Add at the back, remove from the front.

```dart
import 'dart:collection';

void main() {
  var printJobs = Queue<String>()
    ..add('report.pdf')
    ..add('photo.png')
    ..add('invoice.docx');

  while (printJobs.isNotEmpty) {
    final job = printJobs.removeFirst();
    print('Printing $job (${printJobs.length} waiting)');
  }
}
```

```output
Printing report.pdf (2 waiting)
Printing photo.png (1 waiting)
Printing invoice.docx (0 waiting)
```

## Last in, first out: a stack

Add and remove at the same end and you have a stack, the structure behind an "undo" button.

```dart
import 'dart:collection';

void main() {
  var history = Queue<String>();

  history.addLast('typed "Hello"');
  history.addLast('made text bold');
  history.addLast('deleted a line');

  print('Undo: ${history.removeLast()}');
  print('Undo: ${history.removeLast()}');
  print('Remaining: $history');
}
```

```output
Undo: deleted a line
Undo: made text bold
Remaining: {typed "Hello"}
```

A plain `List` with `add` and `removeLast` also works well as a stack.

## Queue or List?

| Operation | `List` | `Queue` |
| --- | --- | --- |
| Add or remove at the end | Fast | Fast |
| Add or remove at the start | Slow on big lists | Fast |
| Read by index `[i]` | Fast | Not available (`elementAt` is slow) |
| Sort | Yes | No |

Choose a queue when items are processed in arrival order: tasks waiting to run, messages to send, pages to visit in a search. Otherwise stay with a list.

A queue is an `Iterable`, so `for-in`, `where`, `map`, `contains` and `toList` all work on it.

## Try it yourself

Simulate a ticket counter. Add five customer names to a queue. A VIP arrives and goes to the front. Serve customers one at a time, printing who is served and who is next, until the queue is empty.
