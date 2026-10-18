---
title: "Extension Types in Dart: Zero-Cost Wrappers"
linkTitle: "Extension types"
description: "Learn extension types in Dart: wrap an existing type in a new, distinct type with no run-time cost for safer IDs, units and APIs."
weight: 15
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart extension type"
  - "zero cost wrapper"
  - "type safe id"
  - "representation type"
  - "dart 3.3"
---

Imagine a function `transfer(int fromAccount, int toAccount, int amount)`. All three are `int`, so passing them in the wrong order compiles happily and moves money to the wrong place.

An **extension type** fixes this. It wraps an existing type in a new, separate type that the compiler tells apart, and it costs nothing at run time because the wrapper is erased when the program is compiled.

## Declaring an extension type

```dart
extension type AccountId(int value) {}
extension type Rupees(int value) {}

void transfer(AccountId from, AccountId to, Rupees amount) {
  print('Moving ${amount.value} from ${from.value} to ${to.value}');
}

void main() {
  var mine = AccountId(1001);
  var yours = AccountId(2002);
  var amount = Rupees(500);

  transfer(mine, yours, amount);
  // transfer(mine, amount, yours); // error: Rupees is not an AccountId
  // transfer(1001, 2002, 500);     // error: int is not an AccountId
}
```

```output
Moving 500 from 1001 to 2002
```

`AccountId(int value)` declares both the constructor and the **representation**: the underlying value, available as `.value`.

## Adding your own members

By default an extension type exposes **none** of the wrapped type's members. You decide what is available.

```dart
extension type Email(String value) {
  bool get isValid => value.contains('@') && value.contains('.');
  String get domain => value.split('@').last;
}

void main() {
  var email = Email('rita@example.com');
  print(email.isValid);
  print(email.domain);
  // print(email.length); // error: Email has no 'length'
}
```

```output
true
example.com
```

This is useful for narrowing a big API down to the few operations that make sense.

## Exposing the wrapped type with implements

Add `implements` to let the new type be used as the original and inherit its members.

```dart
extension type Celsius(double value) implements double {
  double get fahrenheit => value * 9 / 5 + 32;
}

void main() {
  var t = Celsius(36.6);
  print(t.fahrenheit.toStringAsFixed(1));
  print(t + 1);          // works: all of double's members are available
  double plain = t;      // works: a Celsius is a double
  print(plain);
}
```

```output
97.9
37.6
36.6
```

## Validating in a constructor

```dart
extension type Percentage._(int value) {
  Percentage(int value) : this._(value < 0 ? 0 : (value > 100 ? 100 : value));
}

void main() {
  print(Percentage(140).value);
  print(Percentage(-5).value);
}
```

```output
100
0
```

## Extension type, class, typedef or extension?

| Tool | Creates a distinct type? | Run-time cost | Use for |
| --- | --- | --- | --- |
| `typedef` | No, just a nickname | None | Shortening long types |
| `extension` | No, adds members to an existing type | None | Helper methods |
| `extension type` | Yes, at compile time | None | Type-safe IDs, units, restricted APIs |
| `class` | Yes, at run time too | An extra object | Real data with its own identity |

## One important limit

The wrapper only exists at compile time. At run time, an `AccountId` **is** an `int`.

```dart
extension type AccountId(int value) {}

void main() {
  Object id = AccountId(7);
  print(id is int);
  print(id.runtimeType);
}
```

```output
true
int
```

So extension types help you avoid mistakes, but they are not a security boundary and cannot be told apart with `is`. When you need a type that is truly separate while the program runs, write a class.

## Try it yourself

Create extension types `Metres` and `Feet`, both wrapping `double`. Give `Feet` a getter `toMetres` that returns a `Metres`. Write `void buildFence(Metres length)` and confirm that passing a `Feet` value is a compile error.
