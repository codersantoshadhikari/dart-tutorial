---
title: "Benchmarking and Profiling Dart Code"
linkTitle: "Benchmarking and profiling"
description: "Measure Dart performance correctly: Stopwatch, warm-up, JIT versus AOT, benchmark_harness, the DevTools CPU profiler and common optimizations."
weight: 6
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart benchmark"
  - "dart profiling"
  - "Stopwatch"
  - "benchmark_harness"
  - "cpu profiler"
  - "dart optimization tips"
  - "JIT AOT performance"
aliases:
  - "/memory-management--performance/benchmarking-and-optimization-tips/"
  - "/fr/memory-management--performance/benchmarking-and-optimization-tips/"
  - "/memory-management--performance/performance-profiling-basics/"
  - "/fr/memory-management--performance/performance-profiling-basics/"
---

Developers are notoriously bad at guessing which part of a program is slow. The rule of performance work is: **measure first, change second, measure again.**

## Stopwatch: the quick measurement

```dart
void main() {
  final watch = Stopwatch()..start();

  var sum = 0;
  for (var i = 0; i < 50000000; i++) {
    sum += i % 3;
  }

  watch.stop();
  print('Result $sum in ${watch.elapsedMilliseconds} ms');
}
```

`Stopwatch` uses a high-resolution clock that never jumps. Do not time code with `DateTime.now()`.

## Why a single measurement lies

Three things distort a naive measurement:

1. **Warm-up.** With `dart run`, code starts in a slower mode and is optimised by the JIT compiler once it becomes "hot". The first runs are much slower than later ones.
2. **Noise.** Other programs, the garbage collector and the CPU's power management all add variation.
3. **The wrong build.** Debug builds are far slower than release builds and behave differently.

So warm up first, run many times, and look at the typical result.

```dart
int work() {
  var total = 0;
  for (var i = 0; i < 2000000; i++) {
    total += i.isEven ? i : -i;
  }
  return total;
}

void main() {
  // Warm up.
  for (var i = 0; i < 20; i++) {
    work();
  }

  // Measure.
  final times = <int>[];
  for (var run = 0; run < 15; run++) {
    final watch = Stopwatch()..start();
    work();
    times.add(watch.elapsedMicroseconds);
  }

  times.sort();
  print('fastest: ${times.first} us');
  print('median:  ${times[times.length ~/ 2]} us');
  print('slowest: ${times.last} us');
}
```

Report the median or the fastest run, not the average, which is skewed by the occasional slow outlier.

## Measure the build your users get

| How it runs | Compiler | Use for |
| --- | --- | --- |
| `dart run` | JIT | Development. Not for final numbers |
| `dart compile exe`, then run | AOT | Realistic numbers for command-line and server apps |
| `flutter run --profile` | AOT, with profiling enabled | Measuring Flutter apps |
| `flutter run --release` | AOT | What users experience |
| `flutter run` (debug) | JIT, with assertions | Never for performance measurement |

Always profile Flutter apps in **profile mode on a real device**. Debug mode and emulators give misleading results.

## benchmark_harness

For careful comparisons, the official `benchmark_harness` package handles warm-up and repetition.

```bash
dart pub add --dev benchmark_harness
```

```dart
import 'package:benchmark_harness/benchmark_harness.dart';

class ListContains extends BenchmarkBase {
  ListContains() : super('List.contains');
  late List<int> data;

  @override
  void setup() => data = List.generate(10000, (i) => i);

  @override
  void run() {
    data.contains(9999);
  }
}

class SetContains extends BenchmarkBase {
  SetContains() : super('Set.contains');
  late Set<int> data;

  @override
  void setup() => data = Set.of(List.generate(10000, (i) => i));

  @override
  void run() {
    data.contains(9999);
  }
}

void main() {
  ListContains().report();
  SetContains().report();
}
```

It prints the time per run in microseconds for each benchmark. Expect the set to be hundreds of times faster here.

## Finding the slow part: the CPU profiler

A benchmark tells you **how long**. A profiler tells you **where** the time goes.

1. Run the program so that DevTools can attach, for example by starting a debug session in your editor, or with `dart run --observe`. For Flutter, use profile mode.
2. Open [DevTools](/tools-and-performance/debugging-and-devtools/) and select the **CPU Profiler** tab.
3. Press **Record**, perform the slow action, and press **Stop**.
4. Read the results:

| View | Shows |
| --- | --- |
| Bottom up | The functions where time was actually spent. Start here |
| Call tree | Time from the top down, starting at `main` |
| Flame chart | A picture of the call stack over time. Wide bars are expensive |

Look for a function with a high **self time**, or one that is called far more often than you expected.

For Flutter, the **Performance** view shows each frame as a bar. Frames that exceed the budget (about 16 ms at 60 Hz) are flagged, and you can see whether the build, layout or paint phase was responsible.

## Optimisations that usually matter

Listed roughly by how often they are the real answer.

**1. Use a better algorithm or data structure.** This beats every micro-optimisation.

```dart
void main() {
  final a = List.generate(20000, (i) => i);
  final b = List.generate(20000, (i) => i * 2);

  var watch = Stopwatch()..start();
  var common = a.where(b.contains).length; // list lookup inside a loop
  print('List: $common in ${watch.elapsedMilliseconds} ms');

  watch = Stopwatch()..start();
  final bSet = b.toSet();
  common = a.where(bSet.contains).length;  // set lookup
  print('Set:  $common in ${watch.elapsedMilliseconds} ms');
}
```

**2. Do not repeat work.** Cache results, move calculations out of loops, and call `toList()` on a lazy iterable you use several times.

**3. Do less.** Load 20 items, not 20,000. Paginate, and build list items lazily (`ListView.builder` in Flutter).

**4. Keep the main isolate free.** Move heavy computation to an [isolate](/async/isolates/).

**5. Run independent async work in parallel** with `Future.wait`.

**6. Use `const`** for objects and widgets that never change.

**7. Build strings with `StringBuffer`** or `join`, not `+=` in a loop.

**8. Avoid `dynamic` in hot code.** Typed code lets the compiler generate direct calls.

**9. Rebuild less in Flutter.** Keep `build` methods small, split large widgets, and place state as low in the tree as possible.

## Things that rarely matter

- `for` against `for-in` against `forEach`.
- `final` against `var`.
- Single against double quotes.
- Shaving one small object allocation.

Write these for clarity. The compiler takes care of the rest.

## A sensible process

1. **Set a goal.** "The list should scroll without dropped frames." "The import should take under 2 seconds."
2. **Measure** with realistic data, in a release or profile build.
3. **Profile** to find the largest cost.
4. **Change one thing.**
5. **Measure again.** If there is no real improvement, undo the change. Complexity without benefit is a loss.
6. **Stop** when the goal is met.

> "Premature optimization is the root of all evil." (Donald Knuth). Make it work, make it right, then make it fast, and only the parts that need it.

## Try it yourself

Write two versions of a function that counts how many words in a list of 50,000 words appear in a second list of 5,000 words: one using `List.contains`, one using a `Set`. Benchmark both with warm-up and several runs, and report the median times. Then compile the program with `dart compile exe` and compare the numbers with `dart run`.
