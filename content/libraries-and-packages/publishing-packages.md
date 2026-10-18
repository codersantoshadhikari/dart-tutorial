---
title: "Creating and Publishing a Dart Package"
linkTitle: "Publishing packages"
description: "Step-by-step guide to creating a Dart package and publishing it on pub.dev: structure, pubspec, docs, tests, versioning and dart pub publish."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "publish dart package"
  - "dart pub publish"
  - "create package"
  - "pub.dev publishing"
  - "semantic versioning"
  - "CHANGELOG"
aliases:
  - "/libraries-and-packages/creating-and-publishing-packages/"
  - "/fr/libraries-and-packages/creating-and-publishing-packages/"
---

Publishing a package is how you share reusable code with every Dart developer. It is also a good way to sharpen your skills, since publishing forces you to think about API design, documentation and testing.

## 1. Create the package

```bash
dart create -t package string_tools
cd string_tools
```

For a package containing Flutter widgets, use `flutter create --template=package`.

```text
string_tools/
  lib/
    string_tools.dart       # public API: exports
    src/
      string_tools_base.dart # implementation
  test/
    string_tools_test.dart
  example/
    string_tools_example.dart
  pubspec.yaml
  README.md
  CHANGELOG.md
  LICENSE
  analysis_options.yaml
```

## 2. Write the code

```dart
// File: lib/src/casing.dart

/// Extra helpers for changing the case of a [String].
extension Casing on String {
  /// Returns this string with its first letter in upper case.
  ///
  /// For example, `'dart'.capitalized` is `'Dart'`.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Converts `hello world` to `Hello World`.
  String get titleCase =>
      split(' ').map((word) => word.capitalized).join(' ');
}
```

```dart
// File: lib/string_tools.dart

/// Small, dependency-free string utilities.
library;

export 'src/casing.dart';
```

Every public member should have a `///` doc comment. They become your API reference on pub.dev.

## 3. Fill in pubspec.yaml

```yaml
name: string_tools
description: >-
  Small, dependency-free helpers for working with strings:
  capitalising, title case and more.
version: 1.0.0
repository: https://github.com/your-name/string_tools
issue_tracker: https://github.com/your-name/string_tools/issues
topics:
  - strings
  - utilities

environment:
  sdk: ^3.5.0

dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.0
```

- `name` must be unique on pub.dev, lower case with underscores.
- `description` should be 60 to 180 characters. It appears in search results.
- Keep `dependencies` as few and as loosely constrained as you can.

## 4. Write tests

```dart
// File: test/string_tools_test.dart
import 'package:string_tools/string_tools.dart';
import 'package:test/test.dart';

void main() {
  group('capitalized', () {
    test('upper-cases the first letter', () {
      expect('dart'.capitalized, 'Dart');
    });

    test('leaves an empty string alone', () {
      expect(''.capitalized, '');
    });
  });

  test('titleCase capitalises every word', () {
    expect('hello dart world'.titleCase, 'Hello Dart World');
  });
}
```

```bash
dart test
```

## 5. Write the supporting files

| File | What goes in it |
| --- | --- |
| `README.md` | What the package does, how to install it, a short usage example. This is your pub.dev front page |
| `CHANGELOG.md` | What changed in each version, newest first |
| `LICENSE` | An open-source licence such as MIT or BSD-3-Clause. Required |
| `example/` | A small runnable program showing typical use |

A minimal changelog:

```text
## 1.0.0

- Initial release with `capitalized` and `titleCase`.
```

## 6. Check everything

```bash
dart format .
dart analyze
dart test
dart doc              # build the API docs locally and read them
dart pub publish --dry-run
```

The dry run reports problems without publishing: missing files, a description that is too short, an invalid version. Fix every warning. Your pub points depend on it.

## 7. Publish

```bash
dart pub publish
```

You will be asked to sign in with a Google account the first time. Within a few minutes the package is live at `pub.dev/packages/string_tools`.

**Publishing is permanent.** A published version cannot be deleted, so that projects depending on it never break. You can only mark a version as retracted or the package as discontinued. Check for secrets, such as API keys, before you publish.

## 8. Release updates

Follow semantic versioning strictly. Users rely on it.

| Change | Version bump | Example |
| --- | --- | --- |
| Bug fix, no API change | Patch | 1.0.0 to 1.0.1 |
| New feature, compatible | Minor | 1.0.1 to 1.1.0 |
| Removed or changed existing API | Major | 1.1.0 to 2.0.0 |

For each release: update `version` in `pubspec.yaml`, add a `CHANGELOG.md` entry, run the checks, and publish again.

Before removing something, mark it `@Deprecated('Use newName instead')` for a release or two so users have time to move.

## Tips for a package people trust

- Create a **verified publisher** on pub.dev linked to a domain you own. It shows a badge and lets a team manage packages.
- Keep the public API small. Everything you expose is something you must keep working.
- Support a reasonable range of SDK versions.
- Answer issues, even briefly.
- Add `topics` and screenshots to help people find the package.

## Without publishing

You can share a package privately without pub.dev: depend on it by `path` or `git`, as shown in [using packages](/libraries-and-packages/pub-packages/).

## Try it yourself

Create a package containing one or two utilities you have written during this course. Add doc comments, tests, a README and a changelog, and run `dart pub publish --dry-run` until it reports no warnings. Publishing for real is optional.
