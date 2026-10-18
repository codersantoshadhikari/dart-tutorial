---
title: "Reading Files in Dart"
linkTitle: "Reading files"
description: "Learn how to read files in Dart with dart:io: whole file as text, line by line, as bytes, as a stream, and sync versus async methods."
weight: 1
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart read file"
  - "readAsString"
  - "readAsLines"
  - "readAsBytes"
  - "openRead"
  - "dart:io File"
  - "sync vs async file"
aliases:
  - "/dart-file-handling/reading-files/"
  - "/fr/dart-file-handling/reading-files/"
  - "/dart-file-handling/asynchronous-file-operations/"
  - "/fr/dart-file-handling/asynchronous-file-operations/"
---

To work with a file, create a `File` object from its path. This does not open or create anything. It is only a reference to a location on disk.

For the examples, assume a file `notes.txt` with this content:

```text
Buy milk
Call Hari
Finish the Dart tutorial
```

## Read the whole file as a string

```dart
import 'dart:io';

Future<void> main() async {
  final file = File('notes.txt');

  final contents = await file.readAsString();
  print(contents);
  print('${contents.length} characters');
}
```

```output
Buy milk
Call Hari
Finish the Dart tutorial

44 characters
```

`readAsString` returns a `Future<String>`, so it must be awaited. Text is decoded as UTF-8 unless you pass another `encoding`.

## Read as a list of lines

```dart
import 'dart:io';

Future<void> main() async {
  final lines = await File('notes.txt').readAsLines();

  print('${lines.length} tasks');
  for (final (i, line) in lines.indexed) {
    print('${i + 1}. $line');
  }
}
```

```output
3 tasks
1. Buy milk
2. Call Hari
3. Finish the Dart tutorial
```

## Read as bytes

Images, PDFs and other binary files are read as a list of bytes.

```dart
import 'dart:io';

Future<void> main() async {
  final bytes = await File('photo.jpg').readAsBytes();

  print('${bytes.length} bytes');
  print('First bytes: ${bytes.take(3).toList()}');
}
```

## Read a large file as a stream

The methods above load the entire file into memory. For a file of hundreds of megabytes, read it in pieces with `openRead`, which returns a [stream](/async/streams/).

```dart
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final lines = File('server.log')
      .openRead()
      .transform(utf8.decoder)        // bytes -> text
      .transform(const LineSplitter()); // text -> lines

  var errors = 0;
  await for (final line in lines) {
    if (line.contains('ERROR')) errors++;
  }
  print('$errors error lines');
}
```

Only a small chunk is in memory at any moment, however big the file is.

## Synchronous and asynchronous versions

Almost every file method comes in two forms.

| Asynchronous | Synchronous | Returns |
| --- | --- | --- |
| `readAsString()` | `readAsStringSync()` | Text |
| `readAsLines()` | `readAsLinesSync()` | List of lines |
| `readAsBytes()` | `readAsBytesSync()` | Bytes |
| `exists()` | `existsSync()` | `bool` |
| `writeAsString()` | `writeAsStringSync()` | The file |

```dart
import 'dart:io';

void main() {
  final contents = File('notes.txt').readAsStringSync();
  print(contents.split('\n').first);
}
```

```output
Buy milk
```

The synchronous form needs no `await`, but it **blocks the program** until the disk responds. Which to choose:

- **Short scripts and command-line tools**: synchronous is fine and simpler.
- **Flutter apps and servers**: use the asynchronous form. A blocked thread means a frozen screen or other requests left waiting.

## The file must exist

Reading a file that is not there throws a `PathNotFoundException`, a kind of `FileSystemException`.

```dart
import 'dart:io';

Future<void> main() async {
  final file = File('missing.txt');

  try {
    print(await file.readAsString());
  } on PathNotFoundException {
    print('${file.path} does not exist');
  } on FileSystemException catch (e) {
    print('Could not read the file: ${e.message}');
  }
}
```

```output
missing.txt does not exist
```

See [file error handling](/files-and-io/file-error-handling/) for more.

## Relative and absolute paths

`File('notes.txt')` is a **relative** path. It is resolved from the folder where you ran the command, not the folder containing your `.dart` file. If a file "cannot be found", print `Directory.current.path` to see where the program is looking. Details are in [file paths](/files-and-io/file-paths/).

## Try it yourself

Create a text file with a few lines of numbers, one per line. Write a program that reads it, ignores blank or invalid lines, and prints the count, the sum and the average.
