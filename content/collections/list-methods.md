---
title: "Dart List Methods: Complete Guide with Easy Examples"
linkTitle: "List methods"
description: "All the Dart list methods you need, with runnable examples: add, insert, remove, contains, indexOf, where, map, reduce, fold, sort, sublist, toSet and more."
weight: 3
date: 2026-10-15
lastmod: 2026-10-15
keywords:
  - "dart list methods"
  - "dart list functions"
  - "dart list examples"
  - "dart array methods"
  - "dart list sort"
  - "dart list remove"
  - "dart list map"
  - "List.generate"
---

The [Lists](/collections/lists/) lesson introduced the `List` type. This page collects the list methods you will reach for every day, grouped by what you want to do, each with a short program and its output. Press **Run** on any example, change the numbers, and run it again.

## Quick reference table

| Method | What it does | Changes the list? |
| --- | --- | --- |
| `add(x)` / `addAll(xs)` | Add to the end | Yes |
| `insert(i, x)` / `insertAll(i, xs)` | Add at a position | Yes |
| `remove(x)` / `removeAt(i)` / `removeLast()` | Remove one item | Yes |
| `removeWhere(test)` / `retainWhere(test)` | Remove by condition | Yes |
| `clear()` | Remove everything | Yes |
| `sort()` / `shuffle()` | Reorder | Yes |
| `contains(x)` / `indexOf(x)` | Find an item | No |
| `firstWhere(test)` / `indexWhere(test)` | Find by condition | No |
| `any(test)` / `every(test)` | Check a condition | No |
| `where(test)` | Keep matching items | No (new iterable) |
| `map(f)` | Transform each item | No (new iterable) |
| `reduce(f)` / `fold(start, f)` | Combine into one value | No |
| `sublist(a, b)` / `take(n)` / `skip(n)` | Get part of the list | No |
| `join(sep)` | Make one string | No |
| `toSet()` | Remove duplicates | No |

Methods such as `where`, `map`, `take` and `skip` return a lazy `Iterable`. Add `.toList()` when you need a real list back. The [Iterable](/collections/iterables/) lesson explains why.

## Creating lists

```dart
void main() {
  var empty = <String>[];
  var zeros = List.filled(3, 0);
  var squares = List.generate(5, (i) => i * i);
  var a = [1, 2];
  var b = [3, 4];
  var both = [...a, ...b];

  print(empty);
  print(zeros);
  print(squares);
  print(both);
}
```

```output
[]
[0, 0, 0]
[0, 1, 4, 9, 16]
[1, 2, 3, 4]
```

## Adding items

```dart
void main() {
  var nums = [1, 2, 3];

  nums.add(4);
  nums.addAll([5, 6]);
  nums.insert(0, 0);
  nums.insertAll(2, [10, 20]);

  print(nums);
  print(nums.length);
}
```

```output
[0, 1, 10, 20, 2, 3, 4, 5, 6]
9
```

## Removing items

```dart
void main() {
  var n = [5, 10, 15, 20, 25, 30];

  print(n.remove(10));     // true: it was found
  print(n.removeAt(0));    // returns the removed item
  print(n.removeLast());
  n.removeWhere((x) => x > 20);
  print(n);

  var m = [1, 2, 3, 4, 5, 6];
  m.retainWhere((x) => x.isEven);  // keep only even numbers
  print(m);

  m.clear();
  print(m.isEmpty);
}
```

```output
true
5
30
[15, 20]
[2, 4, 6]
true
```

## Finding items

```dart
void main() {
  var langs = ['Dart', 'Kotlin', 'Swift', 'Dart'];

  print(langs.contains('Swift'));
  print(langs.indexOf('Dart'));
  print(langs.lastIndexOf('Dart'));
  print(langs.indexWhere((l) => l.startsWith('S')));
  print(langs.firstWhere((l) => l.length > 4));
  print(langs.firstWhere((l) => l == 'Go', orElse: () => 'none'));
  print(langs.any((l) => l == 'Java'));
  print(langs.every((l) => l.isNotEmpty));
}
```

```output
true
0
3
2
Kotlin
none
false
true
```

Without `orElse`, `firstWhere` throws a `StateError` when nothing matches.

