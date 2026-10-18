---
title: "Dart Cheat Sheet: Syntax Quick Reference"
seoTitle: "Dart Cheat Sheet: Syntax Quick Reference with Examples"
linkTitle: "Dart cheat sheet"
description: "A one-page Dart cheat sheet: variables, strings, collections, control flow, functions, classes, null safety, async and Dart 3 syntax."
weight: 4
date: 2026-10-10
lastmod: 2026-10-16
keywords:
  - "dart cheat sheet"
  - "dart syntax"
  - "dart quick reference"
  - "dart cheatsheet"
  - "dart examples"
---

A compact reference for the syntax you use most. Each section links to the full lesson.

## Variables

Full lesson: [Variables in Dart](/dart-basics/variables/).

```dart
var name = 'Asha';         // type inferred, can be reassigned
String city = 'Pokhara';   // explicit type
final age = 28;            // set once, at run time
const pi = 3.14159;        // compile-time constant
int? score;                // nullable, starts as null
late String token;         // set later, before first use
dynamic anything = 42;     // no static checking
```

## Built-in types

Full lesson: [Built-in types in Dart](/dart-basics/data-types/).

```dart
int count = 10;
double price = 9.99;
num either = 3;                       // int or double
bool isReady = true;
String text = 'hello';
List<int> list = [1, 2, 3];
Set<String> tags = {'a', 'b'};
Map<String, int> ages = {'Asha': 28};
(String, int) pair = ('x', 1);        // record
({String name, int age}) person = (name: 'Bimal', age: 31);
```

## Strings

Full lesson: [Strings in Dart](/dart-basics/strings/).

```dart
var s = 'Dart';
'Hello, $s!';                  // interpolation
'Length: ${s.length}';         // expression
'''Multi
line''';
r'Raw \n string';
s.toUpperCase();  s.toLowerCase();  s.trim();
s.contains('ar');  s.startsWith('D');  s.indexOf('r');
s.substring(1, 3);  s.split('');  s.replaceAll('a', 'o');
s.padLeft(6, '*');  s.isEmpty;  s[0];
int.parse('42');  double.parse('3.5');  int.tryParse('x');  42.toString();
```

## Operators

Full lesson: [Operators in Dart](/dart-basics/operators/).

```dart
+  -  *  /  ~/  %            // arithmetic (~/ is integer division)
==  !=  >  <  >=  <=         // comparison
&&  ||  !                    // logical
=  +=  -=  *=  ~/=  ??=      // assignment
++  --                       // increment, decrement
is  is!  as                  // type test and cast
a ? b : c                    // ternary
a ?? b                       // b if a is null
a?.b   a!   a?[i]   ...?a    // null-aware
obj..a()..b()                // cascade
```

## Control flow

Full lesson: [Control flow in Dart](/control-flow/if-else/).

```dart
if (x > 0) { } else if (x == 0) { } else { }

for (var i = 0; i < 5; i++) { }
for (final item in items) { }
for (final (i, item) in items.indexed) { }
while (condition) { }
do { } while (condition);
break;  continue;

switch (value) {
  case 1:
    print('one');
  case 2 || 3:
    print('two or three');
  case > 10 when isSpecial:
    print('big and special');
  default:
    print('other');
}

final label = switch (code) {
  200 => 'OK',
  404 => 'Not found',
  >= 500 => 'Server error',
  _ => 'Unknown',
};

if (json case {'name': String name}) print(name);
```

## Functions

Full lesson: [Functions in Dart](/functions/functions/).

```dart
int add(int a, int b) { return a + b; }
int square(int n) => n * n;                          // arrow
void log(String msg, [String? tag]) { }              // optional positional
void greet({required String name, int times = 1}) { } // named
greet(name: 'Asha', times: 2);

var doubleIt = (int n) => n * 2;                     // anonymous
int Function(int) triple = (n) => n * 3;             // function type
typedef Compare<T> = int Function(T a, T b);

(int, int) minMax(List<int> xs) => (xs.first, xs.last); // multiple returns
var (lo, hi) = minMax([1, 9]);
```

