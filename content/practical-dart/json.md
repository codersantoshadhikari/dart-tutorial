---
title: "Working with JSON in Dart: Encode, Decode and Model Classes"
linkTitle: "JSON"
description: "Learn JSON in Dart: jsonDecode and jsonEncode, converting to and from model classes with fromJson and toJson, lists and nested objects."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart json"
  - "jsonDecode"
  - "jsonEncode"
  - "fromJson toJson"
  - "parse json dart"
  - "json_serializable"
  - "dart:convert"
---

JSON is the format most web APIs use to exchange data. It is plain text made of objects (`{}`), arrays (`[]`), strings, numbers, booleans and `null`. Dart's `dart:convert` library translates between JSON text and Dart values.

| JSON | Dart |
| --- | --- |
| object `{ }` | `Map<String, dynamic>` |
| array `[ ]` | `List<dynamic>` |
| string | `String` |
| number | `int` or `double` |
| `true` / `false` | `bool` |
| `null` | `null` |

## Decoding: JSON text to Dart

```dart
import 'dart:convert';

void main() {
  const text = '{"name": "Asha", "age": 28, "skills": ["Dart", "Flutter"]}';

  final data = jsonDecode(text) as Map<String, dynamic>;

  print(data['name']);
  print(data['age'] + 1);
  print(data['skills'][0]);
  print(data['email']); // missing key
}
```

```output
Asha
29
Dart
null
```

`jsonDecode` returns `dynamic`, because the shape of the data is only known when the program runs. Working with raw maps is error-prone: a typo in a key gives `null`, not an error.

## Encoding: Dart to JSON text

```dart
import 'dart:convert';

void main() {
  final user = {
    'name': 'Bimal',
    'age': 31,
    'verified': true,
    'tags': ['admin', 'editor'],
    'address': null,
  };

  print(jsonEncode(user));
  print(const JsonEncoder.withIndent('  ').convert(user));
}
```

```output
{"name":"Bimal","age":31,"verified":true,"tags":["admin","editor"],"address":null}
{
  "name": "Bimal",
  "age": 31,
  "verified": true,
  "tags": [
    "admin",
    "editor"
  ],
  "address": null
}
```

## Model classes: the right way

Convert maps to typed objects at the edge of your program. After that, the compiler checks every field name and type.

```dart
import 'dart:convert';

class User {
  final int id;
  final String name;
  final String? email;

  const User({required this.id, required this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (email != null) 'email': email,
      };
}

void main() {
  final user = User.fromJson(jsonDecode('{"id": 7, "name": "Chandra"}'));
  print('${user.id}: ${user.name}, email: ${user.email}');

  // jsonEncode calls toJson() automatically.
  print(jsonEncode(User(id: 8, name: 'Dipa', email: 'dipa@example.com')));
}
```

```output
7: Chandra, email: null
{"id":8,"name":"Dipa","email":"dipa@example.com"}
```

## Lists of objects

```dart
import 'dart:convert';

class Product {
  final String name;
  final double price;
  Product(this.name, this.price);

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(json['name'] as String, (json['price'] as num).toDouble());
}

void main() {
  const text = '[{"name": "Pen", "price": 20}, {"name": "Bag", "price": 1499.5}]';

  final list = jsonDecode(text) as List<dynamic>;
  final products = [
    for (final item in list) Product.fromJson(item as Map<String, dynamic>),
  ];

  for (final p in products) {
    print('${p.name}: ${p.price}');
  }
}
```

```output
Pen: 20.0
Bag: 1499.5
```

Note `(json['price'] as num).toDouble()`. JSON does not distinguish `20` from `20.0`, so a price can arrive as an `int`. Casting straight to `double` would crash.

## Nested objects

```dart
import 'dart:convert';

class Address {
  final String city;
  Address(this.city);
  factory Address.fromJson(Map<String, dynamic> json) =>
      Address(json['city'] as String);
  Map<String, dynamic> toJson() => {'city': city};
}

class Customer {
  final String name;
  final Address address;
  final List<String> tags;
  Customer(this.name, this.address, this.tags);

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        json['name'] as String,
        Address.fromJson(json['address'] as Map<String, dynamic>),
        (json['tags'] as List<dynamic>? ?? []).cast<String>(),
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'address': address.toJson(), 'tags': tags};
}

void main() {
  final customer = Customer.fromJson(jsonDecode(
    '{"name": "Esha", "address": {"city": "Pokhara"}}',
  ));

  print('${customer.name} lives in ${customer.address.city}');
  print(jsonEncode(customer));
}
```

```output
Esha lives in Pokhara
{"name":"Esha","address":{"city":"Pokhara"},"tags":[]}
```

## Handling bad JSON

```dart
import 'dart:convert';

void main() {
  for (final text in ['{"ok": true}', '{not json}', '[1, 2, 3]']) {
    try {
      final data = jsonDecode(text);
      if (data case {'ok': bool ok}) {
        print('ok is $ok');
      } else {
        print('Valid JSON, but not the shape we expected');
      }
    } on FormatException {
      print('Not valid JSON');
    }
  }
}
```

```output
ok is true
Not valid JSON
Valid JSON, but not the shape we expected
```

Patterns are a compact way to check a JSON structure. See [patterns](/records-and-patterns/patterns/).

## Types that JSON does not have

Dates, enums and other custom types must be converted by hand.

```dart
import 'dart:convert';

enum Status { active, blocked }

void main() {
  final json = {
    'createdAt': DateTime.utc(2026, 10, 10).toIso8601String(),
    'status': Status.active.name,
  };
  final text = jsonEncode(json);
  print(text);

  final back = jsonDecode(text) as Map<String, dynamic>;
  final created = DateTime.parse(back['createdAt'] as String);
  final status = Status.values.byName(back['status'] as String);
  print('${created.year} $status');
}
```

```output
{"createdAt":"2026-10-10T00:00:00.000Z","status":"active"}
2026 Status.active
```

## Generating the code

Writing `fromJson` and `toJson` for dozens of classes is tedious and easy to get wrong. The `json_serializable` and `freezed` packages generate them from your class definition. Use them once you have more than a handful of models.

## Try it yourself

Given the text `{"title": "Dart Basics", "pages": 240, "author": {"name": "R. Sharma"}, "tags": ["dart", "beginner"]}`, write `Book` and `Author` classes with `fromJson` and `toJson`. Decode it, print a summary, change the page count with a `copyWith`, and encode it again.
