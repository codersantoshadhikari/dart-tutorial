---
title: "Const Constructors in Dart: Immutable Objects"
linkTitle: "Const constructors"
description: "Learn const constructors in Dart: create immutable, compile-time constant objects, understand canonicalization and why Flutter uses const."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart const constructor"
  - "immutable class"
  - "canonical instances"
  - "flutter const"
aliases:
  - "/advanced-classes/const-constructors/"
  - "/fr/advanced-classes/const-constructors/"
  - "/advanced-classes/const-constructors/_index-/"
  - "/fr/advanced-classes/const-constructors/_index-/"
---

A `const` constructor lets a class produce **compile-time constants**: objects that are created once, can never change, and are shared wherever the same values are used.

## Requirements

A class can have a `const` constructor when every field is `final`.

```dart
class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);
}

void main() {
  const a = Point(1, 2);
  const b = Point(1, 2);
  var c = Point(1, 2); // not const: a new object each time

  print(identical(a, b));
  print(identical(a, c));
}
```

```output
true
false
```

`a` and `b` are the same single object in memory. Dart calls this **canonicalization**. `c` was created without `const`, so it is a separate object even though its values match.

## const on the constructor is permission, not a command

Declaring the constructor `const` means it **can** be used to make constants. You still choose at each call. You get a constant when you write `const` in front, or when the surrounding context is already constant.

```dart
class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);
}

void main() {
  const origin = Point(0, 0);           // const from the variable
  var corner = const Point(10, 10);     // const from the expression
  const line = [Point(0, 0), Point(5, 5)]; // const context: both points are const

  var n = 3;
  var dynamicPoint = Point(n, n);       // fine, just not a constant
  // const bad = Point(n, n);           // error: n is not a constant

  print(identical(origin, line[0]));
  print('${corner.x} ${dynamicPoint.x}');
}
```

```output
true
10 3
```

## Immutable classes

Even when you never write `const` at the call site, a class with only `final` fields is immutable, which makes it easy to reason about. To "change" one, create a modified copy. The usual helper is called `copyWith`.

```dart
class Settings {
  final String theme;
  final double fontSize;

  const Settings({this.theme = 'light', this.fontSize = 14});

  Settings copyWith({String? theme, double? fontSize}) {
    return Settings(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  String toString() => 'Settings($theme, $fontSize)';
}

void main() {
  const defaults = Settings();
  final dark = defaults.copyWith(theme: 'dark');

  print(defaults);
  print(dark);
}
```

```output
Settings(light, 14.0)
Settings(dark, 14.0)
```

## Why Flutter cares

Flutter rebuilds parts of the screen many times a second. A widget created with `const` is built once and reused, and Flutter can skip rebuilding it entirely. That is why the analyzer keeps suggesting you add `const`.

```text
const Text('Welcome')          // created once, reused on every rebuild
const SizedBox(height: 16)
const EdgeInsets.all(8)
```

## Rules to remember

- All fields must be `final`.
- A `const` constructor cannot have a body.
- The initializer list may only use constant expressions.
- Arguments must themselves be constants when you create a constant.
- A `const` object's fields must also hold constants, so a `const` object is immutable all the way down.

## Try it yourself

Create an immutable `Money` class with `amount` and `currency` and a `const` constructor. Make two constants with the same values and check `identical`. Then add a `copyWith` method and use it to change only the amount.
