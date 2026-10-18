---
title: "Math and Random Numbers in Dart: dart:math, Random, Rounding"
seoTitle: "Dart Random Numbers and Math: dart:math Guide"
linkTitle: "Math and random numbers"
description: "Use dart:math in Dart: random numbers with Random, nextInt and Random.secure, shuffle, min, max, sqrt, pow, pi, and rounding with round, floor, ceil and clamp."
weight: 7
date: 2026-10-16
lastmod: 2026-10-16
keywords:
  - "dart random number"
  - "dart math"
  - "dart:math"
  - "dart random nextInt"
  - "dart round double"
  - "dart sqrt pow"
  - "dart toStringAsFixed"
faq:
  - q: "How do I get a random number between two values in Dart?"
    a: "Use Random().nextInt(max - min + 1) + min. For example, a number from 1 to 6 is Random().nextInt(6) + 1. nextInt(n) returns 0 up to n - 1."
  - q: "How do I round a double to 2 decimal places in Dart?"
    a: "To show it, use value.toStringAsFixed(2), which returns a String. To get a rounded number, use (value * 100).round() / 100."
---

Dart's basic number operators (`+ - * / ~/ %`) are always available. For square roots, powers, trigonometry, `min` / `max` and random numbers, import the **`dart:math`** library:

```dart
import 'dart:math';
```

## Random numbers

```dart
import 'dart:math';

void main() {
  final random = Random();

  final dice = random.nextInt(6) + 1;  // 1 to 6
  final chance = random.nextDouble();  // 0.0 up to (not including) 1.0
  final coin = random.nextBool();      // true or false

  print('dice: $dice');
  print('chance below 1: ${chance < 1}');
  print('coin: ${coin ? 'heads' : 'tails'}');
}
```

```output
dice: 4
chance below 1: true
coin: heads
```

Your numbers will be different each time you press **Run**.

| Method | Returns |
| --- | --- |
| `nextInt(max)` | An `int` from `0` to `max - 1` (`max` must be at least 1) |
| `nextDouble()` | A `double` from `0.0` up to, but not including, `1.0` |
| `nextBool()` | `true` or `false` |

### A random number in a range

```dart
import 'dart:math';

final _random = Random();

/// A random int from [min] to [max], both included.
int randomBetween(int min, int max) => min + _random.nextInt(max - min + 1);

void main() {
  print(randomBetween(10, 20));
  print(randomBetween(-5, 5));
}
```

Create one `Random` object and reuse it, as above, instead of making a new one for every number.

### Random item and shuffle

```dart
import 'dart:math';

void main() {
  final random = Random();
  final colours = ['red', 'green', 'blue', 'yellow'];

  final pick = colours[random.nextInt(colours.length)];
  print('picked: $pick');

  final deck = [1, 2, 3, 4, 5]..shuffle(random);
  print('shuffled: $deck');
}
```

`shuffle` changes the list in place. Copy it first with `[...list]` if you need the original order too.

### Repeatable random numbers with a seed

Give `Random` a **seed** and it produces the same sequence every time. That is useful for tests and games with a "daily level".

```dart
import 'dart:math';

void main() {
  final a = Random(42);
  final b = Random(42);
  print(a.nextInt(100) == b.nextInt(100));
}
```

```output
true
```

### Secure random numbers

For passwords, tokens and anything security related, use **`Random.secure()`**, which uses the operating system's cryptographic generator:

```dart
import 'dart:math';

String randomCode(int length) {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final rng = Random.secure();
  return List.generate(length, (_) => chars[rng.nextInt(chars.length)]).join();
}

void main() => print(randomCode(8));
```

## min, max, sqrt, pow and constants

```dart
import 'dart:math';

void main() {
  print(max(3, 9));      // 9
  print(min(3, 9));      // 3
  print(sqrt(16));       // 4.0
  print(pow(2, 10));     // 1024
  print(pi.toStringAsFixed(5));
  print(e.toStringAsFixed(3));

  // Circle area and the hypotenuse of a triangle
  const r = 2.0;
  print((pi * r * r).toStringAsFixed(2));
  print(sqrt(pow(3, 2) + pow(4, 2)));
}
```

```output
9
3
4.0
1024
3.14159
2.718
12.57
5.0
```

`pow` returns a `num`. Use `pow(2, 10).toInt()` when you need an `int`. Trigonometry functions (`sin`, `cos`, `tan`, `atan2`) take **radians**: convert with `degrees * pi / 180`.

The largest and smallest value in a list:

```dart
import 'dart:math';

void main() {
  final scores = [72, 95, 64, 88];
  print(scores.reduce(max));
  print(scores.reduce(min));
}
```

```output
95
64
```

## Rounding numbers

These methods are built into `double` and need no import.

```dart
void main() {
  const price = 7.456;

  print(price.round());          // 7   nearest int
  print(price.floor());          // 7   down
  print(price.ceil());           // 8   up
  print(price.truncate());       // 7   drop the decimals
  print(price.toStringAsFixed(2)); // 7.46  a String for display
  print((price * 100).round() / 100); // 7.46  a double

  print((-2.5).round());         // -3  halves round away from zero
  print(12.clamp(0, 10));        // 10  keep a value inside a range
  print((-3).abs());             // 3
}
```

```output
7
7
8
7
7.46
7.46
-3
10
3
```

**Money tip:** `double` cannot store some decimals exactly (`0.1 + 0.2` is `0.30000000000000004`). For prices, store whole cents in an `int` (`745` for 7.45) and only format with decimals when you display them.

## Formatting numbers

```dart
void main() {
  const n = 1234567.891;

  print(n.toStringAsFixed(1));      // 1234567.9
  print(255.toRadixString(16));     // ff  (hexadecimal)
  print(5.toString().padLeft(3, '0')); // 005
  print(int.parse('ff', radix: 16));  // 255
}
```

```output
1234567.9
ff
005
255
```

For thousands separators and currency (`1,234,567.89`, `€1.234,57`, `₹12,34,567`), use `NumberFormat` from the [`intl`](https://pub.dev/packages/intl) package.

## Practice: a number guessing game

```dart
import 'dart:math';

void main() {
  final secret = Random().nextInt(100) + 1;
  final guesses = [50, 25, 37, 43, 40, 41, 42];

  for (final guess in guesses) {
    if (guess == secret) {
      print('$guess is right!');
      return;
    }
    print(guess < secret ? '$guess is too low' : '$guess is too high');
  }
  print('The number was $secret');
}
```

Make it interactive in a terminal by reading guesses with `stdin.readLineSync()`, as shown in [user input](/dart-basics/user-input/). More number basics: [numbers in Dart](/dart-basics/numbers/) and [operators](/dart-basics/operators/).
