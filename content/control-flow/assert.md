---
title: "assert in Dart: Catching Mistakes During Development"
linkTitle: "assert"
description: "Learn how assert statements work in Dart, when they run, and how to use them to catch programming mistakes early."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart assert"
  - "assertions"
  - "debug mode"
  - "enable-asserts"
---

An `assert` states something that must be true at that point in the program. If it is false, Dart stops with an error that points to the exact line. Asserts are a way of writing down your assumptions so the computer can check them.

## Syntax

```dart
void main() {
  var age = 25;
  assert(age >= 0, 'Age cannot be negative');
  print('Age is $age');
}
```

The second argument is an optional message shown when the check fails.

## Asserts only run in development

This is the important part. Asserts are **ignored in production**, so they cost nothing in a released app.

| How the code runs | Asserts |
| --- | --- |
| `dart run --enable-asserts app.dart` | Checked |
| `dart run app.dart` | Ignored |
| Flutter debug mode | Checked |
| Flutter release mode, `dart compile exe` | Ignored |

## A failing assert

```dart
double discountedPrice(double price, double percent) {
  assert(percent >= 0 && percent <= 100, 'percent must be 0-100, got $percent');
  return price * (1 - percent / 100);
}

void main() {
  print(discountedPrice(200, 15));
  print(discountedPrice(200, 150)); // a bug in the calling code
}
```

Run with asserts enabled, the second call stops the program:

```output
170.0
Failed assertion: 'percent >= 0 && percent <= 100': percent must be 0-100, got 150.0
```

## assert in constructors

Asserts are often placed in a constructor's initializer list to validate arguments.

```dart
class Rectangle {
  final double width;
  final double height;

  Rectangle(this.width, this.height)
      : assert(width > 0, 'width must be positive'),
        assert(height > 0, 'height must be positive');
}

void main() {
  var r = Rectangle(3, 4);
  print(r.width * r.height);
}
```

```output
12.0
```

## assert or exception?

Use an **assert** for mistakes made by a programmer: a function called with arguments that should never happen. Use an **exception** for problems that can occur in a correct program: a missing file, no internet, a user typing letters into a number field. Because asserts vanish in release builds, never rely on them to validate user input.

```dart
void withdraw(double balance, double amount) {
  // A user can really ask for too much, so this must always be checked.
  if (amount > balance) {
    throw ArgumentError('Insufficient balance');
  }
  print('Withdrew $amount');
}

void main() {
  withdraw(100, 30);
}
```

```output
Withdrew 30.0
```

Never put code with side effects inside an assert. `assert(list.remove(item))` would remove the item in debug mode and do nothing in release.

## Try it yourself

Write `double average(List<int> numbers)` with an assert that the list is not empty. Call it with an empty list using `dart run --enable-asserts` and read the failure message.
