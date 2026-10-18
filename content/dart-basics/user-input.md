---
title: "Reading User Input in Dart with stdin"
linkTitle: "User input"
description: "Read text and numbers typed by the user in a Dart console program using stdin.readLineSync, with safe parsing and validation."
weight: 10
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart user input"
  - "stdin readLineSync"
  - "dart io"
  - "console input"
  - "read number dart"
---

So far your programs have only talked. To listen, a console program reads from **standard input** using the `dart:io` library.

> `dart:io` does not work in DartPad or in the browser. Save these examples to a file and run them with `dart run file.dart`.

## Reading a line of text

```dart
import 'dart:io';

void main() {
  stdout.write('What is your name? ');
  String? name = stdin.readLineSync();

  print('Nice to meet you, $name!');
}
```

```output
What is your name? Priya
Nice to meet you, Priya!
```

Two things to notice:

- `stdout.write` prints **without** a new line, so the cursor stays next to the question.
- `readLineSync` returns `String?`. The `?` means the result can be `null`, which happens when there is no more input.

## Dealing with the possible null

Give a fallback with `??` so the rest of your code has a real `String`.

```dart
import 'dart:io';

void main() {
  stdout.write('City: ');
  final city = stdin.readLineSync()?.trim() ?? '';

  if (city.isEmpty) {
    print('You did not type anything.');
  } else {
    print('$city sounds lovely.');
  }
}
```

## Reading a number

Input always arrives as text. Convert it with `tryParse` and check the result.

```dart
import 'dart:io';

void main() {
  stdout.write('Enter your age: ');
  final age = int.tryParse(stdin.readLineSync() ?? '');

  if (age == null) {
    print('That is not a whole number.');
  } else {
    print('In 10 years you will be ${age + 10}.');
  }
}
```

```output
Enter your age: 24
In 10 years you will be 34.
```

## Asking until the answer is valid

```dart
import 'dart:io';

int askForNumber(String question) {
  while (true) {
    stdout.write(question);
    final value = int.tryParse(stdin.readLineSync() ?? '');
    if (value != null) return value;
    print('Please type a whole number.');
  }
}

void main() {
  final a = askForNumber('First number: ');
  final b = askForNumber('Second number: ');
  print('$a + $b = ${a + b}');
}
```

```output
First number: ten
Please type a whole number.
First number: 10
Second number: 5
10 + 5 = 15
```

## Reading several values on one line

```dart
import 'dart:io';

void main() {
  stdout.write('Enter numbers separated by spaces: ');
  final line = stdin.readLineSync() ?? '';

  final numbers = line
      .split(' ')
      .map(int.tryParse)
      .whereType<int>()
      .toList();

  print('Sum: ${numbers.fold(0, (a, b) => a + b)}');
}
```

## Try it yourself

Write a tip calculator. Ask for the bill amount and the tip percentage, then print the tip and the total with two decimal places. Make sure it does not crash when the user types letters.
