---
title: "Enums in Dart: Simple and Enhanced Enumerations"
linkTitle: "Enums"
description: "Learn enums in Dart: define a fixed set of values, use them in switch, and add fields, methods and constructors with enhanced enums."
weight: 13
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart enum"
  - "enhanced enums"
  - "enum values"
  - "enum with fields"
  - "switch enum"
  - "byName"
aliases:
  - "/advanced-classes/enums/"
  - "/fr/advanced-classes/enums/"
---

An **enum** (enumeration) is a type with a small, fixed set of possible values. Use one whenever a variable should only ever be one of a few named options: the days of the week, the state of an order, the size of a T-shirt.

## Why not strings?

With `String status = 'shiped';` the typo compiles and fails silently. With an enum, a misspelt value is a compile error and autocomplete lists every option.

## A simple enum

```dart
enum OrderStatus { pending, paid, shipped, delivered, cancelled }

void main() {
  var status = OrderStatus.shipped;

  print(status);
  print(status.name);   // the name as a String
  print(status.index);  // position, starting at 0
  print(status == OrderStatus.shipped);
}
```

```output
OrderStatus.shipped
shipped
2
true
```

## All the values

```dart
enum Size { small, medium, large }

void main() {
  print(Size.values);

  for (final size in Size.values) {
    print('${size.index}: ${size.name}');
  }

  // From a String back to an enum value.
  var chosen = Size.values.byName('medium');
  print(chosen);
}
```

```output
[Size.small, Size.medium, Size.large]
0: small
1: medium
2: large
Size.medium
```

`byName` throws if the name does not exist. For untrusted text, search safely with `Size.values.where((s) => s.name == text).firstOrNull`.

## Enums and switch

Dart checks that a `switch` on an enum handles **every** value. If you add a new value later, every switch that forgot it stops compiling, which is exactly what you want.

```dart
enum Light { red, yellow, green }

String action(Light light) => switch (light) {
      Light.red => 'Stop',
      Light.yellow => 'Slow down',
      Light.green => 'Go',
    };

void main() {
  print(action(Light.yellow));
}
```

```output
Slow down
```

## Enhanced enums: fields, constructors and methods

An enum can carry data and behaviour, like a small class. Each value calls the constructor with its own arguments.

```dart
enum Planet {
  mercury(diameterKm: 4879, moons: 0),
  earth(diameterKm: 12742, moons: 1),
  jupiter(diameterKm: 139820, moons: 95);

  const Planet({required this.diameterKm, required this.moons});

  final int diameterKm;
  final int moons;

  bool get hasMoons => moons > 0;

  String describe() => '$name: $diameterKm km across, $moons moon(s)';
}

void main() {
  print(Planet.earth.describe());
  print(Planet.mercury.hasMoons);

  var biggest = Planet.values.reduce(
    (a, b) => a.diameterKm > b.diameterKm ? a : b,
  );
  print(biggest.name);
}
```

```output
earth: 12742 km across, 1 moon(s)
false
jupiter
```

The rules for enhanced enums:

- List the values first, and end the list with a semicolon.
- The constructor must be `const`, and all fields must be `final`.
- You cannot create new values at run time.

## A practical example

```dart
enum Plan {
  free('Free', 0, 1),
  pro('Pro', 499, 10),
  team('Team', 1999, 100);

  const Plan(this.label, this.pricePerMonth, this.maxProjects);

  final String label;
  final int pricePerMonth;
  final int maxProjects;

  bool canCreate(int currentProjects) => currentProjects < maxProjects;
}

void main() {
  var plan = Plan.free;
  print('${plan.label}: Rs. ${plan.pricePerMonth}/month');
  print(plan.canCreate(1));
  print(Plan.pro.canCreate(1));
}
```

```output
Free: Rs. 0/month
false
true
```

## Enums can implement interfaces and use mixins

```dart
abstract class HasCode {
  String get code;
}

enum Currency implements HasCode {
  npr('NPR'),
  usd('USD');

  const Currency(this.code);

  @override
  final String code;
}

void main() => print(Currency.npr.code);
```

```output
NPR
```

## Tips

- Name the enum in `UpperCamelCase` and its values in `lowerCamelCase`.
- Do not store `index` in a database or file. Reordering the values would change every number. Store `name` instead.
- An enum is ideal for a closed list of simple options. When each option needs its own different data, use a [sealed class](/records-and-patterns/sealed-classes/).

## Try it yourself

Create a `Weekday` enum with a field `isWeekend`. Add a getter `shortName` that returns the first three letters in upper case. Loop over all values and print only the weekdays that are not weekend days.
