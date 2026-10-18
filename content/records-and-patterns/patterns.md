---
title: "Patterns and Destructuring in Dart"
linkTitle: "Patterns"
description: "Learn pattern matching in Dart 3: destructure lists, maps, records and objects, and use patterns in variables, if-case, for loops and switch."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart patterns"
  - "pattern matching"
  - "destructuring"
  - "if case"
  - "list pattern"
  - "map pattern"
  - "object pattern"
aliases:
  - "/new-features/pattern-matching-with-records/"
  - "/fr/new-features/pattern-matching-with-records/"
  - "/new-features/record-decomposition/"
  - "/fr/new-features/record-decomposition/"
---

A **pattern** describes the shape of a value. Dart can use it to do two things at once:

- **Match**: check whether a value has that shape.
- **Destructure**: pull the pieces out into variables.

Patterns appear in variable declarations, assignments, `for` loops, `if`, and `switch`.

## Destructuring in a declaration

```dart
void main() {
  var [first, second, third] = [10, 20, 30];
  print(first + second + third);

  var (name, age) = ('Asha', 28);
  print('$name is $age');

  var {'host': host, 'port': port} = {'host': 'localhost', 'port': 8080};
  print('$host:$port');
}
```

```output
60
Asha is 28
localhost:8080
```

In a declaration the pattern must be certain to match. `var [a, b] = [1, 2, 3];` throws, because the lengths differ.

## List patterns and the rest element

`...` matches any number of remaining items. Give it a name to capture them.

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5];

  var [head, ...tail] = numbers;
  print('$head then $tail');

  var [start, ..., end] = numbers;
  print('$start ... $end');

  var [_, second, ...] = numbers; // _ ignores a value
  print(second);
}
```

```output
1 then [2, 3, 4, 5]
1 ... 5
2
```

## Object patterns

Match an object by its class and pull out its getters.

```dart
class User {
  final String name;
  final int age;
  User(this.name, this.age);
}

void main() {
  var user = User('Bimal', 31);

  var User(name: userName, age: userAge) = user;
  print('$userName $userAge');

  // Shorthand when the variable has the same name as the getter.
  var User(:name, :age) = user;
  print('$name $age');
}
```

```output
Bimal 31
Bimal 31
```

## if-case: match, and use the parts if it fits

When a pattern might **not** match, use `if (value case pattern)`. The variables exist only inside the block.

```dart
void describe(Object value) {
  if (value case [int x, int y]) {
    print('A pair of ints: $x and $y');
  } else if (value case {'name': String name}) {
    print('A map with the name $name');
  } else if (value case String s when s.isNotEmpty) {
    print('Some text: $s');
  } else {
    print('Something else');
  }
}

void main() {
  describe([3, 4]);
  describe({'name': 'Chandra', 'age': 40});
  describe('hello');
  describe(3.14);
}
```

```output
A pair of ints: 3 and 4
A map with the name Chandra
Some text: hello
Something else
```

Notice that a **map pattern** matches when the listed keys are present; extra keys are ignored. A **list pattern** must match the length exactly unless you use `...`.

## Validating JSON

Patterns make checking the structure of decoded JSON short and safe.

```dart
void main() {
  Map<String, dynamic> json = {
    'user': {'name': 'Dipa', 'roles': ['admin', 'editor']},
  };

  if (json case {'user': {'name': String name, 'roles': [String first, ...]}}) {
    print('$name, first role: $first');
  } else {
    print('Unexpected JSON');
  }
}
```

```output
Dipa, first role: admin
```

Without patterns this would take several `is` checks, null checks and casts.

## Patterns in for loops

```dart
void main() {
  var prices = {'tea': 25, 'coffee': 60};
  for (final MapEntry(:key, :value) in prices.entries) {
    print('$key: $value');
  }

  var points = [(1, 2), (3, 4)];
  for (final (x, y) in points) {
    print(x * y);
  }
}
```

```output
tea: 25
coffee: 60
2
12
```

## The kinds of pattern

| Pattern | Example | Matches when |
| --- | --- | --- |
| Constant | `0`, `'yes'`, `null` | The value equals the constant |
| Variable | `var x`, `int x` | Always (or when the type fits), and binds it |
| Wildcard | `_` | Always, and ignores the value |
| Relational | `> 10`, `<= 5`, `!= 0` | The comparison is true |
| Logical or | `'y' \|\| 'yes'` | Either side matches |
| Logical and | `>= 0 && < 10` | Both sides match |
| Null-check | `var x?` | The value is not null |
| Cast | `var x as int` | Always; throws if the type is wrong |
| List | `[a, b, ...rest]` | It is a list of matching shape |
| Map | `{'key': v}` | It is a map containing those keys |
| Record | `(a, b)`, `(:x, :y)` | It is a record of that shape |
| Object | `Point(x: 0, :y)` | It is that type and its getters match |

Patterns nest freely: a record inside a list inside a map is fine.

## Null-check patterns

```dart
void main() {
  String? maybeName = 'Esha';

  if (maybeName case var name?) {
    print('Hello, $name'); // name is a non-nullable String
  }

  (int?, int?) coords = (3, null);
  if (coords case (var x?, var y?)) {
    print('Both present: $x, $y');
  } else {
    print('At least one is missing');
  }
}
```

```output
Hello, Esha
At least one is missing
```

## Guards with when

A `when` clause adds a condition that can use the variables the pattern just bound.

```dart
String classify((int, int) point) {
  return switch (point) {
    (0, 0) => 'origin',
    (var x, var y) when x == y => 'on the diagonal',
    (var x, _) when x < 0 => 'left side',
    _ => 'somewhere else',
  };
}

void main() {
  print(classify((0, 0)));
  print(classify((4, 4)));
  print(classify((-2, 7)));
}
```

```output
origin
on the diagonal
left side
```

Patterns are most powerful inside `switch`, which is the subject of the next lesson.

## Try it yourself

Write a function that takes a `List<int>` and uses `if-case` or `switch` to return `'empty'`, `'one item: X'`, `'two items: X and Y'`, or `'starts with X, N more'` for longer lists.
