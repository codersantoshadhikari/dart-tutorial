---
title: "Generators in Dart: sync*, async*, yield and yield*"
linkTitle: "Generators"
description: "Learn generator functions in Dart: produce values lazily with sync* and async*, use yield and yield*, and build infinite sequences."
weight: 11
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart generators"
  - "sync*"
  - "async*"
  - "yield"
  - "yield*"
  - "lazy sequence"
  - "iterable generator"
---

A **generator** is a function that produces a sequence of values one at a time, on demand. It pauses after each value and resumes when the next is requested. Dart has two kinds:

| Keyword | Returns | Values arrive |
| --- | --- | --- |
| `sync*` | `Iterable<T>` | Immediately, when asked |
| `async*` | `Stream<T>` | Over time |

In both, `yield` hands out one value.

## A synchronous generator

```dart
Iterable<int> countTo(int max) sync* {
  for (var i = 1; i <= max; i++) {
    yield i;
  }
}

void main() {
  for (final n in countTo(4)) {
    print(n);
  }
  print(countTo(3).toList());
}
```

```output
1
2
3
4
[1, 2, 3]
```

## Generators are lazy

The body runs only as far as needed to produce the value being asked for.

```dart
Iterable<int> numbers() sync* {
  print('  producing 1');
  yield 1;
  print('  producing 2');
  yield 2;
  print('  producing 3');
  yield 3;
}

void main() {
  final firstTwo = numbers().take(2);
  print('Nothing has run yet');

  for (final n in firstTwo) {
    print('got $n');
  }
}
```

```output
Nothing has run yet
  producing 1
got 1
  producing 2
got 2
```

"producing 3" never appears. The generator stopped as soon as the consumer had enough.

## Infinite sequences

Because values are made on demand, a generator can describe a sequence with no end. The consumer decides how much to take.

```dart
Iterable<int> fibonacci() sync* {
  var a = 0, b = 1;
  while (true) {
    yield a;
    (a, b) = (b, a + b);
  }
}

void main() {
  print(fibonacci().take(10).toList());
  print(fibonacci().firstWhere((n) => n > 1000));
  print(fibonacci().takeWhile((n) => n < 50).where((n) => n.isEven).toList());
}
```

```output
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
1597
[0, 2, 8, 34]
```

Never call `toList()` or `length` on an infinite generator without `take` or `takeWhile` first.

## yield*: hand over to another sequence

`yield*` emits every value of another iterable or stream. It is what makes recursive generators neat.

```dart
Iterable<int> countDown(int from) sync* {
  if (from <= 0) return;
  yield from;
  yield* countDown(from - 1);
}

Iterable<String> menu() sync* {
  yield 'Starters';
  yield* ['Soup', 'Salad'];
  yield 'Mains';
  yield* ['Dal bhat', 'Momo'];
}

void main() {
  print(countDown(5).toList());
  print(menu().toList());
}
```

```output
[5, 4, 3, 2, 1]
[Starters, Soup, Salad, Mains, Dal bhat, Momo]
```

## Walking a tree

```dart
class Folder {
  final String name;
  final List<Folder> children;
  Folder(this.name, [this.children = const []]);

  Iterable<String> paths([String prefix = '']) sync* {
    final path = '$prefix/$name';
    yield path;
    for (final child in children) {
      yield* child.paths(path);
    }
  }
}

void main() {
  final root = Folder('home', [
    Folder('docs', [Folder('work'), Folder('personal')]),
    Folder('photos'),
  ]);

  root.paths().forEach(print);
}
```

```output
/home
/home/docs
/home/docs/work
/home/docs/personal
/home/photos
```

## An asynchronous generator

`async*` functions can `await` between values. They return a [stream](/async/streams/).

```dart
Stream<int> ticker(int count) async* {
  for (var i = 1; i <= count; i++) {
    await Future.delayed(Duration(milliseconds: 300));
    yield i;
  }
}

Stream<String> loadAllPages() async* {
  for (var page = 1; page <= 3; page++) {
    await Future.delayed(Duration(milliseconds: 200)); // pretend network call
    yield* Stream.fromIterable(['item ${page}a', 'item ${page}b']);
  }
}

Future<void> main() async {
  await for (final t in ticker(3)) {
    print('tick $t');
  }
  print(await loadAllPages().toList());
}
```

```output
tick 1
tick 2
tick 3
[item 1a, item 1b, item 2a, item 2b, item 3a, item 3b]
```

When the listener cancels, an `async*` function stops at its next `yield`, so no further work is done.

## Generator or a plain list?

| Build a list when | Use a generator when |
| --- | --- |
| The data is small and all of it is needed | The sequence is large, or infinite |
| You need random access with `[i]` | Values are expensive and only some may be used |
| It will be read many times | It will be read once, in order |

Remember that a `sync*` iterable is re-run each time it is iterated. Call `toList()` once if you need to go through the values repeatedly.

## Try it yourself

Write `Iterable<int> primes()` as an infinite `sync*` generator. Print the first 15 primes, then the first prime above 1,000. Then write an `async*` version that emits one prime every 100 ms and stop it after five with `take(5)`.
