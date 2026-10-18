---
title: "Writing Files in Dart"
linkTitle: "Writing files"
description: "Learn how to write files in Dart: create and overwrite with writeAsString, append, write bytes, and write large files with IOSink."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart write file"
  - "writeAsString"
  - "FileMode.append"
  - "IOSink"
  - "openWrite"
  - "create file dart"
aliases:
  - "/dart-file-handling/writing-files/"
  - "/fr/dart-file-handling/writing-files/"
---

Writing is as direct as reading. One method call creates the file if needed and puts your text in it.

## Write a string

```dart
import 'dart:io';

Future<void> main() async {
  final file = File('greeting.txt');

  await file.writeAsString('Hello, file!\n');
  print(await file.readAsString());
}
```

```output
Hello, file!
```

If the file does not exist it is created. If it does exist, **its contents are replaced**.

## Append instead of overwrite

Pass `mode: FileMode.append` to add to the end.

```dart
import 'dart:io';

Future<void> main() async {
  final log = File('app.log');

  await log.writeAsString('App started\n');
  await log.writeAsString('User logged in\n', mode: FileMode.append);
  await log.writeAsString('User logged out\n', mode: FileMode.append);

  print(await log.readAsString());
}
```

```output
App started
User logged in
User logged out
```

| Mode | Effect |
| --- | --- |
| `FileMode.write` (default) | Replace everything |
| `FileMode.append` | Add to the end |
| `FileMode.writeOnly` | Replace, without read access |
| `FileMode.writeOnlyAppend` | Append, without read access |

## Write several lines

Join the lines with a newline, or build the text with a `StringBuffer`.

```dart
import 'dart:io';

Future<void> main() async {
  final tasks = ['Buy milk', 'Call Hari', 'Finish the Dart tutorial'];

  await File('tasks.txt').writeAsString('${tasks.join('\n')}\n');
  print('Saved ${tasks.length} tasks');
}
```

## Create missing folders first

Writing to `reports/2026/summary.txt` fails if the `reports/2026` folder does not exist. `create(recursive: true)` makes the file and any missing parent folders.

```dart
import 'dart:io';

Future<void> main() async {
  final file = File('reports/2026/summary.txt');

  await file.create(recursive: true);
  await file.writeAsString('Total sales: 1200\n');

  print('Wrote ${file.path}');
}
```

## Write bytes

```dart
import 'dart:io';

Future<void> main() async {
  final source = File('photo.jpg');
  final bytes = await source.readAsBytes();

  await File('photo_backup.jpg').writeAsBytes(bytes);
  print('Copied ${bytes.length} bytes');
}
```

For a plain copy, `await source.copy('photo_backup.jpg')` does the same without loading the file into memory.

## Write a lot, piece by piece, with IOSink

Calling `writeAsString` in a loop reopens the file each time. For many writes, open the file once with `openWrite`, which gives you an `IOSink`.

```dart
import 'dart:io';

Future<void> main() async {
  final sink = File('numbers.csv').openWrite();

  sink.writeln('number,square');
  for (var i = 1; i <= 5; i++) {
    sink.writeln('$i,${i * i}');
  }

  await sink.flush(); // push buffered data to disk
  await sink.close(); // release the file

  print(await File('numbers.csv').readAsString());
}
```

```output
number,square
1,1
2,4
3,9
4,16
5,25
```

Always `close` a sink. Until you do, some data may still be sitting in memory. `openWrite(mode: FileMode.append)` appends.

## Writing structured data

To save a list or a map, convert it to JSON text first. See [working with JSON](/practical-dart/json/).

```dart
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final settings = {'theme': 'dark', 'fontSize': 16, 'recent': ['a.txt', 'b.txt']};

  await File('settings.json')
      .writeAsString(const JsonEncoder.withIndent('  ').convert(settings));

  final loaded = jsonDecode(await File('settings.json').readAsString());
  print(loaded['theme']);
}
```

```output
dark
```

## Writing safely

If the program crashes halfway through a write, the file can be left half written. For data that matters, write to a temporary file and then rename it over the original. A rename either happens fully or not at all.

```dart
import 'dart:io';

Future<void> saveSafely(String path, String contents) async {
  final temp = File('$path.tmp');
  await temp.writeAsString(contents, flush: true);
  await temp.rename(path);
}

Future<void> main() async {
  await saveSafely('important.txt', 'Do not lose this\n');
  print(await File('important.txt').readAsString());
}
```

## Try it yourself

Write a tiny diary program. Each time it runs, it reads a line from the keyboard and appends it to `diary.txt` with the current date and time in front. Then it prints how many entries the diary holds.
