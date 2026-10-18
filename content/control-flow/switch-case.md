---
title: "switch and case in Dart"
linkTitle: "switch and case"
description: "Learn the switch statement in Dart: matching values, shared cases, default, guards with when, and how Dart 3 removed the need for break."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart switch case"
  - "switch statement"
  - "dart default"
  - "switch when guard"
  - "dart 3 switch"
aliases:
  - "/dart-conditions-and-loops/switch-case-in-dart/"
  - "/fr/dart-conditions-and-loops/switch-case-in-dart/"
---

A `switch` compares one value against a list of cases and runs the first one that matches. It is tidier than a long `else if` chain when every branch tests the same value.

## A basic switch

```dart
void main() {
  var day = 3;

  switch (day) {
    case 1:
      print('Monday');
    case 2:
      print('Tuesday');
    case 3:
      print('Wednesday');
    default:
      print('Another day');
  }
}
```

```output
Wednesday
```

Since Dart 3, a case that contains code ends on its own. You do **not** need `break`, and one case never falls into the next.

## Several values, one result

An empty case shares the body of the case below it. You can also join values with `||`.

```dart
void main() {
  var day = 'sat';

  switch (day) {
    case 'sat':
    case 'sun':
      print('Weekend');
    case 'mon' || 'tue' || 'wed' || 'thu' || 'fri':
      print('Weekday');
    default:
      print('Not a day');
  }
}
```

```output
Weekend
```

## Ranges and comparisons

Cases are [patterns](/records-and-patterns/patterns/), so they can test more than equality.

```dart
void main() {
  var marks = 84;

  switch (marks) {
    case >= 90:
      print('A+');
    case >= 80:
      print('A');
    case >= 60 && < 80:
      print('B');
    default:
      print('C');
  }
}
```

```output
A
```

## Guards with when

Add `when` to attach an extra condition to a case.

```dart
void main() {
  var temperature = 35;
  var isRaining = false;

  switch (temperature) {
    case > 30 when isRaining:
      print('Hot and wet');
    case > 30:
      print('Hot and dry');
    default:
      print('Mild');
  }
}
```

```output
Hot and dry
```

## Switching on an enum

With an [enum](/object-oriented-programming/enums/), Dart checks that you handled every value. If you forget one, the code does not compile, so no `default` is needed.

```dart
enum Light { red, yellow, green }

void main() {
  var light = Light.yellow;

  switch (light) {
    case Light.red:
      print('Stop');
    case Light.yellow:
      print('Get ready');
    case Light.green:
      print('Go');
  }
}
```

```output
Get ready
```

## Switch as an expression

When each branch just produces a value, use the expression form. It is covered fully in [switch expressions](/records-and-patterns/switch-expressions/).

```dart
void main() {
  var code = 404;

  var message = switch (code) {
    200 => 'OK',
    404 => 'Not found',
    500 => 'Server error',
    _ => 'Unknown',
  };

  print(message);
}
```

```output
Not found
```

## Try it yourself

Write a switch on a month number (1 to 12) that prints how many days the month has. Group the months with 31 days into one case and the months with 30 into another.
