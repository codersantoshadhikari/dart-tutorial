---
title: "Comments in Dart: Single-Line, Multi-Line and Doc Comments"
linkTitle: "Comments"
description: "Learn the three kinds of comments in Dart, when to use each, and how documentation comments turn into API docs."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart comments"
  - "dart doc comments"
  - "dart documentation"
aliases:
  - "/introduction/comments/"
  - "/fr/introduction/comments/"
---

A comment is a note in your code that Dart ignores. Comments are for people: your teammates, and you in six months.

## Single-line comments

Everything after `//` on a line is ignored.

```dart
void main() {
  // Price before tax.
  var price = 200;

  var total = price * 1.13; // 13% VAT
  print(total);
}
```

```output
226.0
```

## Multi-line comments

Text between `/*` and `*/` is ignored, across as many lines as you like. This form is mostly used to switch off a block of code for a moment.

```dart
void main() {
  /*
  print('This line will not run.');
  print('Neither will this one.');
  */
  print('Only this line runs.');
}
```

```output
Only this line runs.
```

## Documentation comments

A comment that starts with `///` documents the thing directly below it. Editors show it when you hover over the name, and the `dart doc` command turns these comments into a website.

```dart
/// Returns the area of a rectangle.
///
/// Both [width] and [height] must be zero or greater.
double area(double width, double height) {
  return width * height;
}

void main() {
  print(area(4, 2.5));
}
```

```output
10.0
```

Putting a name in square brackets, as in `[width]`, links to that parameter, class or function in the generated docs.

## Writing comments that help

Good comments explain **why**, because the code already says **what**.

```dart
// Not useful: repeats the code.
// Add 1 to count.
count = count + 1;

// Useful: explains the reason.
// The API counts pages from 1, but our list starts at 0.
count = count + 1;
```

A few habits worth copying:

- Start doc comments with a short sentence that says what the thing does.
- Delete commented-out code before you commit. Version control remembers it for you.
- Write `// TODO: ...` for work you plan to come back to. Editors list these for you.
- If a comment has to explain confusing code, try renaming variables or splitting the function first.

## Quick reference

| Syntax | Name | Use it for |
| --- | --- | --- |
| `// text` | Single-line | Short notes |
| `/* text */` | Multi-line | Temporarily disabling code |
| `/// text` | Documentation | Describing classes, functions and fields |

## Try it yourself

Write a function `double celsiusToFahrenheit(double c)` and give it a doc comment that explains the formula. Hover over the function name in your editor and check that your comment appears.
