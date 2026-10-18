---
title: "Unit Testing in Dart with package:test"
linkTitle: "Testing"
description: "Learn unit testing in Dart: write tests with test and expect, group them, use matchers, test async code and exceptions, and run dart test."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart test"
  - "unit testing dart"
  - "expect matcher"
  - "package:test"
  - "test async dart"
  - "throwsA"
  - "setUp tearDown"
  - "dart test coverage"
---

A test is a small program that checks whether your code does what you expect. Tests catch mistakes before your users do, and they let you change code without fear, because one command tells you whether anything broke.

## Set up

Projects made with `dart create` already include the `test` package. Otherwise:

```bash
dart pub add --dev test
```

Tests live in the `test/` folder, in files whose names end with `_test.dart`.

## The code under test

```dart
// File: lib/cart.dart

class Cart {
  final _items = <String, double>{};

  void add(String name, double price) {
    if (price < 0) throw ArgumentError('Price cannot be negative');
    _items[name] = price;
  }

  void remove(String name) => _items.remove(name);

  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;
  double get total => _items.values.fold(0, (sum, p) => sum + p);

  double totalWithDiscount(double percent) => total * (1 - percent / 100);
}
```

## A first test

```dart
// File: test/cart_test.dart
import 'package:my_app/cart.dart';
import 'package:test/test.dart';

void main() {
  test('a new cart is empty', () {
    final cart = Cart();

    expect(cart.isEmpty, isTrue);
    expect(cart.count, 0);
    expect(cart.total, 0);
  });

  test('total is the sum of item prices', () {
    final cart = Cart()
      ..add('pen', 20)
      ..add('book', 350);

    expect(cart.total, 370);
  });
}
```

`test` takes a description and a function. `expect(actual, expected)` passes when they match, and fails the test with a clear message when they do not.

## Run the tests

```bash
dart test
```

```output
00:00 +2: All tests passed!
```

A failure tells you exactly what went wrong:

```output
00:00 +1 -1: total is the sum of item prices [E]
  Expected: <370>
    Actual: <350.0>
```

Other useful commands:

```bash
dart test test/cart_test.dart        # one file
dart test --name "empty"             # tests whose name contains "empty"
dart test --coverage=coverage        # collect coverage data
```

## Arrange, act, assert

A readable test has three parts: set things up, do the one thing being tested, and check the result.

```dart
import 'package:my_app/cart.dart';
import 'package:test/test.dart';

void main() {
  test('removing an item lowers the total', () {
    // Arrange
    final cart = Cart()
      ..add('pen', 20)
      ..add('book', 350);

    // Act
    cart.remove('pen');

    // Assert
    expect(cart.count, 1);
    expect(cart.total, 350);
  });
}
```

## Groups, setUp and tearDown

`group` collects related tests. `setUp` runs before **each** test in the group, so every test starts from a fresh state.

```dart
import 'package:my_app/cart.dart';
import 'package:test/test.dart';

void main() {
  group('Cart', () {
    late Cart cart;

    setUp(() {
      cart = Cart()..add('book', 400);
    });

    test('counts its items', () {
      expect(cart.count, 1);
    });

    test('applies a percentage discount', () {
      expect(cart.totalWithDiscount(25), 300);
    });

    group('with invalid input', () {
      test('rejects a negative price', () {
        expect(() => cart.add('bad', -5), throwsArgumentError);
      });
    });
  });
}
```

`tearDown` runs after each test, for cleaning up files or connections. `setUpAll` and `tearDownAll` run once for the whole group.

## Matchers

The second argument of `expect` can be a **matcher**, which describes what you expect more flexibly than a single value.

