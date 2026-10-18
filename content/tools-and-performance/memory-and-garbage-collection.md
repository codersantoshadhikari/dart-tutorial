---
title: "Memory Management and Garbage Collection in Dart"
linkTitle: "Memory and garbage collection"
description: "Understand how Dart manages memory: the generational garbage collector, what causes memory leaks, and how to find and prevent them."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart garbage collection"
  - "memory management dart"
  - "memory leak"
  - "generational gc"
  - "WeakReference"
  - "Finalizer"
  - "dart memory"
aliases:
  - "/memory-management--performance/garbage-collection-in-dart/"
  - "/fr/memory-management--performance/garbage-collection-in-dart/"
---

In Dart you create objects and never delete them. Freeing memory is the job of the **garbage collector** (GC), which runs automatically. You do not need to manage memory by hand, but knowing how the collector works helps you write faster code and avoid leaks.

## Where values live

- The **stack** holds local variables and the chain of function calls. It grows and shrinks automatically as functions are called and return.
- The **heap** holds objects. A variable on the stack holds a reference to an object on the heap.

```dart
class User {
  String name;
  User(this.name);
}

void main() {
  var a = User('Asha'); // object on the heap, reference in a
  var b = a;            // second reference, same object
  b.name = 'Bimal';
  print(a.name);
}
```

```output
Bimal
```

## When is an object garbage?

An object can be freed once it is **unreachable**: nothing your program can still get to holds a reference to it.

```dart
class Report {
  final String title;
  Report(this.title);
}

void main() {
  Report? report = Report('Sales'); // reachable through `report`
  print(report.title);

  report = null; // the Report is now unreachable and can be collected
}
```

You cannot know exactly **when** it will be collected, only that it will not be while still reachable.

## The generational collector

Dart's collector is built on one observation: **most objects die young**. A temporary string or a widget rebuilt on the next frame lives for milliseconds.

| | Young generation | Old generation |
| --- | --- | --- |
| Holds | Newly created objects | Objects that survived young collections |
| Collection | Very fast and very frequent | Slower and rare |
| How | Copies the survivors, drops everything else in one go | Marks what is reachable, then sweeps away the rest |
| Cost depends on | The number of **surviving** objects | The size of the heap |

Two consequences matter to you:

1. **Creating many short-lived objects is cheap.** Allocation is a pointer bump, and dead young objects cost nothing to clean up. This is why Flutter can rebuild widgets constantly.
2. **Long-lived objects cost more.** They are promoted to the old generation, whose collections take longer.

Much of the old-generation work runs concurrently, and Flutter schedules collections while the app is idle, so pauses are usually too short to notice.

## Memory leaks

Garbage collection does not make leaks impossible. A leak in Dart is an object that is **still reachable but will never be used again**. The collector must keep it, and everything it refers to.

### Leak 1: a subscription that is never cancelled

```dart
import 'dart:async';

final events = StreamController<String>.broadcast();

class Screen {
  final List<int> bigData = List.filled(1000000, 0);
  StreamSubscription<String>? _subscription;

  void open() {
    // The stream now refers to this callback, which refers to this Screen.
    _subscription = events.stream.listen((e) => print('$e for $hashCode'));
  }

  void close() {
    _subscription?.cancel(); // without this line, the Screen can never be freed
  }
}

void main() {
  final screen = Screen()..open();
  screen.close();
  events.close();
}
```

This is the most common leak in Flutter apps. Cancel subscriptions, timers and animation controllers in `dispose()`.

### Leak 2: a cache that only grows

```dart
class ImageCache {
  static final Map<String, List<int>> _cache = {};

  static List<int> load(String url) {
    return _cache.putIfAbsent(url, () => List.filled(500000, 0));
  }
}
```

A static map lives as long as the program. Give caches a size limit and remove the oldest entries.

### Leak 3: timers and long-lived closures

A periodic `Timer` keeps its callback alive, and the callback keeps alive everything it uses. Call `timer.cancel()`.

### Other common sources

- Global or static lists that are added to and never cleared.
- Listeners added to a long-lived object and never removed.
- Unclosed `StreamController`s, files and sockets.

## Weak references

A `WeakReference` points to an object **without** keeping it alive. If nothing else refers to the object, the collector may free it, and `target` then becomes `null`.

```dart
class Thumbnail {
  final String id;
  Thumbnail(this.id);
}

void main() {
  Thumbnail? strong = Thumbnail('cat.jpg');
  final weak = WeakReference(strong);

  print(weak.target?.id); // still alive: `strong` refers to it

  strong = null;
  // After a future collection, weak.target will be null.
  final again = weak.target;
  print(again == null ? 'collected' : 'not collected yet');
}
```

`Expando` attaches extra data to an object in the same weak way. `Finalizer` runs a callback some time after an object has been collected, which is useful for releasing native resources. All three are specialist tools.

## Finding leaks with DevTools

Open the **Memory** view in [Dart DevTools](/tools-and-performance/debugging-and-devtools/).

1. Watch the memory chart while using the app. A healthy app rises and falls. A steady climb that never comes down suggests a leak.
2. Take a **heap snapshot**, perform an action and undo it (open a screen, then close it), and take another snapshot.
3. **Diff** the two. Classes whose instance counts keep growing are your suspects.
4. Inspect an instance's **retaining path** to see what is holding on to it.

## Using less memory

- **Use `const`** for values that never change. They are created once and shared.
- **Do not build large temporary lists** when a lazy iterable would do. `where` and `map` allocate nothing until used.
- **Process big files as streams**, not by loading them whole.
- **Use typed lists** (`Uint8List`, `Float64List`) for large amounts of numeric data. They are far more compact than `List<int>`.
- **Reuse a `StringBuffer`** in place of repeated string concatenation in loops.
- **Release big objects** you no longer need by letting their variables go out of scope, or setting a long-lived field to `null`.
- **Downscale images** to the size they are displayed at. Images are the largest memory consumers in most apps.

## What not to do

- Do not try to force a collection. There is no supported way, and the collector schedules itself better than you can.
- Do not avoid creating small objects out of fear. Clear code first. Optimise only what profiling shows to be a problem.
- Do not rely on a `Finalizer` for important clean-up. It is not guaranteed to run before the program exits.

## Try it yourself

Write a class that starts a periodic `Timer` in its constructor and has a `dispose` method. Create 1,000 instances in a loop. In the first run never call `dispose`; in the second, dispose each one. Watch the Memory view in DevTools for both runs and compare.
