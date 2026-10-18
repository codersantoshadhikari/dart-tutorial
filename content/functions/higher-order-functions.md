---
title: "Higher-Order Functions in Dart"
linkTitle: "Higher-order functions"
description: "Learn higher-order functions in Dart: functions that take or return other functions, with map, where, reduce, fold and your own examples."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart higher order functions"
  - "callback"
  - "dart map where reduce"
  - "function type"
---

A higher-order function is a function that takes another function as an argument, returns one, or both. They let you separate **what to do** from **when or how often to do it**.

## Taking a function as a parameter

```dart
void repeat(int times, void Function(int) action) {
  for (var i = 1; i <= times; i++) {
    action(i);
  }
}

void main() {
  repeat(3, (i) => print('Round $i'));
}
```

```output
Round 1
Round 2
Round 3
```

`repeat` knows how to loop. The caller decides what happens in each round.

## One function, many behaviours

```dart
int calculate(int a, int b, int Function(int, int) operation) {
  return operation(a, b);
}

int add(int a, int b) => a + b;

void main() {
  print(calculate(8, 2, add));
  print(calculate(8, 2, (a, b) => a * b));
  print(calculate(8, 2, (a, b) => a ~/ b));
}
```

```output
10
16
4
```

## The built-in ones you will use daily

Dart's collections come with higher-order functions that replace most hand-written loops.

```dart
void main() {
  var marks = [45, 82, 67, 91, 38];

  // where: keep the items that pass a test
  var passed = marks.where((m) => m >= 40);

  // map: transform every item
  var bonus = marks.map((m) => m + 5);

  // any / every: ask a yes-or-no question
  var anyFailed = marks.any((m) => m < 40);
  var allPositive = marks.every((m) => m > 0);

  // reduce and fold: combine into one value
  var highest = marks.reduce((a, b) => a > b ? a : b);
  var total = marks.fold(0, (sum, m) => sum + m);

  print(passed.toList());
  print(bonus.toList());
  print('$anyFailed $allPositive');
  print('$highest $total');
}
```

```output
[45, 82, 67, 91]
[50, 87, 72, 96, 43]
true true
91 323
```

These are covered in detail in [filtering and transforming collections](/collections/where-map-reduce/).

## Chaining

Each step returns a new collection, so steps can be chained into a pipeline that reads top to bottom.

```dart
void main() {
  var words = ['dart', 'is', 'fun', 'and', 'fast'];

  var result = words
      .where((w) => w.length > 2)
      .map((w) => w.toUpperCase())
      .join(' ');

  print(result);
}
```

```output
DART FUN AND FAST
```

## Returning a function

```dart
bool Function(int) greaterThan(int limit) => (n) => n > limit;

void main() {
  var numbers = [3, 12, 7, 25];

  print(numbers.where(greaterThan(5)).toList());
  print(numbers.where(greaterThan(10)).toList());
}
```

```output
[12, 7, 25]
[12, 25]
```

## Sorting with a comparison function

`sort` takes a function that compares two items. Return a negative number if the first should come first.

```dart
void main() {
  var names = ['Sunita', 'Om', 'Rajesh'];

  names.sort((a, b) => a.length.compareTo(b.length));
  print(names);

  names.sort((a, b) => b.compareTo(a)); // reverse alphabetical
  print(names);
}
```

```output
[Om, Sunita, Rajesh]
[Sunita, Rajesh, Om]
```

## Try it yourself

Write `List<int> applyToAll(List<int> items, int Function(int) f)` that returns a new list with `f` applied to each item. Use it to square a list and then to subtract 1 from each element.
