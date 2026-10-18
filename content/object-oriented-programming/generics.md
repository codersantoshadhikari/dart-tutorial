---
title: "Generics in Dart: Type-Safe Reusable Code"
linkTitle: "Generics"
description: "Learn generics in Dart: generic classes, functions and constraints with extends, plus covariance and the covariant keyword."
weight: 16
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart generics"
  - "type parameter"
  - "generic class"
  - "generic function"
  - "bounded generics"
  - "covariant keyword"
aliases:
  - "/advanced-classes/generics/"
  - "/fr/advanced-classes/generics/"
  - "/polymorphism/covariant-and-contravariant-types/"
  - "/fr/polymorphism/covariant-and-contravariant-types/"
---

You have been using generics since the collections chapter. In `List<String>`, the `<String>` is a **type argument**: it tells the list what it holds. Generics let you write a class or function once and use it safely with many types.

## The problem generics solve

```dart
class IntBox {
  final int value;
  IntBox(this.value);
}

class StringBox {
  final String value;
  StringBox(this.value);
}
// ...and another class for every type?
```

You could use `Object` or `dynamic` to hold anything, but then you lose type checking and have to cast everywhere.

## A generic class

`T` is a **type parameter**: a placeholder that is filled in when the class is used.

```dart
class Box<T> {
  final T value;
  Box(this.value);

  T open() => value;
}

void main() {
  var intBox = Box<int>(42);
  var textBox = Box('hello'); // T is inferred as String

  print(intBox.open() + 1);
  print(textBox.open().toUpperCase());
  // intBox.open().toUpperCase(); // error: int has no toUpperCase
}
```

```output
43
HELLO
```

One class, full type safety, no casts.

## Several type parameters

```dart
class Pair<A, B> {
  final A first;
  final B second;
  const Pair(this.first, this.second);

  Pair<B, A> swap() => Pair(second, first);

  @override
  String toString() => '($first, $second)';
}

void main() {
  var p = Pair('age', 30);
  print(p);
  print(p.swap());
}
```

```output
(age, 30)
(30, age)
```

By convention, type parameters are single capital letters: `T` for type, `E` for element, `K` and `V` for key and value.

## Generic functions

```dart
T firstOr<T>(List<T> items, T fallback) =>
    items.isEmpty ? fallback : items.first;

List<T> repeat<T>(T item, int times) => [for (var i = 0; i < times; i++) item];

void main() {
  print(firstOr([3, 4], 0));
  print(firstOr(<String>[], 'none'));
  print(repeat('ha', 3));
}
```

```output
3
none
[ha, ha, ha]
```

## Constraining a type with extends

Inside `Box<T>`, Dart knows nothing about `T`, so you can only use what every object has. A **bound** promises more.

```dart
T largest<T extends Comparable<T>>(List<T> items) {
  var best = items.first;
  for (final item in items) {
    if (item.compareTo(best) > 0) best = item;
  }
  return best;
}

class Stats<T extends num> {
  final List<T> values;
  Stats(this.values);

  double get average =>
      values.fold<double>(0, (sum, v) => sum + v) / values.length;
}

void main() {
  print(largest(['pear', 'apple', 'zebra']));
  print(Stats([4, 8, 6]).average);
  // Stats(['a', 'b']); // error: String is not a num
}
```

```output
zebra
6.0
```

## A realistic example: a typed result

```dart
class ApiResult<T> {
  final T? data;
  final String? error;

  const ApiResult.success(T this.data) : error = null;
  const ApiResult.failure(String this.error) : data = null;

  bool get isSuccess => error == null;
}

ApiResult<List<String>> loadNames(bool online) => online
    ? const ApiResult.success(['Asha', 'Bimal'])
    : const ApiResult.failure('No connection');

void main() {
  var result = loadNames(true);
  if (result.isSuccess) print(result.data!.length);

  print(loadNames(false).error);
}
```

```output
2
No connection
```

## Generics are kept at run time

Unlike Java, Dart remembers type arguments while the program runs, so you can test them.

```dart
void main() {
  var names = <String>['a', 'b'];
  print(names is List<String>);
  print(names is List<int>);
}
```

```output
true
false
```

## Covariance: a List of Dog is a List of Animal

In Dart, `List<Dog>` can be used where `List<Animal>` is expected. This is called **covariance**. It is convenient, but it has one trap, which Dart catches at run time instead of compile time.

```dart
class Animal {}

class Dog extends Animal {}

class Cat extends Animal {}

void main() {
  List<Dog> dogs = [Dog()];
  List<Animal> animals = dogs; // allowed

  print(animals.length);

  try {
    animals.add(Cat()); // the real list only holds dogs
  } catch (e) {
    print('Run-time type error');
  }
}
```

```output
1
Run-time type error
```

Reading from such a list is always safe. Writing to it is where care is needed.

## The covariant keyword

Normally an overriding method must accept **at least** everything the parent method accepts. Occasionally a subclass sensibly wants a narrower parameter. Marking the parameter `covariant` allows it, and Dart checks the type at run time.

```dart
class Animal {
  void chase(covariant Animal other) => print('Chasing an animal');
}

class Mouse extends Animal {}

class Cat extends Animal {
  @override
  void chase(Mouse other) => print('Cat chases a mouse'); // narrower type
}

void main() {
  Cat().chase(Mouse());
}
```

```output
Cat chases a mouse
```

Dart also understands **contravariance** for function types: a function that accepts any `Animal` can be used where a function accepting a `Dog` is required, because it can certainly handle dogs.

## Try it yourself

Write a generic `Stack<T>` class with `push`, `pop`, `peek` and `isEmpty`, backed by a private list. Use it once with `int` and once with `String`. Then write `T? maxOf<T extends Comparable<T>>(List<T> items)` that returns `null` for an empty list.
