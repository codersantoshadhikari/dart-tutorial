---
title: "Dart vs Python: Differences, Code Comparison and Which to Learn"
seoTitle: "Dart vs Python: Code Comparison and Which to Learn"
linkTitle: "Dart vs Python"
description: "Dart vs Python compared with side-by-side code: syntax, types, null safety, lists, classes, async, speed and jobs. Find out which language to learn first."
weight: 7
date: 2026-10-16
lastmod: 2026-10-16
keywords:
  - "dart vs python"
  - "dart or python"
  - "dart for python developers"
  - "python vs dart performance"
  - "should i learn dart or python"
faq:
  - q: "Is Dart easier than Python?"
    a: "Python has slightly simpler syntax for a first program, but Dart is not hard. Dart's types and editor hints catch many beginner mistakes before the program runs, which many learners find helpful."
  - q: "Is Dart faster than Python?"
    a: "For most code, yes. Dart compiles to native machine code and is usually many times faster than standard CPython for loops and calculations. Python is fast when the work happens inside libraries written in C, such as NumPy."
  - q: "Should I learn Dart or Python first?"
    a: "Learn Dart first if your goal is mobile or desktop apps with Flutter. Learn Python first if your goal is data science, machine learning, automation or scripting. The ideas you learn carry over to the other language."
---

**Python** is the most popular first language for data science, automation and scripting. **Dart** is the language of **Flutter**, used to build apps for Android, iOS, web and desktop from one codebase. If you know Python, you already understand most of Dart's ideas. This page shows the same code in both languages.

## At a glance

| | Dart | Python |
| --- | --- | --- |
| Typing | Static and sound, with type inference | Dynamic (optional type hints) |
| Null | Sound null safety: `String?` can be null, `String` cannot | Any variable can be `None` |
| Blocks | Curly braces `{ }` and semicolons | Indentation |
| Runs as | Native code, JavaScript or WebAssembly | Interpreted (CPython) |
| Speed | Fast, compiled | Slower for pure-Python loops |
| Main uses | Flutter apps, CLI tools, servers | Data science, AI, scripting, web back ends |
| Packages | pub.dev (`dart pub add`) | PyPI (`pip install`) |

## Hello world and variables

```python
# Python
name = "Asha"
age = 21
print(f"{name} is {age}")
```

```dart
void main() {
  var name = 'Asha';   // type inferred: String
  int age = 21;        // or write the type
  print('$name is $age');
}
```

```output
Asha is 21
```

Dart code lives in functions; a program starts at `main()`. Every statement ends with `;`. String interpolation uses `$` instead of Python's f-strings.

## Types catch mistakes early

```python
age = 21
age = "twenty-one"   # Python allows this
```

```dart
void main() {
  var age = 21;
  // age = 'twenty-one';  // compile error: a String can't be assigned to an int
  age += 1;
  print(age);
}
```

```output
22
```

In Dart, the editor underlines the mistake before you run anything. See [variables](/dart-basics/variables/) and [data types](/dart-basics/data-types/).

## None vs null

```dart
String? findCity(String name) => name == 'Asha' ? 'Kathmandu' : null;

void main() {
  print(findCity('Asha') ?? 'unknown');
  print(findCity('Ravi') ?? 'unknown');
}
```

```output
Kathmandu
unknown
```

Python's `x if x is not None else default` becomes `x ?? default`. Dart will not let you use a `String?` as a `String` until you handle the null case. See [null safety](/null-safety/null-safety-in-dart/).

## if, loops and ranges

```python
for i in range(1, 4):
    if i % 2 == 0:
        print(i, "even")
    else:
        print(i, "odd")
```

```dart
void main() {
  for (var i = 1; i < 4; i++) {
    if (i % 2 == 0) {
      print('$i even');
    } else {
      print('$i odd');
    }
  }
}
```

```output
1 odd
2 even
3 odd
```

Python's `elif` is `else if` in Dart. There is no `range()`; use a classic `for` loop or `List.generate`. See [if else](/control-flow/if-else/) and [loops](/control-flow/loops/).

## Lists and dictionaries

```python
nums = [1, 2, 3, 4]
squares = [n * n for n in nums if n % 2 == 0]
ages = {"Asha": 21, "Ravi": 25}
```

```dart
void main() {
  final nums = [1, 2, 3, 4];
  final squares = [for (final n in nums) if (n.isEven) n * n];
  final ages = {'Asha': 21, 'Ravi': 25};

  print(squares);
  print(ages['Ravi']);
  print(nums.where((n) => n > 2).toList());
}
```

```output
[4, 16]
25
[3, 4]
```

A Python list is a Dart `List`, a dict is a `Map`, and a set is a `Set`. Dart even has list comprehensions: `[for (...) if (...) value]`. See [lists](/collections/lists/), [maps](/collections/maps/) and [collection if and for](/collections/spread-and-collection-if/).

## Functions

```python
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"
```

```dart
String greet(String name, {String greeting = 'Hello'}) => '$greeting, $name!';

void main() {
  print(greet('Asha'));
  print(greet('Ravi', greeting: 'Namaste'));
}
```

```output
Hello, Asha!
Namaste, Ravi!
```

Python keyword arguments map to Dart **named parameters** in `{ }`. See [function parameters](/functions/function-parameters/).

## Classes

```python
class Dog:
    def __init__(self, name):
        self.name = name
    def bark(self):
        return f"{self.name} says woof"
```

```dart
class Dog {
  final String name;
  Dog(this.name);

  String bark() => '$name says woof';
}

void main() {
  final dog = Dog('Bruno');
  print(dog.bark());
}
```

```output
Bruno says woof
```

No `self`, no `__init__`: `Dog(this.name)` is the constructor. Fields starting with `_` are private to the file, like Python's `_name` convention but enforced. See [classes and objects](/object-oriented-programming/classes-and-objects/).

## async and await

Both languages use `async` and `await`. Python's coroutine is Dart's `Future`.

```dart
Future<String> download() async {
  await Future.delayed(const Duration(milliseconds: 500));
  return 'data ready';
}

Future<void> main() async {
  print('Start');
  print(await download());
}
```

```output
Start
data ready
```

Dart has no `asyncio.run()`: the event loop is built in. See the [async and await lesson](/async/async-await/).

## Errors

```dart
void main() {
  try {
    print(int.parse('abc'));
  } on FormatException catch (e) {
    print('Not a number: ${e.source}');
  } finally {
    print('done');
  }
}
```

```output
Not a number: abc
done
```

Python's `except ValueError as e` becomes `on FormatException catch (e)`. See [exceptions](/error-handling/exceptions/).

## Which should you learn?

- **You want to build mobile apps** for Android and iOS, or desktop apps: learn **Dart** and then [Flutter](https://flutter.dart-tutorial.dev/).
- **You want data science, machine learning or AI**: learn **Python**.
- **You want automation and small scripts**: both work; Python has more ready-made libraries.
- **You already know Python**: you can learn Dart in a week or two. Follow the [Dart and Flutter roadmap](/learn-dart-and-flutter/) and move quickly through the first stage.

Both languages are free, well paid and in demand in the USA, Canada, Europe, Australia, India and Nepal. Many developers use Python for back-end and data work and Dart for the app on top. Also see [Dart vs JavaScript](/getting-started/dart-vs-javascript/).
