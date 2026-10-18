---
title: "Sets in Dart: Unique Collections and Set Operations"
linkTitle: "Sets"
description: "Learn Set in Dart: storing unique values, fast lookups, and set operations such as union, intersection and difference."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart set"
  - "unique values"
  - "set union intersection difference"
  - "remove duplicates dart"
aliases:
  - "/dart-collections/sets/"
  - "/fr/dart-collections/sets/"
---

A `Set` is a collection where every value appears at most once. It is the right tool when you care about **whether** something is in the collection, not where or how many times.

## Creating a set

```dart
void main() {
  var colours = {'red', 'green', 'blue', 'red'};
  print(colours);
  print(colours.length);

  var empty = <String>{};
  print(empty.isEmpty);
}
```

```output
{red, green, blue}
3
true
```

The duplicate `'red'` is dropped silently. Dart's default set remembers the order in which items were added.

## Adding and removing

`add` returns `true` if the value was new, and `false` if it was already there.

```dart
void main() {
  var tags = {'dart', 'flutter'};

  print(tags.add('mobile'));
  print(tags.add('dart'));
  tags.addAll(['web', 'flutter']);
  tags.remove('mobile');

  print(tags);
}
```

```output
true
false
{dart, flutter, web}
```

## Fast lookups

Checking `contains` on a set takes the same short time whether it holds ten items or ten million. On a list, Dart has to check items one by one.

```dart
void main() {
  var blocked = {'spam@x.com', 'bot@y.com'};

  var sender = 'bot@y.com';
  if (blocked.contains(sender)) {
    print('Message rejected');
  }
}
```

```output
Message rejected
```

## Set operations

```dart
void main() {
  var football = {'Aman', 'Bina', 'Chandra'};
  var cricket = {'Bina', 'Chandra', 'Dipak'};

  print(football.union(cricket));        // plays either
  print(football.intersection(cricket)); // plays both
  print(football.difference(cricket));   // football only
  print(football.containsAll({'Aman', 'Bina'}));
}
```

```output
{Aman, Bina, Chandra, Dipak}
{Bina, Chandra}
{Aman}
true
```

## Removing duplicates from a list

The classic use: convert to a set and back.

```dart
void main() {
  var visits = ['home', 'about', 'home', 'contact', 'about'];
  var uniquePages = visits.toSet().toList();
  print(uniquePages);

  // Or in one literal with the spread operator:
  print({...visits}.length);
}
```

```output
[home, about, contact]
3
```

## No indexes

A set has no `[0]`. Loop over it, or use `first`, `last` and `elementAt`. If you need positions, convert it to a list.

```dart
void main() {
  var primes = {2, 3, 5, 7};

  for (final p in primes) {
    print(p);
  }
  print(primes.elementAt(2));
}
```

```output
2
3
5
7
5
```

## Uniqueness of your own objects

A set decides whether two values are the same using `==` and `hashCode`. For your own classes you need to define both, as shown in [equality and hashCode](/object-oriented-programming/equality-and-hashcode/).

## Try it yourself

You have two lists of student names: those who submitted assignment 1 and those who submitted assignment 2. Print who submitted both, who submitted only the first, and the total number of different students.
