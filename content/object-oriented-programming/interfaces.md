---
title: "Interfaces in Dart: The implements Keyword"
linkTitle: "Interfaces"
description: "Dart has no interface keyword for declarations: every class is an interface. Learn implements, multiple interfaces and when to use them."
weight: 10
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart interface"
  - "implements keyword"
  - "implicit interface"
  - "multiple interfaces"
  - "extends vs implements"
aliases:
  - "/advanced-classes/interfaces-implicit-class-contracts/"
  - "/fr/advanced-classes/interfaces-implicit-class-contracts/"
---

An **interface** is a list of things a class promises it can do, without saying how. Other code can then depend on the promise and not on any particular class.

Dart takes an unusual approach: **every class automatically defines an interface** made of all its public members. Any other class can `implement` it.

## implements

A class that implements an interface must provide **every** member itself. It inherits nothing.

```dart
abstract class Printer {
  void printDocument(String text);
}

class LaserPrinter implements Printer {
  @override
  void printDocument(String text) => print('Laser printing: $text');
}

class PdfPrinter implements Printer {
  @override
  void printDocument(String text) => print('Saving "$text" as PDF');
}

void sendToPrinter(Printer printer) {
  printer.printDocument('Invoice #42');
}

void main() {
  sendToPrinter(LaserPrinter());
  sendToPrinter(PdfPrinter());
}
```

```output
Laser printing: Invoice #42
Saving "Invoice #42" as PDF
```

`sendToPrinter` works with anything that implements `Printer`, including classes written years later.

Interfaces are usually written as abstract classes with no method bodies, as above.

## Implementing several interfaces

A class can extend only one class, but it can implement as many interfaces as it likes.

```dart
abstract class Flyable {
  void fly();
}

abstract class Swimmable {
  void swim();
}

class Duck implements Flyable, Swimmable {
  @override
  void fly() => print('Duck flies');

  @override
  void swim() => print('Duck swims');
}

class Fish implements Swimmable {
  @override
  void swim() => print('Fish swims');
}

void main() {
  List<Swimmable> swimmers = [Duck(), Fish()];
  for (final s in swimmers) {
    s.swim();
  }
}
```

```output
Duck swims
Fish swims
```

## Any class can be implemented

Because every class has an implicit interface, you can implement a concrete class. You take its shape and throw away its code. This is how fake objects for tests are made.

```dart
class EmailService {
  void send(String to, String message) {
    print('Connecting to mail server and sending to $to');
  }
}

class FakeEmailService implements EmailService {
  final sent = <String>[];

  @override
  void send(String to, String message) => sent.add(to); // no real email
}

void main() {
  EmailService service = FakeEmailService();
  service.send('test@example.com', 'Hi');
  print((service as FakeEmailService).sent);
}
```

```output
[test@example.com]
```

## extends compared with implements

```dart
class Animal {
  void breathe() => print('Breathing');
  void move() => print('Moving');
}

class Dog extends Animal {
  // Inherits breathe and move. Nothing to write.
}

class Robot implements Animal {
  // Must write every member itself.
  @override
  void breathe() => print('Robots do not breathe');

  @override
  void move() => print('Rolling on wheels');
}

void main() {
  Dog().move();
  Robot().move();
}
```

```output
Moving
Rolling on wheels
```

| | `extends` | `implements` |
| --- | --- | --- |
| Gets the parent's code | Yes | No |
| Must override | Only abstract members | Everything |
| How many | One class | Any number |
| Can combine | `class A extends B implements C, D` | |

## The interface modifier

Dart 3 added an `interface class` modifier. It means "other libraries may implement this class but may not extend it". It is covered in [class modifiers](/object-oriented-programming/class-modifiers/).

## Why interfaces matter

Code that depends on an interface is easy to change and easy to test. Your app can depend on a `Storage` interface, use a `DatabaseStorage` in production and a `MemoryStorage` in tests, and none of the code that uses it needs to know the difference.

## Try it yourself

Define a `Storage` interface with `void save(String key, String value)` and `String? read(String key)`. Implement `MemoryStorage` using a map. Write a function `rememberUser(Storage storage, String name)` that takes the interface, not the class.
