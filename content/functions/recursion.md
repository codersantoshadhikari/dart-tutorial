---
title: "Recursion in Dart: Functions That Call Themselves"
linkTitle: "Recursion"
description: "Learn recursion in Dart with factorial, Fibonacci and sum examples. Understand base cases, the call stack and when to use a loop instead."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart recursion"
  - "recursive function"
  - "factorial dart"
  - "fibonacci dart"
  - "base case"
---

A recursive function is one that calls itself. It solves a problem by breaking it into a smaller version of the same problem, until the problem is small enough to answer directly.

## The two parts of every recursive function

1. **Base case**: the simple situation where the function returns an answer without calling itself.
2. **Recursive case**: the function calls itself with a smaller input, moving towards the base case.

Leave out the base case and the function calls itself forever until the program crashes with a stack overflow.

## Counting down

```dart
void countdown(int n) {
  if (n == 0) {        // base case
    print('Lift off!');
    return;
  }
  print(n);
  countdown(n - 1);    // recursive case
}

void main() {
  countdown(3);
}
```

```output
3
2
1
Lift off!
```

## Factorial

The factorial of 5 is `5 * 4 * 3 * 2 * 1`. Notice that it is also `5 * factorial(4)`.

```dart
int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

void main() {
  print(factorial(5));
}
```

```output
120
```

How the calls unfold:

```text
factorial(5)
= 5 * factorial(4)
= 5 * 4 * factorial(3)
= 5 * 4 * 3 * factorial(2)
= 5 * 4 * 3 * 2 * factorial(1)
= 5 * 4 * 3 * 2 * 1
= 120
```

## Sum of a list

```dart
int sum(List<int> numbers) {
  if (numbers.isEmpty) return 0;
  return numbers.first + sum(numbers.sublist(1));
}

void main() {
  print(sum([4, 8, 15, 16]));
}
```

```output
43
```

## Fibonacci, and a warning

Each Fibonacci number is the sum of the two before it.

```dart
int fib(int n) {
  if (n < 2) return n;
  return fib(n - 1) + fib(n - 2);
}

void main() {
  for (var i = 0; i < 10; i++) {
    print(fib(i));
  }
}
```

This version is elegant but slow, because it recalculates the same values again and again. `fib(40)` makes hundreds of millions of calls. Remembering earlier answers (memoization) fixes it:

```dart
final _cache = <int, int>{};

int fib(int n) {
  if (n < 2) return n;
  return _cache[n] ??= fib(n - 1) + fib(n - 2);
}

void main() {
  print(fib(50));
}
```

```output
12586269025
```

## Recursion or a loop?

Anything written with recursion can be written with a loop, and the loop usually uses less memory because every unfinished call takes space on the call stack.

Use recursion when the **data itself is nested**: folders inside folders, comments with replies, a family tree, JSON inside JSON. For those, recursive code is far shorter and clearer.

```dart
int countFiles(Map<String, Object> folder) {
  var total = 0;
  for (final item in folder.values) {
    if (item is Map<String, Object>) {
      total += countFiles(item); // a sub-folder
    } else {
      total++;                   // a file
    }
  }
  return total;
}

void main() {
  final disk = <String, Object>{
    'notes.txt': 1,
    'photos': <String, Object>{'a.jpg': 1, 'b.jpg': 1},
    'work': <String, Object>{
      'cv.pdf': 1,
      'old': <String, Object>{'cv_v1.pdf': 1},
    },
  };
  print(countFiles(disk));
}
```

```output
5
```

## Try it yourself

Write a recursive `int power(int base, int exponent)` and a recursive `String reverse(String text)`. For each, say out loud what the base case is before you write it.