## Lists

Full lesson: [Lists in Dart](/collections/lists/).

```dart
var xs = <int>[3, 1, 2];
xs.add(4);  xs.addAll([5, 6]);  xs.insert(0, 9);
xs.remove(9);  xs.removeAt(0);  xs.removeLast();  xs.removeWhere((x) => x > 4);
xs.length;  xs.first;  xs.last;  xs.isEmpty;  xs.contains(2);  xs.indexOf(2);
xs.sort();  xs.sort((a, b) => b.compareTo(a));  xs.reversed.toList();
xs.sublist(0, 2);  xs.take(2);  xs.skip(1);  xs.join(', ');
List.generate(5, (i) => i * i);  List.filled(3, 0);  [...xs];
```

## Sets and maps

Full lessons: [Sets](/collections/sets/) and [Maps](/collections/maps/).

```dart
var a = {1, 2, 3};
a.add(4);  a.remove(1);  a.contains(2);
a.union(b);  a.intersection(b);  a.difference(b);
list.toSet().toList();                       // remove duplicates

var m = <String, int>{'a': 1};
m['b'] = 2;  m['a'];  m['zzz'] ?? 0;
m.containsKey('a');  m.remove('a');  m.putIfAbsent('c', () => 3);
m.update('b', (v) => v + 1);
m.keys;  m.values;  m.entries;  m.length;
for (final MapEntry(:key, :value) in m.entries) { }
```

## Transforming collections

Full lesson: [Transforming collections in Dart](/collections/where-map-reduce/).

```dart
xs.where((x) => x.isEven)            // filter
xs.map((x) => x * 2)                 // transform
xs.expand((x) => [x, x])             // flatten
xs.reduce((a, b) => a + b)           // combine
xs.fold(0, (sum, x) => sum + x)      // combine with a start value
xs.any((x) => x > 5);  xs.every((x) => x > 0);
xs.firstWhere((x) => x > 1, orElse: () => -1);
xs.whereType<int>();  xs.nonNulls;  xs.toList();  xs.toSet();

[...a, ...?maybeNull];               // spread
[if (show) 'x', for (final i in xs) i * 2]; // collection if and for
{for (final x in xs) x: x * x};      // build a map
```

## Null safety

Full lesson: [Null safety in Dart](/null-safety/null-safety-in-dart/).

```dart
String? name;               // may be null
name?.length;               // null if name is null
name ?? 'Guest';            // default
name ??= 'Guest';           // assign if null
name!.length;               // assert not null (throws if it is)
if (name != null) name.length;        // promoted to String
if (name case final n?) print(n);     // null-check pattern
late final String value;    // initialized later
```

## Classes

Full lesson: [Classes in Dart](/object-oriented-programming/classes-and-objects/).

```dart
class Person {
  final String name;
  int _age;                                // private to the file
  static int count = 0;
  static const species = 'human';

  Person(this.name, this._age);            // initializing formals
  Person.guest() : this('Guest', 0);       // named, redirecting
  factory Person.fromJson(Map<String, dynamic> j) =>
      Person(j['name'] as String, j['age'] as int);

  int get age => _age;                     // getter
  set age(int v) => _age = v < 0 ? 0 : v;  // setter
  bool get isAdult => _age >= 18;

  void greet() => print('Hi, I am $name');

  @override
  String toString() => 'Person($name, $_age)';
}
```

## Inheritance, interfaces and mixins

Full lesson: [Inheritance, interfaces and mixins in Dart](/object-oriented-programming/inheritance/).

```dart
class Animal { void speak() => print('...'); }
class Dog extends Animal {
  @override
  void speak() { super.speak(); print('Woof'); }
}

abstract class Shape { double get area; }            // cannot be instantiated
class Square implements Shape {                      // must define everything
  final double side;
  Square(this.side);
  @override double get area => side * side;
}

mixin Flyer { void fly() => print('Flying'); }
class Bird extends Animal with Flyer {}

sealed class Result {}                               // exhaustive switch
class Ok extends Result { final int value; Ok(this.value); }
class Err extends Result { final String message; Err(this.message); }

enum Level { low(1), high(3); const Level(this.weight); final int weight; }

extension on String { String get shout => '${toUpperCase()}!'; }
extension type UserId(int value) {}

class Box<T> { final T value; Box(this.value); }     // generics
T first<T extends Comparable<T>>(List<T> xs) => xs.first;
```

