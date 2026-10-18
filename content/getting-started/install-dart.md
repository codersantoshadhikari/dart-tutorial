---
title: "How to Install Dart on Windows, macOS and Linux"
seoTitle: "How to Install Dart SDK on Windows, macOS and Linux"
linkTitle: "Install Dart"
description: "Step-by-step guide to installing the Dart SDK on Windows, macOS and Linux, checking the version, and setting up VS Code."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "install dart"
  - "dart sdk"
  - "dart windows"
  - "dart mac"
  - "dart linux"
  - "dartpad"
aliases:
  - "/introduction/install-dart/"
  - "/fr/introduction/install-dart/"
---

You can start learning in the browser with [DartPad](https://dartpad.dev/), but sooner or later you will want Dart on your own machine. That means installing the **Dart SDK**, which contains the `dart` command, the compilers and the core libraries.

> If you already installed Flutter, you have Dart. Flutter ships with its own copy of the SDK. Run `dart --version` to confirm.

## Windows

The easiest route is the [Chocolatey](https://chocolatey.org/) package manager. Open PowerShell **as administrator** and run:

```powershell
choco install dart-sdk
```

Close and reopen the terminal so the new `PATH` is picked up.

## macOS

Use [Homebrew](https://brew.sh/):

```bash
brew tap dart-lang/dart
brew install dart
```

## Linux

On Debian and Ubuntu, add Google's package repository and then install with `apt`:

```bash
sudo apt-get update && sudo apt-get install apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub \
  | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' \
  | sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt-get update && sudo apt-get install dart
```

For other distributions, or if these commands have changed, follow the official page at [dart.dev/get-dart](https://dart.dev/get-dart).

## Check that it worked

```bash
dart --version
```

You should see a line that starts with `Dart SDK version: 3.` followed by your platform. If the terminal says the command is not found, the SDK's `bin` folder is not on your `PATH` yet. Reopen the terminal, or add the folder by hand.

## Set up an editor

Any text editor works, but these two give you autocomplete, error highlighting and a debugger:

- **Visual Studio Code**: install the *Dart* extension from the Extensions panel.
- **IntelliJ IDEA or Android Studio**: install the *Dart* plugin from Settings, then Plugins.

## Create and run a project

The `dart create` command builds a small project with the right folder layout.

```bash
dart create hello_dart
cd hello_dart
dart run
```

```output
Hello world: 42!
```

The code you just ran lives in `bin/hello_dart.dart`. The `pubspec.yaml` file next to it describes the project and its dependencies. You will meet it again in [packages](/libraries-and-packages/pub-packages/).

## Commands you will use every day

| Command | What it does |
| --- | --- |
| `dart run` | Runs the program in the current project |
| `dart run file.dart` | Runs a single file |
| `dart format .` | Formats your code in the standard style |
| `dart analyze` | Reports errors and warnings without running |
| `dart test` | Runs your tests |
| `dart compile exe bin/app.dart` | Builds a standalone program |

## Try it yourself

Install Dart, create a project called `my_first_app`, and run it. Then open `bin/my_first_app.dart` and change the message it prints.
