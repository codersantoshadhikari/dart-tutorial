---
title: "Dart Programming Examples: 30 Simple Programs with Output"
linkTitle: "30 Dart examples"
description: "30 easy Dart programming examples for beginners with code and output: hello world, even odd, factorial, Fibonacci, primes, palindrome, classes and async."
weight: 1
date: 2026-10-15
lastmod: 2026-10-15
keywords:
  - "dart examples"
  - "dart programming examples"
  - "dart code examples"
  - "dart programs for beginners"
  - "dart example programs with output"
  - "dart exercises with solutions"
  - "dart practice programs"
---

These are the small programs every beginner writes, solved in clear, modern Dart. Each one shows the code and the output. Press **Run** to try it in the browser, then **change it**: use other numbers, add a feature, break it on purpose and read the error. That is the fastest way to learn Dart.

The examples go from very easy to intermediate. If a keyword is new to you, follow the link under the example to the lesson that explains it.

## Basics

### 1. Hello, World

```dart
void main() {
  print('Hello, World!');
}
```

```output
Hello, World!
```

Explained in [Your first Dart program](/getting-started/first-dart-program/).

### 2. Add two numbers

```dart
void main() {
  int a = 12;
  int b = 30;
  print('Sum: ${a + b}');
}
```

```output
Sum: 42
```

### 3. Even or odd

```dart
void main() {
  for (var n in [7, 10]) {
    print('$n is ${n.isEven ? 'even' : 'odd'}');
  }
}
```

```output
7 is odd
10 is even
```

Uses the [ternary operator](/control-flow/ternary-operator/).

### 4. Largest of three numbers

```dart
import 'dart:math';

void main() {
  var a = 14, b = 27, c = 9;

  var largest = a;
  if (b > largest) largest = b;
  if (c > largest) largest = c;
  print('Largest: $largest');

  // The same thing in one line:
  print('Largest: ${[a, b, c].reduce(max)}');
}
```

```output
Largest: 27
Largest: 27
```

### 5. Simple calculator

```dart
double calculate(double a, String op, double b) => switch (op) {
      '+' => a + b,
      '-' => a - b,
      '*' => a * b,
      '/' => a / b,
      _ => throw ArgumentError('Unknown operator $op'),
    };

void main() {
  for (var op in ['+', '-', '*', '/']) {
    print('8 $op 2 = ${calculate(8, op, 2)}');
  }
}
```

```output
8 + 2 = 10.0
8 - 2 = 6.0
8 * 2 = 16.0
8 / 2 = 4.0
```

Uses a [switch expression](/records-and-patterns/switch-expressions/).

### 6. Temperature converter

```dart
void main() {
  var celsius = 25;
  var fahrenheit = celsius * 9 / 5 + 32;
  print('$celsius°C = ${fahrenheit.toStringAsFixed(1)}°F');

  var bodyTemp = 98.6;
  var inCelsius = (bodyTemp - 32) * 5 / 9;
  print('$bodyTemp°F = ${inCelsius.toStringAsFixed(1)}°C');
}
```

```output
25°C = 77.0°F
98.6°F = 37.0°C
```

### 7. Simple interest

```dart
void main() {
  var principal = 10000;
  var rate = 5;  // percent per year
  var years = 3;

  var interest = principal * rate * years / 100;
  print('Interest: $interest');
  print('Total: ${principal + interest}');
}
```

```output
Interest: 1500.0
Total: 11500.0
```

### 8. Leap year

```dart
bool isLeapYear(int year) =>
    (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

void main() {
  for (var year in [1900, 2000, 2024, 2026]) {
    print('$year: ${isLeapYear(year)}');
  }
}
```

```output
1900: false
2000: true
2024: true
2026: false
```

### 9. Grade from marks

```dart
String grade(int score) => switch (score) {
      >= 90 => 'A',
      >= 75 => 'B',
      >= 50 => 'C',
      _ => 'F',
    };

void main() {
  for (var score in [95, 80, 62, 30]) {
    print('$score: ${grade(score)}');
  }
}
```

```output
95: A
80: B
62: C
30: F
```

`>= 90` inside a switch is a relational [pattern](/records-and-patterns/patterns/).

## Loops

### 10. Multiplication table

```dart
void main() {
  var n = 5;
  for (var i = 1; i <= 10; i++) {
    print('$n x $i = ${n * i}');
  }
}
```

