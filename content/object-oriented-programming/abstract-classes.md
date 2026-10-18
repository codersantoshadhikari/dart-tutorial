---
title: "Abstract Classes and Methods in Dart"
linkTitle: "Abstract classes"
description: "Learn abstract classes in Dart: define methods without a body, force subclasses to implement them, and share common code."
weight: 9
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart abstract class"
  - "abstract method"
  - "cannot instantiate"
  - "base class"
aliases:
  - "/advanced-classes/abstract-classes/"
  - "/fr/advanced-classes/abstract-classes/"
  - "/advanced-classes/abstract-classes/_index-/"
  - "/fr/advanced-classes/abstract-classes/_index-/"
---

An **abstract class** is a class that is incomplete on purpose. You cannot create an object of it directly. It exists to be extended, and it can declare methods that subclasses **must** provide.

## The problem

What should `area()` return for a generic `Shape`? There is no sensible answer. Returning 0 is a lie, and nothing stops a subclass from forgetting to override it.

## Abstract methods

An abstract method has a signature but no body. It ends with a semicolon.

```dart
abstract class Shape {
  double area(); // abstract: no body

  void describe() { // a normal method, shared by all shapes
    print('$runtimeType with area ${area().toStringAsFixed(2)}');
  }
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

void main() {
  // var s = Shape(); // error: abstract classes can't be instantiated

  List<Shape> shapes = [Circle(1), Rectangle(3, 4)];
  for (final shape in shapes) {
    shape.describe();
  }
}
```

```output
Circle with area 3.14
Rectangle with area 12.00
```

If `Rectangle` left out `area()`, the code would not compile. The abstract class is a contract enforced by the compiler.

## Mixing shared code with required pieces

Abstract classes are at their best when most of the logic is common and only one or two steps differ. The parent defines the overall process and the children fill in the gaps.

```dart
abstract class Report {
  final String title;
  Report(this.title);

  // Each kind of report supplies these.
  List<String> rows();
  String get footer;

  // The shared process.
  void printReport() {
    print('== $title ==');
    rows().forEach(print);
    print(footer);
  }
}

class SalesReport extends Report {
  SalesReport() : super('Sales');

  @override
  List<String> rows() => ['Pens: 120', 'Books: 45'];

  @override
  String get footer => 'Total items: 165';
}

void main() {
  SalesReport().printReport();
}
```

```output
== Sales ==
Pens: 120
Books: 45
Total items: 165
```

Abstract classes can declare abstract getters and setters too, as `footer` shows.

## Abstract classes can have constructors and fields

You cannot call the constructor directly, but subclasses call it through `super`.

```dart
abstract class Account {
  final String owner;
  double balance;

  Account(this.owner, this.balance);

  double monthlyFee();

  void chargeFee() {
    balance -= monthlyFee();
    print('$owner: $balance');
  }
}

class Savings extends Account {
  Savings(super.owner, super.balance);

  @override
  double monthlyFee() => 0;
}

class Business extends Account {
  Business(super.owner, super.balance);

  @override
  double monthlyFee() => balance > 100000 ? 0 : 500;
}

void main() {
  Savings('Mina', 2000).chargeFee();
  Business('Shop', 30000).chargeFee();
}
```

```output
Mina: 2000.0
Shop: 29500.0
```

## Abstract class or interface?

| | `extends` an abstract class | `implements` an interface |
| --- | --- | --- |
| Inherits method bodies and fields | Yes | No, must write everything |
| How many | One | Many |
| Relationship | "is a kind of" | "can do" |

Use an abstract class when subclasses share real code. Use an [interface](/object-oriented-programming/interfaces/) when unrelated classes only need to promise the same methods.

## Try it yourself

Write an abstract class `Employee` with a `name`, an abstract `double pay()` method and a concrete `void printPayslip()`. Create `Salaried` (fixed monthly amount) and `Hourly` (hours times rate) subclasses and print a payslip for each.
