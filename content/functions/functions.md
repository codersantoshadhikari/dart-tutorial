---
title: "Functions in Dart: Defining, Calling and Returning Values"
seoTitle: "Dart Functions with Examples: Define, Call and Return Values"
linkTitle: "Functions basics"
description: "Learn how to define and call functions in Dart, pass arguments, return values, and understand void, scope and local functions."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart functions"
  - "dart return"
  - "void function"
  - "define function dart"
  - "function scope"
aliases:
  - "/functions-in-dart/"
  - "/fr/functions-in-dart/"
  - "/introduction/functions/"
  - "/fr/introduction/functions/"
---

You have been using functions since the first lesson: `main` is one, and so is `print`. Now you will write your own.

## Defining and calling a function

```dart
void greet() {
  print('Hello!');
}

void main() {
  greet();
  greet();
}
```

```output
Hello!
Hello!
```

The definition says what the function does. Nothing happens until you **call** it by writing its name followed by brackets.

## Parameters: giving a function input

```dart
void greet(String name) {
  print('Hello, $name!');
}

void main() {
  greet('Anita');
  greet('Bishal');
}
```

```output
Hello, Anita!
Hello, Bishal!
```

`name` is a **parameter**: a variable that exists only inside the function. The values `'Anita'` and `'Bishal'` are **arguments**.

## Returning a value

A function can hand a result back with `return`. The type before the name says what kind of value comes back.

```dart
int add(int a, int b) {
  return a + b;
}

void main() {
  var sum = add(4, 6);
  print(sum);
  print(add(sum, 100));
}
```

```output
10
110
```

`return` also ends the function immediately. Any code after it does not run.

## void means "nothing comes back"

Use `void` when a function does a job, such as printing, and has no result to give.

```dart
void printLine() {
  print('-' * 20);
}

void main() {
  printLine();
  print('Report');
  printLine();
}
```

```output
--------------------
Report
--------------------
```

## The anatomy of a function

```text
returnType  name ( parameters )  { body }
   double   area (double r)      { return 3.14159 * r * r; }
```

Always write the return type and parameter types. Dart can work without them, but then it treats them as `dynamic` and stops checking your work.

## Scope: where a variable lives

A variable declared inside a function cannot be seen outside it.

```dart
int square(int n) {
  var result = n * n; // local to square
  return result;
}

void main() {
  print(square(9));
  // print(result); // error: result does not exist here
}
```

```output
81
```

## Functions inside functions

You can declare a helper inside another function when it is only needed there.

```dart
void main() {
  String shout(String text) => '${text.toUpperCase()}!';

  print(shout('well done'));
}
```

```output
WELL DONE!
```

## Why bother with functions?

- **Reuse.** Write the logic once and call it from anywhere.
- **Readability.** `calculateTax(price)` explains itself; ten lines of maths do not.
- **Testing.** A small function with clear input and output is easy to check.
- **Fixing.** A bug fixed in one function is fixed everywhere it is used.

A good function does one thing and has a name that says what that thing is. Name functions with a verb: `calculateTotal`, `sendEmail`, `isValid`.

## Try it yourself

Write `double celsiusToFahrenheit(double c)` and `bool isEven(int n)`. Call each from `main` with a few values and print the results.
