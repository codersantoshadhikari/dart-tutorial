---
title: "Switch Expressions in Dart 3"
linkTitle: "Switch expressions"
description: "Learn switch expressions in Dart: return a value from switch, match patterns and records, use guards, and get exhaustiveness checking."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart switch expression"
  - "dart 3 switch"
  - "exhaustive switch"
  - "pattern switch"
  - "switch arrow"
---

A switch **statement** runs code. A switch **expression** produces a value. It is shorter, has no `case` or `break`, and can be used anywhere a value is expected.

## From statement to expression

```dart
enum Level { low, medium, high }

String colourStatement(Level level) {
  switch (level) {
    case Level.low:
      return 'green';
    case Level.medium:
      return 'orange';
    case Level.high:
      return 'red';
  }
}

String colourExpression(Level level) => switch (level) {
      Level.low => 'green',
      Level.medium => 'orange',
      Level.high => 'red',
    };

void main() {
  print(colourStatement(Level.high));
  print(colourExpression(Level.medium));
}
```

```output
red
orange
```

## The syntax

```text
var result = switch (value) {
  pattern1 => expression1,
  pattern2 => expression2,
  _ => defaultExpression,
};
```

- Each case is `pattern => expression`, separated by commas.
- `_` is the wildcard that matches anything, like `default`.
- When assigned to a variable, the whole thing ends with a semicolon.

## Matching values, ranges and alternatives

```dart
String describeMark(int mark) => switch (mark) {
      100 => 'Perfect',
      >= 90 => 'Excellent',
      >= 60 && < 90 => 'Good',
      40 || 41 || 42 => 'Just passed',
      < 40 => 'Failed',
      _ => 'Passed',
    };

void main() {
  for (final m in [100, 95, 70, 41, 20, 50]) {
    print('$m: ${describeMark(m)}');
  }
}
```

```output
100: Perfect
95: Excellent
70: Good
41: Just passed
20: Failed
50: Passed
```

Cases are tried from top to bottom, and the first match wins.

## Switching on more than one value

Put the values in a record and match them together. This replaces tangled nested `if`s.

```dart
String rockPaperScissors(String a, String b) => switch ((a, b)) {
      (var x, var y) when x == y => 'Draw',
      ('rock', 'scissors') || ('scissors', 'paper') || ('paper', 'rock') => 'A wins',
      _ => 'B wins',
    };

String fizzBuzz(int n) => switch ((n % 3, n % 5)) {
      (0, 0) => 'FizzBuzz',
      (0, _) => 'Fizz',
      (_, 0) => 'Buzz',
      _ => '$n',
    };

void main() {
  print(rockPaperScissors('rock', 'scissors'));
  print(rockPaperScissors('paper', 'scissors'));
  print([for (var i = 1; i <= 15; i++) fizzBuzz(i)].join(' '));
}
```

```output
A wins
B wins
1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz
```

## Matching on type and structure

```dart
String describe(Object? value) => switch (value) {
      null => 'nothing',
      int n when n < 0 => 'a negative int',
      int n => 'the int $n',
      String s => 'text of length ${s.length}',
      [] => 'an empty list',
      [var only] => 'a list with just $only',
      [var first, ...] => 'a list starting with $first',
      (var a, var b) => 'a pair: $a and $b',
      _ => 'something else',
    };

void main() {
  print(describe(null));
  print(describe(-3));
  print(describe('dart'));
  print(describe([7]));
  print(describe([1, 2, 3]));
  print(describe(('x', 'y')));
}
```

```output
nothing
a negative int
text of length 4
a list with just 7
a list starting with 1
a pair: x and y
```

## Exhaustiveness

A switch expression must be able to produce a value for **every** possible input. For enums, `bool`, and [sealed classes](/records-and-patterns/sealed-classes/), Dart knows the complete list of possibilities and tells you if you missed one.

```dart
enum Status { active, paused, closed }

String label(Status s) => switch (s) {
      Status.active => 'Running',
      Status.paused => 'On hold',
      // Remove the next line and the code will not compile.
      Status.closed => 'Finished',
    };

void main() => print(label(Status.paused));
```

```output
On hold
```

When you have covered every case, **leave out the `_` wildcard**. Then, if someone adds a new enum value later, the compiler points to every switch that needs updating. A wildcard would hide the gap.

## Using it inline

Because it is an expression, it can go inside string interpolation, arguments and collection literals.

```dart
void main() {
  var items = 3;
  print('You have ${switch (items) { 0 => 'no items', 1 => 'one item', _ => '$items items' }}.');
}
```

```output
You have 3 items.
```

## Statement or expression?

Use the **expression** when every branch simply yields a value. Use the **statement** when branches run several lines of code, or perform actions such as printing or saving.

## Try it yourself

Write `String season(int month)` using a switch expression with `||` patterns. Then write `double shippingCost(String country, double weightKg)` that switches on the record `(country, weightKg)` with guards for different weight bands.
