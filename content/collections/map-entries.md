---
title: "MapEntry in Dart: Working with Map Entries"
linkTitle: "Map entries"
description: "Use MapEntry and the entries property in Dart to sort, filter, transform and rebuild maps with fromEntries and map."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart MapEntry"
  - "map entries"
  - "Map.fromEntries"
  - "sort map dart"
  - "filter map dart"
aliases:
  - "/dart-collections/map-entries/"
  - "/fr/dart-collections/map-entries/"
---

A map is a collection of **entries**. Each entry is a `MapEntry` object holding one `key` and one `value`. Working with entries lets you use all the list-style tools (`where`, `map`, `sort`) on a map.

## Getting the entries

```dart
void main() {
  var scores = {'Anu': 82, 'Bikash': 67, 'Chhiring': 94};

  for (final entry in scores.entries) {
    print('${entry.key} scored ${entry.value}');
  }
}
```

```output
Anu scored 82
Bikash scored 67
Chhiring scored 94
```

## Creating an entry and building a map from entries

```dart
void main() {
  var entry = MapEntry('Dawa', 75);
  print('${entry.key}: ${entry.value}');

  var map = Map.fromEntries([
    MapEntry('x', 1),
    MapEntry('y', 2),
  ]);
  print(map);

  map.addEntries([MapEntry('z', 3)]);
  print(map);
}
```

```output
Dawa: 75
{x: 1, y: 2}
{x: 1, y: 2, z: 3}
```

## Filtering a map

Filter the entries, then turn them back into a map.

```dart
void main() {
  var scores = {'Anu': 82, 'Bikash': 67, 'Chhiring': 94};

  var top = Map.fromEntries(
    scores.entries.where((e) => e.value >= 80),
  );
  print(top);
}
```

```output
{Anu: 82, Chhiring: 94}
```

To remove entries from the existing map instead, use `scores.removeWhere((name, score) => score < 80)`.

## Sorting a map

A map has no `sort` method. Sort a list of its entries and rebuild.

```dart
void main() {
  var scores = {'Anu': 82, 'Bikash': 67, 'Chhiring': 94};

  var sorted = scores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (final e in sorted) {
    print('${e.key}: ${e.value}');
  }

  var byScore = Map.fromEntries(sorted);
  print(byScore.keys.first);
}
```

```output
Chhiring: 94
Anu: 82
Bikash: 67
Chhiring
```

## Transforming keys and values

`map.map` receives each key and value and must return a new `MapEntry`.

```dart
void main() {
  var prices = {'tea': 25, 'coffee': 60};

  var raised = prices.map(
    (item, price) => MapEntry(item.toUpperCase(), price + 5),
  );
  print(raised);

  // Swap keys and values.
  var flipped = prices.map((k, v) => MapEntry(v, k));
  print(flipped);
}
```

```output
{TEA: 30, COFFEE: 65}
{25: tea, 60: coffee}
```

## A shorter way: collection for

Often a map literal with `for` is easier to read than `fromEntries`.

```dart
void main() {
  var scores = {'Anu': 82, 'Bikash': 67, 'Chhiring': 94};

  var grades = {
    for (final MapEntry(:key, :value) in scores.entries)
      key: value >= 80 ? 'A' : 'B',
  };
  print(grades);
}
```

```output
{Anu: A, Bikash: B, Chhiring: A}
```

## Finding the entry with the largest value

```dart
void main() {
  var scores = {'Anu': 82, 'Bikash': 67, 'Chhiring': 94};

  var best = scores.entries.reduce((a, b) => a.value >= b.value ? a : b);
  print('${best.key} with ${best.value}');
}
```

```output
Chhiring with 94
```

## Try it yourself

Given `{'apple': 120, 'banana': 40, 'cherry': 300, 'date': 90}`, produce a new map that contains only items costing 100 or less, sorted from cheapest to most expensive.
