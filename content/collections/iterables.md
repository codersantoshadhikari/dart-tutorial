---
title: "Iterable in Dart: Lazy Sequences Explained"
linkTitle: "Iterables"
description: "Understand Iterable in Dart, the parent of List and Set. Learn lazy evaluation, take, skip, firstWhere and when to call toList."
weight: 7
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart iterable"
  - "lazy evaluation"
  - "firstWhere"
  - "take skip"
  - "toList"
  - "iterator"
aliases:
  - "/dart-collections/iterable-in-dart/"
  - "/fr/dart-collections/iterable-in-dart/"
---

An `Iterable` is anything you can step through one item at a time. `List` and `Set` are both iterables, and so are the results of methods like `where` and `map`. Understanding iterables explains two things beginners find puzzling: why results print with round brackets, and why `.toList()` shows up everywhere.

## Results are iterables, not lists

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5, 6];

  var evens = numbers.where((n) => n.isEven);
  print(evens);
  print(evens.toList());
}
```

```output
(2, 4, 6)
[2, 4, 6]
```

The round brackets tell you `evens` is a plain iterable. It supports `for-in`, `length`, `first`, `contains` and so on, but not `[index]`, `add` or `sort`. Call `toList()` or `toSet()` when you need those.

## Iterables are lazy

An iterable from `where` or `map` does no work when you create it. The work happens only when something asks for the items.

```dart
void main() {
  var numbers = [1, 2, 3];

  var doubled = numbers.map((n) {
    print('doubling $n');
    return n * 2;
  });

  print('Nothing has run yet');
  print(doubled.first);
}
```

```output
Nothing has run yet
doubling 1
2
```

Only the first item was ever calculated. Laziness means you can chain many steps over a huge collection and only pay for what you use.

## The catch: lazy work repeats

Every time you loop over a lazy iterable, the work is done again. If you will use the result more than once, store it with `toList()`.

```dart
void main() {
  var calls = 0;
  var squares = [1, 2, 3].map((n) {
    calls++;
    return n * n;
  });

  squares.toList();
  squares.toList();
  print('Lazy: function ran $calls times');

  calls = 0;
  var saved = [1, 2, 3].map((n) {
    calls++;
    return n * n;
  }).toList();

  saved.length;
  saved.first;
  print('Saved: function ran $calls times');
}
```

```output
Lazy: function ran 6 times
Saved: function ran 3 times
```

## Taking part of a sequence

```dart
void main() {
  var numbers = [5, 10, 15, 20, 25, 30];

  print(numbers.take(2));
  print(numbers.skip(4));
  print(numbers.takeWhile((n) => n < 20));
  print(numbers.skipWhile((n) => n < 20));
}
```

```output
(5, 10)
(25, 30)
(5, 10, 15)
(20, 25, 30)
```

## Finding one item

```dart
void main() {
  var names = ['Ram', 'Shyam', 'Hari'];

  print(names.firstWhere((n) => n.length > 3));
  print(names.firstWhere((n) => n.length > 9, orElse: () => 'none'));
  print(names.where((n) => n.length > 9).firstOrNull);
  print(names.singleWhere((n) => n.startsWith('H')));
}
```

```output
Shyam
none
null
Hari
```

`firstWhere` throws a `StateError` if nothing matches and you gave no `orElse`. So do `first`, `last` and `single` on an empty iterable. `firstOrNull` and `lastOrNull` return `null` instead.

## Making your own lazy sequence

`Iterable.generate` creates values on demand. For more control, write a [generator function](/async/generators/) with `sync*`.

```dart
void main() {
  var evens = Iterable.generate(5, (i) => i * 2);
  print(evens);
}
```

```output
(0, 2, 4, 6, 8)
```

## Try it yourself

Create a list of the numbers 1 to 20 with `List.generate`. In one chain, skip the first five, keep the multiples of 3, take the first three of those and print them as a list. You should get `[6, 9, 12]`.
