---
title: "Dart vs JavaScript: Key Differences Explained with Code"
linkTitle: "Dart vs JavaScript"
description: "Dart vs JavaScript compared side by side: types, null safety, variables, strings, classes, async await, performance and when to choose each. Easy examples."
weight: 6
date: 2026-10-15
lastmod: 2026-10-16
keywords:
  - "dart vs javascript"
  - "dart or javascript"
  - "dart for javascript developers"
  - "difference between dart and javascript"
  - "is dart like javascript"
---

If you know JavaScript, Dart will feel familiar within an hour. The syntax looks alike, both have `async` and `await`, and both run in the browser. The big difference is that Dart checks types *before* your program runs, which catches many bugs early. This page shows the same ideas in both languages so you can map what you already know.

## At a glance

| | Dart | JavaScript |
| --- | --- | --- |
| Types | Static and sound, with type inference | Dynamic (TypeScript adds static types) |
| Null | Sound null safety: `String` can never be null | Any value can be `null` or `undefined` |
| Runs on | Native machine code, the Dart VM, JavaScript and WebAssembly | Browsers, Node.js, Deno, Bun |
| Main use | Flutter apps for mobile, web and desktop; CLI and server | Websites, web apps, Node.js servers |
| Equality | `==` (no type coercion) | `===` recommended, `==` converts types |
| Integer division | `~/` operator | `Math.floor(a / b)` |
| Classes | Classes, mixins, interfaces, sealed classes | Classes and prototypes |
| Package manager | `pub` (pub.dev) | `npm` |

## Variables

```javascript
// JavaScript
let count = 1;
const name = 'Asha';
count = 'one'; // allowed: the type changes
```

```dart
void main() {
  var count = 1;          // count is an int from now on
  final name = 'Asha';
  // count = 'one';       // compile error: a String is not an int
  count = 2;
  print('$name $count');
}
```

```output
Asha 2
```

`final` in Dart is like `const` in JavaScript: it cannot be reassigned. Dart's `const` is stricter: the value must be known when the program is compiled. See [final vs const](/dart-basics/final-and-const/).

## Strings

JavaScript uses back-ticks for template strings. In Dart every string can interpolate.

```javascript
const lang = 'Dart';
console.log(`I am learning ${lang}`);
```

```dart
void main() {
  const lang = 'Dart';
  print('I am learning $lang');
  print('It has ${lang.length} letters');
}
```

```output
I am learning Dart
It has 4 letters
```

## Numbers and equality

```dart
void main() {
  print(7 / 2);     // 3.5
  print(7 ~/ 2);    // 3
  print(1 == 1.0);  // true: same number
  // print(1 == '1');  // always false in Dart, and the analyzer warns you
  print(0.1 + 0.2); // same floating-point rules as JavaScript
}
```

```output
3.5
3
true
0.30000000000000004
```

Dart never converts types when comparing, so there is no `===`. `'1' == 1` is simply `false`.

## Null and undefined

JavaScript has two empty values, `null` and `undefined`, and any variable can hold them. Dart has only `null`, and only types ending in `?` may hold it.

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

`??` and `?.` work the same way as in modern JavaScript. The difference is that Dart will not let you call `.length` on a `String?` without handling the null case first. Read [Null safety in Dart](/null-safety/null-safety-in-dart/).

## Arrays and objects vs lists and maps

```javascript
const nums = [1, 2, 3];
const doubled = nums.map(n => n * 2);
const user = { name: 'Asha', age: 21 };
```

```dart
void main() {
  final nums = [1, 2, 3];
  final doubled = nums.map((n) => n * 2).toList();
  final user = {'name': 'Asha', 'age': 21};

  print(doubled);
  print(user['name']);
}
```

```output
[2, 4, 6]
Asha
```

A JavaScript array is a Dart `List`. A JavaScript object used as a dictionary is a Dart `Map`. For structured data with fixed fields, Dart code normally uses a class or a [record](/records-and-patterns/records/) instead. See [Dart list methods](/collections/list-methods/).

## Functions

```javascript
function add(a, b) { return a + b; }
const square = x => x * x;
```

```dart
int add(int a, int b) => a + b;
int square(int x) => x * x;

void main() {
  print(add(2, 3));
  print(square(5));
}
```

```output
5
25
```

Dart arrow functions can only hold a single expression. Dart also has named parameters built in: `greet(name: 'Asha')`. See [Function parameters](/functions/function-parameters/).

## Classes

```dart
class Person {
  final String name;
  int age;

  Person(this.name, this.age);

  void birthday() => age++;

  @override
  String toString() => '$name ($age)';
}

void main() {
  final p = Person('Asha', 21);
  p.birthday();
  print(p);
}
```

```output
Asha (22)
```

No `new`, no `this.` needed inside methods, and the constructor `Person(this.name, this.age)` fills the fields for you. Dart also has [mixins](/object-oriented-programming/mixins/), [interfaces](/object-oriented-programming/interfaces/) and [sealed classes](/records-and-patterns/sealed-classes/).

## async and await

A JavaScript `Promise` is a Dart `Future`. The `async` / `await` keywords work the same way.

```javascript
async function load() {
  const user = await fetchUser();
  console.log(`Hello, ${user}`);
}
```

```dart
Future<String> fetchUser() async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Asha';
}

void main() async {
  print('Loading...');
  final user = await fetchUser();
  print('Hello, $user');
}
```

```output
Loading...
Hello, Asha
```

Dart also has `Stream`, a built-in type for many values over time, similar to an async iterator. See [async and await in Dart](/async/async-await/) and [Streams](/async/streams/).

## Which should you learn?

- **Building mobile apps** for Android and iOS from one codebase: learn Dart, then [Flutter](https://flutter.dart-tutorial.dev/).
- **Building websites** and front-end web apps: JavaScript (and TypeScript) is the standard.
- **Coming from Python instead?** Read [Dart vs Python](/getting-started/dart-vs-python/).
- **Both is fine.** Many developers use JavaScript for the web and Dart for apps. Knowing one makes the other much easier.

## Try it yourself

Take a small JavaScript function you have written before, such as one that filters an array of objects, and rewrite it in Dart using a `List` of `Map`s. Then rewrite it again with a small class instead of maps and notice how the editor now catches typos in field names.
