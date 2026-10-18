---
title: "Anonymous Functions and Closures in Dart"
linkTitle: "Anonymous functions and closures"
description: "Understand anonymous functions (lambdas) in Dart, how to store functions in variables, and how closures remember values."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart anonymous function"
  - "dart lambda"
  - "dart closure"
  - "function as variable"
---

In Dart a function is a value, like a number or a string. You can store it in a variable, put it in a list or pass it to another function. A function written without a name is called an **anonymous function**, or lambda.

## Writing an anonymous function

Take a normal function, remove the name, and you have one.

```dart
void main() {
  var numbers = [1, 2, 3];

  numbers.forEach((n) {
    print(n * 10);
  });
}
```

```output
10
20
30
```

`(n) { print(n * 10); }` has parameters and a body but no name. It is created right where it is needed.

## Storing a function in a variable

```dart
void main() {
  var square = (int n) => n * n;
  int Function(int, int) add = (a, b) => a + b;

  print(square(6));
  print(add(2, 3));
}
```

```output
36
5
```

`int Function(int, int)` is a **function type**: a function that takes two ints and returns an int.

## Passing a named function by name

You do not have to wrap an existing function in a lambda. Leave off the brackets and you pass the function itself. This is called a tear-off.

```dart
bool isLong(String word) => word.length > 4;

void main() {
  var words = ['tea', 'coffee', 'milk', 'water'];

  print(words.where(isLong).toList());
  words.forEach(print);
}
```

```output
[coffee, water]
tea
coffee
milk
water
```

## Closures

A closure is a function that remembers the variables around it, even after the code that created those variables has finished.

```dart
Function makeCounter() {
  var count = 0;
  return () {
    count++;
    return count;
  };
}

void main() {
  var counterA = makeCounter();
  var counterB = makeCounter();

  print(counterA());
  print(counterA());
  print(counterA());
  print(counterB()); // has its own separate count
}
```

```output
1
2
3
1
```

`count` is a local variable of `makeCounter`, yet it survives because the returned function still uses it. Each call to `makeCounter` creates a fresh `count`.

## A closure that captures a parameter

```dart
int Function(int) multiplyBy(int factor) {
  return (int value) => value * factor;
}

void main() {
  var triple = multiplyBy(3);
  var tenTimes = multiplyBy(10);

  print(triple(7));
  print(tenTimes(7));
}
```

```output
21
70
```

## Where you will see this

- Collection methods: `list.map((x) => ...)`, `list.where((x) => ...)`.
- Event handlers in Flutter: `onPressed: () { ... }`.
- Callbacks for asynchronous work: `future.then((value) => ...)`.
- Sorting: `list.sort((a, b) => a.compareTo(b))`.

## Try it yourself

Write `Function makeGreeter(String greeting)` that returns a function taking a name. `makeGreeter('Namaste')('Asha')` should return `Namaste, Asha!`. Create two greeters with different greetings and call each.
