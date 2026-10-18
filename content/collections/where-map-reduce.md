---
title: "where, map, reduce and fold in Dart: Filter and Transform Collections"
linkTitle: "where, map, reduce, fold"
description: "Filter, transform and summarise collections in Dart with where, map, expand, reduce, fold, any and every, with practical examples."
weight: 8
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart where"
  - "dart map method"
  - "dart reduce"
  - "dart fold"
  - "filter list dart"
  - "expand"
  - "any every"
aliases:
  - "/dart-collections/where-in-dart/"
  - "/fr/dart-collections/where-in-dart/"
---

Most loops do one of three things: pick some items, change every item, or boil everything down to one value. Dart has a method for each, and using them makes the intent of your code obvious.

## where: keep the items that pass a test

```dart
void main() {
  var ages = [12, 25, 17, 40, 8, 33];

  var adults = ages.where((age) => age >= 18).toList();
  print(adults);
}
```

```output
[25, 40, 33]
```

The function you pass is called once per item and returns `true` to keep it. `where` never changes the original list.

Two useful relatives:

```dart
void main() {
  var mixed = [1, 'two', 3, null, 'five'];

  print(mixed.whereType<int>().toList());     // only the ints
  print(mixed.nonNulls.toList());             // drop the nulls
}
```

```output
[1, 3]
[1, two, 3, five]
```

## map: transform every item

```dart
void main() {
  var names = ['asha', 'bimal', 'chandra'];

  var capitalised = names
      .map((n) => n[0].toUpperCase() + n.substring(1))
      .toList();
  var lengths = names.map((n) => n.length).toList();

  print(capitalised);
  print(lengths);
}
```

```output
[Asha, Bimal, Chandra]
[4, 5, 7]
```

The result has the same number of items, and they can be a different type.

## expand: one item becomes many

```dart
void main() {
  var orders = [
    ['tea', 'toast'],
    ['coffee'],
    ['juice', 'eggs', 'toast'],
  ];

  var allItems = orders.expand((order) => order).toList();
  print(allItems);
}
```

```output
[tea, toast, coffee, juice, eggs, toast]
```

## reduce: combine into one value of the same type

```dart
void main() {
  var prices = [250, 120, 480, 90];

  var total = prices.reduce((sum, p) => sum + p);
  var cheapest = prices.reduce((a, b) => a < b ? a : b);

  print(total);
  print(cheapest);
}
```

```output
940
90
```

`reduce` throws an error on an empty collection, because there is nothing to start from.

## fold: combine with a starting value

`fold` is the safer, more flexible version. You give it a starting value, and the result can be a different type from the items.

```dart
void main() {
  var words = ['dart', 'is', 'fun'];

  var letters = words.fold(0, (count, w) => count + w.length);
  var sentence = words.fold('', (text, w) => text.isEmpty ? w : '$text $w');
  var emptyTotal = <int>[].fold(0, (a, b) => a + b);

  print(letters);
  print(sentence);
  print(emptyTotal);
}
```

```output
9
dart is fun
0
```

## any and every

```dart
void main() {
  var marks = [55, 72, 38, 90];

  print(marks.any((m) => m < 40));   // did anyone fail?
  print(marks.every((m) => m >= 30)); // is everyone at least 30?
}
```

```output
true
true
```

## Putting them together

```dart
void main() {
  var products = [
    {'name': 'Pen', 'price': 20, 'inStock': true},
    {'name': 'Bag', 'price': 1500, 'inStock': false},
    {'name': 'Book', 'price': 350, 'inStock': true},
    {'name': 'Lamp', 'price': 900, 'inStock': true},
  ];

  var available = products.where((p) => p['inStock'] == true);
  var names = available.map((p) => p['name']).join(', ');
  var value = available.fold(0, (sum, p) => sum + (p['price'] as int));

  print('Available: $names');
  print('Total value: $value');
}
```

```output
Available: Pen, Book, Lamp
Total value: 1270
```

## Quick reference

| Method | Gives back | Use it to |
| --- | --- | --- |
| `where` | Fewer items | Filter |
| `map` | Same count, changed items | Transform |
| `expand` | More items | Flatten |
| `reduce` | One value, same type | Total, min, max |
| `fold` | One value, any type | Total with a start value |
| `any` / `every` | `bool` | Check a condition |

## Try it yourself

From `[3, 8, 15, 22, 7, 10]`, keep the even numbers, square them, and add them up, all in one chain. The answer is `648`.
