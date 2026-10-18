---
title: "Dart String Methods: Complete List with Easy Examples"
linkTitle: "String methods"
description: "Every common Dart string method with a short, runnable example: trim, toUpperCase, contains, substring, split, replaceAll, padLeft, parse and more."
weight: 5
date: 2026-10-15
lastmod: 2026-10-15
keywords:
  - "dart string methods"
  - "dart string functions"
  - "dart substring"
  - "dart split string"
  - "dart replaceAll"
  - "dart trim"
  - "dart string to int"
  - "dart string examples"
---

The [Strings](/dart-basics/strings/) lesson showed how to create text and use interpolation. This page is a reference you can come back to: the string methods you will use most, grouped by job, each with a tiny program you can run and change.

Remember one rule while you read: **strings never change**. Every method below returns a *new* string (or a value) and leaves the original alone.

## Quick reference table

| Method or property | What it does | Example | Result |
| --- | --- | --- | --- |
| `length` | Number of characters | `'Dart'.length` | `4` |
| `toUpperCase()` | All capitals | `'dart'.toUpperCase()` | `DART` |
| `toLowerCase()` | All small letters | `'DART'.toLowerCase()` | `dart` |
| `trim()` | Remove spaces at both ends | `'  hi  '.trim()` | `hi` |
| `contains(x)` | Is `x` inside? | `'Flutter'.contains('utt')` | `true` |
| `startsWith(x)` | Begins with `x`? | `'Dart'.startsWith('D')` | `true` |
| `endsWith(x)` | Ends with `x`? | `'main.dart'.endsWith('.dart')` | `true` |
| `indexOf(x)` | First position of `x`, or -1 | `'banana'.indexOf('a')` | `1` |
| `substring(a, b)` | Characters from `a` up to `b` | `'Flutter'.substring(0, 4)` | `Flut` |
| `split(x)` | Break into a list | `'a,b'.split(',')` | `[a, b]` |
| `replaceAll(a, b)` | Replace every `a` | `'a-b-c'.replaceAll('-', '+')` | `a+b+c` |
| `padLeft(n, x)` | Fill on the left to width `n` | `'7'.padLeft(3, '0')` | `007` |
| `isEmpty` | Has no characters? | `''.isEmpty` | `true` |
| `*` | Repeat | `'ab' * 3` | `ababab` |

## Changing case and removing spaces

```dart
void main() {
  var name = '  Dart Tutorial  ';

  print('[${name.trim()}]');
  print('[${name.trimLeft()}]');
  print('[${name.trimRight()}]');
  print(name.trim().toUpperCase());
  print(name.trim().toLowerCase());
}
```

```output
[Dart Tutorial]
[Dart Tutorial  ]
[  Dart Tutorial]
DART TUTORIAL
dart tutorial
```

The square brackets are only there so you can see where the spaces are. `trim()` is the first thing to call on anything a user types.

## Searching inside a string

```dart
void main() {
  var text = 'Learn Dart, then learn Flutter';

  print(text.contains('Dart'));
  print(text.contains('dart'));     // case matters
  print(text.startsWith('Learn'));
  print(text.endsWith('Flutter'));
  print(text.indexOf('learn'));
  print(text.indexOf('Flutter'));
  print(text.indexOf('Java'));      // -1 means not found
}
```

```output
true
false
true
true
17
23
-1
```

To search without caring about capitals, change both sides to the same case first: `text.toLowerCase().contains('dart')`.

## Getting part of a string

Positions start at **0**. `substring(start, end)` includes `start` and stops *before* `end`.

```dart
void main() {
  var word = 'Flutter';

  print(word.length);
  print(word[0]);                  // first character
  print(word[word.length - 1]);    // last character
  print(word.substring(0, 4));
  print(word.substring(4));        // from 4 to the end
}
```

```output
7
F
r
Flut
ter
```

## Splitting, joining and replacing

