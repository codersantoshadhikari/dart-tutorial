---
title: "Records in Dart: Return Multiple Values Without a Class"
linkTitle: "Records"
description: "Learn Dart records: positional and named fields, record types, returning multiple values from a function, equality and destructuring."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart records"
  - "return multiple values"
  - "named records"
  - "record type"
  - "tuple dart"
aliases:
  - "/new-features/record-syntax/"
  - "/fr/new-features/record-syntax/"
  - "/new-features/named-records/"
  - "/fr/new-features/named-records/"
  - "/new-features/advanced-record-usage/"
  - "/fr/new-features/advanced-record-usage/"
---

A **record** is a small, fixed-size bundle of values. It is the quickest way to group a few things together, and the standard way to return more than one value from a function without writing a class.

## Creating a record

Write the values in round brackets, separated by commas.

```dart
void main() {
  var person = ('Asha', 28);

  print(person);
  print(person.$1); // first field
  print(person.$2); // second field
}
```

```output
(Asha, 28)
Asha
28
```

Positional fields are read with `$1`, `$2`, `$3` and so on. Counting starts at 1.

## Named fields

Give fields names by wrapping them in curly braces inside the brackets.

```dart
void main() {
  var person = (name: 'Asha', age: 28);

  print(person.name);
  print(person.age);
  print(person);
}
```

```output
Asha
28
(age: 28, name: Asha)
```

When a record is printed, its named fields appear in alphabetical order, whatever order you wrote them in.

You can mix both kinds. Positional fields come first in the type.

```dart
void main() {
  var result = (200, 'OK', duration: 0.42);
  print('${result.$1} ${result.$2} in ${result.duration}s');
}
```

```output
200 OK in 0.42s
```

## Record types

A record has a type made of the types of its fields.

```dart
void main() {
  (String, int) pair = ('pen', 3);
  ({String name, int age}) person = (name: 'Bimal', age: 31);
  (int, String, {bool ok}) response = (404, 'Not found', ok: false);

  print(pair);
  print(person);
  print(response);
}
```

```output
(pen, 3)
(age: 31, name: Bimal)
(404, Not found, ok: false)
```

For positional fields only the order and types matter. For named fields the names are part of the type: `({int a})` and `({int b})` are different types.

## Returning multiple values

This is the main reason records exist.

```dart
(int min, int max) minMax(List<int> numbers) {
  var min = numbers.first;
  var max = numbers.first;
  for (final n in numbers) {
    if (n < min) min = n;
    if (n > max) max = n;
  }
  return (min, max);
}

void main() {
  var result = minMax([8, 3, 12, 5]);
  print(result.$1);
  print(result.$2);

  // Usually you unpack straight into variables.
  var (low, high) = minMax([8, 3, 12, 5]);
  print('$low to $high');
}
```

```output
3
12
3 to 12
```

The names `min` and `max` in the return type are documentation. The fields are still positional.

## Destructuring

Unpacking a record into variables is called destructuring. It is a use of [patterns](/records-and-patterns/patterns/).

```dart
({String city, double temp}) weather() => (city: 'Pokhara', temp: 24.5);

void main() {
  // Positional
  var (x, y) = (10, 20);
  print(x + y);

  // Named: ":city" means "a variable called city from the field city"
  var (:city, :temp) = weather();
  print('$city is $temp degrees');

  // Swap two variables without a temporary one
  var a = 1, b = 2;
  (a, b) = (b, a);
  print('$a $b');
}
```

```output
30
Pokhara is 24.5 degrees
2 1
```

## Records compare by value

Two records are equal when they have the same shape and equal fields. No `==` override is needed.

```dart
void main() {
  print((1, 2) == (1, 2));
  print((x: 1, y: 2) == (y: 2, x: 1)); // order of named fields does not matter
  print((1, 2) == (2, 1));

  var visited = {(0, 0), (1, 1), (0, 0)};
  print(visited.length);
}
```

```output
true
true
false
2
```

This makes records excellent keys for maps and members of sets.

## Records are immutable

You cannot change a field. Create a new record instead.

```dart
void main() {
  var point = (x: 1, y: 2);
  // point.x = 5; // error: no setter
  var moved = (x: 5, y: point.y);
  print(moved);
}
```

```output
(x: 5, y: 2)
```

## Records in collections

```dart
void main() {
  var students = [
    (name: 'Anu', marks: 82),
    (name: 'Bikash', marks: 67),
    (name: 'Chhiring', marks: 94),
  ];

  students.sort((a, b) => b.marks.compareTo(a.marks));

  for (final (:name, :marks) in students) {
    print('$name: $marks');
  }
}
```

```output
Chhiring: 94
Anu: 82
Bikash: 67
```

## Giving a record type a name

A long record type repeated in many places is hard to read. A `typedef` helps.

```dart
typedef Coordinates = ({double lat, double lng});

Coordinates kathmandu() => (lat: 27.7172, lng: 85.3240);

void main() {
  Coordinates c = kathmandu();
  print(c.lat);
}
```

```output
27.7172
```

## Record or class?

| Use a record when | Use a class when |
| --- | --- |
| Returning a few values from a function | The data has behaviour (methods) |
| The grouping is local or temporary | The type is used across the app |
| You want value equality for free | You need validation, inheritance or private fields |
| Two to four fields | Many fields |

## Try it yourself

Write a function `(double average, int highest, int lowest) summarize(List<int> marks)`. Call it and destructure the result into three variables. Then change it to use named fields and destructure with the `:name` shorthand.
