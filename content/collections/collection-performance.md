---
title: "Collection Performance in Dart: Choosing the Fastest Structure"
linkTitle: "Performance"
description: "Understand the speed of common List, Set and Map operations in Dart, and learn practical tips for writing faster collection code."
weight: 11
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart collection performance"
  - "big o"
  - "list vs set contains"
  - "dart optimization"
aliases:
  - "/dart-collections/performance-considerations/"
  - "/fr/dart-collections/performance-considerations/"
---

For a handful of items, every collection is fast. Once you have thousands, the choice of collection and method decides whether your app feels instant or sluggish.

## The cost of common operations

"Constant" means the time does not grow with the size of the collection. "Linear" means that with twice the items it takes twice as long.

| Operation | List | Set | Map |
| --- | --- | --- | --- |
| Read by index or key | Constant | n/a | Constant |
| Add at the end | Constant | Constant | Constant |
| Insert or remove at the start | Linear | n/a | n/a |
| `contains` / `containsKey` | Linear | Constant | Constant |
| Remove by value or key | Linear | Constant | Constant |

## Use a Set or Map for lookups

This is the improvement that matters most in practice.

```dart
void main() {
  final ids = List.generate(100000, (i) => i);
  final idSet = ids.toSet();
  final wanted = List.generate(2000, (i) => i * 50);

  var watch = Stopwatch()..start();
  var found = wanted.where(ids.contains).length;
  print('List: $found found in ${watch.elapsedMilliseconds} ms');

  watch = Stopwatch()..start();
  found = wanted.where(idSet.contains).length;
  print('Set:  $found found in ${watch.elapsedMilliseconds} ms');
}
```

Exact timings depend on your machine, but the list version does about a hundred million comparisons while the set version does two thousand lookups.

## Find by id with a Map

Searching a list with `firstWhere` each time you need a user is linear. Build a map once and every lookup is immediate.

```dart
void main() {
  final users = [
    (id: 1, name: 'Anil'),
    (id: 2, name: 'Bhawana'),
    (id: 3, name: 'Chet'),
  ];

  final byId = {for (final u in users) u.id: u};

  print(byId[2]?.name);
}
```

```output
Bhawana
```

## Do not call toList too early, or too late

Lazy iterables avoid building lists you do not need. Here nothing beyond the first match is ever examined:

```dart
void main() {
  final numbers = List.generate(1000000, (i) => i);

  final firstBig = numbers
      .where((n) => n % 7 == 0)
      .map((n) => n * n)
      .firstWhere((n) => n > 1000);

  print(firstBig);
}
```

```output
1225
```

But if you will loop over a result several times, call `toList()` once so the work is not repeated. See [iterables](/collections/iterables/).

## Other habits that help

- **Avoid `insert(0, x)` and `removeAt(0)` in loops.** Use a [Queue](/collections/queue/), or add at the end and reverse once.
- **Build strings with `StringBuffer` or `join`**, not `+=` in a loop.
- **Avoid nested loops over two big lists.** Turn one of them into a set or map first.
- **Read `length` freely.** It is stored, not counted, for lists, sets and maps. On a lazy iterable, though, `length` walks every item.
- **Use `const` for fixed collections.** They are created once at compile time and shared.
- **Sort once.** Sorting is the most expensive common operation, so do not sort inside a loop.

## Measure before optimising

Clear code comes first. When something really is slow, time it with `Stopwatch` or the profiler in [Dart DevTools](/tools-and-performance/debugging-and-devtools/) rather than guessing. The slow part is rarely where you expect.

## Try it yourself

Create two lists of 20,000 random numbers each. Count how many numbers from the first list appear in the second, once using `list.contains` and once after converting the second list to a set. Time both with `Stopwatch`.
