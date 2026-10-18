---
title: "{{ replace .File.ContentBaseName "-" " " | title }} in Dart"
linkTitle: "{{ replace .File.ContentBaseName "-" " " | title }}"
description: "One or two sentences (about 120-160 characters) that say what the reader will learn. This is shown in Google results."
weight: 99
date: {{ .Date | time.Format "2006-01-02" }}
lastmod: {{ .Date | time.Format "2006-01-02" }}
keywords:
  - "dart keyword"
---

One short paragraph that introduces the topic.

## First section

```dart
void main() {
  print('Hello');
}
```

```output
Hello
```

## Try it yourself

An exercise for the reader.
