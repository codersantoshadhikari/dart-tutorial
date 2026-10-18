---
title: "Polymorphism in Dart: One Interface, Many Forms"
linkTitle: "Polymorphism"
description: "Understand polymorphism in Dart with examples: method overriding, dynamic dispatch, interface-based polymorphism and type checks."
weight: 12
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart polymorphism"
  - "dynamic dispatch"
  - "method overriding"
  - "runtime polymorphism"
  - "method overloading dart"
aliases:
  - "/polymorphism/"
  - "/fr/polymorphism/"
  - "/polymorphism/compile-time-vs-runtime-polymorphism/"
  - "/fr/polymorphism/compile-time-vs-runtime-polymorphism/"
  - "/polymorphism/interface-based-polymorphism/"
  - "/fr/polymorphism/interface-based-polymorphism/"
  - "/polymorphism/overriding-and-dynamic-dispatch/"
  - "/fr/polymorphism/overriding-and-dynamic-dispatch/"
---

Polymorphism means "many forms". In code, it means you can call the same method on different kinds of objects, and each one responds in its own way. The calling code does not need to know which kind it has.

## The idea in one example

```dart
abstract class Notification {
  void send(String message);
}

class EmailNotification extends Notification {
  @override
  void send(String message) => print('Email: $message');
}

class SmsNotification extends Notification {
  @override
  void send(String message) => print('SMS: $message');
}

class PushNotification extends Notification {
  @override
  void send(String message) => print('Push: $message');
}

void main() {
  List<Notification> channels = [
    EmailNotification(),
    SmsNotification(),
    PushNotification(),
  ];

  for (final channel in channels) {
    channel.send('Your order has shipped');
  }
}
```

```output
Email: Your order has shipped
SMS: Your order has shipped
Push: Your order has shipped
```

The loop contains no `if` and no knowledge of email or SMS. Adding a `WhatsAppNotification` class later needs **no change** to the loop. That is the payoff.

## Dynamic dispatch: the object decides

The method that runs is chosen by the object's **actual** type while the program runs, not by the type of the variable.

```dart
class Animal {
  String sound() => 'Some sound';
}

class Dog extends Animal {
  @override
  String sound() => 'Woof';
}

void main() {
  Animal pet = Dog();  // variable type: Animal, object type: Dog
  print(pet.sound());
  print(pet.runtimeType);
}
```

```output
Woof
Dog
```

The variable's type decides which methods you are **allowed** to call. The object's type decides which **version** runs.

## Compile-time and run-time polymorphism

Textbooks describe two kinds:

- **Run-time polymorphism** is method overriding, shown above. Dart supports it fully.
- **Compile-time polymorphism** usually means method overloading: several methods with the same name and different parameter lists. **Dart does not have overloading.** A class cannot contain two methods called `add`.

Dart covers the same ground with other features:

```dart
class Calculator {
  // Optional parameters replace add(a, b) and add(a, b, c).
  int add(int a, int b, [int c = 0]) => a + b + c;

  // Different names replace overloads that take different types.
  double addDoubles(double a, double b) => a + b;

  // Generics replace overloads that differ only by type.
  T firstOf<T>(List<T> items) => items.first;
}

void main() {
  var calc = Calculator();
  print(calc.add(1, 2));
  print(calc.add(1, 2, 3));
  print(calc.addDoubles(1.5, 2.5));
  print(calc.firstOf(['a', 'b']));
}
```

```output
3
6
4.0
a
```

Named constructors (`Point.origin()`, `Point.fromJson()`) play the role of constructor overloads.

## Polymorphism through interfaces

The objects do not have to share a parent with code in it. Implementing the same interface is enough.

```dart
abstract class Payable {
  double amountDue();
}

class Invoice implements Payable {
  final double total;
  Invoice(this.total);
  @override
  double amountDue() => total;
}

class Employee implements Payable {
  final double salary;
  Employee(this.salary);
  @override
  double amountDue() => salary;
}

double totalPayout(List<Payable> items) =>
    items.fold(0, (sum, item) => sum + item.amountDue());

void main() {
  print(totalPayout([Invoice(1200), Employee(45000), Invoice(300)]));
}
```

```output
46500.0
```

An invoice and an employee have nothing in common except that both can be paid.

## Reaching subclass members

Through a parent-typed variable you can only see the parent's members. Check the type with `is` and Dart promotes the variable for you.

```dart
class Shape {}

class Circle extends Shape {
  double radius = 2;
}

class Square extends Shape {
  double side = 3;
}

void printSize(Shape shape) {
  if (shape is Circle) {
    print('Circle with radius ${shape.radius}');
  } else if (shape is Square) {
    print('Square with side ${shape.side}');
  }
}

void main() {
  printSize(Circle());
  printSize(Square());
}
```

```output
Circle with radius 2.0
Square with side 3.0
```

Many `is` checks in a row are usually a hint that the behaviour belongs in an overridden method, or that the hierarchy should be a [sealed class](/records-and-patterns/sealed-classes/) handled by a `switch`.

## Why it matters

- New types can be added without touching existing code.
- Long `if`/`else` chains that test types disappear.
- Functions that accept the general type work with every specific type, now and in future.

## Try it yourself

Model a drawing app. Create an abstract `Shape` with `void draw()` and `double area()`. Add three shapes. Write `void render(List<Shape> shapes)` that draws each one and prints the total area. Then add a fourth shape without changing `render`.
