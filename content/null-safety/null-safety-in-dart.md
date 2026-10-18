---
title: "Null Safety in Dart: Nullable and Non-Nullable Types"
seoTitle: "Dart Null Safety Explained: Nullable and Non-Nullable Types"
linkTitle: "Null safety basics"
description: "Learn sound null safety in Dart: what null is, nullable types with ?, type promotion, and how the compiler prevents null errors."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart null safety"
  - "nullable types"
  - "non-nullable"
  - "type promotion"
  - "sound null safety"
aliases:
  - "/null-safety-in-dart/"
  - "/fr/null-safety-in-dart/"
---

`null` means "no value". It is useful: a user may have no middle name, a search may find nothing. The danger comes from **forgetting** that a value might be missing and using it anyway.

Dart's answer is **sound null safety**: every type is non-nullable unless you say otherwise, and the compiler checks every use.

## Non-nullable by default

```dart
void main() {
  String name = 'Dart';
  // name = null; // error: null can't be assigned to String

  print(name.length); // always safe
}
```

```output
4
```

Because `name` can never be null, `name.length` can never crash.

## Allowing null with ?

Add `?` after a type to say the variable may hold `null`.

```dart
void main() {
  String? middleName;       // starts as null
  print(middleName);

  middleName = 'Kumar';
  print(middleName);

  int? age = null;
  print(age);
}
```

```output
null
Kumar
null
```

`String` and `String?` are different types. Think of `String?` as "either a String or nothing".

## The compiler protects you

You cannot call methods on a value that might be null.

```dart
void main() {
  String? city;

  // print(city.length);
  // error: 'length' can't be accessed because the receiver can be null

  print(city?.length); // safe: gives null instead of crashing
}
```

```output
null
```

## Type promotion: check, then use

When you test that a variable is not null, Dart treats it as non-nullable from that point on. No extra syntax is needed.

```dart
void describe(String? city) {
  if (city == null) {
    print('No city given');
    return;
  }
  // From here, city is a String.
  print('${city.toUpperCase()} has ${city.length} letters');
}

void main() {
  describe(null);
  describe('Pokhara');
}
```

```output
No city given
POKHARA has 7 letters
```

Promotion works for local variables, parameters and private `final` fields. For other fields, copy the value into a local variable first:

```dart
class Profile {
  String? bio;
}

void main() {
  var profile = Profile()..bio = 'Dart learner';

  final bio = profile.bio;
  if (bio != null) {
    print(bio.length);
  }
}
```

```output
12
```

## Nullable types in functions and collections

```dart
String? findUser(int id) {
  const users = {1: 'Asha', 2: 'Bimal'};
  return users[id]; // null when the id is missing
}

void main() {
  print(findUser(1));
  print(findUser(9));

  List<String?> answers = ['yes', null, 'no']; // items may be null
  List<String>? maybeList;                     // the list itself may be null

  print(answers);
  print(maybeList);
}
```

```output
Asha
null
[yes, null, no]
null
```

## What "sound" means

If a variable's type is non-nullable, it is **guaranteed** never to be null, in every part of the program. Since Dart 3 this is always on. That guarantee lets the compiler remove hidden null checks, so null-safe code is also a little faster.

## Good habits

- Make things non-nullable unless there is a real reason for them to be missing.
- Prefer an empty list or an empty string to `null` when "nothing" and "empty" mean the same thing.
- Handle the null case close to where the value arrives, then pass non-null values around.

The next lesson covers the operators that make working with nullable values short: `?.`, `??`, `??=` and `!`.

## Try it yourself

Write `String greeting(String name, String? title)` that returns `Hello, Dr. Rai` when a title is given and `Hello, Rai` when it is null. Use an `if` check and let type promotion do the work.
