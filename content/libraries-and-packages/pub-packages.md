---
title: "Using Packages from pub.dev in Dart"
linkTitle: "Using packages"
description: "Learn to find, add, use and update Dart packages from pub.dev: pubspec.yaml, dart pub add, version constraints and pubspec.lock."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "pub.dev"
  - "dart pub add"
  - "pubspec.yaml"
  - "dart packages"
  - "dependencies"
  - "version constraints"
  - "pubspec.lock"
  - "dart pub get"
aliases:
  - "/libraries-and-packages/packages-from-pub.dev/"
  - "/fr/libraries-and-packages/packages-from-pub.dev/"
---

A **package** is a bundle of Dart code that someone has published for others to use. [pub.dev](https://pub.dev/) is the official home of Dart and Flutter packages, with tens of thousands available for HTTP, databases, dates, state management, testing and much more.

## pubspec.yaml

Every Dart project has a `pubspec.yaml` at its root. It names the project and lists what it depends on.

```yaml
name: my_app
description: A sample command-line application.
version: 1.0.0

environment:
  sdk: ^3.5.0

dependencies:
  http: ^1.2.0
  path: ^1.9.0

dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.0
```

| Section | Meaning |
| --- | --- |
| `environment` | Which Dart SDK versions the project supports |
| `dependencies` | Packages the program needs to run |
| `dev_dependencies` | Packages needed only while developing: tests, linters, code generators |

YAML uses indentation for structure. Use two spaces, never tabs.

## Adding a package

Let the tool edit the file and download the code:

```bash
dart pub add http
dart pub add --dev test
```

In a Flutter project the command is `flutter pub add http`.

If you edit `pubspec.yaml` by hand, fetch the packages afterwards:

```bash
dart pub get
```

## Using it

```dart
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
  final response = await http.get(url);

  print(response.statusCode);
  print(response.body);
}
```

The import path is `package:<package name>/<file>.dart`. The package's page on pub.dev shows the exact line.

## Version numbers and constraints

Packages use **semantic versioning**: `MAJOR.MINOR.PATCH`.

- **PATCH** (1.2.**3** to 1.2.**4**): bug fixes.
- **MINOR** (1.**2**.3 to 1.**3**.0): new features, still compatible.
- **MAJOR** (**1**.2.3 to **2**.0.0): changes that may break your code.

| Constraint | Allows |
| --- | --- |
| `^1.2.3` | `1.2.3` up to, but not including, `2.0.0` |
| `^0.4.2` | `0.4.2` up to, but not including, `0.5.0` |
| `>=1.2.0 <1.5.0` | Exactly that range |
| `1.2.3` | Only that version. Avoid; it causes conflicts |
| `any` | Anything. Avoid |

The caret form (`^`) is the standard choice: take improvements automatically, but not breaking changes.

## pubspec.lock

After resolving versions, pub writes the **exact** version of every package to `pubspec.lock`. Everyone who then runs `dart pub get` gets the same versions, so the code behaves the same on every machine.

- For an **app**, commit `pubspec.lock` to version control.
- For a **package** you publish, it matters less, since users resolve their own versions.

## Keeping packages up to date

```bash
dart pub outdated          # what could be upgraded
dart pub upgrade           # newest versions allowed by your constraints
dart pub upgrade --major-versions   # also move to new major versions
dart pub remove http       # drop a package
dart pub deps              # show the dependency tree
```

## Choosing a good package

Anyone can publish to pub.dev, so look before you depend on something.

| Check | What to look for |
| --- | --- |
| Pub points | A score for documentation, analysis and platform support |
| Likes and downloads | Is it widely used? |
| Publisher | A verified publisher, such as `dart.dev` or `flutter.dev`, is a good sign |
| Last updated | Still maintained? Supports current Dart? |
| Platforms | Does it support the platforms you target? |
| Example and README | Clear documentation saves hours |
| Open issues | Visit the repository to see how problems are handled |
| Licence | Compatible with your project? |

Each dependency is code you must keep updated and trust. For a ten-line helper, writing it yourself is often better.

## Packages worth knowing

| Package | For |
| --- | --- |
| `http`, `dio` | Network requests |
| `path` | File path handling |
| `intl` | Dates, numbers and translations |
| `collection` | Extra collection utilities |
| `args` | Command-line arguments |
| `test` | Unit testing |
| `json_serializable`, `freezed` | Generating model classes |
| `logging` | Structured logging |

## Other dependency sources

```yaml
dependencies:
  # A folder on your machine, useful while developing two packages together
  my_utils:
    path: ../my_utils

  # Straight from a Git repository
  some_fork:
    git:
      url: https://github.com/someone/some_fork.git
      ref: main
```

## Try it yourself

Create a project, add the `intl` package, and print today's date formatted as `10 October 2026`. Then run `dart pub outdated` and `dart pub deps` and read what they report.