```output
5 x 1 = 5
5 x 2 = 10
5 x 3 = 15
5 x 4 = 20
5 x 5 = 25
5 x 6 = 30
5 x 7 = 35
5 x 8 = 40
5 x 9 = 45
5 x 10 = 50
```

### 11. Sum of 1 to 100

```dart
void main() {
  var sum = 0;
  for (var i = 1; i <= 100; i++) {
    sum += i;
  }
  print('Sum: $sum');
}
```

```output
Sum: 5050
```

See [Loops in Dart](/control-flow/loops/).

### 12. FizzBuzz

```dart
void main() {
  var out = List.generate(15, (index) {
    var i = index + 1;
    if (i % 15 == 0) return 'FizzBuzz';
    if (i % 3 == 0) return 'Fizz';
    if (i % 5 == 0) return 'Buzz';
    return '$i';
  });
  print(out.join(' '));
}
```

```output
1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz
```

### 13. Star pyramid

```dart
void main() {
  var rows = 4;
  for (var i = 1; i <= rows; i++) {
    print(' ' * (rows - i) + '*' * (2 * i - 1));
  }
}
```

```output
   *
  ***
 *****
*******
```

### 14. Factorial

```dart
int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);

void main() {
  print('5! = ${factorial(5)}');
  print('10! = ${factorial(10)}');
}
```

```output
5! = 120
10! = 3628800
```

A function that calls itself is called [recursion](/functions/recursion/).

### 15. Fibonacci series

```dart
void main() {
  var fib = [0, 1];
  while (fib.length < 10) {
    fib.add(fib[fib.length - 1] + fib[fib.length - 2]);
  }
  print(fib.join(', '));
}
```

```output
0, 1, 1, 2, 3, 5, 8, 13, 21, 34
```

### 16. Prime numbers

```dart
bool isPrime(int n) {
  if (n < 2) return false;
  for (var i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}

void main() {
  var primes = List.generate(30, (i) => i + 1).where(isPrime).toList();
  print(primes);
}
```

```output
[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
```

## Strings

### 17. Reverse a string

```dart
void main() {
  var word = 'Flutter';
  var reversed = word.split('').reversed.join();
  print(reversed);
}
```

```output
rettulF
```

### 18. Palindrome check

```dart
bool isPalindrome(String s) {
  var clean = s.toLowerCase();
  return clean == clean.split('').reversed.join();
}

void main() {
  for (var word in ['level', 'dart', 'Racecar']) {
    print('$word: ${isPalindrome(word)}');
  }
}
```

```output
level: true
dart: false
Racecar: true
```

### 19. Count vowels

```dart
void main() {
  var text = 'Learn Dart programming';
  var count = text
      .toLowerCase()
      .split('')
      .where((c) => 'aeiou'.contains(c))
      .length;
  print('Vowels: $count');
}
```

```output
Vowels: 6
```

More tools in [Dart string methods](/dart-basics/string-methods/).

### 20. Word frequency

```dart
void main() {
  var sentence = 'dart is fun and dart is fast';
  var counts = <String, int>{};

  for (var word in sentence.split(' ')) {
    counts[word] = (counts[word] ?? 0) + 1;
  }
  print(counts);
}
```

```output
{dart: 2, is: 2, fun: 1, and: 1, fast: 1}
```

Uses a [Map](/collections/maps/).

## Lists

### 21. Average, highest and lowest

```dart
void main() {
  var marks = [72, 45, 91, 38, 84];

  var total = marks.fold(0, (sum, m) => sum + m);
  var highest = marks.reduce((a, b) => a > b ? a : b);
  var lowest = marks.reduce((a, b) => a < b ? a : b);

  print('Average: ${(total / marks.length).toStringAsFixed(1)}');
  print('Highest: $highest');
  print('Lowest: $lowest');
}
```

```output
Average: 66.0
Highest: 91
Lowest: 38
```

### 22. Remove duplicates

```dart
void main() {
  var numbers = [3, 1, 3, 2, 1];
  print(numbers.toSet().toList());
}
```

```output
[3, 1, 2]
```

### 23. Sort names alphabetically

```dart
void main() {
  var names = ['Sita', 'Arjun', 'Maya', 'Bikash'];
  names.sort();
  print(names);
}
```

