---
title: "Variables in Dart: var, Explicit Types and dynamic"
seoTitle: "Dart Variables: var, final, const, dynamic with Examples"
linkTitle: "Variables"
description: "Learn how to declare variables in Dart with var and explicit types, how type inference works, and the rules for naming them."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart variables"
  - "dart var"
  - "dart dynamic"
  - "type inference"
  - "dart naming"
aliases:
  - "/introduction/variables/"
  - "/fr/introduction/variables/"
---

A variable is a name that refers to a value. You create one, give it a value, and use the name wherever you need that value.

## Declaring a variable with var

```dart
void main() {
  var city = 'Kathmandu';
  var population = 1442000;
  var isCapital = true;

  print('$city, population $population, capital: $isCapital');
}
```

```output
Kathmandu, population 1442000, capital: true
```

`var` tells Dart to work out the type from the value. `city` is a `String`, `population` is an `int` and `isCapital` is a `bool`. This is called **type inference**.

## The type is fixed

Once Dart has decided the type, it stays. You can change the value, but only to another value of the same type.

```dart
void main() {
  var score = 10;
  score = 25;        // fine, still an int
  // score = 'high'; // error: a String can't be assigned to an int
  print(score);
}
```

```output
25
```

## Writing the type yourself

You can state the type instead of `var`. The result is identical; choose whichever reads better.

```dart
void main() {
  String name = 'Aarav';
  int age = 19;
  double height = 1.74;
  bool isStudent = true;

  print('$name, $age, $height m, student: $isStudent');
}
```

```output
Aarav, 19, 1.74 m, student: true
```

Dart style prefers `var` for local variables when the type is obvious from the value, and written types for function parameters and class fields.

## Declaring now, assigning later

If you do not give a value straight away, write the type so Dart knows what to expect. Dart will refuse to let you read the variable before it has a value.

```dart
void main() {
  String grade;
  var marks = 82;

  if (marks >= 80) {
    grade = 'A';
  } else {
    grade = 'B';
  }
  print(grade);
}
```

```output
A
```

## dynamic: switching type checks off

A `dynamic` variable can hold anything and change type at any time. Dart stops checking it for you, so mistakes only show up when the program runs. Use it rarely.

```dart
void main() {
  dynamic value = 42;
  print(value.runtimeType);
  value = 'now a string';
  print(value.runtimeType);
}
```

```output
int
String
```

## Naming rules

- Use `lowerCamelCase`: `firstName`, `totalPrice`, `isLoggedIn`.
- Names may contain letters, digits, `_` and `$`, and cannot start with a digit.
- Names are case sensitive: `total` and `Total` are different.
- You cannot use reserved words such as `class`, `if` or `return`.
- Choose names that say what the value means. `daysUntilExam` beats `d`.

## Try it yourself

Declare variables for a book: its title, number of pages, price and whether you have read it. Print them in one sentence. Then try assigning a number to the title and read the error message.
