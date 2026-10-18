---
title: "What Is Dart? An Introduction to the Dart Language"
seoTitle: "What Is Dart? The Dart Programming Language for Beginners"
linkTitle: "What is Dart?"
description: "Dart is a typed, object-oriented language from Google used to build mobile, web, desktop and server apps. Learn what it is and why people use it."
weight: 1
date: 2026-10-10
lastmod: 2026-10-16
keywords:
  - "dart introduction"
  - "dart language"
  - "why learn dart"
  - "dart vs javascript"
aliases:
  - "/introduction/"
  - "/fr/introduction/"
---

Dart is a programming language created by Google. It was first shown in 2011, and today it is best known as the language behind **Flutter**, the toolkit used to build apps for Android, iOS, web, Windows, macOS and Linux from one codebase.

You can also use Dart on its own for command-line tools, servers and scripts. This tutorial teaches the language itself, so everything you learn here applies whether or not you go on to Flutter.

## What Dart code looks like

If you have seen Java, C#, JavaScript or Kotlin, Dart will look familiar. Every program starts in a function called `main`.

```dart
void main() {
  var language = 'Dart';
  print('Hello from $language!');
}
```

```output
Hello from Dart!
```

## Why learn Dart

- **It is typed, but not noisy.** Dart checks types before your program runs, so many bugs are caught while you type. You rarely have to write the types out because Dart infers them.
- **It is null safe.** A variable cannot hold `null` unless you say so. This removes a whole family of crashes. See [null safety](/null-safety/null-safety-in-dart/).
- **It is fast to work in.** During development Dart runs on a virtual machine with hot reload, so changes show up in under a second.
- **It is fast to run.** For release, Dart compiles to native machine code for phones and desktops, and to JavaScript or WebAssembly for browsers.
- **One language covers the whole app.** The same Dart code can run in your mobile app, your website and your backend.

## How Dart runs your code

Dart has two ways of running a program, and you will use both without thinking about it.

| Mode | When it is used | What you get |
| --- | --- | --- |
| JIT (just-in-time) | `dart run` and Flutter debug builds | Quick start, hot reload, rich debugging |
| AOT (ahead-of-time) | `dart compile exe` and Flutter release builds | Small, fast native programs |

## A short history

| Year | What happened |
| --- | --- |
| 2011 | Dart is announced by Google |
| 2013 | Dart 1.0 is released |
| 2018 | Dart 2 adds a sound type system; Flutter 1.0 ships |
| 2021 | Dart 2.12 introduces sound null safety |
| 2023 | Dart 3 adds records, patterns and class modifiers |
| 2024 | Dart 3.3 adds extension types; Dart compiles to WebAssembly |
| 2025 | Dart 3.8 and 3.10 add null-aware elements and dot shorthands |

This site teaches Dart 3. Everything shown works on any current stable release. See [what's new in Dart 3](/next-steps/whats-new-in-dart-3/) for the newest features.

## What you need before starting

Nothing except a computer and curiosity. Lessons are short and build on each other, so follow them in order the first time through.

## Try it yourself

Press **Run** on the example above. Change `'Dart'` to your own name and run it again. That is all it takes to write and run a Dart program.
