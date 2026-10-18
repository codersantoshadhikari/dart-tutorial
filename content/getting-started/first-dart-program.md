---
title: "Your First Dart Program: Hello World Explained"
seoTitle: "Dart Hello World: Your First Dart Program Explained"
linkTitle: "Your first program"
description: "Write Hello World in Dart and understand every part of it: the main function, print, statements, semicolons and how to run the file."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart hello world"
  - "dart main function"
  - "dart print"
  - "basic dart program"
aliases:
  - "/introduction/basic-program/"
  - "/fr/introduction/basic-program/"
---

Every Dart program, from a five-line script to a full mobile app, starts running at the same place: a function called `main`.

## Hello, world

Create a file named `hello.dart` and type this in:

```dart
void main() {
  print('Hello, world!');
}
```

Run it from the terminal with `dart run hello.dart`, or press **Run** above.

```output
Hello, world!
```

## Reading the program piece by piece

| Part | Meaning |
| --- | --- |
| `void` | The function gives nothing back when it finishes |
| `main` | The special name Dart looks for to start the program |
| `()` | The function takes no input here |
| `{ ... }` | The body: the statements that run, top to bottom |
| `print(...)` | A built-in function that writes a line to the console |
| `'Hello, world!'` | A string, which is a piece of text |
| `;` | Ends a statement. Dart requires it |

## Statements run in order

```dart
void main() {
  print('Step 1: boil water');
  print('Step 2: add tea');
  print('Step 3: wait three minutes');
}
```

```output
Step 1: boil water
Step 2: add tea
Step 3: wait three minutes
```

## Printing values, not just text

`print` accepts any value. Put a `$` in front of a variable name inside a string to drop its value in. Use `${...}` for a calculation.

```dart
void main() {
  var name = 'Maya';
  var age = 21;

  print(name);
  print(age);
  print('$name is $age years old.');
  print('Next year she will be ${age + 1}.');
}
```

```output
Maya
21
Maya is 21 years old.
Next year she will be 22.
```

## A shorter main

When a function body is a single expression, you can write it with an arrow.

```dart
void main() => print('Hello, world!');
```

## Reading command-line arguments

`main` can receive the words typed after the file name.

```dart
void main(List<String> args) {
  print('You passed ${args.length} argument(s): $args');
}
```

Running `dart run hello.dart red blue` prints `You passed 2 argument(s): [red, blue]`.

## Common mistakes

- **Forgetting the semicolon.** `print('hi')` without `;` is an error.
- **Wrong capital letters.** Dart is case sensitive. `Print` and `Main` do not exist.
- **Mismatched quotes.** A string that starts with `'` must end with `'`.
- **Code outside a function.** Statements such as `print(...)` must be inside `main` or another function.

## Try it yourself

Write a program that prints your name, your city and your favourite food on three separate lines. Then change it so all three appear in a single sentence using `$` interpolation.
