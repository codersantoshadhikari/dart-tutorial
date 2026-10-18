---
title: "Dart Glossary: Programming Terms Explained in Simple Words"
seoTitle: "Dart Glossary: Key Terms Explained Simply"
linkTitle: "Dart glossary"
description: "A simple A to Z Dart glossary: async, class, closure, const, Future, generics, mixin, null safety, record, Stream, widget and more, each linked to a lesson."
weight: 6
date: 2026-10-16
lastmod: 2026-10-16
keywords:
  - "dart glossary"
  - "dart terms"
  - "dart programming terms"
  - "dart keywords meaning"
---

New words are the hardest part of learning to program. This glossary explains the terms you will meet in Dart and Flutter in one or two simple sentences each, with a link to the lesson that teaches it properly.

## A to E

**Abstract class**
: A class you cannot create directly. It describes what subclasses must have. [Abstract classes](/object-oriented-programming/abstract-classes/)

**Analyzer**
: The tool that checks your code for errors while you type. Run it yourself with `dart analyze`. [Formatting and linting](/tools-and-performance/formatting-and-linting/)

**Anonymous function**
: A function without a name, often passed to another function: `(x) => x * 2`. [Anonymous functions and closures](/functions/anonymous-functions-and-closures/)

**AOT (ahead-of-time) compilation**
: Turning Dart into machine code before the program runs. Used for fast release apps and `dart compile exe`. [What is Dart?](/getting-started/what-is-dart/)

**Argument / parameter**
: A *parameter* is the name in the function definition (`int a`). An *argument* is the value you pass (`add(2, 3)`). [Function parameters](/functions/function-parameters/)

**async / await**
: Keywords for waiting for slow work (network, files) without freezing the program. [async and await](/async/async-await/)

**Class**
: A blueprint for objects: it groups data (fields) and behaviour (methods). [Classes and objects](/object-oriented-programming/classes-and-objects/)

**Closure**
: A function that remembers the variables around it, even after that code has finished. [Closures](/functions/anonymous-functions-and-closures/)

**Collection**
: A value that holds many values: `List`, `Set`, `Map`, `Queue`. [Collections overview](/collections/collections-overview/)

**Compile-time constant (`const`)**
: A value fixed when the program is compiled, such as `const pi = 3.14`. [final and const](/dart-basics/final-and-const/)

**Constructor**
: The special function that creates an object: `Person('Asha', 21)`. [Constructors](/object-oriented-programming/constructors/)

**dynamic**
: A type that turns off type checking. Avoid it unless you really need it. [Data types](/dart-basics/data-types/)

**Enum**
: A fixed set of named values, such as `enum Size { small, medium, large }`. [Enums](/object-oriented-programming/enums/)

**Event loop**
: The engine that runs your async code one task at a time. [Event loop](/async/event-loop/)

**Exception**
: An error that happens while the program runs. Catch it with `try` / `catch`. [Exceptions](/error-handling/exceptions/)

**Extension method**
: Adds a new method to an existing type, even one you did not write, such as `String`. [Extension methods](/object-oriented-programming/extension-methods/)

## F to L

**Factory constructor**
: A constructor that can return an existing object or a subclass instead of always making a new one. [Factory constructors](/object-oriented-programming/factory-constructors/)

**final**
: A variable that can be set only once. [final and const](/dart-basics/final-and-const/)

**Future**
: A value that will be ready later, like the result of a download. [Futures](/async/futures/)

**Generics**
: Type placeholders such as `List<T>` that let one class or function work safely with many types. [Generics](/object-oriented-programming/generics/)

**Getter / setter**
: Methods that look like fields: `circle.area` instead of `circle.area()`. [Getters and setters](/object-oriented-programming/getters-and-setters/)

**Higher-order function**
: A function that takes or returns another function, such as `map` and `where`. [Higher-order functions](/functions/higher-order-functions/)

