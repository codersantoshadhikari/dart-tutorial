---
title: "Class Modifiers in Dart 3: base, interface, final, sealed and mixin"
linkTitle: "Class modifiers"
description: "Understand Dart 3 class modifiers. Learn what abstract, base, interface, final, sealed and mixin allow and when to use each one."
weight: 18
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart class modifiers"
  - "interface class"
  - "final class"
  - "base class"
  - "sealed class"
  - "mixin class"
  - "dart 3"
aliases:
  - "/advanced-classes/interface-classes-new-feature/"
  - "/fr/advanced-classes/interface-classes-new-feature/"
---

By default a Dart class is wide open: anyone can construct it, extend it, and implement its interface. **Class modifiers**, added in Dart 3, let the author of a class restrict that. They are most useful when you publish a package and want to control how other people build on your types.

## The three things you can do with a class

| Action | Meaning |
| --- | --- |
| Construct | Create an instance: `Vehicle()` |
| Extend | Inherit its code: `class Car extends Vehicle` |
| Implement | Copy its shape only: `class Fake implements Vehicle` |

## What each modifier allows

This table describes code in **other libraries** (other files).

| Declaration | Construct | Extend | Implement |
| --- | --- | --- | --- |
| `class` | Yes | Yes | Yes |
| `abstract class` | No | Yes | Yes |
| `base class` | Yes | Yes | No |
| `interface class` | Yes | No | Yes |
| `final class` | Yes | No | No |
| `sealed class` | No | No | No |
| `mixin class` | Yes | Yes | Yes, and can be mixed in |

Inside the **same file**, the restrictions of `base`, `interface` and `final` do not apply. The author can always subclass their own types.

## interface class

"You may implement my contract, but you may not inherit my code."

```dart
// File: lib/logger.dart
interface class Logger {
  void log(String message) => print('LOG: $message');
}
```

```dart
// File: bin/main.dart
import 'package:my_app/logger.dart';

class SilentLogger implements Logger { // allowed
  @override
  void log(String message) {}
}

// class MyLogger extends Logger {}    // error: can't be extended outside its library

void main() {
  Logger().log('hello');               // allowed: it is not abstract
  SilentLogger().log('hello');
}
```

This protects against the "fragile base class" problem, where a subclass depends on how the parent's methods call each other and breaks when the parent is refactored.

For a pure contract with no implementation, combine the two: `abstract interface class`.

```dart
abstract interface class Shape {
  double get area;
}

class Square implements Shape {
  final double side;
  Square(this.side);

  @override
  double get area => side * side;
}

void main() => print(Square(3).area);
```

```output
9.0
```

## base class

"You may inherit from me, but you may not write a separate implementation."

Every subtype is then guaranteed to contain your real code, including private members and constructor checks. Subclasses of a base class must themselves be marked `base`, `final` or `sealed`.

```dart
base class Account {
  double _balance = 0;
  double get balance => _balance;

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Invalid amount');
    _balance += amount;
  }
}

base class SavingsAccount extends Account {
  void addInterest() => deposit(balance * 0.05);
}

void main() {
  var account = SavingsAccount()..deposit(1000);
  account.addInterest();
  print(account.balance);
}
```

```output
1050.0
```

## final class

"Use me as I am." No extending and no implementing outside the library. The author can add methods later without worrying about breaking a subclass somewhere.

```dart
final class Money {
  final int cents;
  const Money(this.cents);

  Money operator +(Money other) => Money(cents + other.cents);

  @override
  String toString() => (cents / 100).toStringAsFixed(2);
}

void main() => print(const Money(1050) + const Money(250));
```

```output
13.00
```

## sealed class

A sealed class is abstract, and all of its direct subtypes must be in the same file. Because the compiler knows the full list, a `switch` over a sealed type is checked for completeness. It has its own lesson: [sealed classes](/records-and-patterns/sealed-classes/).

## mixin class

A plain `class` cannot be used after `with`, and a `mixin` cannot be constructed. `mixin class` gives you both.

```dart
mixin class Greeter {
  void greet() => print('Hello from $runtimeType');
}

class Shop with Greeter {}

void main() {
  Greeter().greet(); // used as a class
  Shop().greet();    // used as a mixin
}
```

```output
Hello from Greeter
Hello from Shop
```

## Which should I use?

- **Writing an app?** You rarely need any of them except `sealed` and `abstract`. Plain classes are fine.
- **Publishing a package?** Start strict (`final`), and loosen only when users need to extend. Loosening later is safe; tightening later breaks people's code.
- **Defining a contract?** `abstract interface class`.
- **Modelling a fixed set of cases?** `sealed`.

## Try it yourself

In one file, declare `final class Token`. In a second file, try to extend it and then to implement it, and read both errors. Change it to `interface class` and then to `base class`, and note which of the two attempts each modifier permits.
