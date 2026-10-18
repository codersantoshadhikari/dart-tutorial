---
title: "The late Keyword in Dart: Late and Lazy Initialization"
linkTitle: "late variables"
description: "Learn when and how to use the late keyword in Dart for variables initialized after declaration, and for lazy initialization."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart late keyword"
  - "late final"
  - "lazy initialization"
  - "LateInitializationError"
---

Dart insists that a non-nullable variable has a value before it is used. Sometimes you know it will, but the compiler cannot see it. The `late` keyword says: "I will give this a value later, before I read it."

## The problem

```dart
class Thermometer {
  // double reading; // error: non-nullable field must be initialized

  late double reading;

  void measure() {
    reading = 36.6;
  }
}

void main() {
  var t = Thermometer();
  t.measure();
  print(t.reading);
}
```

```output
36.6
```

Without `late` you would have to make `reading` nullable and then check for null everywhere it is used.

## The risk

`late` moves the check from compile time to run time. Read the variable too early and the program throws.

```dart
class Thermometer {
  late double reading;
}

void main() {
  var t = Thermometer();
  try {
    print(t.reading);
  } catch (e) {
    print('Error: reading was used before it was set');
  }
}
```

```output
Error: reading was used before it was set
```

The real error is a `LateInitializationError`. If you cannot be sure the value is set first, a nullable type is the honest choice.

## late final: set exactly once

```dart
class Session {
  late final String token;

  void login() {
    token = 'abc123';
    // token = 'xyz'; // would throw: already initialized
  }
}

void main() {
  var s = Session()..login();
  print(s.token);
}
```

```output
abc123
```

## Lazy initialization

When a `late` variable has an initializer, the initializer does not run until the first time the variable is read. If it is never read, the work is never done.

```dart
String loadConfig() {
  print('Loading config (expensive)...');
  return 'config-v2';
}

void main() {
  late final config = loadConfig();

  print('Program started');
  print(config); // loadConfig runs here
  print(config); // already loaded, does not run again
}
```

```output
Program started
Loading config (expensive)...
config-v2
config-v2
```

## Lazy fields that use other fields

A normal field initializer cannot use `this`. A `late` one can, because it runs after the object exists.

```dart
class Circle {
  final double radius;
  Circle(this.radius);

  late final double area = 3.14159 * radius * radius;
}

void main() {
  print(Circle(2).area);
}
```

```output
12.56636
```

## When to use late

| Situation | Good choice |
| --- | --- |
| Value arrives in a setup method that always runs first (such as Flutter's `initState`) | `late` |
| Expensive value that may never be needed | `late final x = ...;` |
| Value might truly be absent | Nullable type `T?` |
| Value is known when the object is built | Plain `final`, set in the constructor |

Treat `late` like `!`: a promise to the compiler. Use it where the guarantee is obvious from the structure of the code, not as a way to quiet errors.

## Try it yourself

Create a class `Report` with a `late final String summary = buildSummary();` field, where `buildSummary` prints a message and returns some text. Create a `Report` and confirm the message appears only when you first print `summary`.
