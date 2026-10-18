---
title: "Constructors in Dart: Default, Named, Initializer Lists and Redirecting"
seoTitle: "Dart Constructors: Default, Named, Initializer List and Redirecting"
linkTitle: "Constructors"
description: "Every kind of generative constructor in Dart: default, initializing formals, named parameters, named constructors and initializer lists."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart constructor"
  - "named constructor"
  - "initializer list"
  - "redirecting constructor"
  - "this.field"
---

A constructor creates an object and makes sure its fields have values. Dart offers several styles, and the short ones cover most needs.

## The default constructor

If you write no constructor, Dart gives you one with no parameters. Fields then need default values.

```dart
class Light {
  bool isOn = false;
  int brightness = 50;
}

void main() {
  var light = Light();
  print('${light.isOn} ${light.brightness}');
}
```

```output
false 50
```

## Initializing formals

Writing `this.name` in the parameter list assigns the argument straight to the field. This is the form you will write most.

```dart
class Student {
  final String name;
  final int grade;

  Student(this.name, this.grade);
}

void main() {
  var s = Student('Sabina', 10);
  print('${s.name} is in grade ${s.grade}');
}
```

```output
Sabina is in grade 10
```

It replaces the long version found in other languages:

```text
Student(String name, int grade) {
  this.name = name;
  this.grade = grade;
}
```

## Named parameters in constructors

For classes with more than two or three fields, named parameters make the call readable. Flutter widgets are written this way.

```dart
class Product {
  final String name;
  final double price;
  final int stock;
  final String? description;

  Product({
    required this.name,
    required this.price,
    this.stock = 0,
    this.description,
  });
}

void main() {
  var p = Product(name: 'Notebook', price: 120);
  print('${p.name}: Rs. ${p.price}, ${p.stock} in stock');
}
```

```output
Notebook: Rs. 120.0, 0 in stock
```

## Named constructors

A class can have several constructors as long as each has a different name. Use them to offer clear alternative ways of creating an object.

```dart
class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
  Point.onXAxis(this.x) : y = 0;
  Point.fromList(List<double> values) : x = values[0], y = values[1];

  @override
  String toString() => '($x, $y)';
}

void main() {
  print(Point(2, 3));
  print(Point.origin());
  print(Point.onXAxis(5));
  print(Point.fromList([7, 8]));
}
```

```output
(2.0, 3.0)
(0.0, 0.0)
(5.0, 0.0)
(7.0, 8.0)
```

## The initializer list

The part after the colon runs **before** the constructor body. It is the only place you can set `final` fields from calculated values, and you can also put `assert`s there.

```dart
class Temperature {
  final double celsius;
  final double fahrenheit;

  Temperature(this.celsius)
      : assert(celsius >= -273.15, 'Below absolute zero'),
        fahrenheit = celsius * 9 / 5 + 32;
}

void main() {
  var t = Temperature(100);
  print(t.fahrenheit);
}
```

```output
212.0
```

## Redirecting constructors

One constructor can hand its work to another with `: this(...)`.

```dart
class Circle {
  final double radius;

  Circle(this.radius);
  Circle.unit() : this(1);
  Circle.fromDiameter(double diameter) : this(diameter / 2);
}

void main() {
  print(Circle.unit().radius);
  print(Circle.fromDiameter(10).radius);
}
```

```output
1.0
5.0
```

## A constructor body

Add a body in braces when you need to run statements after the fields are set.

```dart
class Order {
  final List<double> prices;
  double total = 0;

  Order(this.prices) {
    for (final p in prices) {
      total += p;
    }
  }
}

void main() {
  print(Order([10, 20.5]).total);
}
```

```output
30.5
```

## Private constructors

A constructor whose name starts with `_` can only be called inside its own file. Combined with a `static` field, this makes a class with exactly one instance.

```dart
class Settings {
  Settings._();
  static final Settings instance = Settings._();

  String theme = 'light';
}

void main() {
  Settings.instance.theme = 'dark';
  print(Settings.instance.theme);
}
```

```output
dark
```

Constructors that decide which object to return are called [factory constructors](/object-oriented-programming/factory-constructors/), and are covered next.

## Try it yourself

Write a `Book` class with `title`, `author` and `pages`. Give it a main constructor using named parameters, and a named constructor `Book.untitled(String author)` that redirects to the main one with the title `'Untitled'` and 0 pages.
