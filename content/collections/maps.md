---
title: "Maps in Dart: Key-Value Pairs Explained"
seoTitle: "Dart Map Tutorial: Methods and Examples for Key-Value Pairs"
linkTitle: "Maps"
description: "Learn Map in Dart: create key-value pairs, read, add, update and remove entries, loop over a map, and handle missing keys safely."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart map"
  - "key value pairs"
  - "dart dictionary"
  - "map methods"
  - "containsKey"
  - "putIfAbsent"
aliases:
  - "/dart-collections/maps/"
  - "/fr/dart-collections/maps/"
---

A `Map` links **keys** to **values**. Give it a key and it returns the value, the way a dictionary gives you a definition for a word. Other languages call this a dictionary, hash map or object.

## Creating and reading

```dart
void main() {
  var capitals = {
    'Nepal': 'Kathmandu',
    'Japan': 'Tokyo',
    'Kenya': 'Nairobi',
  };

  print(capitals['Japan']);
  print(capitals['Brazil']); // key not present
  print(capitals.length);
}
```

```output
Tokyo
null
3
```

Looking up a missing key returns `null` rather than failing. That is why the result of `map[key]` is always a nullable type.

## Handling a missing key

```dart
void main() {
  var stock = {'pen': 12, 'book': 0};

  print(stock['ruler'] ?? 0);          // fallback value
  print(stock.containsKey('ruler'));   // ask first

  final pens = stock['pen'];
  if (pens != null) {
    print(pens + 1);                   // safe: pens is an int here
  }
}
```

```output
0
false
13
```

## Adding, updating and removing

```dart
void main() {
  var ages = <String, int>{};

  ages['Rita'] = 28;      // add
  ages['Suman'] = 35;
  ages['Rita'] = 29;      // same key: the value is replaced

  ages.update('Suman', (age) => age + 1);
  ages.putIfAbsent('Tara', () => 22); // only added if missing
  ages.putIfAbsent('Rita', () => 0);  // ignored, Rita exists
  ages.remove('Suman');

  print(ages);
}
```

```output
{Rita: 29, Tara: 22}
```

## Looping over a map

```dart
void main() {
  var prices = {'tea': 25, 'coffee': 60, 'juice': 90};

  for (final item in prices.keys) {
    print(item);
  }

  for (final price in prices.values) {
    print(price);
  }

  for (final MapEntry(:key, :value) in prices.entries) {
    print('$key costs Rs. $value');
  }
}
```

```output
tea
coffee
juice
25
60
90
tea costs Rs. 25
coffee costs Rs. 60
juice costs Rs. 90
```

The last loop uses a [pattern](/records-and-patterns/patterns/) to pull the key and value out of each entry. `prices.forEach((key, value) { ... })` does the same job.

## Counting with a map

A very common pattern: count how often each thing occurs.

```dart
void main() {
  var votes = ['tea', 'coffee', 'tea', 'tea', 'juice', 'coffee'];
  var counts = <String, int>{};

  for (final vote in votes) {
    counts[vote] = (counts[vote] ?? 0) + 1;
  }

  print(counts);
}
```

```output
{tea: 3, coffee: 2, juice: 1}
```

## Maps holding other collections

Values can be any type, including lists and other maps. This is the shape of most JSON data.

```dart
void main() {
  var student = {
    'name': 'Nisha',
    'marks': [78, 85, 91],
    'address': {'city': 'Lalitpur', 'ward': 4},
  };

  final marks = student['marks'] as List<int>;
  print(marks.last);
}
```

```output
91
```

## Rules for keys

- Each key appears once. Assigning to an existing key replaces the value.
- Keys can be any type, but strings, ints and enums are the usual choices.
- Dart's default map keeps entries in the order you added them.

## Try it yourself

Build a small phone book as a `Map<String, String>`. Add three contacts, change one number, delete another, then print every contact as `Name: number`. Finally, look up a name that is not there and print `Not found` instead of `null`.
