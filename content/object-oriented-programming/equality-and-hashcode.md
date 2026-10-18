---
title: "Object Equality in Dart: ==, hashCode and identical"
linkTitle: "Equality and hashCode"
description: "Learn how equality works in Dart: identity versus value equality, overriding == and hashCode correctly, and why it matters for Set and Map."
weight: 17
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart equality"
  - "override == operator"
  - "hashCode"
  - "identical"
  - "value equality"
  - "Object.hash"
aliases:
  - "/advanced-classes/object-identity--equality/"
  - "/fr/advanced-classes/object-identity--equality/"
---

Are two objects "the same"? There are two different questions hiding in that word:

- **Identity**: are they the very same object in memory?
- **Equality**: do they represent the same value?

## The default is identity

For your own classes, `==` compares identity unless you say otherwise.

```dart
class Point {
  final int x, y;
  Point(this.x, this.y);
}

void main() {
  var a = Point(1, 2);
  var b = Point(1, 2);
  var c = a;

  print(a == b);         // different objects
  print(a == c);         // same object
  print(identical(a, c));
}
```

```output
false
true
true
```

Two points with the same coordinates are not equal. That is rarely what you want for data classes.

## Built-in types compare by value

Numbers, strings and booleans already behave sensibly. Collections do **not**: two lists are equal only if they are the same list.

```dart
void main() {
  print('dart' == 'dart');
  print(3 == 3.0);
  print([1, 2] == [1, 2]);
}
```

```output
true
true
false
```

## Overriding == and hashCode

To get value equality, override the `==` operator. You must override `hashCode` as well.

```dart
class Point {
  final int x, y;
  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Point($x, $y)';
}

void main() {
  var a = Point(1, 2);
  var b = Point(1, 2);

  print(a == b);
  print(identical(a, b));
  print(a.hashCode == b.hashCode);
}
```

```output
true
false
true
```

Reading the `==` method: if `other` is the very same object, they are equal. Otherwise, `other` must be a `Point` with matching fields.

## Why hashCode matters

`Set` and `Map` use `hashCode` to find items quickly, and only then call `==`. The rule is:

> If `a == b`, then `a.hashCode` must equal `b.hashCode`.

Break the rule and sets and maps misbehave.

```dart
class Point {
  final int x, y;
  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  var visited = {Point(0, 0), Point(1, 1), Point(0, 0)};
  print(visited.length);

  var labels = {Point(0, 0): 'origin'};
  print(labels[Point(0, 0)]);
}
```

```output
2
origin
```

Without the overrides, the set would hold three points and the map lookup would return `null`.

Use `Object.hash(a, b, c)` for up to twenty fields and `Object.hashAll(list)` for a collection.

## Equality with collections inside

If a field is a list, `==` on it compares identity. Compare the contents with helpers from the `collection` package.

```dart
import 'package:collection/collection.dart';

class Playlist {
  final String name;
  final List<String> songs;
  Playlist(this.name, this.songs);

  static const _eq = ListEquality<String>();

  @override
  bool operator ==(Object other) =>
      other is Playlist && other.name == name && _eq.equals(other.songs, songs);

  @override
  int get hashCode => Object.hash(name, _eq.hash(songs));
}
```

## Ways to avoid writing it by hand

- **Records** have value equality built in: `(1, 2) == (1, 2)` is `true`. See [records](/records-and-patterns/records/).
- **`const` objects** with the same values are identical, so they are also equal.
- The **equatable** package lets you list the fields once.
- Code generators such as **freezed** write `==`, `hashCode`, `toString` and `copyWith` for you.

## Rules for a correct ==

- Only use fields that never change. If an object's hash changes while it is inside a set, the set can no longer find it. Value-equal classes should be immutable.
- Always override `hashCode` together with `==`.
- Use the same fields in both.
- The parameter type must be `Object`, not your own class.

## Try it yourself

Create a `Money` class with `amount` and `currency`. Before overriding anything, put two equal-looking values in a `Set` and print its length. Then add `==` and `hashCode` and run it again.
