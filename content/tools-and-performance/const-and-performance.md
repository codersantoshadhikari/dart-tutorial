---
title: "const and Performance in Dart: Compile-Time Constants"
linkTitle: "const and performance"
description: "Learn how const objects and compile-time constants improve Dart performance and memory use, and when const is and is not possible."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart const performance"
  - "compile time constant"
  - "canonicalization"
  - "const widgets flutter"
  - "const vs final performance"
aliases:
  - "/memory-management--performance/const-objects-and-compile-time-constants/"
  - "/fr/memory-management--performance/const-objects-and-compile-time-constants/"
---

You have met `const` already as a way to say "this value is fixed". It is also a performance tool. A constant is built once by the compiler, stored in the program itself, and never allocated or garbage collected while the app runs.

## What makes something a compile-time constant

The compiler must be able to work out the complete value before the program starts.

```dart
const maxRetries = 3;                       // a literal
const timeout = Duration(seconds: 30);      // a const constructor
const sizes = [8, 16, 24];                  // a const collection
const greeting = 'Hello ' 'world';          // joined literals
const area = 12 * 12;                       // arithmetic on constants
const isBig = area > 100;                   // comparisons on constants
const label = isBig ? 'big' : 'small';      // conditional on constants

void main() {
  print('$maxRetries ${timeout.inSeconds} $sizes $greeting $area $label');
}
```

```output
3 30 [8, 16, 24] Hello world 144 big
```

Not allowed in a constant: anything only known at run time, such as `DateTime.now()`, user input, the result of a normal function call, or a non-const variable.

## Benefit 1: one shared instance

Equal constants are **canonicalized**: the compiler keeps a single copy.

```dart
class Colour {
  final int r, g, b;
  const Colour(this.r, this.g, this.b);
}

void main() {
  final a = const Colour(11, 95, 217);
  final b = const Colour(11, 95, 217);
  final c = Colour(11, 95, 217);

  print(identical(a, b)); // one object, used twice
  print(identical(a, c)); // c was allocated at run time
}
```

```output
true
false
```

Use a constant in a thousand places and there is still one object in memory.

## Benefit 2: no allocation, no garbage

A non-const object created inside a function is allocated every time the function runs, and must later be collected. A const one already exists.

```dart
class Padding {
  final double all;
  const Padding(this.all);
}

Padding runtime() => Padding(8);       // a new object on every call
Padding compileTime() => const Padding(8); // the same object every time

void main() {
  print(identical(runtime(), runtime()));
  print(identical(compileTime(), compileTime()));
}
```

```output
false
true
```

## Benefit 3: Flutter can skip work

This is where `const` matters most. When Flutter rebuilds a screen it compares each new widget with the old one. If they are the **identical** object, which is the case for a `const` widget, Flutter knows nothing changed and skips rebuilding that whole part of the tree.

```text
// Rebuilt and re-compared on every frame of an animation:
Padding(padding: EdgeInsets.all(8), child: Text('Total'))

// Created once, skipped during rebuilds:
const Padding(padding: EdgeInsets.all(8), child: Text('Total'))
```

Enable the `prefer_const_constructors` lint and let `dart fix --apply` add `const` wherever it is valid.

## Making your classes const-capable

```dart
class Money {
  final int cents;
  final String currency;

  const Money(this.cents, [this.currency = 'NPR']);
  const Money.zero() : this(0);

  // Initializer lists may use constant expressions only.
  const Money.fromRupees(int rupees)
      : cents = rupees * 100,
        currency = 'NPR';
}

void main() {
  const price = Money.fromRupees(250);
  print('${price.cents} ${price.currency}');
}
```

```output
25000 NPR
```

Requirements: every field is `final`, the constructor is marked `const` and has no body, and any superclass constructor it calls is `const` as well. Adding `const` to a constructor costs nothing and takes nothing away from callers who do not use it, so add it whenever the class allows.

## const collections

```dart
const supportedLocales = ['en', 'ne', 'hi'];
const defaultHeaders = {'Accept': 'application/json'};
const primes = {2, 3, 5, 7};

void main() {
  print(supportedLocales.contains('ne'));

  try {
    supportedLocales.add('fr');
  } on UnsupportedError {
    print('A const list cannot be modified');
  }
}
```

```output
true
A const list cannot be modified
```

Be careful: changing a const collection is not caught by the compiler. It fails when the program runs.

## const, final and static const

| Declaration | Value fixed at | One copy shared | Typical use |
| --- | --- | --- | --- |
| `const x = ...` | Compile time | Yes | Fixed values inside a function or at top level |
| `static const x = ...` | Compile time | Yes | Constants that belong to a class |
| `final x = ...` | Run time, once | No | Values computed once: `DateTime.now()`, parsed config |
| `static final x = ...` | Run time, on first use | One per class | Expensive values computed lazily |

Inside a class, a constant must be `static const`. An instance field can be `final` but not `const`.

## Where const does not help

- Values that depend on run-time data cannot be const. Do not twist your code to make them so.
- For numbers, strings and booleans, `const` and `final` perform the same. The gain comes from objects and collections.
- `const` is not a cure for a slow algorithm. Measure first. See [benchmarking](/tools-and-performance/benchmarking/).

## Practical rules

1. Mark constructors `const` whenever all the fields are `final`.
2. Write `const` at the call site whenever all the arguments are constants. Let the linter find the places.
3. Use `static const` for fixed values that belong to a class.
4. Use `final` for everything else that is assigned once.

## Try it yourself

Create a `Point` class with a `const` constructor. In a loop that runs a million times, create `Point(1, 2)` with and without `const`, counting how many distinct objects you get by adding them to an identity-based set (`Set.identity()`). Explain the two counts.
