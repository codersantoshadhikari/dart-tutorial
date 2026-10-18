---
title: "Private Members and Encapsulation in Dart"
linkTitle: "Private members"
description: "Dart has no private keyword. Learn how the underscore makes members library-private, how privacy works across files, and best practices."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart private"
  - "dart access modifiers"
  - "underscore private"
  - "encapsulation"
  - "library privacy"
  - "dart protected"
aliases:
  - "/access-modifier-in-dart-classes/"
  - "/fr/access-modifier-in-dart-classes/"
  - "/access-modifier-in-dart-classes/public-and-private-_/"
  - "/fr/access-modifier-in-dart-classes/public-and-private-_/"
  - "/access-modifier-in-dart-classes/file-level-privacy/"
  - "/fr/access-modifier-in-dart-classes/file-level-privacy/"
  - "/access-modifier-in-dart-classes/privacy-across-libraries/"
  - "/fr/access-modifier-in-dart-classes/privacy-across-libraries/"
  - "/access-modifier-in-dart-classes/best-practices/"
  - "/fr/access-modifier-in-dart-classes/best-practices/"
---

If you come from Java or C#, you will look for `public`, `private` and `protected`. Dart has none of them. It has one rule:

> A name that starts with an underscore (`_`) is private to its **library**. Everything else is public.

A library is normally a single `.dart` file.

## Public and private members

```dart
class BankAccount {
  String owner;        // public
  double _balance = 0; // private to this file

  BankAccount(this.owner);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit must be positive');
    _balance += amount;
    _log('deposit $amount');
  }

  void _log(String message) => print('[$owner] $message'); // private method
}

void main() {
  var account = BankAccount('Sarita');
  account.deposit(250);
  print(account.balance);
}
```

```output
[Sarita] deposit 250.0
250.0
```

The underscore works on anything with a name: fields, methods, constructors, classes, top-level functions and variables.

## Privacy is per file, not per class

This surprises people. Code in the **same file** can reach private members, even from another class or from `main`.

```dart
class Safe {
  final String _code = '1234';
}

void main() {
  var safe = Safe();
  print(safe._code); // allowed: main is in the same library
}
```

```output
1234
```

So the example above only shows real privacy once the class lives in its own file.

## Privacy across files

```dart
// File: lib/safe.dart
class Safe {
  final String _code = '1234';
  bool open(String attempt) => attempt == _code;
}
```

```dart
// File: bin/main.dart
import 'package:my_app/safe.dart';

void main() {
  var safe = Safe();
  print(safe.open('1234')); // true
  // print(safe._code);     // error: the getter '_code' isn't defined
}
```

From another file the private member does not merely refuse access. As far as that file is concerned, it does not exist.

## Private classes and functions

Helpers that are nobody else's business can be hidden entirely.

```dart
// File: lib/price_formatter.dart

String formatPrice(double amount) => '${_symbol()} ${_round(amount)}';

String _symbol() => 'Rs.';                           // private function
String _round(double n) => n.toStringAsFixed(2);

class _Cache {}                                      // private class
```

Only `formatPrice` can be used by code that imports this file.

## What about protected?

Dart has no `protected`. A subclass in a **different** file cannot see `_private` members of its parent. If subclasses need access, the options are:

- make the member public, or
- annotate it with `@protected` from the `meta` package. The analyzer then warns when it is used outside subclasses. It is a warning, not an enforced rule.

## Why hide things?

This idea is called **encapsulation**. A class exposes a small, safe set of operations and keeps the details to itself.

- **Protects rules.** If `_balance` could be set directly, anyone could make it negative. Going through `deposit` keeps the object valid.
- **Lets you change your mind.** Private parts can be rewritten without breaking any code that uses the class.
- **Makes the class easier to use.** Autocomplete shows five public members instead of thirty.

## Best practices

- Make members private by default and open them up only when needed.
- Pair a private field with a public getter to make it read-only.
- Put each important class in its own file so that privacy actually applies.
- In a package, keep implementation files in `lib/src/` and export only the public API from a top-level file.
- Do not start a **local** variable name with `_`. Locals are already private to their function. A lone `_` is fine for a value you are deliberately ignoring.

## Try it yourself

Create a file `password_vault.dart` with a class that stores a private `_password`, a `bool check(String attempt)` method, and a `change(String oldPassword, String newPassword)` method. From a second file, confirm you cannot read `_password` directly.
