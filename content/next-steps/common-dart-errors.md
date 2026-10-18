---
title: "Common Dart Errors and How to Fix Them: A Troubleshooting Guide"
seoTitle: "Common Dart Errors and How to Fix Them"
linkTitle: "Fix common errors"
description: "Fix the most common Dart errors fast: null check errors, LateInitializationError, RangeError, FormatException, type errors, Bad state and pub errors."
weight: 5
date: 2026-10-16
lastmod: 2026-10-16
keywords:
  - "dart errors"
  - "dart error fix"
  - "null check operator used on a null value"
  - "LateInitializationError"
  - "dart troubleshooting"
  - "type is not a subtype of type"
  - "Bad state: No element"
faq:
  - q: "How do I read a Dart error message?"
    a: "Read the first line for the error type and message, then find the first line of the stack trace that points to your own file (not dart:core or a package). That file and line number is usually where the fix belongs."
  - q: "What is the difference between a compile-time error and a runtime error in Dart?"
    a: "A compile-time error is found by the analyzer before the program runs, and is shown with a red underline in your editor. A runtime error (an exception) happens while the program is running, for example when a list index is out of range."
  - q: "Why does my editor show no error but the program crashes?"
    a: "Some problems can only be seen at run time: bad user input, a missing file, a server returning unexpected JSON, or a ! on a value that turned out to be null. Handle these cases with checks, tryParse and try/catch."
---

Every Dart developer sees the same errors again and again. This guide lists the most common ones, explains **what each error means in plain words**, and shows **how to fix it**. Use your browser's search (Ctrl+F or Cmd+F) to jump to the message you are seeing.

There are two kinds of errors:

| Kind | When you see it | Example |
| --- | --- | --- |
| **Compile-time error** | In the editor, before the program runs (red underline) | `The argument type 'String?' can't be assigned...` |
| **Runtime error** (exception) | While the program runs | `Null check operator used on a null value` |