**Hot reload**
: Updating a running app with your code changes in under a second, without losing its state. Mostly used in Flutter. [Hot reload](https://flutter.dart-tutorial.dev/getting-started/hot-reload/)

**Immutable**
: A value that cannot change after it is created. [Immutability and copyWith](/object-oriented-programming/immutability-and-copywith/)

**Inheritance**
: A class taking the fields and methods of another class with `extends`. [Inheritance](/object-oriented-programming/inheritance/)

**Interface**
: A list of methods a class promises to have, used with `implements`. [Interfaces](/object-oriented-programming/interfaces/)

**Isolate**
: Dart's way to run code in parallel, each with its own memory. [Isolates](/async/isolates/)

**Iterable**
: Anything you can loop over with `for-in`. `List` and `Set` are iterables. [Iterables](/collections/iterables/)

**JIT (just-in-time) compilation**
: Compiling code while it runs. Used during development, and what makes hot reload possible.

**JSON**
: A text format for data, used by almost every web API. [JSON in Dart](/practical-dart/json/)

**late**
: Says "this non-nullable variable will be set before it is used". [late variables](/null-safety/late-variables/)

**Library**
: A Dart file (or group of files) that you can import. [Creating libraries](/libraries-and-packages/creating-libraries/)

## M to R

**Map**
: A collection of key-value pairs, like a dictionary: `{'apple': 3}`. [Maps](/collections/maps/)

**Method**
: A function that belongs to a class. [Classes and objects](/object-oriented-programming/classes-and-objects/)

**Mixin**
: A bundle of methods you can add to many classes with `with`. [Mixins](/object-oriented-programming/mixins/)

**Null safety**
: Dart's guarantee that a variable cannot be `null` unless its type ends in `?`. [Null safety](/null-safety/null-safety-in-dart/)

**Object**
: One thing made from a class. Also the type that every non-null value belongs to. [Classes and objects](/object-oriented-programming/classes-and-objects/)

**Package**
: Shared code you add from [pub.dev](https://pub.dev/) with `dart pub add`. [Pub packages](/libraries-and-packages/pub-packages/)

**Pattern**
: A shape that a value can be matched against and taken apart, used in `switch` and destructuring. [Patterns](/records-and-patterns/patterns/)

**Polymorphism**
: One piece of code working with objects of different classes through a shared type. [Polymorphism](/object-oriented-programming/polymorphism/)

**pubspec.yaml**
: The file that names your project and lists its packages. [Pub packages](/libraries-and-packages/pub-packages/)

**Record**
: A small group of values without a class: `(name: 'Asha', age: 21)`. [Records](/records-and-patterns/records/)

**Recursion**
: A function that calls itself to solve a smaller version of the problem. [Recursion](/functions/recursion/)

## S to Z

**Scope**
: The part of the code where a variable exists, usually the nearest `{ }`. [Functions](/functions/functions/)

**Sealed class**
: A class whose subclasses are all known, so `switch` can check that you handled every case. [Sealed classes](/records-and-patterns/sealed-classes/)

**Set**
: A collection with no duplicates. [Sets](/collections/sets/)

**Sound type system**
: Dart guarantees that a variable always holds a value of its declared type.

**Spread operator (`...`)**
: Puts the items of one collection inside another: `[...a, ...b]`. [Spread and collection if](/collections/spread-and-collection-if/)

**Static member**
: A field or method that belongs to the class itself, not to each object. [Static members](/object-oriented-programming/static-members/)

**Stream**
: A sequence of values that arrive over time, like clicks or chat messages. [Streams](/async/streams/)

**String interpolation**
: Putting values inside text with `$name` or `${a + b}`. [Strings](/dart-basics/strings/)

**Type inference**
: Dart working out a type for you: `var n = 3;` makes `n` an `int`. [Variables](/dart-basics/variables/)

**Typedef**
: A short name for a type, often a function type. [Typedef](/functions/typedef/)

**Widget**
: In Flutter, a piece of the user interface, such as `Text` or `Button`. [Flutter widgets](https://flutter.dart-tutorial.dev/widgets/widgets-introduction/)

Missing a word? Tell us on the [contact page](/contact/) and we will add it. For quick syntax, keep the [Dart cheat sheet](/next-steps/dart-cheat-sheet/) open.
