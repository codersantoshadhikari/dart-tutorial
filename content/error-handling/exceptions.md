---
title: "Exception Handling in Dart: try, catch, on and finally"
linkTitle: "Exceptions"
description: "Learn exception handling in Dart: throw, try, catch, on, finally and rethrow, the difference between Exception and Error, and best practices."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart try catch"
  - "exception handling"
  - "dart finally"
  - "dart throw"
  - "rethrow"
  - "on clause"
  - "stack trace"
aliases:
  - "/dart-conditions-and-loops/exception-handling-in-dart/"
  - "/fr/dart-conditions-and-loops/exception-handling-in-dart/"
---

An **exception** is Dart's way of signalling that something went wrong while the program was running. If nobody handles it, the program stops.

## An unhandled exception

```dart
void main() {
  var number = int.parse('twelve');
  print(number); // never reached
}
```

```output
Unhandled exception:
FormatException: Invalid radix-10 number (at character 1)
twelve
^
```

## try and catch

Put the risky code in a `try` block. If it throws, control jumps to `catch` and the program carries on.

```dart
void main() {
  try {
    var number = int.parse('twelve');
    print(number);
  } catch (e) {
    print('That was not a number.');
  }
  print('Program continues.');
}
```

```output
That was not a number.
Program continues.
```

## Catching specific types with on

A bare `catch` catches everything, which can hide real bugs. Use `on` to handle only the problems you expect.

```dart
void process(String input, List<int> data) {
  try {
    var index = int.parse(input);
    print('Value: ${data[index]}');
  } on FormatException {
    print('"$input" is not a number');
  } on RangeError {
    print('There is no item at position $input');
  }
}

void main() {
  var data = [10, 20, 30];
  process('1', data);
  process('one', data);
  process('7', data);
}
```

```output
Value: 20
"one" is not a number
There is no item at position 7
```

Use `on Type catch (e)` when you also need the exception object. Clauses are checked in order, so put the most specific type first.

```dart
void main() {
  try {
    int.parse('3.7');
  } on FormatException catch (e) {
    print('Bad format: ${e.source}');
  } catch (e) {
    print('Something else: $e');
  }
}
```

```output
Bad format: 3.7
```

## finally: always runs

Code in `finally` runs whether or not an exception was thrown. Use it for clean-up such as closing a file or hiding a loading spinner.

```dart
void loadData(bool fail) {
  print('Opening connection');
  try {
    if (fail) throw Exception('Server did not respond');
    print('Data loaded');
  } catch (e) {
    print('Failed: $e');
  } finally {
    print('Closing connection');
  }
}

void main() {
  loadData(false);
  print('---');
  loadData(true);
}
```

```output
Opening connection
Data loaded
Closing connection
---
Opening connection
Failed: Exception: Server did not respond
Closing connection
```

## Throwing your own

Use `throw` when your code detects a situation it cannot handle.

```dart
double divide(double a, double b) {
  if (b == 0) {
    throw ArgumentError('Cannot divide by zero');
  }
  return a / b;
}

void main() {
  try {
    print(divide(10, 2));
    print(divide(5, 0));
  } on ArgumentError catch (e) {
    print('Error: ${e.message}');
  }
}
```

```output
5.0
Error: Cannot divide by zero
```

`throw` is an expression, so it can be used after `??` and in arrow functions: `final name = input ?? (throw ArgumentError('name is required'));`.

## The stack trace

`catch` can take a second parameter: the stack trace, which lists the calls that led to the problem. Log it; do not show it to users.

```dart
void main() {
  try {
    [1, 2, 3].firstWhere((n) => n > 5);
  } catch (e, stackTrace) {
    print('Caught: $e');
    print(stackTrace.toString().split('\n').first);
  }
}
```

## rethrow: handle a little, then pass it on

Sometimes a function wants to note that something failed but leave the decision to its caller.

```dart
int parsePort(String text) {
  try {
    return int.parse(text);
  } on FormatException {
    print('[log] invalid port "$text"');
    rethrow; // same exception, original stack trace
  }
}

void main() {
  try {
    parsePort('80a');
  } on FormatException {
    print('Using default port 8080');
  }
}
```

```output
[log] invalid port "80a"
Using default port 8080
```

## Exception or Error?

Dart has two families of throwable objects.

| | `Exception` | `Error` |
| --- | --- | --- |
| Means | Something outside your control failed | There is a bug in the code |
| Examples | `FormatException`, `TimeoutException`, `HttpException` | `RangeError`, `TypeError`, `StateError`, `ArgumentError` |
| What to do | Catch it and recover | Fix the code so it never happens |

A list index out of range is an `Error`: the right response is to check the length, not to wrap the code in `try`.

## Common built-in types

| Type | Thrown when |
| --- | --- |
| `FormatException` | Text is not in the expected format |
| `RangeError` | An index or value is outside the allowed range |
| `ArgumentError` | A function received an unacceptable argument |
| `StateError` | An object is used in the wrong state, such as `first` on an empty list |
| `TypeError` | A cast with `as` fails |
| `UnsupportedError` | The operation is not allowed, such as adding to a fixed-length list |

## Best practices

- **Catch what you can handle.** If all you can do is ignore it, let it travel up to code that can respond.
- **Be specific.** Prefer `on FormatException` to a bare `catch`.
- **Never leave a catch block empty.** At least log the problem.
- **Prefer checking to catching** when it is cheap: `tryParse` over `parse`, `isEmpty` before `first`.
- **Use `finally` for clean-up**, so it happens on every path.
- **Write messages for the reader.** A user needs "Check your internet connection", not a stack trace.

## Try it yourself

Write `double safeDivide(String a, String b)` that parses both strings and divides them. Handle text that is not a number and division by zero with separate, friendly messages, and always print `Calculation finished` at the end.
