---
title: "typedef in Dart: Naming Function and Other Types"
linkTitle: "typedef"
description: "Use typedef in Dart to give long function types and generic types a short, readable name. Includes practical callback examples."
weight: 7
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart typedef"
  - "type alias"
  - "function type alias"
  - "callback type"
---

A `typedef` gives a type a second name. It does not create a new type. It is a shortcut that makes long types readable and keeps them in one place.

## The problem it solves

Function types get long quickly.

```dart
void fetchUser(
  int id,
  void Function(String name, int age) onSuccess,
  void Function(String message) onError,
) {
  if (id > 0) {
    onSuccess('Kiran', 28);
  } else {
    onError('Invalid id');
  }
}

void main() {
  fetchUser(1, (name, age) => print('$name, $age'), print);
}
```

## Naming the function types

```dart
typedef UserCallback = void Function(String name, int age);
typedef ErrorCallback = void Function(String message);

void fetchUser(int id, UserCallback onSuccess, ErrorCallback onError) {
  if (id > 0) {
    onSuccess('Kiran', 28);
  } else {
    onError('Invalid id');
  }
}

void main() {
  fetchUser(1, (name, age) => print('$name, $age'), print);
  fetchUser(-1, (name, age) => print('$name, $age'), print);
}
```

```output
Kiran, 28
Invalid id
```

The signature of `fetchUser` now fits on one line and says what each callback is for.

## Aliases for any type

A typedef is not limited to functions. It can shorten any type, which is useful for nested generics and records.

```dart
typedef Json = Map<String, dynamic>;
typedef Point = (double x, double y);
typedef Scores = Map<String, List<int>>;

String describe(Json data) => '${data['name']} (${data['age']})';

double squaredLength(Point p) => p.$1 * p.$1 + p.$2 * p.$2;

void main() {
  Json user = {'name': 'Lila', 'age': 31};
  print(describe(user));

  Point p = (3, 4);
  print(squaredLength(p));

  Scores scores = {'maths': [80, 92]};
  print(scores);
}
```

```output
Lila (31)
25.0
{maths: [80, 92]}
```

## Generic typedefs

```dart
typedef Predicate<T> = bool Function(T value);
typedef Mapper<A, B> = B Function(A input);

List<T> keep<T>(List<T> items, Predicate<T> test) =>
    [for (final item in items) if (test(item)) item];

void main() {
  print(keep([1, 2, 3, 4], (n) => n.isEven));
  print(keep(['a', 'bb', 'ccc'], (s) => s.length > 1));
}
```

```output
[2, 4]
[bb, ccc]
```

## Remember: it is only a name

Because a typedef is an alias, it gives no extra type safety. A `Json` and a `Map<String, dynamic>` are interchangeable. When you want a genuinely separate type, for example so that a `UserId` cannot be passed where an `OrderId` is expected, use an [extension type](/object-oriented-programming/extension-types/) or a class.

## Try it yourself

Create `typedef Validator = String? Function(String input);` where the function returns an error message, or `null` if the input is fine. Write two validators (not empty, at least 8 characters) and a function that runs a list of validators and returns the first error.
