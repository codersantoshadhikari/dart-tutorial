---
title: "Creating Your Own Libraries in Dart"
linkTitle: "Creating libraries"
description: "Learn to organise Dart code into libraries: split files, structure the lib folder, use export to build a public API, and keep details private."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart library"
  - "export keyword"
  - "lib src folder"
  - "part of"
  - "organise dart code"
  - "barrel file"
aliases:
  - "/libraries-and-packages/custom-libraries/"
  - "/fr/libraries-and-packages/custom-libraries/"
---

As a project grows, one file becomes hundreds of lines and then thousands. Splitting code into libraries keeps each piece small, lets you hide implementation details, and makes the code reusable.

## A file is a library

You already know how to make a library: create a `.dart` file.

```dart
// File: lib/temperature.dart

double celsiusToFahrenheit(double c) => c * 9 / 5 + 32;

double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;

// Private: only usable inside this file.
double _round(double value) => (value * 10).round() / 10;

String describe(double celsius) =>
    '${_round(celsius)}°C is ${_round(celsiusToFahrenheit(celsius))}°F';
```

```dart
// File: bin/main.dart
import 'package:my_app/temperature.dart';

void main() {
  print(describe(36.6));
  // _round(1.23); // error: private to temperature.dart
}
```

```output
36.6°C is 97.9°F
```

Names starting with `_` are invisible outside the file. This is how a library separates its public API from its internals.

## The standard project layout

```text
my_app/
  pubspec.yaml        # name, dependencies
  bin/
    main.dart         # entry point for a command-line app
  lib/
    my_app.dart       # the public face of the library
    src/              # implementation files
      models/
        user.dart
        order.dart
      services/
        api_client.dart
  test/
    user_test.dart
```

| Folder | Purpose |
| --- | --- |
| `lib/` | Code that can be imported with `package:my_app/...` |
| `lib/src/` | Implementation. By convention, private to the package |
| `bin/` | Programs you can run |
| `test/` | Tests |

## export: one import for many files

It would be tedious for users to import ten files. Create one library file that **exports** the others. This is often called a barrel file.

```dart
// File: lib/src/models/user.dart
class User {
  final String name;
  User(this.name);
}
```

```dart
// File: lib/src/models/order.dart
class Order {
  final int id;
  Order(this.id);
}

class OrderValidator {} // an internal helper
```

```dart
// File: lib/my_app.dart
export 'src/models/user.dart';
export 'src/models/order.dart' show Order; // OrderValidator stays hidden
```

```dart
// File: bin/main.dart
import 'package:my_app/my_app.dart';

void main() {
  final user = User('Asha');
  final order = Order(101);
  print('${user.name} placed order ${order.id}');
}
```

```output
Asha placed order 101
```

`show` and `hide` work on exports as they do on imports, giving precise control over what is public.

## Import is not export

Importing a library does not pass it on. If `a.dart` imports `dart:math`, a file that imports `a.dart` does not get `sqrt`. Each file imports what it uses, unless a library explicitly exports it.

## Splitting by feature

For apps, grouping files by **feature** scales better than grouping by type.

```text
lib/
  features/
    auth/
      login_page.dart
      auth_service.dart
      user.dart
    cart/
      cart_page.dart
      cart_service.dart
      cart_item.dart
  shared/
    widgets/
    utils/
```

Everything about the cart sits together, so a change to the cart touches one folder.

## part and part of

`part` splits **one** library across several files that share private members. You will meet it mainly with code generators, which write a `.g.dart` file that belongs to your library.

```dart
// File: lib/user.dart
part 'user.g.dart'; // generated code joins this library

class User {
  final String name;
  User(this.name);
}
```

```dart
// File: lib/user.g.dart
part of 'user.dart';

// Can use private members of user.dart.
```

For code you write by hand, prefer separate libraries with `import` and `export`.

## The library directive

You may see `library my_app;` at the top of older files. It is optional now. The modern use is a bare `library;` line to attach a documentation comment or annotation to the whole file.

```dart
/// Utilities for converting between temperature scales.
library;

double celsiusToFahrenheit(double c) => c * 9 / 5 + 32;
```

## Guidelines

- One main idea per file. File names are `lowercase_with_underscores.dart`.
- Keep the public API small. Start private and expose only what users need.
- Put implementation in `lib/src/` and export from a top-level file.
- Avoid circular imports between features. They are legal but make code hard to follow.
- Do not create a file per class out of habit. Small classes that are always used together can share a file.

## Try it yourself

Create a project with `dart create my_shapes`. Add `lib/src/circle.dart`, `lib/src/rectangle.dart` and a private helper file. Export only the two shape classes from `lib/my_shapes.dart`, and use them from `bin/my_shapes.dart` with a single import.
