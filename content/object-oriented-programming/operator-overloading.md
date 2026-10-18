---
title: "Operator Overloading and Callable Classes in Dart"
linkTitle: "Operator overloading"
description: "Define how operators such as +, -, ==, [] and < work on your own classes in Dart, and make objects callable with the call method."
weight: 19
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart operator overloading"
  - "operator keyword"
  - "callable class"
  - "call method"
  - "custom operators"
---

Operators such as `+`, `<` and `[]` are just methods with special names. Dart lets you define them for your own classes, so that objects representing numbers, vectors, money or collections can be used with natural syntax.

## Defining an operator

Use the `operator` keyword followed by the symbol.

```dart
class Vector {
  final double x, y;
  const Vector(this.x, this.y);

  Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
  Vector operator -(Vector other) => Vector(x - other.x, y - other.y);
  Vector operator *(double factor) => Vector(x * factor, y * factor);
  Vector operator -() => Vector(-x, -y); // unary minus

  @override
  String toString() => 'Vector($x, $y)';
}

void main() {
  const a = Vector(1, 2);
  const b = Vector(3, 4);

  print(a + b);
  print(b - a);
  print(a * 3);
  print(-a);
}
```

```output
Vector(4.0, 6.0)
Vector(2.0, 2.0)
Vector(3.0, 6.0)
Vector(-1.0, -2.0)
```

`a + b` is exactly the same as calling a method named `+` on `a` with the argument `b`.

## Comparison operators

```dart
class Version implements Comparable<Version> {
  final int major, minor;
  const Version(this.major, this.minor);

  @override
  int compareTo(Version other) =>
      major != other.major ? major - other.major : minor - other.minor;

  bool operator <(Version other) => compareTo(other) < 0;
  bool operator >(Version other) => compareTo(other) > 0;
  bool operator <=(Version other) => compareTo(other) <= 0;
  bool operator >=(Version other) => compareTo(other) >= 0;

  @override
  String toString() => '$major.$minor';
}

void main() {
  const v1 = Version(3, 2);
  const v2 = Version(3, 10);

  print(v1 < v2);
  print(v1 >= v2);

  var versions = [v2, const Version(2, 9), v1]..sort();
  print(versions);
}
```

```output
true
false
[2.9, 3.2, 3.10]
```

Implementing `Comparable` makes `sort()` work with no arguments.

## Index operators

`[]` reads and `[]=` writes.

```dart
class Grid {
  final int width, height;
  final List<int> _cells;

  Grid(this.width, this.height) : _cells = List.filled(width * height, 0);

  int operator []((int, int) position) {
    final (col, row) = position;
    return _cells[row * width + col];
  }

  void operator []=((int, int) position, int value) {
    final (col, row) = position;
    _cells[row * width + col] = value;
  }
}

void main() {
  var grid = Grid(3, 3);
  grid[(1, 2)] = 9;
  print(grid[(1, 2)]);
  print(grid[(0, 0)]);
}
```

```output
9
0
```

## Operators you can define

| Group | Operators |
| --- | --- |
| Arithmetic | `+` `-` `*` `/` `~/` `%` and unary `-` |
| Comparison | `<` `>` `<=` `>=` `==` |
| Index | `[]` `[]=` |
| Bitwise | `&` `\|` `^` `~` `<<` `>>` `>>>` |

You cannot define `&&`, `||`, `!`, `??`, `=`, `?.` or `is`. You do not define `!=`: Dart derives it from `==`. Likewise `+=` comes from `+`.

Overriding `==` has extra rules; see [equality and hashCode](/object-oriented-programming/equality-and-hashcode/).

## Callable classes

Give a class a method named `call` and its objects can be used like functions.

```dart
class Multiplier {
  final int factor;
  const Multiplier(this.factor);

  int call(int value) => value * factor;
}

void main() {
  const triple = Multiplier(3);

  print(triple(5));                       // same as triple.call(5)
  print([1, 2, 3].map(triple.call).toList());
}
```

```output
15
[3, 6, 9]
```

This suits objects that are basically one action with some configuration, such as a validator or a formatter.

## Use operators with restraint

An operator should do what readers expect. `money + money`, `vector * 2` and `date1 < date2` are clear. Using `+` to mean "send an email" or `>>` to mean "log in" is clever and confusing. When the meaning is not obvious, a named method is better.

## Try it yourself

Create a `Fraction` class with a numerator and denominator. Implement `+`, `*`, `==` (with `hashCode`), `<` and `toString`. Check that `Fraction(1, 2) + Fraction(1, 3)` prints `5/6`.
