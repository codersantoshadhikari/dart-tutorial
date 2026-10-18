---
title: "Inheritance in Dart: extends, super and @override"
seoTitle: "Dart Inheritance Tutorial: extends, super and @override"
linkTitle: "Inheritance"
description: "Learn inheritance in Dart: create subclasses with extends, call the parent with super, override methods and pass constructor arguments."
weight: 8
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart inheritance"
  - "extends keyword"
  - "super keyword"
  - "override method"
  - "subclass superclass"
aliases:
  - "/advanced-classes/inheritance/"
  - "/fr/advanced-classes/inheritance/"
  - "/advanced-classes/inheritance/_index-/"
  - "/fr/advanced-classes/inheritance/_index-/"
---

Inheritance lets one class build on another. The new class (the **subclass** or child) gets all the fields and methods of the existing one (the **superclass** or parent), and can add or change behaviour.

It models an "is a" relationship: a dog **is an** animal, a manager **is an** employee.

## extends

```dart
class Animal {
  String name;
  Animal(this.name);

  void eat() => print('$name is eating');
  void sleep() => print('$name is sleeping');
}

class Dog extends Animal {
  Dog(super.name);

  void bark() => print('$name says Woof!');
}

void main() {
  var dog = Dog('Bruno');
  dog.eat();   // inherited
  dog.sleep(); // inherited
  dog.bark();  // its own
}
```

```output
Bruno is eating
Bruno is sleeping
Bruno says Woof!
```

`Dog` did not define `eat`, `sleep` or `name`. It inherited them.

## Passing values to the parent constructor

Constructors are **not** inherited. A subclass must call a parent constructor so the parent's fields get set. `super.name` in the parameter list is the short way to forward an argument.

```dart
class Employee {
  final String name;
  final double salary;
  Employee(this.name, this.salary);
}

class Manager extends Employee {
  final int teamSize;

  // super.name and super.salary are forwarded to Employee.
  Manager(super.name, super.salary, this.teamSize);
}

class Intern extends Employee {
  // The long form: call super(...) in the initializer list.
  Intern(String name) : super(name, 15000);
}

void main() {
  var m = Manager('Rekha', 90000, 6);
  var i = Intern('Sagar');
  print('${m.name} leads ${m.teamSize} people');
  print('${i.name} earns ${i.salary}');
}
```

```output
Rekha leads 6 people
Sagar earns 15000.0
```

## Overriding methods

A subclass can replace an inherited method with its own version. Mark it `@override` so Dart can warn you if the parent's method is renamed or you mistype the name.

```dart
class Animal {
  void speak() => print('Some sound');
}

class Cat extends Animal {
  @override
  void speak() => print('Meow');
}

class Cow extends Animal {
  @override
  void speak() => print('Moo');
}

void main() {
  Animal().speak();
  Cat().speak();
  Cow().speak();
}
```

```output
Some sound
Meow
Moo
```

## Extending instead of replacing with super

Call `super.method()` to run the parent's version as part of yours.

```dart
class Vehicle {
  void start() => print('Checking fuel');
}

class Car extends Vehicle {
  @override
  void start() {
    super.start();
    print('Fastening seat belt');
    print('Engine on');
  }
}

void main() => Car().start();
```

```output
Checking fuel
Fastening seat belt
Engine on
```

## Chains of inheritance

A class can extend a class that extends another. Dart allows only **one** direct parent (single inheritance), and every class ultimately descends from `Object`, which is where `toString`, `==` and `hashCode` come from.

```dart
class Animal {
  void breathe() => print('Breathing');
}

class Mammal extends Animal {
  void feedMilk() => print('Feeding milk');
}

class Dog extends Mammal {
  void bark() => print('Woof');
}

void main() {
  var d = Dog();
  d.breathe();
  d.feedMilk();
  d.bark();
  print(d is Animal);
}
```

```output
Breathing
Feeding milk
Woof
true
```

## A subclass can be used wherever the parent is expected

```dart
class Animal {
  String sound() => '...';
}

class Dog extends Animal {
  @override
  String sound() => 'Woof';
}

void describe(Animal a) => print(a.sound());

void main() {
  describe(Animal());
  describe(Dog()); // a Dog is an Animal
}
```

```output
...
Woof
```

This is the foundation of [polymorphism](/object-oriented-programming/polymorphism/).

## Inheritance or composition?

Use inheritance only for a true "is a" relationship. When one thing **has** another (a car has an engine), store it as a field instead. Composition is more flexible, and deep inheritance trees become hard to change. To share behaviour between unrelated classes, use a [mixin](/object-oriented-programming/mixins/).

## Try it yourself

Create a `Shape` class with a `name` and an `area()` method that returns 0. Add `Circle` and `Rectangle` subclasses that override `area()`. Put one of each in a `List<Shape>` and print every area in a loop.
