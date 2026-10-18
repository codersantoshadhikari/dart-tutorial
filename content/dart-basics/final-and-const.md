---
title: "final vs const in Dart: Values That Do Not Change"
linkTitle: "final and const"
description: "Learn the difference between final and const in Dart, when each is set, and why constant values make code safer and faster."
weight: 8
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart final"
  - "dart const"
  - "final vs const"
  - "compile-time constant"
  - "immutable"
---

Many values never change once they are set: a person's date of birth, the value of pi, the address of an API. Dart gives you two keywords to say so, and the compiler then stops anyone from changing them by accident.

## final: set once, at run time

A `final` variable can be assigned exactly one time. The value can be worked out while the program runs.

```dart
void main() {
  final name = 'Sita';
  final startedAt = DateTime.now(); // known only at run time

  // name = 'Gita'; // error: a final variable can only be set once
  print('$name started at ${startedAt.year}');
}
```

## const: fixed at compile time

A `const` value must be known before the program runs. It is baked into the compiled program.

```dart
void main() {
  const pi = 3.14159;
  const secondsPerDay = 60 * 60 * 24; // worked out by the compiler

  // const now = DateTime.now(); // error: not known at compile time
  print(pi);
  print(secondsPerDay);
}
```

```output
3.14159
86400
```

## Side by side

| | `var` | `final` | `const` |
| --- | --- | --- | --- |
| Can be reassigned | Yes | No | No |
| Value known at | Run time | Run time | Compile time |
| Contents can change | Yes | Yes | No |

## final protects the variable, const protects the value

This difference matters most with collections.

```dart
void main() {
  final scores = [90, 85];
  scores.add(70);      // allowed: the list itself can change
  // scores = [1, 2];  // error: the variable cannot point elsewhere
  print(scores);

  const days = ['Sat', 'Sun'];
  // days.add('Mon');  // throws at run time: a const list cannot change
  print(days);
}
```

```output
[90, 85, 70]
[Sat, Sun]
```

## Constant values are shared

Two identical `const` values are the same object in memory, which saves work. This is why Flutter code is full of `const`.

```dart
void main() {
  const a = [1, 2, 3];
  const b = [1, 2, 3];
  final c = [1, 2, 3];

  print(identical(a, b));
  print(identical(a, c));
}
```

```output
true
false
```

## Which should you use?

1. Reach for `const` when the value is known up front: fixed numbers, text and lists.
2. Use `final` for everything else that will not be reassigned. In well-written Dart this is most variables.
3. Use `var` only when the variable really does change, such as a counter.

In a class, a constant shared by all objects is written `static const`. See [static members](/object-oriented-programming/static-members/).

## Try it yourself

Declare `const maxAttempts = 3;` and `final userName = 'you';`. Try to reassign both and read the two error messages. Then make a `final` list, add to it, and explain to yourself why that is allowed.
