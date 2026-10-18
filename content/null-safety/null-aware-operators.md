---
title: "Null-Aware Operators in Dart: ?., ??, ??= and !"
linkTitle: "Null-aware operators"
description: "Learn Dart's null-aware operators with examples: safe access with ?., default values with ??, assign-if-null with ??= and the ! assertion."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart null aware operators"
  - "?? operator"
  - "?. operator"
  - "bang operator"
  - "null assertion"
  - "??="
---

Checking for null with `if` works, but it gets wordy. Dart has a set of small operators that handle the common cases in a few characters.

## ?? gives a default

`a ?? b` means "use `a`, but if it is null use `b`".

```dart
void main() {
  String? nickname;
  var display = nickname ?? 'Guest';
  print(display);

  nickname = 'Sunny';
  print(nickname ?? 'Guest');
}
```

```output
Guest
Sunny
```

The result of `??` is non-nullable when the right-hand side is, so `display` is a plain `String`.

## ?. reaches in safely

`a?.b` means "if `a` is not null, get `b`; otherwise the whole thing is null".

```dart
void main() {
  String? email;
  print(email?.length);
  print(email?.toUpperCase());

  email = 'hi@example.com';
  print(email?.length);
}
```

```output
null
null
14
```

Chains stop at the first null, so `user?.address?.city` never crashes. Combine it with `??` to finish with a real value:

```dart
void main() {
  String? email;
  var length = email?.length ?? 0;
  print(length);
}
```

```output
0
```

## ??= assigns only if null

```dart
void main() {
  int? retries;

  retries ??= 3; // retries was null, so it becomes 3
  retries ??= 9; // already has a value, nothing happens

  print(retries);
}
```

```output
3
```

It is handy for filling in a value the first time it is needed, as in `cache[key] ??= compute(key)`.

## ! insists the value is not null

The "bang" operator converts a nullable value to a non-nullable one. If the value is in fact null, the program throws.

```dart
void main() {
  String? token = 'abc123';
  String sure = token!;
  print(sure.length);

  String? missing;
  // print(missing!.length); // would throw: Null check operator used on a null value
  print(missing?.length);
}
```

```output
6
null
```

Every `!` is a promise the compiler cannot verify. Use it only when you know something the compiler does not, and prefer `??`, `?.` or an `if` check whenever you can. A codebase sprinkled with `!` has given up the benefit of null safety.

## Other null-aware forms

```dart
void main() {
  List<int>? numbers;
  Map<String, int>? ages;

  print(numbers?[0]);        // null-aware index
  print(ages?['Ram']);
  print([1, 2, ...?numbers]); // null-aware spread

  StringBuffer? buffer;
  buffer?..write('a')..write('b'); // null-aware cascade
  print(buffer);
}
```

```output
null
null
[1, 2]
null
```

## Choosing the right one

| You want to | Use |
| --- | --- |
| Supply a fallback value | `value ?? fallback` |
| Call something only if not null | `value?.method()` |
| Set a value only when it is missing | `value ??= initial` |
| Run several lines only if not null | `if (value != null) { ... }` |
| Assert it cannot be null here | `value!` (last resort) |

## A realistic example

```dart
class User {
  final String name;
  final String? phone;
  User(this.name, [this.phone]);
}

String contactLine(User? user) {
  final name = user?.name ?? 'Unknown';
  final phone = user?.phone ?? 'no phone';
  return '$name ($phone)';
}

void main() {
  print(contactLine(User('Maya', '9800000000')));
  print(contactLine(User('Raj')));
  print(contactLine(null));
}
```

```output
Maya (9800000000)
Raj (no phone)
Unknown (no phone)
```

## Try it yourself

Given `Map<String, String?> settings = {'theme': null, 'lang': 'ne'};`, print the theme in upper case, falling back to `LIGHT`, in a single expression. Then use `??=` to set a default theme in the map.