```dart
void main() {
  var csv = 'apple,banana,mango';

  var fruits = csv.split(',');
  print(fruits);
  print(fruits.length);
  print(fruits.join(' | '));

  print(csv.replaceAll(',', ' and '));
  print(csv.replaceFirst('apple', 'grape'));

  var messy = 'Dart   is    fun';
  print(messy.replaceAll(RegExp(r'\s+'), ' '));
}
```

```output
[apple, banana, mango]
3
apple | banana | mango
apple and banana and mango
grape,banana,mango
Dart is fun
```

`split` turns a string into a [List](/collections/lists/); `join` turns a list back into a string. The last line uses a [regular expression](/practical-dart/regular-expressions/) to squeeze many spaces into one.

## Padding and repeating

```dart
void main() {
  print('5'.padLeft(3, '0'));
  print('Hi'.padRight(6, '.') + '|');
  print('-' * 20);
  print('ab' * 3);

  for (var i = 1; i <= 3; i++) {
    print('Item ${i.toString().padLeft(2)}: ok');
  }
}
```

```output
005
Hi....|
--------------------
ababab
Item  1: ok
Item  2: ok
Item  3: ok
```

Padding is handy for invoice numbers (`007`) and for lining up columns in console output.

## Checking and comparing

```dart
void main() {
  print(''.isEmpty);
  print('   '.isEmpty);          // spaces are characters
  print('   '.trim().isEmpty);
  print('Dart'.isNotEmpty);

  print('Dart' == 'Dart');
  print('Dart' == 'dart');
  print('Dart'.toLowerCase() == 'dart');
  print('apple'.compareTo('banana')); // negative: apple comes first
}
```

```output
true
false
true
true
true
false
true
-1
```

## Converting strings to numbers and back

```dart
void main() {
  print(int.parse('42') + 8);
  print(double.parse('3.5') * 2);
  print(int.tryParse('abc'));        // null instead of a crash
  print(int.tryParse('abc') ?? 0);   // fall back to 0

  print(42.toString() + '!');
  print(3.14159.toStringAsFixed(2));
}
```

```output
50
7.0
null
0
42!
3.14
```

Use `int.parse` when you are sure the text is a number, and `int.tryParse` when it comes from a user. More in [Type conversion](/dart-basics/type-conversion/).

## Three small string programs

**Capitalise every word:**

```dart
void main() {
  var title = 'learn dart and flutter';

  var result = title
      .split(' ')
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');

  print(result);
}
```

```output
Learn Dart And Flutter
```

**Count the vowels:**

```dart
void main() {
  var text = 'Dart Tutorial';

  var vowels = text
      .toLowerCase()
      .split('')
      .where((c) => 'aeiou'.contains(c))
      .length;

  print('Vowels in "$text": $vowels');
}
```

```output
Vowels in "Dart Tutorial": 5
```

**Check for a palindrome:**

```dart
bool isPalindrome(String s) {
  var clean = s.toLowerCase();
  return clean == clean.split('').reversed.join();
}

void main() {
  for (var word in ['Level', 'Dart', 'Racecar']) {
    print('$word: ${isPalindrome(word)}');
  }
}
```

```output
Level: true
Dart: false
Racecar: true
```

## Common mistakes

- **Expecting the original to change.** `name.trim();` on its own does nothing useful. Write `name = name.trim();`.
- **Index out of range.** `'Dart'[4]` and `'Dart'.substring(2, 9)` throw a `RangeError`. Check `length` first.
- **Using `parse` on user input.** `int.parse('12a')` throws a `FormatException`. Use `tryParse`.
- **Joining many strings with `+` in a loop.** Use a `StringBuffer` instead, as shown in [Strings](/dart-basics/strings/#building-long-strings-with-stringbuffer).

## Try it yourself

Write a program that takes `'  hello WORLD from dart  '` and prints:

1. the text trimmed and in title case: `Hello World From Dart`
2. how many words it has: `4`
3. the words joined with `-` in lower case: `hello-world-from-dart`
