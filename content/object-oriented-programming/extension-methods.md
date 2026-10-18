---
title: "Extension Methods in Dart"
linkTitle: "Extension methods"
description: "Add new methods and getters to existing types in Dart with extensions, including String, int, List and nullable types."
weight: 14
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart extension methods"
  - "extension on"
  - "extend String"
  - "add method to class dart"
aliases:
  - "/advanced-classes/extension-methods/"
  - "/fr/advanced-classes/extension-methods/"
---

An **extension** adds new methods, getters and operators to a type you did not write and cannot change, such as `String`, `int` or `List`. The new members then look and feel as if they had always been there.

## Without and with an extension

Without one, you write a helper function and the call reads inside out:

```text
capitalize(name.trim())
```

With one, it chains naturally:

```dart
extension StringExtras on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isBlank => trim().isEmpty;
}

void main() {
  print('dart'.capitalize());
  print('  hello  '.trim().capitalize());
  print('   '.isBlank);
}
```

```output
Dart
Hello
true
```

Inside the extension, `this` is the value the method was called on. Members of that value, like `isEmpty` and `substring`, can be used directly.

## Extending numbers

```dart
extension NumExtras on int {
  bool get isPrime {
    if (this < 2) return false;
    for (var i = 2; i * i <= this; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }

  Duration get seconds => Duration(seconds: this);
  String padded(int width) => toString().padLeft(width, '0');
}

void main() {
  print(17.isPrime);
  print(90.seconds);
  print(7.padded(3));
}
```

```output
true
0:01:30.000000
007
```

## Generic extensions

An extension on `List<T>` or `Iterable<T>` works for every element type.

```dart
extension IterableExtras<T> on Iterable<T> {
  /// Splits the items into groups of [size].
  List<List<T>> chunked(int size) {
    final all = toList();
    return [
      for (var i = 0; i < all.length; i += size)
        all.sublist(i, i + size > all.length ? all.length : i + size),
    ];
  }
}

extension NumberListExtras on Iterable<num> {
  num get sum => fold(0, (a, b) => a + b);
  double get average => isEmpty ? 0 : sum / length;
}

void main() {
  print([1, 2, 3, 4, 5].chunked(2));
  print([10, 20, 30].sum);
  print([10, 20, 30].average);
}
```

```output
[[1, 2], [3, 4], [5]]
60
20.0
```

## Extensions on nullable types

An extension on `String?` can be called even when the value is null, which makes tidy helpers.

```dart
extension NullableStringExtras on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String orDefault(String fallback) => isNullOrEmpty ? fallback : this!;
}

void main() {
  String? name;
  print(name.isNullOrEmpty);
  print(name.orDefault('Anonymous'));
}
```

```output
true
Anonymous
```

## Extending your own types, including enums

```dart
enum Priority { low, medium, high }

extension PriorityLabel on Priority {
  String get label => switch (this) {
        Priority.low => 'Can wait',
        Priority.medium => 'This week',
        Priority.high => 'Do it now',
      };
}

void main() => print(Priority.high.label);
```

```output
Do it now
```

## How extensions really work

An extension does not change the class. It is syntax for calling a static function, chosen by the **declared type** of the variable at compile time. Three consequences:

- Extension methods do **not** work on `dynamic` values.
- If the class already has a member with the same name, the class member wins.
- Extensions cannot add fields (stored state) or constructors.

To use an extension from another file, import that file. If two imported extensions clash, hide one with `import '...' hide ExtensionName;` or call it explicitly as `StringExtras('text').capitalize()`.

## When to use them

Good: small, general helpers that read naturally on the type, such as `date.isToday`, `list.sum` and `text.capitalize()`. Not so good: business logic that belongs in your own classes, or names so generic they confuse readers about where a method came from.

## Try it yourself

Write an extension on `String` with `int get wordCount` and `String truncate(int max)` that cuts long text and adds `...`. Then write one on `DateTime` with a `bool get isWeekend` getter.
