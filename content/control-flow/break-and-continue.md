---
title: "break and continue in Dart"
linkTitle: "break and continue"
description: "Use break to leave a loop early and continue to skip one round. Includes labels for controlling nested loops in Dart."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart break"
  - "dart continue"
  - "loop labels"
  - "exit loop dart"
aliases:
  - "/dart-conditions-and-loops/break-and-continue-in-dart/"
  - "/fr/dart-conditions-and-loops/break-and-continue-in-dart/"
---

Sometimes you need to change the flow of a loop from the inside. `break` stops the loop completely. `continue` skips the rest of the current round and moves on to the next.

## break

```dart
void main() {
  var numbers = [4, 9, 15, 22, 8];

  for (final n in numbers) {
    if (n > 10) {
      print('First number over 10 is $n');
      break;
    }
    print('Checked $n');
  }
}
```

```output
Checked 4
Checked 9
First number over 10 is 15
```

Once the answer is found there is no reason to look at 22 and 8, so `break` saves the work.

## continue

```dart
void main() {
  for (var i = 1; i <= 6; i++) {
    if (i.isEven) continue; // skip even numbers
    print(i);
  }
}
```

```output
1
3
5
```

## break in a while (true) loop

A loop with the condition `true` runs until a `break`. This is a common way to write "keep going until done".

```dart
void main() {
  var total = 0;
  var n = 1;

  while (true) {
    total += n;
    if (total > 20) break;
    n++;
  }
  print('Stopped at n = $n with total $total');
}
```

```output
Stopped at n = 6 with total 21
```

## Nested loops and labels

`break` and `continue` only affect the loop they are written in. To control an outer loop, give it a label.

```dart
void main() {
  outer:
  for (var row = 1; row <= 3; row++) {
    for (var col = 1; col <= 3; col++) {
      if (col == 2 && row == 2) break outer; // leaves both loops
      print('row $row, col $col');
    }
  }
  print('Done');
}
```

```output
row 1, col 1
row 1, col 2
row 1, col 3
row 2, col 1
Done
```

`continue outer;` works the same way: it jumps to the next round of the labelled loop.

Labels are rarely needed. If you reach for one, consider moving the loops into a function and using `return` instead.

## A practical example

```dart
void main() {
  var entries = ['12', 'abc', '7', '', 'stop', '99'];
  var sum = 0;

  for (final entry in entries) {
    if (entry == 'stop') break;   // stop reading
    final value = int.tryParse(entry);
    if (value == null) continue;  // ignore bad input
    sum += value;
  }
  print('Sum: $sum');
}
```

```output
Sum: 19
```

## Things to remember

- `break` and `continue` do not work inside `forEach`. Use a `for-in` loop when you need them.
- In a `while` loop, make sure the counter is updated **before** `continue`, or the loop will never end.
- Since Dart 3 you do not need `break` at the end of a `switch` case.

## Try it yourself

Loop from 1 to 50. Skip every number divisible by 3, and stop completely at the first number divisible by both 5 and 7. Print the numbers you visit.
