---
title: "Dart Collections: List, Set and Map Overview"
linkTitle: "Overview"
description: "An overview of collections in Dart. Compare List, Set and Map, learn collection literals and generics, and choose the right one."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart collections"
  - "list set map"
  - "collection literals"
  - "dart generics collections"
aliases:
  - "/dart-collections/-collection-types-and-operations/"
  - "/fr/dart-collections/-collection-types-and-operations/"
  - "/dart-collections/list-and-set-literals/"
  - "/fr/dart-collections/list-and-set-literals/"
---

Dart has three core collection types. Picking the right one makes your code shorter and faster.

| Type | Ordered? | Duplicates? | Find items by | Literal |
| --- | --- | --- | --- | --- |
| `List` | Yes | Allowed | Position (index) | `[1, 2, 3]` |
| `Set` | Insertion order | Not allowed | The value itself | `{1, 2, 3}` |
| `Map` | Insertion order | Keys are unique | Key | `{'a': 1}` |

## All three at a glance

```dart
void main() {
  // List: an ordered sequence.
  var queue = ['Asha', 'Bimal', 'Asha'];

  // Set: unique values.
  var visitors = {'Asha', 'Bimal', 'Asha'};

  // Map: look up a value by its key.
  var ages = {'Asha': 24, 'Bimal': 31};

  print(queue);
  print(visitors);
  print(ages['Bimal']);
}
```

```output
[Asha, Bimal, Asha]
{Asha, Bimal}
31
```

## Collection literals

A literal is a collection written directly in code. Square brackets make a list. Curly braces make a set, or a map when the items are `key: value` pairs.

```dart
void main() {
  var list = [1, 2, 3];
  var set = {1, 2, 3};
  var map = {'one': 1, 'two': 2};

  print('${list.length} ${set.length} ${map.length}');
}
```

```output
3 3 2
```

## Empty collections need a type

Dart cannot infer the type of an empty collection, so say it in angle brackets. Be careful: plain `{}` is an empty **map**, not a set.

```dart
void main() {
  var names = <String>[];
  var ids = <int>{};
  var stock = <String, int>{};

  names.add('Kamal');
  ids.add(7);
  stock['pen'] = 40;

  print('$names $ids $stock');
}
```

```output
[Kamal] {7} {pen: 40}
```

The type in angle brackets is a [generic](/object-oriented-programming/generics/) type argument. A `List<String>` only accepts strings, so mistakes are caught before the program runs.

## Things every collection can do

```dart
void main() {
  var numbers = [5, 3, 8];

  print(numbers.length);
  print(numbers.isEmpty);
  print(numbers.isNotEmpty);
  print(numbers.contains(3));
  print(numbers.first);
  print(numbers.last);

  for (final n in numbers) {
    print(n);
  }
}
```

```output
3
false
true
true
5
8
5
3
8
```

## Converting between them

```dart
void main() {
  var list = ['b', 'a', 'b'];

  var set = list.toSet();        // removes duplicates
  var back = set.toList();
  var indexed = list.asMap();    // index -> value

  print(set);
  print(back);
  print(indexed);
}
```

```output
{b, a}
[b, a]
{0: b, 1: a, 2: b}
```

## Which should I choose?

- Order matters, or the same value can appear twice: **List**.
- You only care whether something is present, or you need uniqueness: **Set**.
- You look things up by a name or id: **Map**.

## Try it yourself

For each of these, decide whether a List, Set or Map fits best, then create it: the songs in a playlist, the unique words in a sentence, and the price of each item on a menu.
