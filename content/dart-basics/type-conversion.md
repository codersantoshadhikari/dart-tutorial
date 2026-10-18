---
title: "Type Conversion in Dart: Converting Between Types"
linkTitle: "Type conversion"
description: "Convert between String, int, double, bool and collections in Dart using parse, tryParse, toString, toInt and friends."
weight: 9
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart type conversion"
  - "string to int"
  - "int to string"
  - "dart parse"
  - "tryParse"
  - "dart cast"
---

Dart never converts types behind your back. `'5' + 3` is an error, not `8` or `'53'`. When you need a different type, you ask for it.

## String to number

```dart
void main() {
  var a = int.parse('25');
  var b = double.parse('9.75');

  print(a + 5);
  print(b + 0.25);
}
```

```output
30
10.0
```

`parse` throws a `FormatException` when the text is not a valid number. For input you do not control, use `tryParse`, which returns `null` on failure.

```dart
void main() {
  var input = '12abc';
  var number = int.tryParse(input);

  if (number == null) {
    print('"$input" is not a whole number');
  } else {
    print(number * 2);
  }

  // Provide a fallback in one line.
  print(int.tryParse('oops') ?? 0);
}
```

```output
"12abc" is not a whole number
0
```

## Number to string

```dart
void main() {
  var n = 42;
  var price = 1234.5678;

  print(n.toString() + '!');
  print('$n!');                      // interpolation converts for you
  print(price.toStringAsFixed(2));
  print(255.toRadixString(16));      // hexadecimal
  print(5.toString().padLeft(2, '0'));
}
```

```output
42!
42!
1234.57
ff
05
```

## int and double

```dart
void main() {
  print(7.toDouble());
  print(7.9.toInt());   // drops the fraction
  print(7.9.round());   // nearest
  print(7.1.ceil());
  print(7.9.floor());
}
```

```output
7.0
7
8
8
7
```

## String to bool

There is no built-in conversion that guesses. Compare the text yourself, or use `bool.tryParse`, which accepts `'true'` and `'false'`.

```dart
void main() {
  var answer = 'Yes';
  var agreed = answer.toLowerCase() == 'yes';
  print(agreed);

  print(bool.tryParse('true'));
  print(bool.tryParse('maybe'));
}
```

```output
true
true
null
```

## Between collections

```dart
void main() {
  var list = [3, 1, 3, 2, 1];

  var unique = list.toSet();
  print(unique);
  print(unique.toList());

  var words = ['a', 'b', 'c'];
  print(words.join('-'));
  print('a-b-c'.split('-'));

  var texts = ['1', '2', '3'];
  var numbers = texts.map(int.parse).toList();
  print(numbers);
}
```

```output
{3, 1, 2}
[3, 1, 2]
a-b-c
[a, b, c]
[1, 2, 3]
```

## Casting with as

`as` does not convert anything. It tells Dart "trust me, this value already is that type", and it throws if you are wrong.

```dart
void main() {
  num n = 5;
  int i = n as int; // fine: n really holds an int
  print(i + 1);
}
```

```output
6
```

## Try it yourself

Given `var raw = ['10', '20', 'x', '30'];`, build a list of only the valid numbers using `int.tryParse`, then print their sum. You should get `60`.
