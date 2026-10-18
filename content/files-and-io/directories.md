---
title: "Working with Directories in Dart"
linkTitle: "Directories"
description: "Learn directory handling in Dart: create, list, search, copy and delete folders, and find the current and temporary directories."
weight: 4
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart directory"
  - "list files in folder"
  - "create directory"
  - "delete directory recursive"
  - "Directory.current"
  - "systemTemp"
aliases:
  - "/dart-file-handling/directory-handling/"
  - "/fr/dart-file-handling/directory-handling/"
  - "/dart-file-handling/file-system-access/"
  - "/fr/dart-file-handling/file-system-access/"
---

A `Directory` object represents a folder, in the same way a `File` represents a file.

## Create a directory

```dart
import 'dart:io';

Future<void> main() async {
  final dir = Directory('output/reports/2026');

  await dir.create(recursive: true); // creates missing parents too
  print(await dir.exists());
}
```

```output
true
```

Without `recursive: true`, the call fails unless `output/reports` already exists. Creating a directory that is already there is not an error.

## List the contents

`list()` returns a stream of entries. Each one is a `File`, a `Directory` or a `Link`.

```dart
import 'dart:io';

Future<void> main() async {
  final dir = Directory('lib');

  await for (final entity in dir.list()) {
    final kind = entity is Directory ? 'DIR ' : 'FILE';
    print('$kind ${entity.path}');
  }
}
```

```output
FILE lib/main.dart
DIR  lib/models
FILE lib/utils.dart
```

Pass `recursive: true` to include everything in sub-folders. `listSync()` returns a plain list straight away.

## Find files by extension

```dart
import 'dart:io';

Future<List<File>> findFiles(String folder, String extension) async {
  final found = <File>[];

  await for (final entity in Directory(folder).list(recursive: true)) {
    if (entity is File && entity.path.endsWith(extension)) {
      found.add(entity);
    }
  }
  return found;
}

Future<void> main() async {
  final dartFiles = await findFiles('lib', '.dart');

  print('Found ${dartFiles.length} Dart files');
  for (final file in dartFiles) {
    print('  ${file.path}');
  }
}
```

## Total size of a folder

```dart
import 'dart:io';

Future<int> folderSize(Directory dir) async {
  var total = 0;
  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File) total += await entity.length();
  }
  return total;
}

Future<void> main() async {
  final bytes = await folderSize(Directory('lib'));
  print('${(bytes / 1024).toStringAsFixed(1)} KB');
}
```

## Useful locations

```dart
import 'dart:io';

void main() {
  print(Directory.current.path);    // where the program was started
  print(Directory.systemTemp.path); // the system's temp folder
  print(Platform.script.toFilePath()); // the running script
  print(Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']);
}
```

In a Flutter app, do not guess where you may write. Use the `path_provider` package, which returns the correct documents and cache folders on each platform.

## Temporary directories

For scratch files, create a uniquely named folder in the system temp location and remove it when finished.

```dart
import 'dart:io';

Future<void> main() async {
  final temp = await Directory.systemTemp.createTemp('myapp_');

  try {
    final file = File('${temp.path}/work.txt');
    await file.writeAsString('scratch data');
    print('Working in ${temp.path}');
  } finally {
    await temp.delete(recursive: true);
  }
}
```

## Rename and delete

```dart
import 'dart:io';

Future<void> main() async {
  final dir = await Directory('old_name').create();
  final renamed = await dir.rename('new_name');
  print(renamed.path);

  await renamed.delete();                    // only works if empty
  // await renamed.delete(recursive: true);  // deletes all contents as well
}
```

`delete(recursive: true)` is the programming equivalent of `rm -rf`. There is no undo. Never run it on a path you have not checked.

## Copy a directory

`dart:io` has no single call for copying a folder. Walk the tree and copy each file.

```dart
import 'dart:io';

Future<void> copyDirectory(Directory source, Directory target) async {
  await target.create(recursive: true);

  await for (final entity in source.list()) {
    final name = entity.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
    final newPath = '${target.path}/$name';

    if (entity is Directory) {
      await copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      await entity.copy(newPath);
    }
  }
}

Future<void> main() async {
  await copyDirectory(Directory('lib'), Directory('lib_backup'));
  print('Copied');
}
```

## Watch for changes

On desktop platforms you can be notified when something in a folder changes.

```dart
import 'dart:io';

void main() {
  Directory('lib').watch(recursive: true).listen((event) {
    print('${event.type}: ${event.path}');
  });
  print('Watching lib/ ... press Ctrl+C to stop');
}
```

## Quick reference

| Task | Code |
| --- | --- |
| Create, with parents | `await dir.create(recursive: true)` |
| Exists? | `await dir.exists()` |
| List | `dir.list()` or `dir.listSync()` |
| List everything below | `dir.list(recursive: true)` |
| Rename or move | `await dir.rename(newPath)` |
| Delete if empty | `await dir.delete()` |
| Delete with contents | `await dir.delete(recursive: true)` |
| Parent folder | `dir.parent` |

## Try it yourself

Write a program that takes a folder path and prints a report: the number of files, the number of sub-folders, the total size, and the five largest files.