## Records and patterns

Full lesson: [Records and patterns in Dart](/records-and-patterns/records/).

```dart
var point = (3, 4);  point.$1;
var user = (name: 'Asha', age: 28);  user.name;
var (x, y) = point;                       // destructure
var (:name, :age) = user;
(a, b) = (b, a);                          // swap
var [first, ...rest] = [1, 2, 3];
var {'id': id} = {'id': 7};

final text = switch (result) {
  Ok(:var value) => 'Got $value',
  Err(:var message) => 'Failed: $message',
};
```

## Exceptions

Full lesson: [Exceptions in Dart](/error-handling/exceptions/).

```dart
try {
  risky();
} on FormatException catch (e) {
  print(e.message);
} catch (e, stackTrace) {
  print('$e\n$stackTrace');
  rethrow;
} finally {
  cleanUp();
}

throw ArgumentError('bad value');
class MyException implements Exception { final String message; MyException(this.message); }
```

## Async

Full lesson: [Async in Dart](/async/async-await/).

```dart
Future<String> fetch() async {
  await Future.delayed(Duration(seconds: 1));
  return 'done';
}

final value = await fetch();
final results = await Future.wait([fetch(), fetch()]);
final (a, b) = await (fetchA(), fetchB()).wait;
await fetch().timeout(Duration(seconds: 5));

Stream<int> count(int n) async* {
  for (var i = 1; i <= n; i++) yield i;
}
await for (final n in count(3)) print(n);
final sub = stream.listen(print, onError: print, onDone: () {});
await sub.cancel();

Iterable<int> naturals() sync* { var i = 0; while (true) yield i++; }
final answer = await Isolate.run(() => heavyWork());
```

## Imports

Full lesson: [Imports in Dart](/libraries-and-packages/imports/).

```dart
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/user.dart';
import 'utils.dart' show formatDate;
import 'legacy.dart' hide OldClass;
export 'src/public_api.dart';
```

## Common tasks

```dart
// JSON
final map = jsonDecode(text) as Map<String, dynamic>;
final text = jsonEncode({'a': 1});

// Dates
final now = DateTime.now();
final later = now.add(Duration(days: 7));
final diff = later.difference(now).inDays;
now.toIso8601String();  DateTime.parse('2026-10-10');

// Random
Random().nextInt(10);            // 0 to 9
([1, 2, 3]..shuffle()).first;

// Files (dart:io)
final text = await File('a.txt').readAsString();
await File('b.txt').writeAsString('hello');

// Timing
final watch = Stopwatch()..start();
print(watch.elapsedMilliseconds);
```

## Command line

| Command | Does |
| --- | --- |
| `dart create my_app` | Create a project |
| `dart run` | Run it |
| `dart run --enable-asserts` | Run with asserts checked |
| `dart format .` | Format the code |
| `dart analyze` | Find problems |
| `dart fix --apply` | Apply automatic fixes |
| `dart test` | Run the tests |
| `dart pub add <package>` | Add a dependency |
| `dart pub get` | Download dependencies |
| `dart pub upgrade` | Update dependencies |
| `dart compile exe bin/app.dart` | Build a native executable |
| `dart doc` | Generate API documentation |

## Naming conventions

| Thing | Style | Example |
| --- | --- | --- |
| Classes, enums, typedefs, extensions | `UpperCamelCase` | `HttpClient` |
| Variables, functions, parameters, constants | `lowerCamelCase` | `maxRetries` |
| Files, folders, packages | `lowercase_with_underscores` | `user_profile.dart` |
| Private members | Leading underscore | `_cache` |
| Import prefixes | `lowercase_with_underscores` | `as http` |
