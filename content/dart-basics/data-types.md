---
title: "Data Types in Dart: A Complete Overview"
seoTitle: "Dart Data Types with Examples: int, double, String, bool, List, Map"
linkTitle: "Data types"
description: "A tour of Dart's built-in data types: int, double, String, bool, List, Set, Map, Record, Null, Object and dynamic, with examples."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart data types"
  - "dart types"
  - "int double string bool"
  - "runtimeType"
aliases:
  - "/introduction/datatypes/"
  - "/fr/introduction/datatypes/"
---

Every value in Dart has a type, and the type decides what you can do with the value. You can add two numbers, but you cannot add a number to a `true`.

## The built-in types

| Type | Holds | Example |
| --- | --- | --- |
| `int` | Whole numbers | `42`, `-7` |
| `double` | Numbers with a decimal point | `3.14`, `-0.5` |
| `num` | Either an `int` or a `double` | `42`, `3.14` |
| `String` | Text | `'hello'` |
| `bool` | True or false | `true`, `false` |
| `List` | An ordered group of values | `[1, 2, 3]` |
| `Set` | A group of unique values | `{1, 2, 3}` |
| `Map` | Key and value pairs | `{'a': 1}` |
| `Record` | A fixed bundle of values | `('Ana', 30)` |
| `Null` | The single value `null` | `null` |

## Seeing the types in action

```dart
void main() {
  int apples = 12;
  double price = 4.5;
  String fruit = 'apple';
  bool inStock = true;
  List<String> colours = ['red', 'green'];
  Set<int> sizes = {1, 2, 3};
  Map<String, double> prices = {'apple': 4.5, 'pear': 6.0};
  (String, int) pair = ('apple', 12);

  print(apples.runtimeType);
  print(price.runtimeType);
  print(fruit.runtimeType);
  print(inStock.runtimeType);
  print(colours.runtimeType);
  print(pair.runtimeType);
  print('$sizes $prices');
}
```

```output
int
double
String
bool
List<String>
(String, int)
{1, 2, 3} {apple: 4.5, pear: 6.0}
```

`runtimeType` tells you the type of a value while the program runs. It is handy for learning and debugging.

## Everything is an object

In Dart, numbers, strings, booleans and even functions are objects. That is why you can call methods directly on a value.

```dart
void main() {
  print(7.isEven);
  print(3.7.round());
  print('dart'.toUpperCase());
}
```

```output
false
4
DART
```

## Object and dynamic

`Object` is the parent of every non-null type. A variable typed `Object` can hold any value, but Dart only lets you use what all objects share until you check the real type.

```dart
void main() {
  Object thing = 'a string';

  if (thing is String) {
    // Inside this block Dart knows it is a String.
    print(thing.length);
  }
}
```

```output
8
```

`dynamic` also accepts anything, but turns checking off. Prefer `Object` when you truly need "any value".

## Checking a type with is

```dart
void main() {
  var value = 3.5;
  print(value is double);
  print(value is num);
  print(value is! String);
}
```

```output
true
true
true
```

## Statically typed, with inference

Dart checks types before running. If you write `int x = 'hello';` the program will not start. You get this safety without typing much, because `var` infers the type for you.

## Try it yourself

Create one variable of each type in the table and print its `runtimeType`. What does `print((1 + 2.0).runtimeType);` show, and why?
