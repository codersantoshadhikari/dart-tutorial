---
title: "Numbers in Dart: int, double and num"
linkTitle: "Numbers"
description: "Work with int, double and num in Dart: arithmetic, integer division, rounding, parsing text into numbers and the dart:math library."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart numbers"
  - "dart int"
  - "dart double"
  - "dart num"
  - "dart math"
  - "integer division"
---

Dart has two number types. `int` holds whole numbers and `double` holds numbers with a fractional part. Both are kinds of `num`.

## Arithmetic

```dart
void main() {
  var a = 17;
  var b = 5;

  print(a + b);  // addition
  print(a - b);  // subtraction
  print(a * b);  // multiplication
  print(a / b);  // division, always a double
  print(a ~/ b); // integer division
  print(a % b);  // remainder
}
```

```output
22
12
85
3.4
3
2
```

The `/` operator always returns a `double`, even for `10 / 2`, which gives `5.0`. Use `~/` when you want a whole number.

## int and double do not mix silently

```dart
void main() {
  int whole = 7;
  double asDouble = whole.toDouble();
  int back = 7.9.toInt(); // cuts off the fraction

  print(asDouble);
  print(back);

  double price = 10; // an int literal is allowed where a double is expected
  print(price);
}
```

```output
7.0
7
10.0
```

## Rounding

```dart
void main() {
  var n = 3.14159;

  print(n.round());            // nearest whole number
  print(n.floor());            // round down
  print(n.ceil());             // round up
  print(n.toStringAsFixed(2)); // text with 2 decimals
}
```

```output
3
3
4
3.14
```

## Useful properties and methods

```dart
void main() {
  print(8.isEven);
  print(8.isOdd);
  print((-12).abs());
  print(15.clamp(0, 10));
  print(2.5.isNegative);
}
```

```output
true
false
12
10
false
```

## Turning text into numbers

`parse` throws an error if the text is not a number. `tryParse` returns `null` instead, which is safer for anything typed by a user.

```dart
void main() {
  print(int.parse('42') + 1);
  print(double.parse('3.5') * 2);
  print(int.tryParse('forty'));
}
```

```output
43
7.0
null
```

## The dart:math library

```dart
import 'dart:math';

void main() {
  print(sqrt(81));
  print(pow(2, 10));
  print(max(4, 9));
  print(pi.toStringAsFixed(4));

  var dice = Random().nextInt(6) + 1; // 1 to 6
  print(dice >= 1 && dice <= 6);
}
```

```output
9.0
1024
9
3.1416
true
```

## Things to know

- Floating-point maths is not exact. `0.1 + 0.2` prints `0.30000000000000004`. Compare doubles with a small tolerance, and store money as whole cents.
- On phones, desktops and servers an `int` is a 64-bit value. In a browser, numbers follow JavaScript rules, so very large integers lose precision.
- You can write big numbers with underscores for readability: `1_000_000`.
- DartPad runs your code as JavaScript, where a double with no fraction prints without the `.0`. There `10 / 2` shows `5`, while `dart run` on your computer shows `5.0`. The value is the same.

## Try it yourself

Write a program that converts 500 minutes into hours and remaining minutes using `~/` and `%`. It should print `8 hours 20 minutes`.
