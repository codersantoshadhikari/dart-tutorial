---
title: "Function Parameters in Dart: Positional, Named, Optional and Default"
linkTitle: "Parameters"
description: "Master Dart function parameters: required positional, optional positional, named parameters, the required keyword and default values."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart named parameters"
  - "optional parameters"
  - "default values"
  - "required keyword"
  - "positional parameters"
---

Dart gives you several ways to pass values into a function. Choosing well makes your functions easier to call correctly.

## Required positional parameters

The plain kind. Arguments are matched by position, and every one must be supplied.

```dart
String fullName(String first, String last) {
  return '$first $last';
}

void main() {
  print(fullName('Ada', 'Lovelace'));
}
```

```output
Ada Lovelace
```

## Optional positional parameters

Wrap parameters in `[ ]` to make them optional. Without a default they are `null` when left out, so their type needs a `?`.

```dart
String greet(String name, [String? title]) {
  if (title == null) return 'Hello, $name';
  return 'Hello, $title $name';
}

void main() {
  print(greet('Sharma'));
  print(greet('Sharma', 'Dr.'));
}
```

```output
Hello, Sharma
Hello, Dr. Sharma
```

## Default values

Give an optional parameter a default with `=`. Then it is never null.

```dart
double priceWithTax(double price, [double rate = 0.13]) {
  return price * (1 + rate);
}

void main() {
  print(priceWithTax(100));
  print(priceWithTax(100, 0.05));
}
```

```output
112.99999999999999
105.0
```

(The first result shows floating-point rounding. Use `toStringAsFixed(2)` when displaying money.)

## Named parameters

Wrap parameters in `{ }` and the caller must write the name. The order no longer matters, and the call explains itself.

```dart
void createUser({required String name, int age = 18, String? city}) {
  print('$name, $age, ${city ?? 'unknown city'}');
}

void main() {
  createUser(name: 'Ravi');
  createUser(age: 30, name: 'Mina', city: 'Pokhara');
}
```

```output
Ravi, 18, unknown city
Mina, 30, Pokhara
```

Each named parameter must be one of three things:

- marked `required`, so the caller has to pass it,
- given a default value, or
- nullable (`String?`), in which case it is `null` when omitted.

## Mixing positional and named

Positional parameters come first, then the named ones.

```dart
void sendMessage(String text, {required String to, bool urgent = false}) {
  print('${urgent ? '[URGENT] ' : ''}To $to: $text');
}

void main() {
  sendMessage('Lunch?', to: 'Sam');
  sendMessage('Server is down', to: 'Ops', urgent: true);
}
```

```output
To Sam: Lunch?
[URGENT] To Ops: Server is down
```

You cannot use `[ ]` and `{ }` in the same function.

## Which kind should I use?

| Use | When |
| --- | --- |
| Required positional | One or two arguments whose meaning is obvious: `sqrt(9)` |
| Named | Three or more arguments, any `bool`, or anything that could be confused |
| Optional positional | Rarely; a single obvious extra such as a separator |

Compare `resize(800, 600, true, false)` with `resize(width: 800, height: 600, keepRatio: true, animate: false)`. Named parameters are the reason Flutter code is readable.

## Try it yourself

Write `String formatPrice(double amount, {String currency = 'Rs.', int decimals = 2})`. Calling `formatPrice(1499.5)` should return `Rs. 1499.50`, and `formatPrice(20, currency: r'$', decimals: 0)` should return `$ 20`.
