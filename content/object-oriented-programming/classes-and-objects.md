---
title: "Classes and Objects in Dart"
seoTitle: "Dart Classes and Objects Tutorial with Examples"
linkTitle: "Classes and objects"
description: "Learn object-oriented basics in Dart: define a class, create objects, and use fields, methods, this and toString with clear examples."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart class"
  - "dart object"
  - "instance"
  - "fields and methods"
  - "this keyword"
  - "toString"
aliases:
  - "/introduction/classes-and-objects/"
  - "/fr/introduction/classes-and-objects/"
---

A **class** is a blueprint. An **object** is a thing built from that blueprint. The class `Car` describes what every car has and can do; your car and your neighbour's car are two objects of that class.

## Defining a class

```dart
class Dog {
  // Fields: the data each dog has.
  String name;
  int age;

  // Constructor: runs when a dog is created.
  Dog(this.name, this.age);

  // Method: something a dog can do.
  void bark() {
    print('$name says Woof!');
  }
}

void main() {
  var dog = Dog('Bruno', 3);
  dog.bark();
  print(dog.age);
}
```

```output
Bruno says Woof!
3
```

Class names use `UpperCamelCase`. Fields and methods use `lowerCamelCase`.

## Each object has its own data

```dart
class Dog {
  String name;
  int age;
  Dog(this.name, this.age);

  void birthday() {
    age++;
    print('$name is now $age');
  }
}

void main() {
  var a = Dog('Bruno', 3);
  var b = Dog('Kali', 7);

  a.birthday();
  print(b.age); // unchanged
}
```

```output
Bruno is now 4
7
```

Both dogs share the same methods, but each keeps its own `name` and `age`.

## The this keyword

Inside a class, `this` refers to the current object. You usually do not need to write it. It is required only when a local name hides a field.

```dart
class Counter {
  int value = 0;

  void add(int value) {
    this.value += value; // field += parameter
  }
}

void main() {
  var c = Counter();
  c.add(5);
  c.add(2);
  print(c.value);
}
```

```output
7
```

## Methods that return values

```dart
class Rectangle {
  double width;
  double height;
  Rectangle(this.width, this.height);

  double area() => width * height;
  double perimeter() => 2 * (width + height);
  bool isSquare() => width == height;
}

void main() {
  var r = Rectangle(4, 6);
  print(r.area());
  print(r.perimeter());
  print(r.isSquare());
}
```

```output
24.0
20.0
false
```

## A readable print with toString

Printing an object shows `Instance of 'Dog'` by default. Override `toString` to say something useful.

```dart
class Dog {
  String name;
  int age;
  Dog(this.name, this.age);

  @override
  String toString() => 'Dog($name, $age)';
}

void main() {
  print(Dog('Bruno', 3));
}
```

```output
Dog(Bruno, 3)
```

## Objects are passed by reference

A variable holds a reference to an object, not a copy. Two variables can point to the same object.

```dart
class Dog {
  String name;
  Dog(this.name);
}

void rename(Dog d) => d.name = 'Max';

void main() {
  var a = Dog('Bruno');
  var b = a;      // same dog
  rename(b);
  print(a.name);
}
```

```output
Max
```

## Vocabulary

| Term | Meaning |
| --- | --- |
| Class | The blueprint |
| Object / instance | One thing made from the class |
| Field / property | A variable that belongs to an object |
| Method | A function that belongs to an object |
| Constructor | The special function that creates an object |
| Member | Any field, method or constructor of a class |

## Try it yourself

Create a `BankAccount` class with an `owner` and a `balance`. Add `deposit` and `withdraw` methods, where `withdraw` refuses to go below zero, and a `toString` that prints `Owner: balance`. Make two accounts and move money between them.
