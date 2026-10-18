---
title: "Building Command-Line Apps in Dart"
linkTitle: "Command-line apps"
description: "Build command-line tools in Dart: read arguments and options with the args package, use stdin, stdout and exit codes, and compile to an executable."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart cli"
  - "command line app dart"
  - "args package"
  - "exit code"
  - "stderr"
  - "dart compile exe"
  - "ArgParser"
---

Dart is an excellent language for command-line tools. It starts quickly, runs on Windows, macOS and Linux, and compiles to a single file that runs without Dart installed.

## Create the project

```bash
dart create -t cli word_count
cd word_count
dart run
```

The entry point is `bin/word_count.dart`.

## Arguments

Whatever follows the program name arrives in `main` as a list of strings.

```dart
void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: greet <name>');
    return;
  }
  print('Hello, ${arguments.join(' ')}!');
}
```

```bash
dart run bin/greet.dart Asha Rai
```

```output
Hello, Asha Rai!
```

## Standard output, standard error and exit codes

A well-behaved tool follows three conventions.

| Stream or value | Use for |
| --- | --- |
| `stdout` | The actual result of the program |
| `stderr` | Errors and diagnostics, so they do not pollute piped output |
| Exit code | `0` for success, anything else for failure |

```dart
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln('Usage: line_count <file>');
    exitCode = 64; // "command used incorrectly"
    return;
  }

  final file = File(arguments.first);
  if (!file.existsSync()) {
    stderr.writeln('Error: ${file.path} not found');
    exitCode = 66; // "input not found"
    return;
  }

  stdout.writeln(file.readAsLinesSync().length);
}
```

Setting `exitCode` and returning lets the program finish cleanly. Calling `exit(1)` stops immediately and can cut off pending output, so prefer `exitCode`.

Scripts and CI systems rely on the exit code to know whether your tool worked.

## Parsing options with the args package

Hand-parsing `--verbose` and `-n 5` gets messy fast. Use the official `args` package.

```bash
dart pub add args
```

```dart
import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('name', abbr: 'n', help: 'Who to greet.', defaultsTo: 'World')
    ..addOption('times', abbr: 't', help: 'How many times.', defaultsTo: '1')
    ..addFlag('shout', abbr: 's', help: 'Use capital letters.', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Show this help.', negatable: false);

  final ArgResults options;
  try {
    options = parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln(parser.usage);
    exitCode = 64;
    return;
  }

  if (options.flag('help')) {
    print('Usage: greet [options]\n${parser.usage}');
    return;
  }

  final times = int.tryParse(options.option('times')!) ?? 1;
  var message = 'Hello, ${options.option('name')}!';
  if (options.flag('shout')) message = message.toUpperCase();

  for (var i = 0; i < times; i++) {
    print(message);
  }
}
```

```bash
dart run bin/greet.dart --name Asha -t 2 --shout
```

```output
HELLO, ASHA!
HELLO, ASHA!
```

- An **option** takes a value: `--name Asha` or `-n Asha`.
- A **flag** is on or off: `--shout`.
- Anything left over is in `options.rest`.

## Interactive input

```dart
import 'dart:io';

void main() {
  stdout.write('Delete 3 files? [y/N] ');
  final answer = stdin.readLineSync()?.trim().toLowerCase();

  if (answer == 'y' || answer == 'yes') {
    print('Deleted.');
  } else {
    print('Cancelled.');
  }
}
```

## Reading piped input

Tools are often chained together with `|`. Read everything from `stdin` as a stream of lines.

```dart
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  var lines = 0, words = 0;

  await for (final line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    lines++;
    words += line.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  print('$lines lines, $words words');
}
```

```bash
cat README.md | dart run bin/wc.dart
```

## Environment variables and platform

```dart
import 'dart:io';

void main() {
  final apiKey = Platform.environment['API_KEY'];
  if (apiKey == null) {
    stderr.writeln('Set the API_KEY environment variable first.');
    exitCode = 78;
    return;
  }

  print('Running on ${Platform.operatingSystem} with ${Platform.numberOfProcessors} cores');
}
```

Read secrets from environment variables. Do not pass them as arguments, where they show up in shell history.

## Running other programs

```dart
import 'dart:io';

Future<void> main() async {
  final result = await Process.run('git', ['status', '--short']);

  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exitCode = result.exitCode;
    return;
  }
  final changed = (result.stdout as String).trim();
  print(changed.isEmpty ? 'Working tree is clean' : changed);
}
```

## Compile to a standalone program

```bash
dart compile exe bin/greet.dart -o greet
./greet --name Dart
```

The output is a single native executable. Users do not need the Dart SDK. It only runs on the operating system it was built on, so build once on each platform you support.

To install a tool for your own use from a package, run `dart pub global activate --source path .`.

## Checklist for a pleasant tool

- Support `--help`, and print usage when arguments are wrong.
- Results to `stdout`, messages to `stderr`.
- Exit with a non-zero code on failure.
- Do not ask questions when input is piped, or offer a `--yes` flag.
- Keep `main` thin: parse arguments there, and put the real work in functions under `lib/` so it can be tested.

## Try it yourself

Build `todo`, a command-line to-do list that stores tasks in a JSON file. Support `todo add "Buy milk"`, `todo list`, `todo done 2` and `todo --help`. Return a non-zero exit code for an unknown command.
