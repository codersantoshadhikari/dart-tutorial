---
title: "Strings in Dart: Interpolation, Methods and Multi-Line Text"
linkTitle: "Strings"
description: "Create and work with strings in Dart: quotes, interpolation, multi-line and raw strings, common methods, and StringBuffer."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart string"
  - "string interpolation"
  - "dart string methods"
  - "StringBuffer"
  - "multiline string"
aliases:
  - "/introduction/strings-in-dart/"
  - "/fr/introduction/strings-in-dart/"
---

A `String` is a piece of text. You can write one with single or double quotes; Dart style uses single quotes unless the text itself contains one.

```dart
void main() {
  var a = 'Hello';
  var b = "It's easy";
  print('$a. $b.');
}
```

```output
Hello. It's easy.
```

## String interpolation

Put `$name` inside a string to insert a variable. Wrap any other expression in `${ }`.

```dart
void main() {
  var item = 'coffee';
  var price = 3.5;
  var qty = 2;

  print('$qty x $item = ${price * qty}');
  print('${item.toUpperCase()} has ${item.length} letters');
}
```

```output
2 x coffee = 7.0
COFFEE has 6 letters
```

## Joining strings

```dart
void main() {
  var first = 'Dart';
  var second = 'Tutorial';

  print(first + ' ' + second);  // works
  print('$first $second');      // preferred
  print('Dart ' 'Tutorial');    // neighbouring literals join automatically
}
```

```output
Dart Tutorial
Dart Tutorial
Dart Tutorial
```

## Multi-line and raw strings

Three quotes let a string run over several lines. An `r` before the quote makes a raw string, where `\` and `$` are just characters.

```dart
void main() {
  var poem = '''
Roses are red,
Dart is blue.''';
  print(poem);

  print('Tab:\tdone');
  print(r'C:\new\table costs $5');
}
```

```output
Roses are red,
Dart is blue.
Tab:	done
C:\new\table costs $5
```

Common escapes are `\n` (new line), `\t` (tab), `\'` (quote), `\\` (backslash) and `\$` (dollar sign).

## Methods you will use constantly

```dart
void main() {
  var text = '  Learn Dart Today  ';
  var clean = text.trim();

  print(clean.length);
  print(clean.toLowerCase());
  print(clean.contains('Dart'));
  print(clean.startsWith('Learn'));
  print(clean.indexOf('Dart'));
  print(clean.substring(6, 10));
  print(clean.replaceAll('Today', 'Now'));
  print(clean.split(' '));
  print('7'.padLeft(3, '0'));
  print(clean.isEmpty);
}
```

```output
16
learn dart today
true
true
6
Dart
Learn Dart Now
[Learn, Dart, Today]
007
false
```

## Strings cannot be changed in place

A string is immutable. Methods such as `toUpperCase` return a **new** string and leave the original alone.

```dart
void main() {
  var word = 'dart';
  word.toUpperCase();        // result thrown away
  print(word);
  word = word.toUpperCase(); // keep the result
  print(word);
}
```

```output
dart
DART
```

## Characters and comparison

```dart
void main() {
  var word = 'Dart';
  print(word[0]);
  print(word[word.length - 1]);
  print(word == 'Dart');             // compares the text
  print('apple'.compareTo('banana')); // negative: apple sorts first
}
```

```output
D
t
true
-1
```

## Building long strings with StringBuffer

When you add to a string many times in a loop, a `StringBuffer` is faster than `+`.

```dart
void main() {
  var buffer = StringBuffer();
  for (var i = 1; i <= 3; i++) {
    buffer.write('Line $i');
    buffer.write('; ');
  }
  print(buffer.toString());
}
```

```output
Line 1; Line 2; Line 3; 
```

## Try it yourself

Take the string `'  flutter AND dart  '`. Trim it, make it lower case, replace `and` with `&`, and print how many characters the result has.
