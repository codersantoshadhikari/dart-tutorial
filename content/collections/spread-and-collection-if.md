---
title: "Spread Operator, Collection if and Collection for in Dart"
linkTitle: "Spread, if and for"
description: "Build lists, sets and maps in Dart using the spread operator (...), null-aware spread, collection if and collection for."
weight: 9
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart spread operator"
  - "collection if"
  - "collection for"
  - "null-aware spread"
  - "combine lists dart"
aliases:
  - "/dart-collections/spread-operator-and-collection-if/"
  - "/fr/dart-collections/spread-operator-and-collection-if/"
---

Dart lets you put a little logic directly inside a collection literal. These three features are small, but they are used on almost every screen of a Flutter app.

## The spread operator

`...` unpacks one collection into another.

```dart
void main() {
  var fruits = ['apple', 'banana'];
  var vegetables = ['carrot', 'spinach'];

  var basket = ['bread', ...fruits, ...vegetables, 'milk'];
  print(basket);
}
```

```output
[bread, apple, banana, carrot, spinach, milk]
```

Without the dots you would get a list **inside** a list.

It is also the simplest way to copy a list.

```dart
void main() {
  var original = [1, 2, 3];
  var copy = [...original];

  copy.add(4);
  print(original);
  print(copy);
}
```

```output
[1, 2, 3]
[1, 2, 3, 4]
```

## Spreading sets and maps

```dart
void main() {
  var a = {1, 2, 3};
  var b = {3, 4};
  print({...a, ...b});

  var defaults = {'theme': 'light', 'fontSize': 14};
  var userSettings = {'theme': 'dark'};
  print({...defaults, ...userSettings}); // later keys win
}
```

```output
{1, 2, 3, 4}
{theme: dark, fontSize: 14}
```

## Null-aware spread

If the collection might be `null`, use `...?`. It adds nothing when the value is null.

```dart
void main() {
  List<String>? extras;

  var menu = ['tea', 'coffee', ...?extras];
  print(menu);
}
```

```output
[tea, coffee]
```

## Collection if

Include an item only when a condition is true.

```dart
void main() {
  var isAdmin = false;
  var isLoggedIn = true;

  var menu = [
    'Home',
    if (isLoggedIn) 'Profile',
    if (isAdmin) 'Admin panel',
    if (isLoggedIn) 'Log out' else 'Log in',
  ];
  print(menu);
}
```

```output
[Home, Profile, Log out]
```

## Collection for

Generate items with a loop, right inside the literal.

```dart
void main() {
  var numbers = [1, 2, 3];

  var squares = [for (final n in numbers) n * n];
  var labels = [for (var i = 1; i <= 3; i++) 'Item $i'];
  var lookup = {for (final n in numbers) n: 'number $n'};

  print(squares);
  print(labels);
  print(lookup);
}
```

```output
[1, 4, 9]
[Item 1, Item 2, Item 3]
{1: number 1, 2: number 2, 3: number 3}
```

## Combining them

`if` and `for` can be nested, and a spread can follow either. This replaces a `where` plus a `map`.

```dart
void main() {
  var scores = {'Anu': 82, 'Bikash': 37, 'Chhiring': 94};
  var showHeader = true;

  var lines = [
    if (showHeader) ...['RESULTS', '-------'],
    for (final MapEntry(:key, :value) in scores.entries)
      if (value >= 40) '$key passed with $value',
  ];

  lines.forEach(print);
}
```

```output
RESULTS
-------
Anu passed with 82
Chhiring passed with 94
```

## Why Flutter developers love this

A Flutter screen is a tree of nested lists. Being able to write "show this widget only if the user is logged in" inline keeps the layout readable.

```text
children: [
  Header(),
  if (user != null) Avatar(user),
  for (final post in posts) PostCard(post),
]
```

## Try it yourself

You have `var base = ['rice', 'dal'];`, a nullable `List<String>? sides` and a `bool wantsDessert`. Build one list literal that contains the base items, the sides if there are any, and `'kheer'` only when dessert is wanted.
