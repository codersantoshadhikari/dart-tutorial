---
title: "Booleans in Dart: true, false and Logical Operators"
linkTitle: "Booleans"
description: "Understand the bool type in Dart, comparison results, and how to combine conditions with the and, or and not operators."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart bool"
  - "dart boolean"
  - "logical operators"
  - "dart true false"
---

A `bool` has only two possible values: `true` and `false`. Booleans are how a program makes decisions.

## Where booleans come from

Most booleans are the result of a comparison.

```dart
void main() {
  var age = 20;

  bool isAdult = age >= 18;
  bool isTeen = age >= 13 && age <= 19;

  print(isAdult);
  print(isTeen);
}
```

```output
true
false
```

## Combining conditions

| Operator | Name | True when |
| --- | --- | --- |
| `&&` | and | both sides are true |
| `\|\|` | or | at least one side is true |
| `!` | not | the value is false |

```dart
void main() {
  var hasTicket = true;
  var hasId = false;
  var isVip = true;

  print(hasTicket && hasId);
  print(hasTicket || hasId);
  print(!hasId);
  print((hasTicket && hasId) || isVip);
}
```

```output
false
true
true
true
```

## Short-circuit evaluation

Dart stops as soon as it knows the answer. With `&&`, if the left side is false the right side never runs. With `||`, if the left side is true the right side never runs. This lets you guard a risky check.

```dart
void main() {
  var items = <int>[];

  // items.first would throw on an empty list, but it is never reached.
  if (items.isNotEmpty && items.first > 10) {
    print('Big first item');
  } else {
    print('Empty, or first item is small');
  }
}
```

```output
Empty, or first item is small
```

## Only bool works in a condition

Some languages treat `0`, `''` or `null` as false. Dart does not. A condition must be a real `bool`.

```dart
void main() {
  var name = '';
  var count = 0;

  // if (name) { }   // error: a String is not a bool
  // if (count) { }  // error: an int is not a bool

  if (name.isEmpty) print('No name given');
  if (count == 0) print('Nothing counted');
}
```

```output
No name given
Nothing counted
```

## Naming booleans

Start the name with `is`, `has`, `can` or `should` so the code reads like a sentence: `isLoggedIn`, `hasError`, `canEdit`.

## Try it yourself

A cinema lets you in if you are 16 or older, or if you are with an adult. Create `age` and `withAdult` variables and print whether entry is allowed. Test it with three different combinations.
