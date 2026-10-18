---
title: "Custom Exceptions in Dart"
linkTitle: "Custom exceptions"
description: "Create your own exception classes in Dart by implementing Exception. Add fields, build exception hierarchies and handle them with on."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart custom exception"
  - "implements Exception"
  - "exception class"
  - "exception hierarchy"
  - "sealed exception"
---

The built-in exception types are general. Your app has its own failures: "insufficient balance", "user not found", "session expired". A **custom exception** gives each of them a name, so callers can handle them precisely and carry useful data along.

## A minimal custom exception

Implement the `Exception` interface. It has no required members.

```dart
class InsufficientFundsException implements Exception {
  final double balance;
  final double requested;

  InsufficientFundsException(this.balance, this.requested);

  @override
  String toString() =>
      'InsufficientFundsException: tried to withdraw $requested, '
      'but the balance is $balance';
}

class Account {
  double balance;
  Account(this.balance);

  void withdraw(double amount) {
    if (amount > balance) {
      throw InsufficientFundsException(balance, amount);
    }
    balance -= amount;
  }
}

void main() {
  var account = Account(500);

  try {
    account.withdraw(200);
    account.withdraw(800);
  } on InsufficientFundsException catch (e) {
    print(e);
    print('You are short by ${e.requested - e.balance}');
  }
}
```

```output
InsufficientFundsException: tried to withdraw 800.0, but the balance is 300.0
You are short by 500.0
```

Because the exception carries `balance` and `requested`, the handler can do something specific with them.

## Why not throw a String?

Dart lets you `throw 'something broke';`, but then nobody can catch it by type, and there is nowhere to put extra data. Always throw an object whose class says what went wrong.

## A family of exceptions

Give related exceptions a common parent. Callers can then catch one specific problem or the whole group.

```dart
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class WrongPasswordException extends AuthException {
  final int attemptsLeft;
  const WrongPasswordException(this.attemptsLeft) : super('Wrong password');
}

class AccountLockedException extends AuthException {
  const AccountLockedException() : super('Account is locked');
}

void login(String password, int attempts) {
  if (attempts >= 3) throw const AccountLockedException();
  if (password != 'secret') throw WrongPasswordException(2 - attempts);
  print('Logged in');
}

void tryLogin(String password, int attempts) {
  try {
    login(password, attempts);
  } on WrongPasswordException catch (e) {
    print('${e.message}. ${e.attemptsLeft} attempt(s) left.');
  } on AuthException catch (e) {
    print('Login failed: ${e.message}');
  }
}

void main() {
  tryLogin('secret', 0);
  tryLogin('guess', 1);
  tryLogin('secret', 3);
}
```

```output
Logged in
Wrong password. 1 attempt(s) left.
Login failed: Account is locked
```

The specific handler comes first. The general `AuthException` handler catches everything else in the family.

## Wrapping a lower-level exception

Translate technical failures into ones that make sense for your app, and keep the original for debugging.

```dart
class ConfigException implements Exception {
  final String message;
  final Object? cause;
  ConfigException(this.message, [this.cause]);

  @override
  String toString() => 'ConfigException: $message';
}

int readPort(Map<String, String> config) {
  final raw = config['port'];
  if (raw == null) throw ConfigException('"port" is missing');
  try {
    return int.parse(raw);
  } on FormatException catch (e) {
    throw ConfigException('"port" must be a number, got "$raw"', e);
  }
}

void main() {
  for (final config in [
    {'port': '8080'},
    {'port': 'eighty'},
    <String, String>{},
  ]) {
    try {
      print(readPort(config));
    } on ConfigException catch (e) {
      print(e);
    }
  }
}
```

```output
8080
ConfigException: "port" must be a number, got "eighty"
ConfigException: "port" is missing
```

## Sealed exception hierarchies

Make the parent `sealed` and a `switch` over the exception must handle every kind. See [sealed classes](/records-and-patterns/sealed-classes/).

```dart
sealed class PaymentException implements Exception {}

class CardDeclined extends PaymentException {
  final String reason;
  CardDeclined(this.reason);
}

class NetworkDown extends PaymentException {}

String messageFor(PaymentException e) => switch (e) {
      CardDeclined(:var reason) => 'Your card was declined: $reason',
      NetworkDown() => 'No connection. Please try again.',
    };

void main() {
  try {
    throw CardDeclined('expired');
  } on PaymentException catch (e) {
    print(messageFor(e));
  }
}
```

```output
Your card was declined: expired
```

## Guidelines

- End the class name with `Exception`.
- Implement `Exception` for problems a caller might recover from. Extend `Error` only for programming mistakes.
- Include the data a handler needs, as `final` fields.
- Override `toString` so logs are readable.
- Document which exceptions a function can throw in its doc comment. Dart does not declare them in the signature.
- Do not create a new exception type for every line. A handful of meaningful types is plenty.

## Try it yourself

Build a small `Inventory` class with `remove(String item, int quantity)`. Throw `ItemNotFoundException` when the item does not exist and `OutOfStockException` (with `available` and `requested` fields) when there is not enough. Give them a shared `InventoryException` parent and handle each case differently.