| Matcher | Passes when |
| --- | --- |
| `equals(x)` or just `x` | Equal. Lists and maps are compared by content |
| `isTrue`, `isFalse`, `isNull`, `isNotNull` | As named |
| `isA<String>()` | The value is of that type |
| `greaterThan(5)`, `lessThanOrEqualTo(10)`, `inInclusiveRange(1, 5)` | Number comparisons |
| `closeTo(3.14, 0.01)` | A double within a tolerance |
| `contains('x')` | A string, list or map contains it |
| `startsWith('a')`, `endsWith('z')`, `matches(r'\d+')` | String checks |
| `isEmpty`, `isNotEmpty`, `hasLength(3)` | Collection size |
| `containsAll([1, 2])`, `unorderedEquals([2, 1])` | Collection contents |
| `throwsA(isA<FormatException>())` | The function throws that type |
| `throwsArgumentError`, `throwsStateError` | Shortcuts for common errors |

```dart
import 'package:test/test.dart';

void main() {
  test('matcher examples', () {
    expect([3, 1, 2], hasLength(3));
    expect([3, 1, 2], containsAll([1, 2]));
    expect('Dart tutorial', startsWith('Dart'));
    expect(0.1 + 0.2, closeTo(0.3, 1e-9));
    expect({'a': 1}, containsPair('a', 1));
    expect(() => int.parse('x'), throwsFormatException);
    expect(
      () => throw StateError('closed'),
      throwsA(isA<StateError>().having((e) => e.message, 'message', 'closed')),
    );
  });
}
```

When testing an exception, pass a **function** to `expect`, as in `() => int.parse('x')`. If you call it directly, it throws before `expect` runs.

## Testing asynchronous code

Make the test function `async` and `await` as usual. The test waits for it to finish.

```dart
import 'package:test/test.dart';

Future<String> fetchGreeting(String name) async {
  await Future.delayed(Duration(milliseconds: 50));
  if (name.isEmpty) throw ArgumentError('name is empty');
  return 'Hello, $name';
}

Stream<int> countTo(int n) async* {
  for (var i = 1; i <= n; i++) {
    yield i;
  }
}

void main() {
  test('returns a greeting', () async {
    expect(await fetchGreeting('Asha'), 'Hello, Asha');
  });

  test('completes with a value', () {
    expect(fetchGreeting('Bimal'), completion(endsWith('Bimal')));
  });

  test('fails for an empty name', () {
    expect(fetchGreeting(''), throwsArgumentError);
  });

  test('stream emits values in order', () {
    expect(countTo(3), emitsInOrder([1, 2, 3, emitsDone]));
  });
}
```

## Replacing real dependencies with fakes

Tests should not call a real server or database. They would be slow and fail at random. Depend on an interface and pass in a simple fake.

```dart
import 'package:test/test.dart';

abstract interface class WeatherApi {
  Future<double> temperature(String city);
}

class FakeWeatherApi implements WeatherApi {
  @override
  Future<double> temperature(String city) async => city == 'Pokhara' ? 24 : 31;
}

class Advisor {
  Advisor(this.api);
  final WeatherApi api;

  Future<String> advice(String city) async =>
      await api.temperature(city) > 28 ? 'Stay in the shade' : 'Go for a walk';
}

void main() {
  test('gives advice based on temperature', () async {
    final advisor = Advisor(FakeWeatherApi());

    expect(await advisor.advice('Pokhara'), 'Go for a walk');
    expect(await advisor.advice('Nepalgunj'), 'Stay in the shade');
  });
}
```

For larger projects, the `mocktail` and `mockito` packages create mocks for you.

## What makes a good test

- **One behaviour per test.** When it fails, the name tells you what is broken.
- **A descriptive name**: `rejects a negative price`, not `test2`.
- **Independent.** Tests must not rely on running in a particular order.
- **Fast.** No network, no sleeping. Hundreds of tests should take seconds.
- **Covers the edges**: empty input, zero, negative numbers, very large values, `null`.
- **Tests behaviour, not implementation.** Check what a function returns, not how it does it, so you can refactor freely.

When you find a bug, first write a test that fails because of it, then fix the code. The bug cannot quietly return.

## Try it yourself

Write a `PasswordValidator` class with an `errors(String password)` method that returns a list of problems: too short, no digit, no upper-case letter. Write at least six tests for it, including an empty password and a valid one, and run them with `dart test`.
