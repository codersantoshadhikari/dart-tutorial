---
title: "Logging in Dart: print, dart:developer and the logging Package"
linkTitle: "Logging"
description: "Learn logging in Dart: when print is enough, structured logs with dart:developer, and levels, loggers and handlers with package:logging."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart logging"
  - "package logging"
  - "log levels"
  - "dart developer log"
  - "Logger"
  - "print vs log"
  - "debugPrint"
aliases:
  - "/dart-dev-tools--debugging/logging/"
  - "/fr/dart-dev-tools--debugging/logging/"
---

A debugger shows what is happening now, on your machine. **Logs** record what happened earlier, including on a user's device or a server you cannot attach to. Good logs turn "it crashed" into "it crashed after the third retry because the token had expired".

## print: fine for learning, limited for apps

```dart
void main() {
  print('Loading user 42');
}
```

`print` has no levels, no timestamps and no way to switch it off, and in a released app it still runs. Use it in scripts and while experimenting. The `avoid_print` lint will remind you to replace it in real projects.

## dart:developer log

`log` from `dart:developer` sends structured messages to DevTools and to the debug console of your editor. It costs almost nothing when no tool is listening.

```dart
import 'dart:developer' as developer;

void main() {
  developer.log('Fetching profile', name: 'app.network');

  try {
    throw const FormatException('Bad response');
  } catch (e, stackTrace) {
    developer.log(
      'Profile request failed',
      name: 'app.network',
      level: 1000, // severe
      error: e,
      stackTrace: stackTrace,
    );
  }
}
```

The `name` lets you filter by area in the DevTools Logging view.

## The logging package

For most applications, the official `logging` package is the right tool.

```bash
dart pub add logging
```

```dart
import 'package:logging/logging.dart';

final _log = Logger('CartService');

void main() {
  // Configure once, at start-up.
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name.padRight(7)} ${record.loggerName}: ${record.message}');
  });

  _log.fine('Cart loaded from cache');       // below INFO: not shown
  _log.info('Added item "pen"');
  _log.warning('Stock is low for "pen"');
  _log.severe('Checkout failed');
}
```

```output
INFO    CartService: Added item "pen"
WARNING CartService: Stock is low for "pen"
SEVERE  CartService: Checkout failed
```

Your code says **what happened and how important it is**. A single handler, set up in one place, decides **where it goes**: the console, a file, or a crash-reporting service.

## Log levels

| Level | Value | Use for |
| --- | --- | --- |
| `FINEST`, `FINER`, `FINE` | 300 to 500 | Detailed tracing while debugging |
| `CONFIG` | 700 | Configuration at start-up |
| `INFO` | 800 | Normal, noteworthy events: user logged in, order placed |
| `WARNING` | 900 | Something odd that the app recovered from |
| `SEVERE` | 1000 | A failure the user will notice |
| `SHOUT` | 1200 | Critical. Someone should be woken up |

Setting `Logger.root.level = Level.WARNING` in production hides the chatter. In development, `Level.ALL` shows everything.

## Logging errors with their stack traces

```dart
import 'package:logging/logging.dart';

final _log = Logger('PaymentService');

Future<void> pay(double amount) async {
  try {
    if (amount > 1000) throw StateError('Card limit exceeded');
    _log.info('Paid $amount');
  } catch (error, stackTrace) {
    _log.severe('Payment of $amount failed', error, stackTrace);
  }
}

Future<void> main() async {
  Logger.root.onRecord.listen((r) {
    print('[${r.level.name}] ${r.loggerName}: ${r.message}');
    if (r.error != null) print('  error: ${r.error}');
  });

  await pay(250);
  await pay(5000);
}
```

```output
[INFO] PaymentService: Paid 250.0
[SEVERE] PaymentService: Payment of 5000.0 failed
  error: Bad state: Card limit exceeded
```

## A logger for each area

Loggers form a hierarchy through dots in their names. You can make one area more or less talkative without touching the others.

```dart
import 'package:logging/logging.dart';

void main() {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.WARNING;
  Logger('app.network').level = Level.ALL; // investigate just this area

  Logger.root.onRecord.listen((r) => print('${r.loggerName}: ${r.message}'));

  Logger('app.network').fine('GET /users');
  Logger('app.database').fine('SELECT * FROM users'); // hidden
  Logger('app.database').warning('Slow query: 900 ms');
}
```

```output
app.network: GET /users
app.database: Slow query: 900 ms
```

## Avoid paying for messages nobody reads

Building a large message takes time even if its level is switched off. Pass a function and it is only called when needed.

```dart
import 'package:logging/logging.dart';

final _log = Logger('Sync');

String expensiveDump() {
  print('(building dump)');
  return 'lots of detail';
}

void main() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) => print(r.message));

  _log.fine(() => 'State: ${expensiveDump()}'); // never built
  _log.info('Sync complete');
}
```

```output
Sync complete
```

## What to log, and what never to log

**Do log:**

- Start-up, configuration and version.
- Important user actions and state changes.
- Every caught error, with its stack trace.
- External calls: what was requested, the status and how long it took.
- Identifiers that tie lines together: order id, request id.

**Never log:**

- Passwords, tokens, API keys or session cookies.
- Card numbers or bank details.
- Personal data, unless you truly need it and are allowed to keep it.

Logs get copied into bug reports, dashboards and chat. Assume anything you log will be read by someone you did not expect.

## Writing useful messages

```text
Bad:   Error
Bad:   here 2
Good:  Order 1042 could not be saved: database timeout after 5s (attempt 3 of 3)
```

Say what happened, to what, and why if you know it.

## In Flutter

- `debugPrint` is a `print` that avoids dropped lines on Android. It is still only for development.
- Use `logging`, or a similar package such as `logger`, for app logs.
- Send severe records to a crash reporter such as Firebase Crashlytics or Sentry from your `onRecord` handler.

## Try it yourself

Add the `logging` package to a small program with two classes. Give each class its own logger. Configure the root logger to print the time, level, logger name and message. Run it at `Level.ALL` and at `Level.WARNING` and compare the output.
