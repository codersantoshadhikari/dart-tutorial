---
title: "Mixins in Dart: Reusing Code with the with Keyword"
linkTitle: "Mixins"
description: "Learn mixins in Dart: share methods between unrelated classes using mixin and with, restrict them with on, and understand ordering."
weight: 11
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart mixin"
  - "with keyword"
  - "mixin on"
  - "code reuse"
  - "multiple inheritance dart"
  - "mixin class"
aliases:
  - "/advanced-classes/mixins/"
  - "/fr/advanced-classes/mixins/"
---

Inheritance lets a class take code from one parent. But some abilities cut across family trees: both a `Duck` and an `Aeroplane` can fly, yet they share no sensible parent. A **mixin** is a bundle of fields and methods that can be added to any class.

## Defining and using a mixin

```dart
mixin Flyer {
  void fly() => print('$runtimeType is flying');
}

mixin Swimmer {
  void swim() => print('$runtimeType is swimming');
}

class Animal {}

class Duck extends Animal with Flyer, Swimmer {}

class Fish extends Animal with Swimmer {}

class Aeroplane with Flyer {}

void main() {
  Duck()
    ..fly()
    ..swim();
  Fish().swim();
  Aeroplane().fly();
}
```

```output
Duck is flying
Duck is swimming
Fish is swimming
Aeroplane is flying
```

A class can use many mixins, listed after `with`. Unlike `implements`, you get the working code.

## Mixins can hold state

```dart
mixin Timestamped {
  DateTime? _updatedAt;

  void touch() => _updatedAt = DateTime.now();
  bool get wasUpdated => _updatedAt != null;
}

class Note with Timestamped {
  String text;
  Note(this.text);
}

void main() {
  var note = Note('Buy milk');
  print(note.wasUpdated);
  note.touch();
  print(note.wasUpdated);
}
```

```output
false
true
```

Mixins cannot declare constructors, so their fields must have default values or be nullable or `late`.

## Restricting a mixin with on

`on` says the mixin can only be applied to a certain type. In return, the mixin may use that type's members.

```dart
class Musician {
  final String name;
  Musician(this.name);
}

mixin Singer on Musician {
  void sing() => print('$name sings'); // may use name
}

class Vocalist extends Musician with Singer {
  Vocalist(super.name);
}

// class Robot with Singer {} // error: Robot is not a Musician

void main() {
  Vocalist('Ani').sing();
}
```

```output
Ani sings
```

## Requiring members from the host class

A mixin can declare an abstract member. The class that uses the mixin must supply it.

```dart
mixin Describable {
  String get label; // the class must provide this

  void describe() => print('This is $label');
}

class City with Describable {
  @override
  String get label => 'the city of Bhaktapur';
}

void main() => City().describe();
```

```output
This is the city of Bhaktapur
```

## Order matters

If two mixins define the same method, the one listed **last** wins. A mixin's method also overrides the superclass's.

```dart
mixin A {
  String who() => 'A';
}

mixin B {
  String who() => 'B';
}

class First with A, B {}

class Second with B, A {}

void main() {
  print(First().who());
  print(Second().who());
}
```

```output
B
A
```

## A practical example

```dart
mixin Validation {
  final errors = <String>[];

  void require(bool condition, String message) {
    if (!condition) errors.add(message);
  }

  bool get isValid => errors.isEmpty;
}

class SignUpForm with Validation {
  final String email;
  final String password;

  SignUpForm(this.email, this.password) {
    require(email.contains('@'), 'Email is not valid');
    require(password.length >= 8, 'Password is too short');
  }
}

void main() {
  var form = SignUpForm('rina.example.com', 'abc');
  print(form.isValid);
  print(form.errors);
}
```

```output
false
[Email is not valid, Password is too short]
```

## Mixin, class or interface?

| Tool | Gives you | Use for |
| --- | --- | --- |
| `extends` | Code from one parent | "is a" relationships |
| `with` | Code from many mixins | Shared abilities across unrelated classes |
| `implements` | A contract, no code | Swappable implementations |

A `mixin` cannot be instantiated or extended. If you need something that works as both a class and a mixin, declare it as `mixin class`.

## Try it yourself

Write a `Logger` mixin with a `log(String message)` method that prints the class name and the message. Mix it into two unrelated classes, `PaymentService` and `UserRepository`, and call `log` from a method in each.
