---
title: "What's New in Dart 3: Modern Features from 3.0 to 3.10"
seoTitle: "What's New in Dart 3: Features from 3.0 to 3.10"
linkTitle: "What's new in Dart 3"
description: "Modern Dart features with examples: records, patterns, sealed classes, extension types, digit separators, wildcards, null-aware elements and dot shorthands."
weight: 7
date: 2026-10-16
lastmod: 2026-10-16
keywords:
  - "dart 3 features"
  - "what's new in dart"
  - "dart dot shorthands"
  - "dart null-aware elements"
  - "dart digit separators"
  - "dart wildcard variables"
  - "latest dart version features"
faq:
  - q: "How do I check my Dart version?"
    a: "Run dart --version in a terminal. In a Flutter project, flutter --version shows both the Flutter and the Dart version."
  - q: "Why does a new Dart feature give me an error?"
    a: "New language features are turned on by the lower bound of the sdk constraint in pubspec.yaml. If it says sdk: ^3.5.0, features from 3.8 or 3.10 are off. Raise it, for example to sdk: ^3.10.0, and make sure your installed Dart is at least that version."
---

Dart improves every few months. If you learned Dart from an older tutorial, this page shows the **modern features** you may have missed, newest last, each with a small example you can run. Every lesson on this site already uses modern Dart.

To use a feature, your installed Dart must be new enough **and** your `pubspec.yaml` must allow it:

```yaml
environment:
  sdk: ^3.10.0   # the lower bound turns language features on
```

Check your version with `dart --version`, and upgrade as shown in [install Dart](/getting-started/install-dart/).

## Overview

| Version | Year | Main language features |
| --- | --- | --- |
| 3.0 | 2023 | Records, patterns, switch expressions, class modifiers, sealed classes, 100% null safety |
| 3.2 | 2023 | Private final fields can be promoted after a null check |
| 3.3 | 2024 | Extension types |
| 3.6 | 2024 | Digit separators: `1_000_000` |
| 3.7 | 2025 | Wildcard variables `_`; new "tall" formatter style |
| 3.8 | 2025 | Null-aware elements in collections: `[?value]` |
| 3.10 | 2025 | Dot shorthands: `.center` instead of `MainAxisAlignment.center` |

## Dart 3.0: records, patterns and sealed classes

The biggest update since null safety.

```dart
sealed class Shape {}

class Circle extends Shape {
  final double r;
  Circle(this.r);
}

class Square extends Shape {
  final double side;
  Square(this.side);
}

// A record: return two values without a class
(double, String) describe(Shape s) => switch (s) {
      Circle(:final r) => (3.14159 * r * r, 'circle'),
      Square(:final side) => (side * side, 'square'),
    };

void main() {
  for (final shape in [Circle(1), Square(2)]) {
    final (area, name) = describe(shape); // destructuring
    print('$name: ${area.toStringAsFixed(2)}');
  }
}
```

```output
circle: 3.14
square: 4.00
```

Because `Shape` is `sealed`, the compiler knows every subclass and warns you if the `switch` misses one. Learn each part in [records](/records-and-patterns/records/), [patterns](/records-and-patterns/patterns/), [switch expressions](/records-and-patterns/switch-expressions/), [sealed classes](/records-and-patterns/sealed-classes/) and [class modifiers](/object-oriented-programming/class-modifiers/).

## Dart 3.2: private field promotion

A `final` private field can now be used as non-null after you check it, without `!`:

```dart
class Profile {
  final String? _nickname;
  Profile(this._nickname);

  String label() {
    if (_nickname != null) {
      return 'Nickname: ${_nickname.toUpperCase()}'; // no ! needed
    }
    return 'No nickname';
  }
}

void main() {
  print(Profile('ace').label());
  print(Profile(null).label());
}
```

```output
Nickname: ACE
No nickname
```

This works only for **private** and **final** fields, because only then can Dart be sure nothing else changes the value. See [null safety](/null-safety/null-safety-in-dart/).

