---
title: "Arrow Functions in Dart (=> Syntax)"
linkTitle: "Arrow functions"
description: "Write short functions in Dart with the arrow syntax. Learn what => means, where it can be used and where a block body is needed."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart arrow function"
  - "fat arrow"
  - "expression body"
  - "dart => syntax"
---

When a function body is a single expression, Dart lets you replace the braces and `return` with `=>`.

## Block body and arrow body

These two functions are identical:

```dart
int doubleIt(int n) {
  return n * 2;
}

int doubleItShort(int n) => n * 2;

void main() {
  print(doubleIt(21));
  print(doubleItShort(21));
}
```

```output
42
42
```

Read `=> expression` as "returns this expression".

## More examples

```dart
bool isAdult(int age) => age >= 18;

String initials(String first, String last) => '${first[0]}${last[0]}';

double circleArea(double r) => 3.14159 * r * r;

void log(String message) => print('[LOG] $message');

void main() {
  print(isAdult(20));
  print(initials('Grace', 'Hopper'));
  print(circleArea(2));
  log('Started');
}
```

```output
true
GH
12.56636
[LOG] Started
```

`log` returns nothing, but `=>` is still allowed because `print(...)` is a single expression.

## One expression only

An arrow body cannot hold statements. No `if` statement, no `for` loop, no variable declarations. You can use anything that produces a value, such as a ternary or a switch expression.

```dart
String sign(int n) => n > 0 ? 'positive' : n < 0 ? 'negative' : 'zero';

String size(int cm) => switch (cm) {
      < 150 => 'short',
      < 180 => 'medium',
      _ => 'tall',
    };

void main() {
  print(sign(-4));
  print(size(172));
}
```

```output
negative
medium
```

## Arrows with collections

Arrow syntax is most common in small functions passed to other functions.

```dart
void main() {
  var prices = [120, 80, 300];

  var withTax = prices.map((p) => p * 1.13).toList();
  var cheap = prices.where((p) => p < 150).toList();

  print(withTax.map((p) => p.toStringAsFixed(1)).toList());
  print(cheap);
}
```

```output
[135.6, 90.4, 339.0]
[120, 80]
```

## Arrows in classes

Getters and short methods are usually written this way.

```dart
class Rectangle {
  final double width, height;
  Rectangle(this.width, this.height);

  double get area => width * height;
  bool get isSquare => width == height;
}

void main() {
  var r = Rectangle(4, 4);
  print('${r.area} ${r.isSquare}');
}
```

```output
16.0 true
```

## When not to use an arrow

If the expression runs past one line or needs a comment to be understood, switch to a block body. Shorter is only better while it is still easy to read.

## Try it yourself

Rewrite these as arrow functions: a function that returns the larger of two numbers, one that checks whether a string is longer than 8 characters, and one that returns the last element of a list.
