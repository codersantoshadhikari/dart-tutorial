---
title: "Regular Expressions in Dart with RegExp"
linkTitle: "Regular expressions"
description: "Learn RegExp in Dart: test, find, extract and replace text with patterns, use groups and named groups, and validate input."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart regex"
  - "RegExp"
  - "hasMatch"
  - "firstMatch"
  - "allMatches"
  - "named groups"
  - "replaceAllMapped"
  - "validate email dart"
---

A **regular expression** (regex) is a pattern that describes text. With one you can check whether a string has a certain shape, pull pieces out of it, or replace parts of it. In Dart, regular expressions are `RegExp` objects.

Always write the pattern as a **raw string**, `r'...'`, so that backslashes are not treated as escapes by Dart.

## Does it match?

```dart
void main() {
  final digitsOnly = RegExp(r'^\d+$');

  print(digitsOnly.hasMatch('12345'));
  print(digitsOnly.hasMatch('123a5'));
  print(RegExp(r'cat').hasMatch('concatenate')); // found anywhere
}
```

```output
true
false
true
```

Without `^` (start) and `$` (end), a pattern matches if it is found **anywhere** in the text.

## Pattern cheat sheet

| Pattern | Matches |
| --- | --- |
| `abc` | The exact text "abc" |
| `.` | Any single character |
| `\d` `\w` `\s` | A digit, a word character (letter, digit, `_`), whitespace |
| `\D` `\W` `\S` | The opposite of each |
| `[abc]` `[a-z]` `[^0-9]` | One of a set, a range, anything not in the set |
| `^` `$` | Start and end of the text |
| `\b` | A word boundary |
| `*` `+` `?` | Zero or more, one or more, zero or one |
| `{3}` `{2,5}` `{2,}` | Exactly 3, between 2 and 5, 2 or more |
| `a\|b` | Either a or b |
| `( )` | A group |
| `\.` `\?` `\(` | A literal special character |

## Find the first match

`firstMatch` returns a match object, or `null`.

```dart
void main() {
  final price = RegExp(r'\d+\.\d{2}');
  final match = price.firstMatch('Total due: Rs. 1499.50 by Friday');

  if (match != null) {
    print(match.group(0)); // the whole match
    print(match.start);
    print(match.end);
  }

  print('No digits here'.contains(price));
}
```

```output
1499.50
15
22
false
```

## Find every match

```dart
void main() {
  const text = 'Call 9841000000 or 9801234567, not 12345.';
  final phone = RegExp(r'\b9\d{9}\b');

  final numbers = phone.allMatches(text).map((m) => m.group(0)!).toList();
  print(numbers);

  final hashtags = RegExp(r'#\w+')
      .allMatches('Learning #dart and #flutter today')
      .map((m) => m[0]!)
      .toList();
  print(hashtags);
}
```

```output
[9841000000, 9801234567]
[#dart, #flutter]
```

`m[0]` is shorthand for `m.group(0)`.

## Groups: pull out the parts

Brackets capture part of the match. Group 0 is everything, and groups 1, 2, 3 follow the opening brackets from left to right.

```dart
void main() {
  final date = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
  final match = date.firstMatch('Published on 2026-10-10.')!;

  print(match.group(0));
  print(match.group(1));
  print(match.group(2));
  print(match.group(3));
}
```

```output
2026-10-10
2026
10
10
```

## Named groups

Numbers become hard to follow. Give groups names with `(?<name>...)`.

```dart
void main() {
  final pattern = RegExp(r'(?<user>[\w.]+)@(?<domain>[\w.-]+\.\w+)');
  final match = pattern.firstMatch('Contact: asha.rai@example.com.np today');

  if (match != null) {
    print(match.namedGroup('user'));
    print(match.namedGroup('domain'));
  }
}
```

```output
asha.rai
example.com.np
```

## Replace

`String.replaceAll` accepts a `RegExp`. Use `replaceAllMapped` when the replacement depends on what was matched.

```dart
void main() {
  // Collapse runs of whitespace.
  print('too    many     spaces'.replaceAll(RegExp(r'\s+'), ' '));

  // Hide all but the last four digits.
  print('4111111111111111'.replaceAll(RegExp(r'\d(?=\d{4})'), '*'));

  // Swap day and month.
  print('10/31/2026'.replaceAllMapped(
    RegExp(r'(\d+)/(\d+)/(\d+)'),
    (m) => '${m[2]}/${m[1]}/${m[3]}',
  ));

  // Upper-case every word that follows a hash.
  print('use #dart daily'.replaceAllMapped(
    RegExp(r'#(\w+)'),
    (m) => '#${m[1]!.toUpperCase()}',
  ));
}
```

```output
too many spaces
************1111
31/10/2026
use #DART daily
```

## Split

```dart
void main() {
  print('apple, banana;cherry  date'.split(RegExp(r'[,;\s]+')));
}
```

```output
[apple, banana, cherry, date]
```

## Options

```dart
void main() {
  final anyCase = RegExp(r'dart', caseSensitive: false);
  print(anyCase.hasMatch('I love DART'));

  final lineStarts = RegExp(r'^\w+', multiLine: true);
  print(lineStarts.allMatches('one two\nthree four').map((m) => m[0]).toList());

  final emoji = RegExp(r'\p{Emoji_Presentation}', unicode: true);
  print(emoji.hasMatch('Hello 👋'));
}
```

```output
true
[one, three]
true
```

| Option | Effect |
| --- | --- |
| `caseSensitive: false` | Ignore upper and lower case |
| `multiLine: true` | `^` and `$` match at each line, not only at the ends of the text |
| `dotAll: true` | `.` also matches new lines |
| `unicode: true` | Enables `\p{...}` and treats emoji as single characters |

## Validation helpers

```dart
final _email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
final _username = RegExp(r'^[a-z][a-z0-9_]{2,15}$');
final _hexColour = RegExp(r'^#([0-9a-fA-F]{6})$');

bool isEmail(String s) => _email.hasMatch(s);
bool isUsername(String s) => _username.hasMatch(s);
bool isHexColour(String s) => _hexColour.hasMatch(s);

bool isStrongPassword(String s) =>
    s.length >= 8 &&
    s.contains(RegExp(r'[A-Z]')) &&
    s.contains(RegExp(r'[a-z]')) &&
    s.contains(RegExp(r'\d'));

void main() {
  print(isEmail('rita@example.com'));
  print(isEmail('rita@example'));
  print(isUsername('dart_fan99'));
  print(isHexColour('#0B5FD9'));
  print(isStrongPassword('Secret123'));
}
```

```output
true
false
true
true
true
```

## Advice

- Create a `RegExp` once and reuse it. Building one inside a loop wastes time.
- Start simple and test with real examples, including ones that should **not** match.
- A regex for email can only check the rough shape. The real test is sending a message.
- If a pattern needs a paragraph to explain, plain string methods (`startsWith`, `split`, `contains`) may be clearer.
- Do not parse HTML or JSON with regular expressions. Use a parser.

## Try it yourself

Write a function that takes a log line such as `2026-10-10 14:05:33 [ERROR] Disk full on /dev/sda1` and returns a record with the date, the time, the level and the message, using named groups. Return `null` when the line does not match.
