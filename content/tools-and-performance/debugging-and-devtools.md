---
title: "Debugging Dart Code: Breakpoints and Dart DevTools"
linkTitle: "Debugging and DevTools"
description: "Learn to debug Dart with breakpoints, stepping, watches and the call stack in VS Code, and explore Dart DevTools for deeper inspection."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart debugging"
  - "breakpoints"
  - "dart devtools"
  - "vs code debug dart"
  - "step over step into"
  - "debugger statement"
  - "call stack"
aliases:
  - "/dart-dev-tools--debugging/debugging-with-breakpoints/"
  - "/fr/dart-dev-tools--debugging/debugging-with-breakpoints/"
  - "/dart-dev-tools--debugging/using-dart-devtools/"
  - "/fr/dart-dev-tools--debugging/using-dart-devtools/"
---

Sprinkling `print` statements around works for small problems. For anything more, a **debugger** is faster: it pauses your program at a line you choose and lets you look at every variable.

## A program with a bug

```dart
double average(List<int> marks) {
  var total = 0;
  for (var i = 0; i <= marks.length; i++) { // bug: should be <
    total += marks[i];
  }
  return total / marks.length;
}

void main() {
  print(average([70, 85, 90]));
}
```

Running this throws a `RangeError`. Let us find out why without guessing.

## Breakpoints

A breakpoint marks a line where the program should pause.

**In VS Code:**

1. Install the Dart extension.
2. Click in the margin to the left of the line number of `total += marks[i];`. A red dot appears.
3. Press **F5**, or choose Run, then Start Debugging.

**In IntelliJ or Android Studio:** click in the gutter and press the Debug button (the bug icon).

The program runs until it reaches the breakpoint and then stops, **before** executing that line.

## What you can see while paused

| Panel | Shows |
| --- | --- |
| Variables | Every local variable and its current value: `i`, `total`, `marks` |
| Watch | Expressions you add, re-evaluated at each pause, such as `marks.length - i` |
| Call stack | The chain of function calls that led here: `average`, called by `main` |
| Debug console | Type any expression to evaluate it in the current context |

Hovering over a variable in the editor also shows its value.

## Stepping through the code

| Action | Key in VS Code | What it does |
| --- | --- | --- |
| Continue | F5 | Run to the next breakpoint |
| Step over | F10 | Run the current line, then pause on the next |
| Step into | F11 | Enter the function called on this line |
| Step out | Shift+F11 | Finish the current function and pause in the caller |
| Restart | Ctrl+Shift+F5 | Start again from the beginning |
| Stop | Shift+F5 | End the session |

Press Continue a few times and watch `i` go 0, 1, 2 and then 3. With three items in the list, index 3 does not exist. The bug is the `<=`.

## Smarter breakpoints

Right-click a breakpoint to edit it.

- **Conditional breakpoint**: pause only when an expression is true, for example `i == marks.length`. Essential inside a loop that runs thousands of times.
- **Hit count**: pause on the nth time the line is reached.
- **Logpoint**: print a message such as `i is {i}, total is {total}` without pausing and without editing the code.

## Break on exceptions

In the Breakpoints panel, tick **Uncaught Exceptions**, and if needed **All Exceptions**. The debugger then stops at the exact line that throws, with all the variables still available. For the program above, that takes you straight to the problem.

## Pausing from code

`debugger()` from `dart:developer` acts as a breakpoint written in code. It does nothing unless a debugger is attached.

```dart
import 'dart:developer';

void processOrder(int quantity) {
  debugger(when: quantity < 0); // pause only for the suspicious case
  print('Processing $quantity');
}

void main() {
  processOrder(3);
  processOrder(-1);
}
```

Remove such calls before committing.

## Reading a stack trace

When a program crashes, the stack trace is your first clue. Read it from the top, and look for the first line that mentions **your** code.

```output
Unhandled exception:
RangeError (length): Invalid value: Not in inclusive range 0..2: 3
#0      List.[] (dart:core-patch/growable_array.dart)
#1      average (file:///home/asha/app/bin/main.dart:4:19)
#2      main (file:///home/asha/app/bin/main.dart:10:9)
```

Line `#1` says: in `average`, at line 4, column 19. The message even tells you the valid range was 0 to 2 and the index was 3.

## Dart DevTools

DevTools is a suite of debugging and performance tools that runs in your browser and connects to a running Dart or Flutter program.

**Opening it:**

- VS Code: start a debug session, open the command palette and run **Dart: Open DevTools**.
- IntelliJ or Android Studio: click the DevTools button in the Debug or Flutter tool window.
- Command line:

```bash
dart run --observe bin/main.dart   # prints a URL for the VM service
dart devtools                      # opens DevTools; paste the URL to connect
```

**What it contains:**

| Tool | Use it to |
| --- | --- |
| Debugger | Set breakpoints and step, in the browser |
| CPU Profiler | See which functions use the most time |
| Memory | Watch memory use, take snapshots and find leaks |
| Network | Inspect HTTP requests and responses |
| Logging | View everything written with `log`, plus framework events |
| Flutter Inspector | Explore the widget tree and fix layout problems (Flutter only) |
| Performance | Find slow frames (Flutter only) |
| App Size | See what makes a build large |

## A method for debugging

1. **Reproduce it.** Find the smallest set of steps that triggers the problem every time.
2. **Read the error.** The message and stack trace often give the answer directly.
3. **Form a guess.** "I think `total` is wrong after the loop."
4. **Test the guess** with a breakpoint or a logpoint. Do not change code at random.
5. **Narrow it down.** If the value is right at one point and wrong at another, the bug lies between them. Halve the distance and check again.
6. **Fix it, then add a test** so it cannot come back.

Explaining the problem aloud, line by line, to a colleague or even to a rubber duck, solves a surprising number of bugs.

## Try it yourself

Type in the `average` example. Set a breakpoint in the loop, run the debugger, and step until the error occurs, watching `i` and `total`. Then add a conditional breakpoint that only pauses when `i == marks.length`, and fix the bug.