Compile-time errors are the friendly kind: Dart stops you before anything goes wrong. Start by reading [how to read an error](#how-to-read-a-dart-error-and-stack-trace) if stack traces look confusing.

## How to read a Dart error and stack trace

```text
Unhandled exception:
RangeError (index): Invalid value: Not in inclusive range 0..2: 3
#0      List.[] (dart:core-patch/growable_array.dart:264:36)
#1      printThird (file:///home/asha/app/bin/app.dart:6:15)
#2      main (file:///home/asha/app/bin/app.dart:2:3)
```

1. **The first line after "Unhandled exception"** is the error type and message: `RangeError`, the index was 3 but the valid range is 0 to 2.
2. **The numbered lines** are the stack trace, newest call first.
3. **Skip lines from `dart:` and packages** and find the first line in *your* file: `app.dart:6:15` means line 6, column 15. Start looking there.

## Null safety errors

### The argument type 'String?' can't be assigned to the parameter type 'String'

**Meaning:** you are passing a value that *might* be null to something that requires a value.

```dart
String? readName() => null;

void greet(String name) => print('Hello, $name');

void main() {
  final name = readName();
  // greet(name);            // Error: 'String?' can't be assigned to 'String'
  greet(name ?? 'Guest');    // Fix 1: give a default value
  if (name != null) {
    greet(name);             // Fix 2: check first, Dart then knows it is a String
  }
}
```

```output
Hello, Guest
```

The same idea fixes **"The property 'length' can't be unconditionally accessed because the receiver can be 'null'"**: use `name?.length`, `name ?? ''` or an `if` check. See [Null safety in Dart](/null-safety/null-safety-in-dart/) and [null-aware operators](/null-safety/null-aware-operators/).

### Null check operator used on a null value

**Meaning:** you used `!` on a value that was `null` at run time. The `!` operator means "I promise this is not null", and the promise was broken.

```dart
void main() {
  final scores = {'Asha': 90};

  // print(scores['Ravi']! + 1); // Crash: Null check operator used on a null value

  final ravi = scores['Ravi'];
  if (ravi == null) {
    print('No score for Ravi yet');
  } else {
    print(ravi + 1);
  }
}
```

```output
No score for Ravi yet
```

**Rule of thumb:** search your code for `!` and replace each one you are not 100% sure about with `??`, `?.` or an `if` check.

### LateInitializationError: Field 'x' has not been initialized

**Meaning:** a `late` variable was read before anything was assigned to it.

```dart
class Profile {
  late String name;          // promised to be set later
  String? nickname;          // or: allow null instead of using late
}

void main() {
  final p = Profile();
  // print(p.name);          // Crash: LateInitializationError
  p.name = 'Asha';
  print(p.name);
  print(p.nickname ?? 'no nickname');
}
```

```output
Asha
no nickname
```

Fix it by assigning the value in the constructor, giving it a default, or making the type nullable. Read more in [late variables](/null-safety/late-variables/).

### Non-nullable instance field 'name' must be initialized

**Meaning:** a class field of a non-nullable type has no value when the object is created.

```dart
class User {
  final String name;
  int age = 0;               // Fix 1: a default value

  User(this.name);           // Fix 2: set it in the constructor
}

void main() {
  final u = User('Asha');
  print('${u.name} ${u.age}');
}
```

```output
Asha 0
```

## Type errors

### A value of type 'double' can't be assigned to a variable of type 'int'

```dart
void main() {
  // int half = 7 / 2;       // Error: / always returns a double
  int half = 7 ~/ 2;         // Fix 1: integer division
  int rounded = (7 / 2).round(); // Fix 2: round the double
  double exact = 7 / 2;      // Fix 3: use a double
  print('$half $rounded $exact');
}
```

```output
3 4 3.5
```

### type 'String' is not a subtype of type 'int'

**Meaning:** at run time, a value had a different type than your code expected. This happens most often with **JSON** and `dynamic` data.

```dart
import 'dart:convert';

void main() {
  final data = jsonDecode('{"age": "21"}'); // the server sent age as text

  // int age = data['age'];  // Crash: type 'String' is not a subtype of type 'int'

  final raw = data['age'];
  final age = raw is int ? raw : int.tryParse('$raw') ?? 0;
  print(age + 1);
}
```

```output
22
```

Fix it by checking the type with `is`, converting with `int.tryParse`, or fixing the data at the source. See [JSON in Dart](/practical-dart/json/) and [type conversion](/dart-basics/type-conversion/).

### The method 'x' isn't defined for the type 'Object'

**Meaning:** the variable's type does not have that method. Often the variable is `Object` or the wrong class.

```dart
void main() {
  Object value = 'hello';
  // print(value.toUpperCase()); // Error: isn't defined for the type 'Object'

  if (value is String) {
    print(value.toUpperCase());  // inside the if, Dart knows it is a String
  }
}
```

```output
HELLO
```

If the method belongs to your own class, check the spelling and that the file is imported.

## Collection errors

### RangeError (index): Invalid value: Not in inclusive range

**Meaning:** you asked for a list position that does not exist. Indexes start at **0**, so the last item is at `length - 1`.

```dart
void main() {
  final fruits = ['apple', 'banana', 'mango'];

  // print(fruits[3]);           // Crash: valid indexes are 0..2

  print(fruits[fruits.length - 1]); // the last item
  print(fruits.last);               // simpler

  const i = 5;
  print(i < fruits.length ? fruits[i] : 'no item at $i');
}
```

```output
mango
mango
no item at 5
```

A `for` loop written as `i <= list.length` is the classic cause. Use `i < list.length`, or better, `for (final item in list)`.

### Bad state: No element

**Meaning:** you called `first`, `last`, `single`, `reduce` or `firstWhere` on a list with no matching items.

```dart
void main() {
  final numbers = <int>[1, 3, 5];

  // numbers.firstWhere((n) => n.isEven); // Crash: Bad state: No element

  final even = numbers.where((n) => n.isEven);
  print(even.isEmpty ? 'no even number' : even.first);

  print(numbers.isEmpty ? 0 : numbers.reduce((a, b) => a + b));
}
```

```output
no even number
9
```

With `package:collection` you can also use `firstWhereOrNull`, which returns `null` instead of throwing.

### Unsupported operation: Cannot add to an unmodifiable list

**Meaning:** the list is `const` or was made with `List.unmodifiable`, so it cannot change.

```dart
void main() {
  const fixed = [1, 2, 3];
  // fixed.add(4);               // Crash: Cannot add to an unmodifiable list

  final growable = [...fixed];   // copy into a normal list
  growable.add(4);
  print(growable);
}
```

```output
[1, 2, 3, 4]
```

### Concurrent modification during iteration

**Meaning:** you added or removed items from a list while looping over it with `for-in` or `forEach`.

```dart
void main() {
  final tasks = ['buy milk', 'done: call mom', 'study Dart'];

  // for (final t in tasks) {
  //   if (t.startsWith('done')) tasks.remove(t); // Crash
  // }

  tasks.removeWhere((t) => t.startsWith('done')); // Fix
  print(tasks);
}
```

```output
[buy milk, study Dart]
```

## Parsing and input errors

### FormatException: Invalid radix-10 number

**Meaning:** `int.parse` or `double.parse` was given text that is not a number, such as `'abc'`, `''` or `' 42'`.

```dart
void main() {
  final inputs = ['42', ' 7 ', 'abc', ''];

  for (final text in inputs) {
    final n = int.tryParse(text.trim());   // null instead of a crash
    print(n == null ? '"$text" is not a number' : 'number: $n');
  }
}
```

```output
number: 42
number: 7
"abc" is not a number
"" is not a number
```

Always use `tryParse` for text that comes from users, files or the network. See [user input](/dart-basics/user-input/).

## Function and async errors

### The body might complete normally, causing 'null' to be returned

**Meaning:** a function promises to return a value, but some path through it returns nothing.

```dart
String grade(int score) {
  if (score >= 90) return 'A';
  if (score >= 75) return 'B';
  return 'C';              // Fix: every path now returns a String
}

void main() => print(grade(80));
```

```output
B
```

### My program prints `Instance of 'Future<String>'`

**Meaning:** you forgot `await`, so you printed the *promise of a value* instead of the value.

```dart
Future<String> loadUser() async {
  await Future.delayed(const Duration(milliseconds: 300));
  return 'Asha';
}

Future<void> main() async {
  // print(loadUser());      // prints: Instance of 'Future<String>'
  print(await loadUser());   // Fix: await the Future
}
```

```output
Asha
```

Also check that the calling function is marked `async`. An error thrown inside a Future you never `await` becomes an **unhandled exception**, so wrap awaited calls in `try` / `catch`. See [async and await](/async/async-await/) and [async error handling](/async/async-error-handling/).

### Stack Overflow

**Meaning:** a function called itself forever. Recursion needs a **base case** that stops it.

```dart
int factorial(int n) {
  if (n <= 1) return 1;        // base case: without it, Stack Overflow
  return n * factorial(n - 1);
}

void main() => print(factorial(5));
```

```output
120
```

A getter that returns itself (`int get age => age;`) causes the same crash. See [recursion](/functions/recursion/).

## Name and import errors

### Undefined name 'x' / Undefined class 'X'

- Check the **spelling and capital letters**: Dart is case-sensitive, so `myList` and `mylist` are different.
- Check that the variable is in **scope**: a variable made inside `{ }` does not exist outside it.
- Check the **import**. `jsonDecode` needs `import 'dart:convert';`, `sqrt` and `Random` need `import 'dart:math';`, `File` needs `import 'dart:io';`.
- For package classes, add the package with `dart pub add <name>` and import it. See [imports](/libraries-and-packages/imports/).

## Tooling and setup errors

| Error | Fix |
| --- | --- |
| `dart: command not found` / `'dart' is not recognized` | Dart is not on your PATH. Repeat the PATH step in [install Dart](/getting-started/install-dart/), then open a new terminal. |
| `version solving failed` | Two packages need different versions of a dependency. Run `dart pub outdated`, relax the version in `pubspec.yaml` (for example `^2.0.0`), then `dart pub upgrade`. |
| `Target of URI doesn't exist: 'package:...'` | Run `dart pub get`. If it still fails, check the package name in `pubspec.yaml`. |
| `The current Dart SDK version is X. Because app requires SDK version >=Y...` | Update Dart (`dart --version` to check), or lower the `sdk:` constraint in `pubspec.yaml`. |
| Editor shows old errors after a fix | Restart the Dart analysis server (VS Code: Command Palette, *Dart: Restart Analysis Server*). |

## A checklist when you are stuck

1. **Read the whole error message**, then the first stack-trace line in your file.
2. **Print the values** just before the failing line: `print('items=$items, i=$i');`. See [debugging](/tools-and-performance/debugging-and-devtools/).
3. **Shrink the problem**: copy the failing part into the [Dart online compiler](/playground/) until only the bug is left.
4. **Run `dart analyze`**: it often explains the problem before you run anything.
5. **Search the exact message** in quotes, or ask under the [dart tag on stackoverflow.com](https://stackoverflow.com/questions/tagged/dart) with the smallest code that shows the error.

Building Flutter apps? See [common Flutter errors and fixes](https://flutter.dart-tutorial.dev/next-steps/common-flutter-errors/).
