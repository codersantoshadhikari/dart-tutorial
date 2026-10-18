---
title: "Formatting and Linting Dart Code: dart format and dart analyze"
linkTitle: "Formatting and linting"
description: "Keep Dart code clean with dart format, dart analyze, lints and dart fix. Learn to configure analysis_options.yaml for your project."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart format"
  - "dart analyze"
  - "lints"
  - "analysis_options.yaml"
  - "dart fix"
  - "linter rules"
  - "code style dart"
aliases:
  - "/dart-dev-tools--debugging/linting-and-formatting/"
  - "/fr/dart-dev-tools--debugging/linting-and-formatting/"
---

Two tools keep a Dart codebase healthy without any effort from you. The **formatter** decides how code looks. The **analyzer** finds mistakes and questionable code before you run it.

## dart format

The formatter rewrites your files in the standard Dart style: indentation, spacing, line breaks.

```bash
dart format .                               # format everything in the project
dart format lib/main.dart                   # one file
dart format --output=none --set-exit-if-changed .   # check only, for CI
```

Before:

```dart
void main(){var names=['Asha','Bimal'];for(final n in names){print('Hello, $n');}}
```

After:

```dart
void main() {
  var names = ['Asha', 'Bimal'];
  for (final n in names) {
    print('Hello, $n');
  }
}
```

Why use it:

- Nobody argues about style in code reviews.
- Every Dart project looks familiar.
- Changes in version control show real edits, not whitespace.

Turn on **format on save** in your editor and forget about it. In VS Code, set `"editor.formatOnSave": true`.

## dart analyze

The analyzer reads your code without running it and reports three levels of problem.

```bash
dart analyze
```

```output
Analyzing my_app...

  error - lib/main.dart:4:16 - A value of type 'String' can't be assigned to a variable of type 'int'. - invalid_assignment
warning - lib/main.dart:2:8 - Unused import: 'dart:io'. - unused_import
   info - lib/main.dart:7:7 - The local variable 'x' isn't used. - unused_local_variable

3 issues found.
```

| Level | Meaning |
| --- | --- |
| Error | The code will not compile or will certainly fail |
| Warning | Probably a mistake |
| Info / lint | A style or best-practice suggestion |

Your editor runs the analyzer continuously and underlines the same problems as you type.

## Lints

Lints are extra rules that catch bad habits. New projects come with the official `lints` package (or `flutter_lints` for Flutter), configured in `analysis_options.yaml` at the project root.

```yaml
include: package:lints/recommended.yaml
```

| Rule set | Contains |
| --- | --- |
| `package:lints/core.yaml` | The essential rules |
| `package:lints/recommended.yaml` | Core plus widely agreed good practice |
| `package:flutter_lints/flutter.yaml` | Recommended plus Flutter-specific rules |

## Customising analysis_options.yaml

```yaml
include: package:lints/recommended.yaml

analyzer:
  language:
    strict-casts: true          # no implicit casts from dynamic
    strict-inference: true      # no silently inferred dynamic
    strict-raw-types: true      # List must be List<Something>
  errors:
    unused_import: error        # promote a warning to an error
    todo: ignore                # silence a diagnostic
  exclude:
    - "**/*.g.dart"             # skip generated code
    - build/**

linter:
  rules:
    prefer_single_quotes: true
    prefer_const_constructors: true
    prefer_final_locals: true
    always_declare_return_types: true
    avoid_print: true
    unawaited_futures: true
    avoid_dynamic_calls: true
    require_trailing_commas: false  # switch a rule off
```

The three `strict-*` options are well worth enabling in a new project.

## Lints worth knowing

| Rule | Catches |
| --- | --- |
| `avoid_print` | `print` calls left in production code |
| `unawaited_futures` | A future that is neither awaited nor marked `unawaited` |
| `prefer_const_constructors` | Missing `const`, which costs performance in Flutter |
| `prefer_final_locals` | Variables that are never reassigned but are not `final` |
| `avoid_dynamic_calls` | Method calls on `dynamic`, which are unchecked |
| `always_use_package_imports` | Inconsistent import styles |
| `cancel_subscriptions` | Stream subscriptions that are never cancelled |
| `use_build_context_synchronously` | Using a Flutter `BuildContext` after an `await` |

## dart fix: repair automatically

Many diagnostics come with an automatic fix.

```bash
dart fix --dry-run   # show what would change
dart fix --apply     # make the changes
```

This is also the quickest way to update a codebase after upgrading the SDK or a package.

## Ignoring a diagnostic

Occasionally a rule is wrong for one line. Silence it there, with a reason.

```dart
void main() {
  // ignore: avoid_print
  print('A command-line tool is allowed to print.');
}
```

`// ignore_for_file: rule_name` at the top applies to the whole file. Use both rarely. An ignore is a debt.

## Putting it in CI

Run the same checks on every push so that problems never reach the main branch.

```bash
dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
```

## Try it yourself

Take a file you wrote earlier in this course. Run `dart format` on it, then add `prefer_final_locals` and `avoid_print` to `analysis_options.yaml` and run `dart analyze`. Fix what it reports, using `dart fix --apply` for whatever can be automated.