## Dart 3.3: extension types

An extension type gives an existing type a new name and its own methods, with zero runtime cost:

```dart
extension type UserId(int value) {
  bool get isAdmin => value < 100;
}

void main() {
  final id = UserId(42);
  print(id.isAdmin);
  print(id.value);
}
```

```output
true
42
```

Now a function that takes a `UserId` cannot be passed any random `int` by mistake. Full lesson: [extension types](/object-oriented-programming/extension-types/).

## Dart 3.6: digit separators

Underscores make long numbers readable. They do not change the value.

```dart
void main() {
  const population = 30_000_000;
  const price = 1_299.99;
  const mask = 0xFF_FF_00_00;

  print(population);
  print(price);
  print(mask == 0xFFFF0000);
}
```

```output
30000000
1299.99
true
```

See [numbers in Dart](/dart-basics/numbers/).

## Dart 3.7: wildcard variables

A variable named `_` is now a **wildcard**: it does not create a variable, so you can use `_` several times for values you do not need.

```dart
void main() {
  final pairs = [(1, 'one'), (2, 'two')];

  // Ignore the number, keep the word
  for (final (_, word) in pairs) {
    print(word);
  }

  // Ignore both callback parameters
  final always = (_, _) => 'ignored';
  print(always(1, 2));
}
```

```output
one
two
ignored
```

The same release introduced the new **"tall" style** of `dart format`, which puts trailing commas and line breaks in for you. See [formatting and linting](/tools-and-performance/formatting-and-linting/).

## Dart 3.8: null-aware elements

Put `?` before an element to add it **only if it is not null**. No more `if (x != null) x`:

```dart
String? findMiddleName() => null;
String? findNickname() => 'Ace';

void main() {
  final middleName = findMiddleName();
  final nickname = findNickname();

  final names = ['Asha', ?middleName, 'Rai'];
  print(names);

  final profile = {
    'name': 'Asha',
    'nickname': ?nickname,
    'middle': ?middleName,
  };
  print(profile);
}
```

```output
[Asha, Rai]
{name: Asha, nickname: Ace}
```

This is very handy for building JSON and Flutter widget lists. Compare with [collection if and spread](/collections/spread-and-collection-if/).

## Dart 3.10: dot shorthands

When Dart already knows the type, you can leave out the type name and write just `.value`:

```dart
enum Status { active, paused, closed }

String label(Status s) => switch (s) {
      .active => 'Running',
      .paused => 'On hold',
      .closed => 'Finished',
    };

void main() {
  Status current = .paused;   // instead of Status.paused
  print(label(current));
  print(label(.active));
  print(current == .paused);
}
```

```output
On hold
Running
true
```

Dot shorthands also work for static members and constructors when the type is known. In Flutter this makes layout code much shorter:

```dart
// Not standalone: inside a Flutter build method.
Column(
  mainAxisAlignment: .center,        // MainAxisAlignment.center
  crossAxisAlignment: .start,        // CrossAxisAlignment.start
  mainAxisSize: .min,                // MainAxisSize.min
  children: [
    Text('Hello'),
  ],
)
```

See [enums](/object-oriented-programming/enums/).

## Tools that improved too

- **Faster native compilation** and smaller executables with `dart compile exe`.
- **WebAssembly**: Dart and Flutter web apps can compile to Wasm for better performance.
- **Pub workspaces** (3.6): several packages in one repository share one resolution.
- **Cross-compilation** (3.8): build Linux executables from macOS or Windows.

## Upgrading old code

1. Run `dart --version`, then upgrade Dart (or `flutter upgrade`).
2. Raise `sdk:` in `pubspec.yaml`.
3. Run `dart fix --apply`: it updates many deprecated patterns automatically.
4. Run `dart format .` to switch to the new style, and `dart analyze` to check everything.

The official, always up-to-date list is the [Dart language evolution page](https://dart.dev/resources/language/evolution). Next, test yourself with the [Dart interview questions](/next-steps/dart-interview-questions/).
