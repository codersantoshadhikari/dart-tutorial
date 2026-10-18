---
title: "Date and Time in Dart: DateTime and Duration"
linkTitle: "Date and time"
description: "Work with dates and times in Dart: create, parse, format, compare and calculate with DateTime and Duration, including UTC and time zones."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart datetime"
  - "dart duration"
  - "format date dart"
  - "parse date"
  - "date difference"
  - "utc local time"
  - "intl DateFormat"
---

Dart handles dates with two classes. `DateTime` is a moment in time. `Duration` is a length of time.

## Creating a DateTime

```dart
void main() {
  final now = DateTime.now();
  final birthday = DateTime(1998, 4, 23);
  final meeting = DateTime(2026, 10, 15, 14, 30);
  final parsed = DateTime.parse('2026-12-31T23:59:00');

  print(now.year >= 2026);
  print(birthday);
  print(meeting);
  print(parsed);
}
```

```output
true
1998-04-23 00:00:00.000
2026-10-15 14:30:00.000
2026-12-31 23:59:00.000
```

Months are numbered 1 to 12 and days start at 1, as you would expect.

`DateTime.parse` throws on text it cannot read. Use `DateTime.tryParse`, which returns `null`, for input you do not control.

## Reading the parts

```dart
void main() {
  final date = DateTime(2026, 10, 15, 14, 30, 45);

  print(date.year);
  print(date.month);
  print(date.day);
  print(date.hour);
  print(date.minute);
  print(date.second);
  print(date.weekday); // 1 = Monday ... 7 = Sunday
  print(date.weekday == DateTime.thursday);
}
```

```output
2026
10
15
14
30
45
4
true
```

## Duration

```dart
void main() {
  const lesson = Duration(minutes: 45);
  const breakTime = Duration(minutes: 15);
  final total = lesson * 3 + breakTime * 2;

  print(total);
  print(total.inMinutes);
  print(total.inHours);
  print('${total.inHours}h ${total.inMinutes.remainder(60)}m');
  print(lesson > breakTime);
}
```

```output
2:45:00.000000
165
2
2h 45m
true
```

## Date arithmetic

A `DateTime` cannot be changed. `add` and `subtract` return a new one.

```dart
void main() {
  final start = DateTime(2026, 1, 30, 9, 0);

  print(start.add(Duration(days: 7)));
  print(start.subtract(Duration(hours: 10)));

  // Adding months or years: build a new date.
  print(DateTime(start.year, start.month + 1, start.day));
  print(DateTime(start.year + 1, start.month, start.day));
}
```

```output
2026-02-06 09:00:00.000
2026-01-29 23:00:00.000
2026-03-02 00:00:00.000
2027-01-30 00:00:00.000
```

Look at the third line. There is no 30 February, so Dart rolls over into March. Out-of-range values always overflow like this, which gives a neat trick: day 0 of a month is the last day of the month before.

```dart
void main() {
  final lastDayOfFeb = DateTime(2028, 3, 0);
  print(lastDayOfFeb.day); // 2028 is a leap year
}
```

```output
29
```

## Difference between two dates

```dart
void main() {
  final from = DateTime.utc(2026, 10, 10);
  final exam = DateTime.utc(2026, 12, 1, 9, 30);

  final remaining = exam.difference(from);

  print(remaining.inDays);
  print(remaining.inHours);
  print('${remaining.inDays} days and ${remaining.inHours % 24} hours');
}
```

```output
52
1257
52 days and 9 hours
```

## Comparing

```dart
void main() {
  final a = DateTime(2026, 5, 1);
  final b = DateTime(2026, 8, 1);

  print(a.isBefore(b));
  print(a.isAfter(b));
  print(a.isAtSameMomentAs(DateTime(2026, 5, 1)));
  print(a.compareTo(b)); // negative: a is earlier

  final dates = [b, a, DateTime(2025, 12, 25)]..sort();
  print(dates.first.year);
}
```

```output
true
false
true
-1
2025
```

To test whether two moments fall on the same calendar day, compare year, month and day.

## Local time and UTC

Every `DateTime` is either in the device's local time zone or in UTC. Store and send times in UTC. Convert to local only when showing them to a person.

```dart
void main() {
  final utc = DateTime.utc(2026, 10, 10, 12, 0);
  final local = utc.toLocal();

  print(utc.isUtc);
  print(utc.toIso8601String()); // the Z means UTC
  print(local.isUtc);
  print(local.timeZoneName.isNotEmpty);
  print(utc.isAtSameMomentAs(local)); // the same instant, shown differently
}
```

```output
true
2026-10-10T12:00:00.000Z
false
true
true
```

`toIso8601String()` is the format to use in JSON and databases, and `DateTime.parse` reads it back.

## Timestamps

```dart
void main() {
  final moment = DateTime.utc(2026, 1, 1);
  final millis = moment.millisecondsSinceEpoch;

  print(millis);
  print(DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true));
}
```

```output
1767225600000
2026-01-01 00:00:00.000Z
```

## Formatting for people

By hand, for simple cases:

```dart
String two(int n) => n.toString().padLeft(2, '0');

String formatDate(DateTime d) => '${two(d.day)}/${two(d.month)}/${d.year}';
String formatTime(DateTime d) => '${two(d.hour)}:${two(d.minute)}';

void main() {
  final d = DateTime(2026, 3, 7, 9, 5);
  print(formatDate(d));
  print(formatTime(d));
}
```

```output
07/03/2026
09:05
```

For month names, weekdays and other languages, use the `intl` package.

```dart
import 'package:intl/intl.dart';

void main() {
  final d = DateTime(2026, 10, 10, 18, 45);

  print(DateFormat('d MMMM yyyy').format(d));
  print(DateFormat('EEE, MMM d').format(d));
  print(DateFormat('hh:mm a').format(d));
  print(DateFormat.yMMMd().format(d));
}
```

```output
10 October 2026
Sat, Oct 10
06:45 PM
Oct 10, 2026
```

## Measuring how long code takes

Use `Stopwatch`, not `DateTime.now()`, for timing.

```dart
void main() {
  final watch = Stopwatch()..start();
  var sum = 0;
  for (var i = 0; i < 10000000; i++) {
    sum += i;
  }
  watch.stop();
  print('Sum $sum computed in ${watch.elapsedMilliseconds} ms');
}
```

## Try it yourself

Write `int ageOn(DateTime birthDate, DateTime today)` that returns a person's age in whole years, taking into account whether their birthday has happened yet this year. Then write a function that returns how many days remain until the next New Year.
