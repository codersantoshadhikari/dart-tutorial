---
title: "Immutable Classes and copyWith in Dart"
linkTitle: "Immutability and copyWith"
description: "Write immutable Dart classes: final fields, const constructors, unmodifiable lists, the copyWith pattern, value equality, and when to use records or freezed."
weight: 20
date: 2026-10-16
lastmod: 2026-10-16
keywords:
  - "dart immutable class"
  - "dart copyWith"
  - "copywith dart"
  - "dart unmodifiable list"
  - "flutter immutable state"
faq:
  - q: "What does copyWith do in Dart?"
    a: "copyWith is a method you write on an immutable class. It returns a new object with the same values as the old one, except for the fields you pass in. The original object is never changed."
  - q: "Why does Flutter use immutable classes?"
    a: "Widgets and state objects in Riverpod, Bloc and Provider are compared to decide what to rebuild. With immutable objects, a change always produces a new object, so the change is easy to detect and no other code can modify your data by surprise."
---

An **immutable** object cannot change after it is created. To "change" it, you make a new object with the new values. This sounds wasteful, but it makes code much easier to reason about, and it is how state works in Flutter, [Riverpod](https://flutter.dart-tutorial.dev/state-packages/riverpod/) and [Bloc](https://flutter.dart-tutorial.dev/state-packages/bloc/).

## The problem with mutable objects

```dart
class Cart {
  List<String> items;
  Cart(this.items);
}

void main() {
  final saved = Cart(['apple']);
  final current = saved;      // the same object, not a copy

  current.items.add('mango');
  print(saved.items);         // the "saved" cart changed too!
}
```

```output
[apple, mango]
```

Two variables pointed at one object, so a change through one was visible through the other. Bugs like this are hard to find in a big app.

## Step 1: final fields and a const constructor

```dart
class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);
}

void main() {
  const p = Point(1, 2);
  // p.x = 5;               // compile error: x is final
  print('${p.x}, ${p.y}');
}
```

```output
1, 2
```

`final` stops the fields from being reassigned. A `const` constructor lets Dart create the object at compile time and reuse it. See [const constructors](/object-oriented-programming/const-constructors/).

## Step 2: protect lists and maps

`final` only protects the *variable*. A `final List` can still be changed with `add`. Make a private, unmodifiable copy:

```dart
class Cart {
  final List<String> items;
  Cart(List<String> items) : items = List.unmodifiable(items);
}

void main() {
  final source = ['apple'];
  final cart = Cart(source);

  source.add('mango');        // does not affect the cart
  print(cart.items);

  try {
    cart.items.add('kiwi');
  } on UnsupportedError {
    print('The cart cannot be changed directly');
  }
}
```

```output
[apple]
The cart cannot be changed directly
```

## Step 3: the copyWith pattern

`copyWith` returns a new object, copying every field you do not pass:

```dart
class User {
  final String name;
  final int age;
  final String city;

  const User({required this.name, required this.age, required this.city});

  User copyWith({String? name, int? age, String? city}) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
      city: city ?? this.city,
    );
  }

  @override
  String toString() => 'User($name, $age, $city)';
}

void main() {
  const asha = User(name: 'Asha', age: 21, city: 'Pokhara');
  final older = asha.copyWith(age: 22);
  final moved = older.copyWith(city: 'Toronto');

  print(asha);
  print(older);
  print(moved);
}
```

```output
User(Asha, 21, Pokhara)
User(Asha, 22, Pokhara)
User(Asha, 22, Toronto)
```

The original `asha` is untouched. This is exactly how you update state in Flutter: `state = state.copyWith(loading: true);`.

### copyWith with a list

```dart
class Cart {
  final List<String> items;
  const Cart([this.items = const []]);

  Cart copyWith({List<String>? items}) => Cart(items ?? this.items);

  Cart add(String item) => copyWith(items: [...items, item]);
  Cart remove(String item) => copyWith(items: items.where((i) => i != item).toList());
}

void main() {
  const empty = Cart();
  final one = empty.add('apple');
  final two = one.add('mango');
  final back = two.remove('apple');

  print(empty.items);
  print(two.items);
  print(back.items);
}
```

```output
[]
[apple, mango]
[mango]
```

Every method returns a **new** cart, built with the [spread operator](/collections/spread-and-collection-if/) and `where`.

### Setting a nullable field back to null

`name ?? this.name` cannot tell "not passed" from "set to null". If a field is nullable and you need to clear it, pass a function instead:

```dart
class Task {
  final String title;
  final DateTime? due;
  const Task(this.title, {this.due});

  Task copyWith({String? title, DateTime? Function()? due}) =>
      Task(title ?? this.title, due: due != null ? due() : this.due);
}

void main() {
  final t = Task('Pay rent', due: DateTime(2026, 11, 1));
  final cleared = t.copyWith(due: () => null);
  print(t.due != null);
  print(cleared.due);
}
```

```output
true
null
```

## Step 4: value equality

Two immutable objects with the same values should usually be **equal**. By default Dart compares identity, so add `==` and `hashCode`:

```dart
class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);

  Point copyWith({int? x, int? y}) => Point(x ?? this.x, y ?? this.y);

  @override
  bool operator ==(Object other) => other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  final a = Point(1, 2);
  final b = a.copyWith();
  print(identical(a, b)); // different objects
  print(a == b);          // but equal values
}
```

```output
false
true
```

Read [equality and hashCode](/object-oriented-programming/equality-and-hashcode/) for the details.

## Shortcuts: records, Equatable and freezed

Writing `copyWith`, `==`, `hashCode` and `toString` by hand gets repetitive. Options:

| Option | Best for |
| --- | --- |
| [Records](/records-and-patterns/records/) `(x: 1, y: 2)` | Small groups of values. Immutable with value equality built in, but no `copyWith`. |
| [`equatable`](https://pub.dev/packages/equatable) package | Adds `==` and `hashCode` from a list of fields. Popular with Bloc. |
| [`freezed`](https://pub.dev/packages/freezed) package | Generates `copyWith` (including setting null), equality, `toString`, JSON and sealed unions. Popular with Riverpod. |
| `@immutable` from [`meta`](https://pub.dev/packages/meta) | The analyzer warns you if a class has a non-final field. Flutter's `foundation.dart` exports it. |

A freezed class looks like this (it needs `build_runner` to generate the code):

```dart
// Not standalone: needs freezed, freezed_annotation and build_runner.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({required String name, required int age}) = _User;
}
```

## Rules for immutable classes

1. Make every field `final`.
2. Add a `const` constructor when you can.
3. Copy incoming lists and maps with `List.unmodifiable` / `Map.unmodifiable`.
4. Change things with `copyWith` (or methods that return a new object), never setters.
5. Override `==` and `hashCode`, or use a record, `equatable` or `freezed`.

## Try it yourself

Write an immutable `BankAccount` with `owner` and `balance`. Add `deposit(amount)` and `withdraw(amount)` methods that return a new account, and make `withdraw` throw an `ArgumentError` when the balance would go below zero.
