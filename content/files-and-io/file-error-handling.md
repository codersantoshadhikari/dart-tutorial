---
title: "Handling File Errors in Dart"
linkTitle: "File error handling"
description: "Handle file system errors in Dart: FileSystemException, missing files, permission problems, and writing reliable file code."
weight: 7
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "FileSystemException"
  - "PathNotFoundException"
  - "dart file error"
  - "permission denied"
  - "OSError"
  - "file exception handling"
aliases:
  - "/dart-file-handling/error-handling/"
  - "/fr/dart-file-handling/error-handling/"
---

File operations depend on things outside your program: the disk, permissions, other programs. Any of them can fail. Good file code expects that.

## FileSystemException

Nearly every failure in `dart:io` is reported as a `FileSystemException`, or one of its subclasses.

```dart
import 'dart:io';

Future<void> main() async {
  try {
    await File('/no/such/folder/data.txt').readAsString();
  } on FileSystemException catch (e) {
    print('Message:  ${e.message}');
    print('Path:     ${e.path}');
    print('OS error: ${e.osError?.message} (code ${e.osError?.errorCode})');
  }
}
```

```output
Message:  Cannot open file
Path:     /no/such/folder/data.txt
OS error: No such file or directory (code 2)
```

| Property | Contains |
| --- | --- |
| `message` | What Dart was trying to do |
| `path` | The file or directory involved |
| `osError` | The operating system's own explanation and error code |

## Specific subclasses

Catch the specific type when you want to react to one cause in particular.

| Exception | Cause |
| --- | --- |
| `PathNotFoundException` | The file or directory does not exist |
| `PathAccessException` | Permission denied |
| `PathExistsException` | Something is already at that path |
| `FileSystemException` | Anything else: disk full, file in use, bad name |

```dart
import 'dart:io';

Future<String> loadConfig(String path) async {
  try {
    return await File(path).readAsString();
  } on PathNotFoundException {
    print('No config found, using defaults');
    return '{}';
  } on PathAccessException {
    print('No permission to read $path');
    rethrow;
  } on FileSystemException catch (e) {
    print('Unexpected file problem: ${e.message}');
    rethrow;
  }
}

Future<void> main() async {
  print(await loadConfig('config.json'));
}
```

```output
No config found, using defaults
{}
```

Put the specific types first. The general `FileSystemException` goes last, since it matches all of them.

## Bad content is a different error

The file may open perfectly and still contain something you cannot use. Those failures are not `FileSystemException`s.

```dart
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> readJson(String path) async {
  try {
    final text = await File(path).readAsString();
    final data = jsonDecode(text);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object');
    }
    return data;
  } on PathNotFoundException {
    return {};
  } on FormatException catch (e) {
    print('$path is not valid JSON: ${e.message}');
    return {};
  }
}

Future<void> main() async {
  print(await readJson('settings.json'));
}
```

A file that is not valid UTF-8 text also raises a `FileSystemException` from `readAsString`. Read it as bytes if you are not sure what it holds.

## Always release what you open

If an error occurs while a sink is open, the file can stay locked. Close it in `finally`.

```dart
import 'dart:io';

Future<void> writeReport(List<String> lines) async {
  final sink = File('report.txt').openWrite();
  try {
    for (final line in lines) {
      sink.writeln(line);
    }
    await sink.flush();
  } finally {
    await sink.close();
  }
}

Future<void> main() async {
  await writeReport(['Line one', 'Line two']);
  print('Report written');
}
```

## Errors in streams

When reading with `openRead`, a failure arrives as a stream error. `await for` inside `try` catches it.

```dart
import 'dart:convert';
import 'dart:io';

Future<int> countLines(String path) async {
  try {
    var count = 0;
    final lines = File(path)
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    await for (final _ in lines) {
      count++;
    }
    return count;
  } on FileSystemException catch (e) {
    print('Could not read $path: ${e.osError?.message ?? e.message}');
    return 0;
  }
}

Future<void> main() async {
  print(await countLines('missing.log'));
}
```

```output
Could not read missing.log: No such file or directory
0
```

## Wrap low-level errors for the rest of your app

The screens of your app should not need to know about `osError` codes. Translate at the boundary. See [custom exceptions](/error-handling/custom-exceptions/).

```dart
import 'dart:io';

class StorageException implements Exception {
  final String userMessage;
  final Object cause;
  StorageException(this.userMessage, this.cause);

  @override
  String toString() => userMessage;
}

Future<void> saveNote(String path, String text) async {
  try {
    await File(path).writeAsString(text);
  } on PathAccessException catch (e) {
    throw StorageException('You do not have permission to save here.', e);
  } on FileSystemException catch (e) {
    throw StorageException('The note could not be saved. Is the disk full?', e);
  }
}

Future<void> main() async {
  try {
    await saveNote('/root/forbidden/note.txt', 'hello');
  } on StorageException catch (e) {
    print(e);          // for the user
    // log(e.cause);   // for the developer
  }
}
```

## Checklist

- Wrap file operations in `try`/`catch`. Assume any of them can fail.
- Catch `FileSystemException`, not a bare `catch`, so real bugs still surface.
- Decide for each case: use a default, ask the user, retry, or give up.
- Close sinks and delete temporary files in `finally`.
- Show users a plain message. Log the path and `osError` for yourself.
- Never ignore a failed **write**. Silent data loss is the worst outcome.

## Try it yourself

Write `Future<List<String>> readLinesOrEmpty(String path)` that returns the lines of a file, an empty list if the file is missing, and throws a `StorageException` with a friendly message for any other problem. Test it with a missing file and with a directory path.
