---
title: "Checking If a File Exists and Deleting Files in Dart"
linkTitle: "Checking and deleting files"
description: "Learn to check whether a file or directory exists in Dart, and to delete, rename, move and copy files safely with dart:io."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart file exists"
  - "delete file dart"
  - "rename file"
  - "copy file"
  - "FileSystemEntity type"
  - "existsSync"
aliases:
  - "/dart-file-handling/deleting-files/"
  - "/fr/dart-file-handling/deleting-files/"
  - "/dart-file-handling/file-existence-check/"
  - "/fr/dart-file-handling/file-existence-check/"
---

Before reading a file you may want to know whether it is there. When you are done with one, you may want to remove it, rename it or copy it.

## Does it exist?

```dart
import 'dart:io';

Future<void> main() async {
  final file = File('notes.txt');

  if (await file.exists()) {
    print('Found ${file.path}');
  } else {
    print('${file.path} is missing');
  }

  // Synchronous version
  print(File('pubspec.yaml').existsSync());
}
```

`File.exists()` is `true` only if the path exists **and is a file**. For a folder, use `Directory(path).exists()`.

## What kind of thing is at this path?

When you do not know whether a path is a file, a folder or a link, ask `FileSystemEntity`.

```dart
import 'dart:io';

Future<void> describe(String path) async {
  final type = await FileSystemEntity.type(path);

  final label = switch (type) {
    FileSystemEntityType.file => 'a file',
    FileSystemEntityType.directory => 'a directory',
    FileSystemEntityType.link => 'a link',
    _ => 'not there',
  };
  print('$path is $label');
}

Future<void> main() async {
  await describe('pubspec.yaml');
  await describe('lib');
  await describe('nothing-here');
}
```

```output
pubspec.yaml is a file
lib is a directory
nothing-here is not there
```

There are also the shortcuts `FileSystemEntity.isFile(path)` and `FileSystemEntity.isDirectory(path)`.

## Check, or just try?

Checking and then acting leaves a small gap in which another program could delete the file. For that reason, the most robust code simply attempts the operation and handles the failure.

```dart
import 'dart:io';

Future<String?> readIfPresent(String path) async {
  try {
    return await File(path).readAsString();
  } on PathNotFoundException {
    return null;
  }
}

Future<void> main() async {
  final text = await readIfPresent('maybe.txt');
  print(text ?? 'No such file, using defaults');
}
```

```output
No such file, using defaults
```

Use `exists()` when you need to **decide** something, such as whether to create a default config file. Use `try`/`catch` when you are about to **use** the file.

## Delete a file

```dart
import 'dart:io';

Future<void> main() async {
  final file = File('temp.txt');
  await file.writeAsString('temporary');

  await file.delete();
  print('Still there? ${await file.exists()}');
}
```

```output
Still there? false
```

Deleting is permanent. The file does not go to the recycle bin. Deleting a file that does not exist throws a `PathNotFoundException`.

## Delete only if it exists

```dart
import 'dart:io';

Future<bool> deleteIfExists(String path) async {
  try {
    await File(path).delete();
    return true;
  } on PathNotFoundException {
    return false;
  }
}

Future<void> main() async {
  print(await deleteIfExists('old-cache.txt'));
}
```

## Rename or move

`rename` returns a `File` for the new location. Renaming to a path in a different folder moves the file.

```dart
import 'dart:io';

Future<void> main() async {
  final draft = File('draft.txt');
  await draft.writeAsString('My essay');

  final finalFile = await draft.rename('essay.txt');

  print(finalFile.path);
  print(await draft.exists());
}
```

```output
essay.txt
false
```

If the target already exists it is replaced. A rename across different drives may fail; in that case copy the file and delete the original.

## Copy

```dart
import 'dart:io';

Future<void> main() async {
  final original = File('essay.txt');
  final backup = await original.copy('essay_backup.txt');

  print('${await original.length()} bytes copied to ${backup.path}');
}
```

## Delete safely

Before deleting anything based on user input or a calculated path:

- Print or log the full path first while you are developing.
- Check that the path is inside the folder you expect.
- Never build a delete path from unchecked user input.
- For folders, `delete(recursive: true)` removes **everything** inside. Double-check the path. See [directories](/files-and-io/directories/).

## Quick reference

| Task | Code |
| --- | --- |
| Does the file exist? | `await file.exists()` |
| File, folder or link? | `await FileSystemEntity.type(path)` |
| Delete | `await file.delete()` |
| Rename or move | `await file.rename(newPath)` |
| Copy | `await file.copy(newPath)` |
| Size in bytes | `await file.length()` |

## Try it yourself

Write a "safe save" function: if `data.txt` already exists, rename it to `data.bak` (replacing any old backup), then write the new contents to `data.txt`. Test it by saving three times and checking both files.
