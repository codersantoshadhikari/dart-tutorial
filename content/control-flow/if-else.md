---
title: "if, else if and else in Dart"
linkTitle: "if and else"
description: "Learn conditional statements in Dart: if, else if, else, nested conditions and if-case, with clear examples and common mistakes."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart if else"
  - "conditional statements"
  - "dart else if"
  - "if case"
aliases:
  - "/dart-conditions-and-loops/conditional-statements/"
  - "/fr/dart-conditions-and-loops/conditional-statements/"
---

An `if` statement runs a block of code only when a condition is `true`.

## if

```dart
void main() {
  var temperature = 31;

  if (temperature > 30) {
    print('It is hot today.');
  }
}
```

```output
It is hot today.
```

## if and else

`else` runs when the condition is `false`. Exactly one of the two blocks runs.

```dart
void main() {
  var marks = 38;

  if (marks >= 40) {
    print('Pass');
  } else {
    print('Fail');
  }
}
```

```output
Fail
```

## else if

Chain as many checks as you need. Dart tests them from the top and runs the **first** one that is true, then skips the rest.

```dart
void main() {
  var marks = 76;

  if (marks >= 90) {
    print('Grade A+');
  } else if (marks >= 80) {
    print('Grade A');
  } else if (marks >= 60) {
    print('Grade B');
  } else {
    print('Grade C');
  }
}
```

```output
Grade B
```

Order matters. If you tested `marks >= 60` first, a score of 95 would be labelled Grade B.

## Combining conditions

```dart
void main() {
  var age = 25;
  var hasLicence = true;

  if (age >= 18 && hasLicence) {
    print('You may drive.');
  } else if (age >= 18) {
    print('You need a licence first.');
  } else {
    print('You are too young to drive.');
  }
}
```

```output
You may drive.
```

## Nested if, and how to avoid it

You can put an `if` inside another, but deep nesting is hard to read. Often you can flatten it by handling the "no" cases first and returning early.

```dart
String checkLogin(String user, String password) {
  if (user.isEmpty) return 'Enter a user name';
  if (password.length < 8) return 'Password is too short';
  return 'Welcome, $user';
}

void main() {
  print(checkLogin('', 'secret123'));
  print(checkLogin('rina', '123'));
  print(checkLogin('rina', 'secret123'));
}
```

```output
Enter a user name
Password is too short
Welcome, rina
```

## if-case: test a shape and take values out

Dart 3 lets an `if` match a [pattern](/records-and-patterns/patterns/). The block runs only if the value has the shape you describe.

```dart
void main() {
  var point = [3, 4];

  if (point case [var x, var y]) {
    print('x is $x and y is $y');
  }
}
```

```output
x is 3 and y is 4
```

## Common mistakes

- **Using `=` instead of `==`.** `=` assigns, `==` compares. Dart reports an error because an assignment is not a `bool`.
- **A stray semicolon.** `if (x > 5);` ends the statement right there, so the block below it always runs.
- **Skipping the braces.** A single statement works without `{ }`, but adding a second line later creates a bug. Use braces unless the whole `if` fits on one line.

## Try it yourself

Write a program with an `hour` variable from 0 to 23. Print "Good morning" before 12, "Good afternoon" before 17, "Good evening" before 21 and "Good night" otherwise.
