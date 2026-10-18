---
title: "File Attributes and Metadata in Dart"
linkTitle: "File metadata"
description: "Read file attributes in Dart: size, last modified and accessed times, type and permissions, using length, lastModified and stat."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart file size"
  - "last modified"
  - "FileStat"
  - "file permissions"
  - "file attributes"
  - "stat dart"
aliases:
  - "/dart-file-handling/file-attributes/"
  - "/fr/dart-file-handling/file-attributes/"
---

Besides its contents, every file carries information about itself: how big it is, when it was last changed, and who may read it. This is the file's **metadata**.

## Size

```dart
import 'dart:io';

String readableSize(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  return '${size.toStringAsFixed(unit == 0 ? 0 : 1)} ${units[unit]}';
}

Future<void> main() async {
  final file = File('pubspec.yaml');
  final bytes = await file.length();

  print('$bytes bytes');
  print(readableSize(bytes));
  print(readableSize(5368709));
}
```

```output
312 bytes
312 B
5.1 MB
```

## Last modified

```dart
import 'dart:io';

Future<void> main() async {
  final file = File('pubspec.yaml');
  final modified = await file.lastModified();
  final age = DateTime.now().difference(modified);

  print('Last modified: $modified');
  print('That was ${age.inDays} day(s) ago');
}
```

You can also change it with `await file.setLastModified(DateTime.now())`.

## Everything at once with stat

`stat()` returns a `FileStat` holding all the metadata from a single call. It works on files and directories.

```dart
import 'dart:io';

Future<void> main() async {
  final stat = await File('pubspec.yaml').stat();

  print('Type:     ${stat.type}');
  print('Size:     ${stat.size} bytes');
  print('Modified: ${stat.modified}');
  print('Accessed: ${stat.accessed}');
  print('Changed:  ${stat.changed}');
  print('Mode:     ${stat.modeString()}');
}
```

```output
Type:     file
Size:     312 bytes
Modified: 2026-10-08 14:22:05.000
Accessed: 2026-10-10 09:01:44.000
Changed:  2026-10-08 14:22:05.000
Mode:     rw-r--r--
```

| Property | Meaning |
| --- | --- |
| `type` | File, directory, link or not found |
| `size` | Size in bytes |
| `modified` | When the contents last changed |
| `accessed` | When it was last read |
| `changed` | When its metadata last changed. On Windows, the creation time |
| `mode` / `modeString()` | Permissions |

`stat` does not throw for a missing path. It returns a result whose `type` is `FileSystemEntityType.notFound`.

## Reading permissions

`modeString()` shows permissions in the Unix style: three groups of `rwx` for the owner, the group and everyone else.

```text
rw-r--r--
│  │  └── others: read
│  └───── group:  read
└──────── owner:  read and write
```

On Windows the value is less meaningful, since Windows uses a different permission system.

Dart cannot change permissions directly. Run the system command:

```dart
import 'dart:io';

Future<void> main() async {
  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['+x', 'tool.sh']);
    print(result.exitCode == 0 ? 'Now executable' : result.stderr);
  }
}
```

## Practical example: find files changed recently

```dart
import 'dart:io';

Future<void> main() async {
  final cutoff = DateTime.now().subtract(Duration(days: 7));

  await for (final entity in Directory('lib').list(recursive: true)) {
    if (entity is! File) continue;
    final stat = await entity.stat();
    if (stat.modified.isAfter(cutoff)) {
      print('${entity.path}  (${stat.size} bytes)');
    }
  }
}
```

## Practical example: is the cache still fresh?

```dart
import 'dart:io';

Future<bool> isFresh(File file, Duration maxAge) async {
  final stat = await file.stat();
  if (stat.type == FileSystemEntityType.notFound) return false;
  return DateTime.now().difference(stat.modified) < maxAge;
}

Future<void> main() async {
  final cache = File('weather_cache.json');

  if (await isFresh(cache, Duration(minutes: 30))) {
    print('Using cached data');
  } else {
    print('Cache is missing or old, downloading again');
  }
}
```

## Comparing two files

`FileSystemEntity.identical(pathA, pathB)` tells you whether two paths refer to the very same file on disk, for instance through a link. To check whether two different files have the same contents, compare their sizes first, which is quick, and their bytes only if the sizes match.

## Try it yourself

Write a program that lists every file in a folder, sorted from most to least recently modified, showing the date and a human-readable size for each.
