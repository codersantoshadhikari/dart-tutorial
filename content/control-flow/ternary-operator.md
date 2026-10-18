---
title: "The Ternary Operator in Dart (condition ? a : b)"
linkTitle: "Ternary operator"
description: "Use Dart's ternary operator to choose between two values in a single expression, and know when an if statement reads better."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart ternary operator"
  - "conditional expression"
  - "dart question mark colon"
aliases:
  - "/dart-conditions-and-loops/ternary-operator-in-dart/"
  - "/fr/dart-conditions-and-loops/ternary-operator-in-dart/"
---

The ternary operator is a compact `if`/`else` that produces a **value**.

```text
condition ? valueIfTrue : valueIfFalse
```

## Basic use

```dart
void main() {
  var age = 17;
  var status = age >= 18 ? 'adult' : 'minor';
  print(status);
}
```

```output
minor
```

The same thing with `if` takes five lines and needs the variable declared first:

```dart
void main() {
  var age = 17;
  String status;
  if (age >= 18) {
    status = 'adult';
  } else {
    status = 'minor';
  }
  print(status);
}
```

## Inside other expressions

Because it is an expression, a ternary can sit anywhere a value can.

```dart
void main() {
  var items = 1;
  print('You have $items ${items == 1 ? 'item' : 'items'} in your cart.');

  var stock = 0;
  print(stock > 0 ? 'In stock' : 'Sold out');
}
```

```output
You have 1 item in your cart.
Sold out
```

## Chaining

You can chain ternaries to pick between more than two values. Lay each branch on its own line so it reads like a table.

```dart
void main() {
  var marks = 72;
  var grade = marks >= 80
      ? 'A'
      : marks >= 60
          ? 'B'
          : 'C';
  print(grade);
}
```

```output
B
```

With more than two or three branches, a [switch expression](/records-and-patterns/switch-expressions/) is clearer.

## Ternary or ?? for null checks

When the test is simply "is this null?", the `??` operator is shorter.

```dart
void main() {
  String? nickname;

  var a = nickname != null ? nickname : 'Guest'; // works
  var b = nickname ?? 'Guest';                   // better

  print('$a $b');
}
```

```output
Guest Guest
```

## When to use it

Use a ternary when you are **choosing a value** and both options are short. Use `if`/`else` when you are **doing things**, such as calling several functions in each branch. If you have to read a ternary twice to understand it, rewrite it as an `if`.

## Try it yourself

Given `var number = 7;`, use one ternary to print whether it is `even` or `odd`. Then extend it to print `zero` when the number is 0.
