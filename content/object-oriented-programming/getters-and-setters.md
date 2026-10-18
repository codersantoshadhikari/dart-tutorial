---
title: "Getters and Setters in Dart"
linkTitle: "Getters and setters"
description: "Learn getters and setters in Dart: computed properties, validating values, private fields, lazy getters and best practices."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart getter"
  - "dart setter"
  - "get set keyword"
  - "computed property"
  - "private field"
aliases:
  - "/getters-and-setters/"
  - "/fr/getters-and-setters/"
  - "/getters-and-setters/default-getters-and-setters/"
  - "/fr/getters-and-setters/default-getters-and-setters/"
  - "/getters-and-setters/custom-getters-and-setters/"
  - "/fr/getters-and-setters/custom-getters-and-setters/"
  - "/getters-and-setters/lazy-getters/"
  - "/fr/getters-and-setters/lazy-getters/"
  - "/getters-and-setters/use-with-private-variables/"
  - "/fr/getters-and-setters/use-with-private-variables/"
  - "/getters-and-setters/best-practices/"
  - "/fr/getters-and-setters/best-practices/"
---

Getters and setters are methods that look like fields. A **getter** runs when you read a property, and a **setter** runs when you assign to it. They let a class control its data without changing how other code uses it.

## Every field already has them

When you declare a field, Dart creates an invisible getter, and a setter too unless the field is `final`. That is why you rarely need to write trivial ones.

```dart
class User {
  String name = 'Guest';   // getter and setter
  final int id = 1;        // getter only
}

void main() {
  var u = User();
  u.name = 'Hema';  // uses the setter
  print(u.name);    // uses the getter
  // u.id = 2;      // error: no setter
}
```

```output
Hema
```

## Custom getters: computed properties

Use `get` for a value worked out from other fields. It is called without brackets.

```dart
class Rectangle {
  double width;
  double height;
  Rectangle(this.width, this.height);

  double get area => width * height;
  bool get isSquare => width == height;
}

void main() {
  var r = Rectangle(5, 4);
  print(r.area);
  r.width = 4;
  print(r.area);     // always up to date
  print(r.isSquare);
}
```

```output
20.0
16.0
true
```

Nothing is stored, so `area` can never disagree with `width` and `height`.

## Custom setters: validation

A setter receives the new value and decides what to do with it. The usual pattern is a private field (its name starts with `_`) with a public getter and setter in front.

```dart
class Account {
  double _balance = 0;

  double get balance => _balance;

  set balance(double value) {
    if (value < 0) {
      throw ArgumentError('Balance cannot be negative');
    }
    _balance = value;
  }
}

void main() {
  var account = Account();
  account.balance = 500;
  print(account.balance);

  try {
    account.balance = -20;
  } catch (e) {
    print('Rejected: $e');
  }
}
```

```output
500.0
Rejected: Invalid argument(s): Balance cannot be negative
```

## Read-only from outside

Provide a getter and no setter. Code outside the file can read the value but cannot change it.

```dart
class Counter {
  int _count = 0;

  int get count => _count;

  void increment() => _count++;
}

void main() {
  var c = Counter();
  c.increment();
  c.increment();
  print(c.count);
  // c.count = 10; // error: there is no setter named 'count'
}
```

```output
2
```

## Converting on the way in and out

```dart
class Temperature {
  double celsius;
  Temperature(this.celsius);

  double get fahrenheit => celsius * 9 / 5 + 32;
  set fahrenheit(double f) => celsius = (f - 32) * 5 / 9;
}

void main() {
  var t = Temperature(0);
  print(t.fahrenheit);
  t.fahrenheit = 212;
  print(t.celsius);
}
```

```output
32.0
100.0
```

## Lazy getters

If a value is expensive to compute and never changes, compute it once on first use. `late final` does this in a single line.

```dart
class Report {
  final List<int> data;
  Report(this.data);

  late final int total = _computeTotal();

  int _computeTotal() {
    print('Computing...');
    return data.fold(0, (a, b) => a + b);
  }
}

void main() {
  var report = Report([10, 20, 30]);
  print(report.total);
  print(report.total); // not computed again
}
```

```output
Computing...
60
60
```

## Best practices

- **Do not wrap a field just because you can.** `int get age => _age; set age(int v) => _age = v;` adds nothing over a public field. In Dart, switching a field to a getter later does not break callers.
- **Getters should be cheap and have no side effects.** If it does heavy work or changes something, make it a method.
- **Use a getter for "what it is", a method for "what it does".** `list.length` but `list.sort()`.
- **Validate in setters**, or better, make the class immutable and validate once in the constructor.
- **A setter without a getter is confusing.** Use a method instead.

## Try it yourself

Write a `Person` class with a private `_age`. Add a getter, a setter that rejects ages below 0 or above 150, and a getter `isAdult`. Test the setter with a valid and an invalid age.
