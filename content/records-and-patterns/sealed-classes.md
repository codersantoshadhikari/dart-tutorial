---
title: "Sealed Classes in Dart: Exhaustive Type Hierarchies"
linkTitle: "Sealed classes"
description: "Learn sealed classes in Dart 3: model a fixed set of subtypes, get exhaustive switch checking, and represent state and results safely."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart sealed class"
  - "exhaustive switch"
  - "algebraic data types"
  - "union types"
  - "result type"
  - "state modelling"
aliases:
  - "/advanced-classes/sealed-classes/"
  - "/fr/advanced-classes/sealed-classes/"
---

A **sealed class** is a parent class with a closed list of children. All direct subtypes must be declared in the same file, so the compiler knows every one of them. In return, a `switch` over the sealed type is checked: if you forget a case, the code does not compile.

Think of it as an enum where each value can carry its own different data.

## Declaring a sealed hierarchy

```dart
sealed class Shape {}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);
}

class Triangle extends Shape {
  final double base, height;
  Triangle(this.base, this.height);
}

double area(Shape shape) => switch (shape) {
      Circle(:var radius) => 3.14159 * radius * radius,
      Rectangle(:var width, :var height) => width * height,
      Triangle(:var base, :var height) => base * height / 2,
    };

void main() {
  print(area(Circle(1)));
  print(area(Rectangle(3, 4)));
  print(area(Triangle(6, 2)));
}
```

```output
3.14159
12.0
6.0
```

There is no `default` and no `_`. Dart knows that `Circle`, `Rectangle` and `Triangle` are the only possibilities. Add a `Square` class and `area` stops compiling until you handle it.

## What sealed means

- The class is implicitly **abstract**. You cannot write `Shape()`.
- It can only be extended, implemented or mixed in **inside its own library** (file).
- The subclasses themselves are ordinary classes. They can be used anywhere and can have their own subclasses.

## Modelling the state of a screen

This is the most common use in Flutter apps. A screen that loads data is always in exactly one state.

```dart
sealed class LoadState {}

class Loading extends LoadState {}

class Loaded extends LoadState {
  final List<String> items;
  Loaded(this.items);
}

class Failed extends LoadState {
  final String message;
  Failed(this.message);
}

String render(LoadState state) => switch (state) {
      Loading() => 'Please wait...',
      Loaded(items: []) => 'Nothing here yet',
      Loaded(:var items) => 'Showing ${items.length} items',
      Failed(:var message) => 'Error: $message',
    };

void main() {
  print(render(Loading()));
  print(render(Loaded([])));
  print(render(Loaded(['a', 'b'])));
  print(render(Failed('No internet')));
}
```

```output
Please wait...
Nothing here yet
Showing 2 items
Error: No internet
```

Compare this with a class holding `bool isLoading`, `List? items` and `String? error`. That design allows nonsense combinations, such as loading and failed at once. With a sealed class, impossible states cannot be created.

## A Result type

Instead of throwing, a function can return either a success or a failure, and the caller is forced to deal with both.

```dart
sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

class Failure<T> extends Result<T> {
  final String reason;
  Failure(this.reason);
}

Result<int> parseAge(String input) {
  final age = int.tryParse(input);
  if (age == null) return Failure('"$input" is not a number');
  if (age < 0 || age > 150) return Failure('$age is not a realistic age');
  return Success(age);
}

void main() {
  for (final input in ['34', 'abc', '900']) {
    final message = switch (parseAge(input)) {
      Success(:var value) => 'Age accepted: $value',
      Failure(:var reason) => 'Rejected: $reason',
    };
    print(message);
  }
}
```

```output
Age accepted: 34
Rejected: "abc" is not a number
Rejected: 900 is not a realistic age
```

## Shared members

A sealed class is still a class. It can have fields, constructors and methods that all subtypes share.

```dart
sealed class Payment {
  final double amount;
  Payment(this.amount);

  String get receipt => 'Paid Rs. ${amount.toStringAsFixed(2)} by $method';
  String get method;
}

class Cash extends Payment {
  Cash(super.amount);
  @override
  String get method => 'cash';
}

class Card extends Payment {
  final String last4;
  Card(super.amount, this.last4);
  @override
  String get method => 'card ending $last4';
}

void main() {
  print(Cash(250).receipt);
  print(Card(1200, '4242').receipt);
}
```

```output
Paid Rs. 250.00 by cash
Paid Rs. 1200.00 by card ending 4242
```

## Sealed class or enum?

| | Enum | Sealed class |
| --- | --- | --- |
| Fixed set of options | Yes | Yes |
| Exhaustive `switch` | Yes | Yes |
| Each option has different fields | No, all values share the same fields | Yes |
| Many instances of one option | No, one object per value | Yes |

Use an enum for simple labels (`low`, `medium`, `high`). Use a sealed class when the cases carry different data (`Loaded` has items, `Failed` has a message).

## Should behaviour be a method or a switch?

Both work. Put behaviour in an **overridden method** when it is a core part of what the type is. Use a **switch** outside the class when the behaviour belongs to another layer, such as turning a state into something shown on screen. Sealed classes make the second approach as safe as the first.

## Try it yourself

Model a traffic system with `sealed class Vehicle` and subclasses `Bike`, `Car(int passengers)` and `Truck(double loadTonnes)`. Write `double toll(Vehicle v)` with a switch expression. Then add a `Bus` class and watch the compiler show you where to update the code.
