---
title: "Loops in Dart: for, for-in, while and do-while"
seoTitle: "Dart Loops: for, for-in, while and do-while with Examples"
linkTitle: "Loops"
description: "Repeat code in Dart with for, for-in, while and do-while loops and forEach. Learn which loop to pick and how to avoid infinite loops."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart for loop"
  - "dart while loop"
  - "do while"
  - "for in"
  - "forEach"
  - "dart loops"
aliases:
  - "/dart-conditions-and-loops/loops-in-dart/"
  - "/fr/dart-conditions-and-loops/loops-in-dart/"
---

A loop runs the same block of code many times. Dart has four loop statements; which you choose depends on what you know before the loop starts.

## for: when you know how many times

```dart
void main() {
  for (var i = 1; i <= 5; i++) {
    print('Count: $i');
  }
}
```

```output
Count: 1
Count: 2
Count: 3
Count: 4
Count: 5
```

The three parts in the brackets are: **start** (`var i = 1`), **keep going while** (`i <= 5`) and **after each round** (`i++`).

## for-in: once for each item

This is the loop you will use most. It hands you each element of a collection in turn.

```dart
void main() {
  var fruits = ['apple', 'mango', 'kiwi'];

  for (final fruit in fruits) {
    print('I like $fruit');
  }
}
```

```output
I like apple
I like mango
I like kiwi
```

Need the position as well? Use `indexed`.

```dart
void main() {
  var fruits = ['apple', 'mango', 'kiwi'];

  for (final (index, fruit) in fruits.indexed) {
    print('${index + 1}. $fruit');
  }
}
```

```output
1. apple
2. mango
3. kiwi
```

## while: until a condition changes

A `while` loop checks the condition **before** each round. If it is false at the start, the body never runs.

```dart
void main() {
  var savings = 100;
  var months = 0;

  while (savings < 500) {
    savings += 150;
    months++;
  }
  print('Reached $savings after $months months');
}
```

```output
Reached 550 after 3 months
```

## do-while: at least once

A `do-while` loop checks the condition **after** each round, so the body always runs at least one time.

```dart
void main() {
  var attempts = 0;

  do {
    attempts++;
    print('Attempt $attempts');
  } while (attempts < 3);
}
```

```output
Attempt 1
Attempt 2
Attempt 3
```

## forEach

Collections have a `forEach` method that takes a function. It is fine for one-liners; for anything longer, `for-in` is easier to read and works with `break` and `await`.

```dart
void main() {
  [1, 2, 3].forEach(print);

  var prices = {'tea': 20, 'coffee': 50};
  prices.forEach((item, price) => print('$item costs $price'));
}
```

```output
1
2
3
tea costs 20
coffee costs 50
```

## Nested loops

```dart
void main() {
  for (var row = 1; row <= 3; row++) {
    var line = '';
    for (var col = 1; col <= 3; col++) {
      line += '${row * col}\t';
    }
    print(line);
  }
}
```

## Which loop should I use?

| Situation | Loop |
| --- | --- |
| Go through every item in a collection | `for-in` |
| Repeat a known number of times, or need a counter | `for` |
| Repeat until something changes | `while` |
| Must run once before checking | `do-while` |

## Avoiding infinite loops

A loop never ends if its condition never becomes false. The usual cause is forgetting to update the variable the condition depends on. Before running a `while` loop, check that something inside the body moves it towards the exit.

## Try it yourself

Print the multiplication table for 7 from `7 x 1 = 7` to `7 x 10 = 70`. Then use a `while` loop to find the first power of 2 that is greater than 1000.
