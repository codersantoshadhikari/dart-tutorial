---
title: "Operators in Dart: Arithmetic, Comparison, Logical and More"
linkTitle: "Operators"
description: "Every operator in Dart explained with examples: arithmetic, assignment, comparison, logical, type test, cascade and null-aware."
weight: 7
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart operators"
  - "cascade operator"
  - "dart increment"
  - "compound assignment"
  - "operator precedence"
---

An operator is a symbol that works on one or more values. You have already used `+` and `==`. This lesson collects all the common ones in one place.

## Arithmetic

| Operator | Meaning | `7 ? 2` |
| --- | --- | --- |
| `+` | Add | `9` |
| `-` | Subtract | `5` |
| `*` | Multiply | `14` |
| `/` | Divide | `3.5` |
| `~/` | Integer divide | `3` |
| `%` | Remainder | `1` |

## Assignment

```dart
void main() {
  var x = 10;
  x += 5;  // x = x + 5
  print(x);
  x -= 3;
  print(x);
  x *= 2;
  print(x);
  x ~/= 5;
  print(x);
}
```

```output
15
12
24
4
```

## Increment and decrement

`++` adds one and `--` subtracts one. Placed before the name, the change happens first. Placed after, the old value is used first.

```dart
void main() {
  var a = 5;
  print(a++); // prints 5, then a becomes 6
  print(++a); // a becomes 7, then prints 7
  print(a--); // prints 7, then a becomes 6
  print(a);
}
```

```output
5
7
7
6
```

## Comparison

All of these give a `bool`.

```dart
void main() {
  print(5 == 5);
  print(5 != 3);
  print(5 > 3);
  print(5 < 3);
  print(5 >= 5);
  print(5 <= 4);
}
```

```output
true
true
true
false
true
false
```

## Logical

`&&` (and), `||` (or) and `!` (not) are covered in [booleans](/dart-basics/booleans/).

## Type test and cast

```dart
void main() {
  Object value = 'hello';

  print(value is String);
  print(value is! int);

  var text = value as String; // cast: throws if the type is wrong
  print(text.length);
}
```

```output
true
true
5
```

Prefer `is` in an `if` over `as`. After an `is` check Dart treats the variable as that type automatically.

## Conditional operators

```dart
void main() {
  var age = 15;
  var label = age >= 18 ? 'adult' : 'minor';
  print(label);

  String? nickname;
  print(nickname ?? 'no nickname');
}
```

```output
minor
no nickname
```

The `? :` form is the [ternary operator](/control-flow/ternary-operator/). `??` and its relatives are explained in [null-aware operators](/null-safety/null-aware-operators/).

## The cascade operator

`..` lets you make several calls on the same object without repeating its name.

```dart
void main() {
  var numbers = <int>[]
    ..add(3)
    ..add(1)
    ..add(2)
    ..sort();

  print(numbers);
}
```

```output
[1, 2, 3]
```

## Precedence

Multiplication and division happen before addition and subtraction, and comparisons happen before `&&` and `||`. When in doubt, add brackets. They cost nothing and make the intent obvious.

```dart
void main() {
  print(2 + 3 * 4);
  print((2 + 3) * 4);
}
```

```output
14
20
```

## Try it yourself

Start with `var balance = 1000;`. Use compound assignment to add 250, take away 400, then double what is left. Print `true` if the final balance is more than 1500.