## Transforming: where, map, reduce and fold

```dart
void main() {
  var prices = [120, 45, 300, 80];

  print(prices.map((p) => p * 2).toList());
  print(prices.where((p) => p > 100).toList());
  print(prices.reduce((a, b) => a + b));
  print(prices.fold(0, (sum, p) => sum + p));
  print(prices.map((p) => '\$$p').join(', '));
}
```

```output
[240, 90, 600, 160]
[120, 300]
545
545
$120, $45, $300, $80
```

`reduce` fails on an empty list; `fold` does not, because you give it a starting value. There is a full lesson on [where, map, reduce and fold](/collections/where-map-reduce/).

## Sorting and reversing

```dart
void main() {
  var scores = [42, 7, 19, 3];

  scores.sort();
  print(scores);

  scores.sort((a, b) => b.compareTo(a)); // biggest first
  print(scores);

  print(scores.reversed.toList());

  var words = ['banana', 'fig', 'apple'];
  words.sort((a, b) => a.length.compareTo(b.length)); // shortest first
  print(words);
}
```

```output
[3, 7, 19, 42]
[42, 19, 7, 3]
[3, 7, 19, 42]
[fig, apple, banana]
```

`shuffle()` puts the items in a random order, which is useful for quiz and card games.

## Getting part of a list

```dart
void main() {
  var l = [1, 2, 3, 4, 5, 6];

  print(l.sublist(2));
  print(l.sublist(1, 4));
  print(l.take(3).toList());
  print(l.skip(4).toList());
  print(l.takeWhile((x) => x < 4).toList());
  print(l.getRange(1, 3).toList());
  print(l.first);
  print(l.last);
}
```

```output
[3, 4, 5, 6]
[2, 3, 4]
[1, 2, 3]
[5, 6]
[1, 2, 3]
[2, 3]
1
6
```

## Useful extras

```dart
void main() {
  var withDuplicates = [3, 1, 3, 2, 1];
  print(withDuplicates.toSet().toList()); // keeps first appearance order

  var f = List.filled(5, 0);
  f.fillRange(1, 3, 9);
  print(f);

  print(['a', 'b'].asMap());

  for (final (i, v) in ['red', 'green'].indexed) {
    print('$i: $v');
  }
}
```

```output
[3, 1, 2]
[0, 9, 9, 0, 0]
{0: a, 1: b}
0: red
1: green
```

`indexed` gives you each position and value together. It uses a [record](/records-and-patterns/records/) pattern, a Dart 3 feature.

## A small real example: student marks

```dart
void main() {
  var marks = [72, 45, 91, 38, 84];

  var passed = marks.where((m) => m >= 40).toList();
  var total = marks.fold(0, (sum, m) => sum + m);
  var average = total / marks.length;
  var highest = marks.reduce((a, b) => a > b ? a : b);

  var sorted = [...marks]..sort();

  print('Passed: $passed');
  print('Average: ${average.toStringAsFixed(1)}');
  print('Highest: $highest');
  print('Sorted: $sorted');
  print('Original is unchanged: $marks');
}
```

```output
Passed: [72, 45, 91, 84]
Average: 66.0
Highest: 91
Sorted: [38, 45, 72, 84, 91]
Original is unchanged: [72, 45, 91, 38, 84]
```

`[...marks]..sort()` copies the list first, so sorting does not change the original. The `..` is the [cascade operator](/dart-basics/operators/).

## Common mistakes

- **Forgetting `.toList()`.** `print(l.take(2))` prints `(1, 2)` with round brackets because it is an `Iterable`, not a `List`.
- **Changing a list while looping over it.** Removing items inside `for (var x in list)` throws an error. Use `removeWhere` instead.
- **Calling `reduce` on an empty list.** It throws. Use `fold` with a start value.
- **Adding to a fixed-length list.** `List.filled(3, 0).add(1)` throws. Pass `growable: true` if you need to grow it.

## Try it yourself

Start with `var cities = ['Pokhara', 'Toronto', 'Sydney', 'Delhi', 'Lisbon'];` and:

1. Sort the cities alphabetically.
2. Print only the cities with more than five letters.
3. Print the cities in capitals joined with `, `.
4. Check whether any city starts with `L`.
