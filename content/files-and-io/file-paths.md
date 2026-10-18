---
title: "File Paths in Dart with the path Package"
linkTitle: "File paths"
description: "Learn to build and manipulate file paths in Dart safely across Windows, macOS and Linux using the path package: join, basename and more."
weight: 5
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart path package"
  - "join path"
  - "basename"
  - "extension"
  - "absolute path"
  - "relative path"
  - "cross platform paths"
aliases:
  - "/dart-file-handling/file-path-manipulation/"
  - "/fr/dart-file-handling/file-path-manipulation/"
---

A path is a string that says where a file lives. Handling paths with plain string operations is a classic source of bugs, because Windows uses `\` and everything else uses `/`. The official `path` package handles this for you.

## Install it

```bash
dart pub add path
```

It is conventionally imported with the prefix `p`.

## Join parts into a path

Never glue paths together with `+` or string interpolation. `p.join` inserts the right separator for the current platform.

```dart
import 'package:path/path.dart' as p;

void main() {
  final path = p.join('users', 'asha', 'documents', 'report.pdf');
  print(path);
}
```

```output
users/asha/documents/report.pdf
```

On Windows the same code prints `users\asha\documents\report.pdf`.

## Take a path apart

```dart
import 'package:path/path.dart' as p;

void main() {
  const path = '/home/asha/photos/holiday.final.jpg';

  print(p.basename(path));                 // file name
  print(p.basenameWithoutExtension(path)); // name without the extension
  print(p.extension(path));                // extension, with the dot
  print(p.dirname(path));                  // containing folder
  print(p.split(path));                    // every part
}
```

```output
holiday.final.jpg
holiday.final
.jpg
/home/asha/photos
[/, home, asha, photos, holiday.final.jpg]
```

## Change the extension or the name

```dart
import 'package:path/path.dart' as p;

void main() {
  const source = 'images/logo.png';

  print(p.setExtension(source, '.webp'));
  print(p.join(p.dirname(source), 'thumb_${p.basename(source)}'));
  print(p.withoutExtension(source));
}
```

```output
images/logo.webp
images/thumb_logo.png
images/logo
```

## Absolute and relative paths

An **absolute** path starts from the root of the file system. A **relative** path starts from the current working directory.

```dart
import 'package:path/path.dart' as p;

void main() {
  print(p.isAbsolute('/var/log/app.log'));
  print(p.isRelative('data/users.json'));

  // Turn a relative path into an absolute one.
  print(p.absolute('data', 'users.json'));

  // Express one path relative to another.
  print(p.relative('/home/asha/projects/app/lib/main.dart',
      from: '/home/asha/projects'));
}
```

```output
true
true
/home/asha/current-folder/data/users.json
app/lib/main.dart
```

## Clean up messy paths

`normalize` removes `.`, resolves `..` and collapses repeated separators.

```dart
import 'package:path/path.dart' as p;

void main() {
  print(p.normalize('lib/../assets/./images//logo.png'));
  print(p.canonicalize('./lib/../pubspec.yaml')); // absolute and normalized
}
```

```output
assets/images/logo.png
/home/asha/current-folder/pubspec.yaml
```

## Check that a path stays inside a folder

When a file name comes from a user or a network request, someone may send `../../etc/passwd`. Check before you open it.

```dart
import 'package:path/path.dart' as p;

String safePath(String baseDir, String requested) {
  final full = p.normalize(p.join(baseDir, requested));
  if (!p.isWithin(baseDir, full)) {
    throw ArgumentError('Path escapes the allowed folder: $requested');
  }
  return full;
}

void main() {
  print(safePath('/srv/uploads', 'photos/cat.jpg'));
  try {
    safePath('/srv/uploads', '../../etc/passwd');
  } on ArgumentError catch (e) {
    print(e.message);
  }
}
```

```output
/srv/uploads/photos/cat.jpg
Path escapes the allowed folder: ../../etc/passwd
```

## Without the package

`dart:io` offers a few basics that are enough for simple cases.

```dart
import 'dart:io';

void main() {
  final file = File('lib/src/app.dart');

  print(file.path);
  print(file.absolute.path);
  print(file.parent.path);
  print(file.uri.pathSegments.last);
  print(Platform.pathSeparator);
}
```

## Working with a specific platform's style

By default the functions follow the platform the code is running on. To handle paths from another system, use a context.

```dart
import 'package:path/path.dart' as p;

void main() {
  print(p.windows.join('C:', 'Users', 'Asha', 'file.txt'));
  print(p.posix.join('home', 'asha', 'file.txt'));
  print(p.url.join('https://example.com', 'api', 'users'));
}
```

```output
C:\Users\Asha\file.txt
home/asha/file.txt
https://example.com/api/users
```

## Quick reference

| Function | Result for `/a/b/photo.jpg` |
| --- | --- |
| `p.basename` | `photo.jpg` |
| `p.basenameWithoutExtension` | `photo` |
| `p.extension` | `.jpg` |
| `p.dirname` | `/a/b` |
| `p.join(a, b)` | Combine with the correct separator |
| `p.normalize` | Remove `.` and `..` |
| `p.absolute` | Make absolute |
| `p.relative(x, from: y)` | Make relative |
| `p.isWithin(parent, child)` | Is the child inside the parent? |

## Try it yourself

Write `String backupName(String path)` that turns `docs/report.pdf` into `docs/report_backup.pdf`, keeping the folder and extension whatever they are. Test it with a path that has no extension and one with two dots in the name.
