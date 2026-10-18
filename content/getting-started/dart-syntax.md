---
title: "Dart Syntax: The Basic Rules of Dart in One Page"
linkTitle: "Dart syntax basics"
description: "Learn Dart syntax fast: program structure, semicolons, variables, types, strings, if else, loops, functions, classes and null safety, with easy examples."
weight: 5
date: 2026-10-15
lastmod: 2026-10-15
keywords:
  - "dart syntax"
  - "dart basic syntax"
  - "dart language syntax"
  - "dart programming basics"
  - "dart code examples"
  - "dart for beginners"
---

This page is a tour of Dart syntax for beginners. Each section shows one rule in a tiny program. You do not need to remember everything now: every topic links to a full lesson later in the course. If you have programmed before, this page alone is enough to start reading Dart code.

## Every program starts in main

```dart
void main() {
  print('Hello, Dart!');
}
```

```output
Hello, Dart!
```

- `void main()` is where the program begins. `void` means it returns nothing.
- Code that belongs together sits inside curly braces `{ }`.
- Each statement ends with a **semicolon** `;`. Forgetting it is the most common beginner error.
- `print` writes a line to the console.

## Comments

```dart
void main() {
  // A single-line comment
  /* A comment that can
     cover several lines */
  print('Comments are ignored when the program runs');
}
```

```output
Comments are ignored when the program runs
```

`///` starts a documentation comment. See [Comments](/getting-started/comments/).

## Variables and types

```dart
void main() {
  var name = 'Asha';      // Dart works out the type: String
  int age = 21;
  double height = 1.62;
  bool isStudent = true;
  final country = 'Nepal'; // set once
  const pi = 3.14159;      // known at compile time

  print('Name: $name');
  print('Age next year: ${age + 1}');
  print('Height: $height m, student: $isStudent');
  print('$country, pi = $pi');
}
```

```output
Name: Asha
Age next year: 22
Height: 1.62 m, student: true
Nepal, pi = 3.14159
```

Dart is **statically typed**: once `age` is an `int`, you cannot put text in it. The compiler tells you before the program runs. Read more in [Variables](/dart-basics/variables/), [Data types](/dart-basics/data-types/) and [final vs const](/dart-basics/final-and-const/).

## Strings and interpolation

Use `$name` to insert a variable and `${...}` for any expression. Single and double quotes both work.

```dart
void main() {
  var item = 'tea';
  var price = 1.5;
  print('One $item costs \$$price');
  print('Two cost \$${price * 2}');
  print('Upper case: ${item.toUpperCase()}');
}
```

```output
One tea costs $1.5
Two cost $3.0
Upper case: TEA
```

Write `\$` when you want a real dollar sign. All the string tools are in [Dart string methods](/dart-basics/string-methods/).

## Operators

```dart
void main() {
  print(7 + 2);   // 9
  print(7 / 2);   // 3.5  (always a double)
  print(7 ~/ 2);  // 3    (whole-number division)
  print(7 % 2);   // 1    (remainder)
  print(7 > 2 && 2 > 1);
  print(7 == 7.0);
}
```

```output
9
3.5
3
1
true
true
```

See [Operators](/dart-basics/operators/) for the full list.

## if, else if and else

```dart
void main() {
  var score = 72;

  if (score >= 80) {
    print('Grade A');
  } else if (score >= 60) {
    print('Grade B');
  } else {
    print('Grade C');
  }

  var result = score >= 40 ? 'pass' : 'fail';
  print(result);
}
```

```output
Grade B
pass
```

Conditions must be a real `bool`. Dart does not treat `0` or an empty string as false. More in [if else](/control-flow/if-else/) and [the ternary operator](/control-flow/ternary-operator/).

## Loops

```dart
void main() {
  for (var i = 1; i <= 3; i++) {
    print('Round $i');
  }

  for (final fruit in ['apple', 'mango']) {
    print(fruit);
  }

  var n = 3;
  while (n > 0) {
    print(n);
    n--;
  }
}
```

```output
Round 1
Round 2
Round 3
apple
mango
3
2
1
```

See [Loops](/control-flow/loops/) and [switch](/control-flow/switch-case/).

## Functions

```dart
int add(int a, int b) {
  return a + b;
}

int square(int x) => x * x; // arrow syntax for one expression

String greet(String name, {String greeting = 'Hello'}) {
  return '$greeting, $name!';
}

void main() {
  print(add(2, 3));
  print(square(4));
  print(greet('Ram'));
  print(greet('Sita', greeting: 'Namaste'));
}
```

```output
5
16
Hello, Ram!
Namaste, Sita!
```

The type before the name is what the function returns. Named parameters go inside `{ }`. Full details in [Functions](/functions/functions/) and [Function parameters](/functions/function-parameters/).

## Lists, sets and maps

```dart
void main() {
  var list = [1, 2, 3];               // ordered, allows duplicates
  var tags = {'a', 'b'};              // unique values
  var map = {'apple': 3, 'mango': 5}; // key: value

  list.add(4);
  print(list);
  print(tags);
  print(map['mango']);
}
```

```output
[1, 2, 3, 4]
{a, b}
5
```

See [Collections](/collections/) and [Dart list methods](/collections/list-methods/).

## Classes and objects

```dart
class Dog {
  final String name;
  Dog(this.name);

  void bark() => print('$name says woof');
}

void main() {
  var dog = Dog('Bruno'); // no "new" keyword needed
  dog.bark();
}
```

```output
Bruno says woof
```

Start with [Classes and objects](/object-oriented-programming/classes-and-objects/).

## Null safety

A normal variable can never be `null`. Add `?` to the type to allow it.

```dart
void main() {
  String? nickname;               // may be null
  print(nickname ?? 'no nickname');

  nickname = 'Bibek';
  print(nickname.length);         // safe: Dart knows it is not null now
}
```

```output
no nickname
5
```

This is explained step by step in [Null safety in Dart](/null-safety/null-safety-in-dart/).

## Naming rules and style

| What | Style | Example |
| --- | --- | --- |
| Variables, functions, parameters | lowerCamelCase | `userName`, `getTotal()` |
| Classes, enums, types | UpperCamelCase | `ShoppingCart` |
| Files and packages | lowercase_with_underscores | `shopping_cart.dart` |
| Constants | lowerCamelCase | `const maxItems = 10;` |
| Private names | start with `_` | `_balance` |

Other rules worth knowing:

- Dart is **case-sensitive**: `name` and `Name` are different.
- Names can contain letters, digits, `_` and `$`, but cannot start with a digit.
- Keywords such as `class`, `if`, `var` and `return` cannot be used as names.
- Run `dart format .` to lay out your code the standard way. See [Formatting and linting](/tools-and-performance/formatting-and-linting/).

## Try it yourself

Write a program with a function `describe(String name, int age)` that returns `'<name> is an adult'` when `age` is 18 or more and `'<name> is a minor'` otherwise. Call it for three people stored in a list of records, such as `[('Asha', 21), ('Kiran', 15), ('Leo', 18)]`, using a `for` loop.