```output
[Arjun, Bikash, Maya, Sita]
```

Every list tool is in [Dart list methods](/collections/list-methods/).

## Functions, classes and null safety

### 24. Return two values with a record

```dart
(int, int) minMax(List<int> numbers) {
  var sorted = [...numbers]..sort();
  return (sorted.first, sorted.last);
}

void main() {
  final (lowest, highest) = minMax([4, 9, 1, 7]);
  print('min $lowest, max $highest');
}
```

```output
min 1, max 9
```

See [Records in Dart](/records-and-patterns/records/).

### 25. Handle a missing value (null safety)

```dart
String? findUser(int id) => id == 1 ? 'Asha' : null;

void main() {
  print(findUser(1) ?? 'Guest');
  print(findUser(2) ?? 'Guest');
  print(findUser(2)?.length);
}
```

```output
Asha
Guest
null
```

See [Null-aware operators](/null-safety/null-aware-operators/).

### 26. Bank account class

```dart
class BankAccount {
  final String owner;
  double _balance = 0;

  BankAccount(this.owner);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError('Deposit must be positive');
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount > _balance) throw StateError('Insufficient funds');
    _balance -= amount;
  }
}

void main() {
  var account = BankAccount('Asha');
  account.deposit(500);
  account.withdraw(120);
  print('${account.owner}: ${account.balance}');

  try {
    account.withdraw(1000);
  } on StateError catch (e) {
    print('Error: ${e.message}');
  }
}
```

```output
Asha: 380.0
Error: Insufficient funds
```

See [Classes and objects](/object-oriented-programming/classes-and-objects/) and [Exception handling](/error-handling/exceptions/).

### 27. Shapes with inheritance and polymorphism

```dart
import 'dart:math';

abstract class Shape {
  String get name;
  double get area;
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  String get name => 'Circle';
  @override
  double get area => pi * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  String get name => 'Rectangle';
  @override
  double get area => width * height;
}

void main() {
  List<Shape> shapes = [Circle(2), Rectangle(3, 4)];
  for (var shape in shapes) {
    print('${shape.name}: ${shape.area.toStringAsFixed(2)}');
  }
}
```

```output
Circle: 12.57
Rectangle: 12.00
```

See [Abstract classes](/object-oriented-programming/abstract-classes/) and [Polymorphism](/object-oriented-programming/polymorphism/).

## Async, streams and JSON

### 28. Wait for a result with async and await

```dart
Future<String> fetchGreeting() async {
  await Future.delayed(const Duration(seconds: 1)); // pretend to call a server
  return 'Hello from the server';
}

void main() async {
  print('Fetching...');
  var message = await fetchGreeting();
  print(message);
}
```

```output
Fetching...
Hello from the server
```

See [async and await in Dart](/async/async-await/).

### 29. Countdown with a stream

```dart
Stream<int> countdown(int from) async* {
  for (var i = from; i > 0; i--) {
    await Future.delayed(const Duration(milliseconds: 500));
    yield i;
  }
}

void main() async {
  await for (var n in countdown(3)) {
    print(n);
  }
  print('Lift off!');
}
```

```output
3
2
1
Lift off!
```

See [Streams in Dart](/async/streams/) and [Generators](/async/generators/).

### 30. Read and write JSON

```dart
import 'dart:convert';

void main() {
  var text = '{"name": "Dart", "year": 2011}';
  var data = jsonDecode(text) as Map<String, dynamic>;
  print('${data['name']} was first announced in ${data['year']}');

  var output = jsonEncode({'language': 'Dart', 'fast': true});
  print(output);
}
```

```output
Dart was first announced in 2011
{"language":"Dart","fast":true}
```

See [Working with JSON in Dart](/practical-dart/json/).

## What to do next

- Solve each example a second way. For example, write factorial with a loop, or FizzBuzz with a `switch`.
- Move on to bigger [Dart practice projects](/next-steps/practice-projects/).
- Test yourself with [Dart interview questions](/next-steps/dart-interview-questions/).
- Ready for apps? Try the [Flutter examples](https://flutter.dart-tutorial.dev/next-steps/flutter-examples/).

## Try it yourself

Pick three examples from this page and extend them: make the multiplication table print any number from 1 to 12, make the calculator handle `%`, and make the word counter ignore capital letters and punctuation.
