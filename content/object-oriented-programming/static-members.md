---
title: "Static Variables and Methods in Dart"
linkTitle: "Static members"
description: "Learn static members in Dart: static fields, static methods, constants, lazy initialization, and when to use them instead of instances."
weight: 7
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart static"
  - "static variable"
  - "static method"
  - "static const"
  - "class members"
aliases:
  - "/static-members/"
  - "/fr/static-members/"
  - "/static-members/static-variables/"
  - "/fr/static-members/static-variables/"
  - "/static-members/static-methods/"
  - "/fr/static-members/static-methods/"
  - "/static-members/static-blocks-initializer-logic/"
  - "/fr/static-members/static-blocks-initializer-logic/"
  - "/static-members/accessing-static-members/"
  - "/fr/static-members/accessing-static-members/"
---

Normal fields and methods belong to each **object**. A `static` member belongs to the **class** itself. There is one copy, shared by everyone, and you use it through the class name.

## Static variables

```dart
class Visitor {
  static int count = 0; // one shared counter
  final String name;    // one per object

  Visitor(this.name) {
    count++;
  }
}

void main() {
  Visitor('Anil');
  Visitor('Bina');
  Visitor('Chitra');

  print(Visitor.count);
}
```

```output
3
```

Every `Visitor` has its own `name`, but there is only one `count`.

## Static constants

The most common static member is a constant that belongs with a class.

```dart
class AppColors {
  static const primary = '#0B5FD9';
  static const danger = '#D92B2B';
}

class Circle {
  static const double pi = 3.14159;
  final double radius;
  Circle(this.radius);

  double get area => pi * radius * radius;
}

void main() {
  print(AppColors.primary);
  print(Circle.pi);
  print(Circle(2).area);
}
```

```output
#0B5FD9
3.14159
12.56636
```

Inside the class you can write `pi` directly. Outside, you write `Circle.pi`.

## Static methods

A static method does not need an object. It is a function that lives inside a class for organisation.

```dart
class Validator {
  static bool isEmail(String text) => text.contains('@') && text.contains('.');

  static bool isStrongPassword(String text) => text.length >= 8;
}

void main() {
  print(Validator.isEmail('hi@example.com'));
  print(Validator.isStrongPassword('1234'));
}
```

```output
true
false
```

## What static methods cannot do

A static method has no `this`. It cannot touch instance fields or call instance methods, because it is not attached to any particular object.

```dart
class Player {
  static int totalPlayers = 0;
  String name;
  Player(this.name) {
    totalPlayers++;
  }

  static void report() {
    print('Players: $totalPlayers'); // fine: static uses static
    // print(name);                  // error: no instance here
  }

  void introduce() {
    // An instance method can use both.
    print('I am $name, one of $totalPlayers');
  }
}

void main() {
  var p = Player('Kiran');
  Player('Laxmi');
  Player.report();
  p.introduce();
}
```

```output
Players: 2
I am Kiran, one of 2
```

## Accessing static members

Always through the class name. Unlike some languages, Dart does not allow `object.staticMember`.

```dart
class Config {
  static String env = 'dev';
}

void main() {
  print(Config.env);
  // print(Config().env); // error: static members can't be accessed via an instance
}
```

```output
dev
```

## Static initialization is lazy

Dart has no "static block". It does not need one, because a static field is initialized the first time it is read. For complex setup, call a function or use an immediately-run closure.

```dart
class Database {
  static final Map<String, String> settings = _load();

  static Map<String, String> _load() {
    print('Loading settings...');
    return {'host': 'localhost', 'port': '5432'};
  }
}

void main() {
  print('App started');
  print(Database.settings['host']); // loads here, on first use
  print(Database.settings['port']); // already loaded
}
```

```output
App started
Loading settings...
localhost
5432
```

## Static members are not inherited

A subclass cannot call a parent's static member through its own name, and static methods cannot be overridden.

## When to use static

| Good use | Why |
| --- | --- |
| Constants (`static const`) | One value that belongs with the class |
| Counters and caches shared by all instances | Data about the class as a whole |
| Helper functions related to the class | No object needed |
| Holding a singleton instance | A single shared object |

Be careful with **mutable** static variables. They are global state: any code can change them, which makes bugs harder to trace and tests harder to write. And if a class contains nothing but static helpers, plain top-level functions are usually simpler in Dart.

## Try it yourself

Create a `Ticket` class where each new ticket automatically receives the next number (1, 2, 3...) from a private static counter. Add a static method `resetNumbers()` and a static constant `maxPerPerson`.
