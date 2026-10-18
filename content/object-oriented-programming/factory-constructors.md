---
title: "Factory Constructors in Dart"
linkTitle: "Factory constructors"
description: "Learn what a factory constructor is in Dart and when to use one: caching, singletons, returning subtypes and creating objects from JSON."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart factory constructor"
  - "factory keyword"
  - "fromJson"
  - "singleton dart"
  - "factory vs named constructor"
aliases:
  - "/advanced-classes/factory-constructors/"
  - "/fr/advanced-classes/factory-constructors/"
---

A normal constructor always creates a brand-new object of its own class. A **factory constructor** is a constructor that gets to decide what to return. It can hand back an existing object, an object of a subclass, or a new object after doing some checks.

To the caller it looks exactly like any other constructor.

## Syntax

```dart
class Temperature {
  final double celsius;
  Temperature(this.celsius);

  factory Temperature.fromFahrenheit(double f) {
    return Temperature((f - 32) * 5 / 9);
  }
}

void main() {
  var t = Temperature.fromFahrenheit(212);
  print(t.celsius);
}
```

```output
100.0
```

A factory constructor has a body that `return`s an object. It cannot use `this`, because no object exists until it creates or finds one.

## Use 1: creating objects from JSON

This is the most common factory you will write. Data from a web API arrives as a `Map`, and `fromJson` turns it into a typed object.

```dart
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String? ?? 'not provided',
    );
  }
}

void main() {
  var user = User.fromJson({'id': 7, 'name': 'Deepa'});
  print('${user.id} ${user.name} ${user.email}');
}
```

```output
7 Deepa not provided
```

## Use 2: returning a cached object

```dart
class Logger {
  final String name;
  static final Map<String, Logger> _cache = {};

  Logger._(this.name);

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._(name));
  }
}

void main() {
  var a = Logger('network');
  var b = Logger('network');
  var c = Logger('database');

  print(identical(a, b));
  print(identical(a, c));
}
```

```output
true
false
```

Asking twice for the `network` logger returns the very same object.

## Use 3: a singleton

```dart
class AppConfig {
  static final AppConfig _instance = AppConfig._();
  AppConfig._();

  factory AppConfig() => _instance;

  String language = 'en';
}

void main() {
  AppConfig().language = 'ne';
  print(AppConfig().language);
  print(identical(AppConfig(), AppConfig()));
}
```

```output
ne
true
```

## Use 4: returning a subclass

The caller asks for a `Shape` and the factory chooses the concrete class.

```dart
abstract class Shape {
  double get area;

  factory Shape(String type, double size) {
    return switch (type) {
      'circle' => Circle(size),
      'square' => Square(size),
      _ => throw ArgumentError('Unknown shape: $type'),
    };
  }
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
  @override
  double get area => 3.14159 * radius * radius;
}

class Square implements Shape {
  final double side;
  Square(this.side);
  @override
  double get area => side * side;
}

void main() {
  print(Shape('square', 4).area);
  print(Shape('circle', 1).area);
}
```

```output
16.0
3.14159
```

## Factory or named constructor?

| | Generative constructor | Factory constructor |
| --- | --- | --- |
| Always creates a new object | Yes | Not necessarily |
| Can use `this` and initializer lists | Yes | No |
| Can return a subtype or cached object | No | Yes |
| Can be called by a subclass with `super` | Yes | No |

If you only need another way to fill in the fields, a named constructor with an initializer list is enough. Use `factory` when you need logic before the object exists, or when you may not create one at all.

## Try it yourself

Write a `Colour` class with `r`, `g` and `b` fields and a `factory Colour.fromHex(String hex)` that accepts text such as `'#FF8800'`. Hint: `int.parse(hex.substring(1, 3), radix: 16)`.
