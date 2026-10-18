---
title: "Imports in Dart: import, as, show and hide"
linkTitle: "Imports"
description: "Learn how to import libraries in Dart: core libraries, packages and your own files, with prefixes (as) and the show and hide keywords."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart import"
  - "import as"
  - "show hide"
  - "import prefix"
  - "dart:core libraries"
  - "relative import"
  - "deferred import"
aliases:
  - "/libraries-and-packages/importing-dart-libraries/"
  - "/fr/libraries-and-packages/importing-dart-libraries/"
  - "/libraries-and-packages/import-aliases/"
  - "/fr/libraries-and-packages/import-aliases/"
  - "/libraries-and-packages/show-and-hide-keywords/"
  - "/fr/libraries-and-packages/show-and-hide-keywords/"
---

In Dart, every `.dart` file is a **library**. To use something defined in another library, you `import` it.

## Three kinds of import

```dart
// 1. A library built into the Dart SDK
import 'dart:math';

// 2. A library from a package (your own project or one from pub.dev)
import 'package:http/http.dart';

// 3. A file in your project, by relative path
import 'utils/formatters.dart';
```

Imports go at the top of the file, before any other code.

## The built-in libraries

| Library | Contains |
| --- | --- |
| `dart:core` | `int`, `String`, `List`, `Map`, `DateTime`, `print`... Imported automatically |
| `dart:async` | `Future`, `Stream`, `Timer`, `Completer` |
| `dart:math` | `sqrt`, `pow`, `min`, `max`, `pi`, `Random` |
| `dart:convert` | JSON, UTF-8 and Base64 encoding |
| `dart:io` | Files, sockets, processes, HTTP server (not on the web) |
| `dart:collection` | `Queue`, `LinkedHashMap`, `SplayTreeMap` |
| `dart:typed_data` | Efficient lists of bytes and numbers |
| `dart:isolate` | Isolates (not on the web) |

```dart
import 'dart:math';

void main() {
  print(sqrt(144));
  print(max(3, 8));
  print(pi.toStringAsFixed(3));
}
```

```output
12.0
8
3.142
```

## Importing your own files

Suppose the project looks like this:

```text
my_app/
  pubspec.yaml
  bin/
    main.dart
  lib/
    models/
      user.dart
    utils/
      formatters.dart
```

Files under `lib/` can be imported from anywhere with a `package:` path, which starts with the package name from `pubspec.yaml`.

```dart
// In bin/main.dart
import 'package:my_app/models/user.dart';
import 'package:my_app/utils/formatters.dart';
```

Files in the same folder tree can also use relative paths.

```dart
// In lib/models/user.dart
import '../utils/formatters.dart';
```

Use `package:` imports to reach into `lib/` from outside it, and pick one style within `lib/` and stick to it.

## as: give an import a prefix

A prefix puts everything from the library behind a name. It solves two problems: name clashes, and "where does this function come from?"

```dart
import 'dart:math' as math;

void main() {
  print(math.sqrt(49));
  print(math.max(10, 20));
  print(math.Random().nextInt(10) < 10);
}
```

```output
7.0
20
true
```

Some packages are designed to be used with a prefix. The `http` package has top-level functions called `get` and `post`, which would be confusing bare.

```dart
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

// http.get(...), p.join(...)
```

When two libraries define the same name, a prefix on one of them resolves it:

```dart
import 'package:shapes/circle.dart';
import 'package:drawing/circle.dart' as drawing;

// Circle()          -> from shapes
// drawing.Circle()  -> from drawing
```

## show: import only some names

```dart
import 'dart:math' show pi, sqrt;

void main() {
  print(sqrt(pi));
  // print(max(1, 2)); // error: max was not imported
}
```

```output
1.7724538509055159
```

`show` documents exactly what you depend on and keeps autocomplete tidy.

## hide: import everything except some names

```dart
import 'dart:math' hide Random;

// Our own Random class no longer clashes with dart:math's.
class Random {
  int next() => 4;
}

void main() {
  print(Random().next());
  print(sqrt(16));
}
```

```output
4
4.0
```

`show` and `hide` can be combined with a prefix: `import 'dart:math' as math show pi;`.

## Deferred loading

On the web, a large library can be downloaded only when it is needed, which makes the first page load faster.

```dart
import 'package:my_app/heavy_charts.dart' deferred as charts;

Future<void> showReport() async {
  await charts.loadLibrary();
  charts.drawSalesChart();
}
```

## export: pass a library on

`export` makes another library's names available to anyone who imports **your** file. It is how a package offers one tidy entry point. See [creating libraries](/libraries-and-packages/creating-libraries/).

## Good habits

- Order imports: `dart:` first, then `package:`, then relative. `dart format` and the linter help.
- Remove unused imports. The analyzer flags them.
- Never import from another package's `lib/src/` folder. That is its private code and may change without warning.
- Use a prefix for libraries with very general names such as `http`, `path` or `math`.

## Try it yourself

Create two files, `geometry.dart` with a function `area` for rectangles and `circles.dart` with a function `area` for circles. Import both into `main.dart` and call each one, first using prefixes and then using `show` and `hide`.
