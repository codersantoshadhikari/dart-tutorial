---
title: "Learn Dart and Flutter: Free Roadmap from Beginner to Advanced"
linkTitle: "Roadmap"
seoTitle: "Learn Dart and Flutter in 2026: Free Beginner to Advanced Roadmap"
description: "A clear, free roadmap to learn Dart and Flutter step by step: from Dart basics and OOP to Flutter widgets, state management, APIs and publishing apps."
date: 2026-10-15
lastmod: 2026-10-16
sitemap:
  priority: 0.9
keywords:
  - "learn dart and flutter"
  - "dart and flutter roadmap"
  - "flutter roadmap"
  - "how to learn flutter"
  - "learn dart"
  - "dart and flutter tutorial"
  - "flutter developer roadmap"
faq:
  - q: "How long does it take to learn Dart and Flutter?"
    a: "With about an hour a day, most beginners learn the core of Dart in four to six weeks and can build simple Flutter apps one to two months after that. Developers who already know JavaScript, Java, Kotlin, Swift or C# are often productive in Flutter within a few weeks."
  - q: "Do I need to learn Dart before Flutter?"
    a: "Yes, but not all of it. Learn variables, functions, collections, classes, null safety and async/await first. That is enough to start Flutter, and you can come back to advanced Dart topics later."
  - q: "Is Flutter good for getting a job in 2026?"
    a: "Flutter is one of the most popular cross-platform frameworks and is used by startups and large companies for Android, iOS, web and desktop apps. Jobs exist in the USA, Canada, Europe, Australia, India, Nepal and remotely. A portfolio of two or three published apps matters more than certificates."
  - q: "Can I learn Dart and Flutter for free?"
    a: "Yes. Every lesson on dart-tutorial.dev is free with no sign-up, and the official Dart and Flutter tools are free and open source."
  - q: "What computer do I need for Flutter?"
    a: "Any recent Windows, macOS or Linux computer can build Android, web and desktop apps. Building iOS apps for the App Store requires a Mac. You can start learning with no installation at all by running the examples in the browser."
---

This roadmap shows you **what to learn, in what order, and how long each stage usually takes** to go from your first line of Dart to a Flutter app in the Play Store and App Store. Every step links to free lessons on this site with easy examples you can run and edit in the browser.

You do not need any programming experience. If you already know another language, move faster through stages 1 and 2.

## Stage 1: Dart basics (week 1 to 2)

Goal: write small programs that use variables, conditions, loops and functions.

1. [What is Dart?](/getting-started/what-is-dart/) and [install Dart](/getting-started/install-dart/) (or skip installing and use the [Dart online compiler](/playground/))
2. [Your first Dart program](/getting-started/first-dart-program/) and [Dart syntax basics](/getting-started/dart-syntax/)
3. [Variables](/dart-basics/variables/), [data types](/dart-basics/data-types/), [strings](/dart-basics/strings/) and [string methods](/dart-basics/string-methods/)
4. [Operators](/dart-basics/operators/), [if else](/control-flow/if-else/), [loops](/control-flow/loops/) and [switch](/control-flow/switch-case/)
5. [Functions](/functions/functions/), [parameters](/functions/function-parameters/) and [arrow functions](/functions/arrow-functions/)

**Practice:** solve the first 15 of the [30 Dart programming examples](/next-steps/dart-programming-examples/) without looking at the answers.

## Stage 2: Collections, null safety and OOP (week 3 to 5)

Goal: model real data with lists, maps and classes, and write code that never crashes on `null`.

1. [Lists](/collections/lists/), [list methods](/collections/list-methods/), [sets](/collections/sets/) and [maps](/collections/maps/)
2. [where, map, reduce and fold](/collections/where-map-reduce/)
3. [Null safety](/null-safety/null-safety-in-dart/) and [null-aware operators](/null-safety/null-aware-operators/)
4. [Classes and objects](/object-oriented-programming/classes-and-objects/), [constructors](/object-oriented-programming/constructors/), [inheritance](/object-oriented-programming/inheritance/), [abstract classes](/object-oriented-programming/abstract-classes/) and [mixins](/object-oriented-programming/mixins/)
5. [Enums](/object-oriented-programming/enums/) and [generics](/object-oriented-programming/generics/)

**Practice:** build the contact book and bank account projects from [Dart practice projects](/next-steps/practice-projects/).

## Stage 3: Modern and asynchronous Dart (week 5 to 6)

Goal: understand the Dart 3 features and async code that every Flutter app uses.

1. [Records](/records-and-patterns/records/), [patterns](/records-and-patterns/patterns/), [switch expressions](/records-and-patterns/switch-expressions/) and [sealed classes](/records-and-patterns/sealed-classes/)
2. [Exception handling](/error-handling/exceptions/)
3. [Future](/async/futures/), [async and await](/async/async-await/) and [streams](/async/streams/)
4. [JSON](/practical-dart/json/) and [HTTP requests](/practical-dart/http-requests/)
5. Optional: [immutable classes and copyWith](/object-oriented-programming/immutability-and-copywith/) (used everywhere in Flutter state) and a [REST API with Shelf](/practical-dart/web-server-with-shelf/)

**Check yourself:** try the [Dart interview questions](/next-steps/dart-interview-questions/). If most answers feel familiar, you are ready for Flutter.

## Stage 4: Flutter fundamentals (week 7 to 9)

Goal: build screens from widgets and make them respond to the user.

1. [What is Flutter?](https://flutter.dart-tutorial.dev/getting-started/what-is-flutter/), [install Flutter](https://flutter.dart-tutorial.dev/getting-started/install-flutter/) and [your first Flutter app](https://flutter.dart-tutorial.dev/getting-started/first-flutter-app/)
2. [Widgets explained](https://flutter.dart-tutorial.dev/widgets/widgets-introduction/), [StatelessWidget](https://flutter.dart-tutorial.dev/widgets/stateless-widget/) and [StatefulWidget](https://flutter.dart-tutorial.dev/widgets/stateful-widget/)
3. Layout: [Row and Column](https://flutter.dart-tutorial.dev/layout/row-and-column/), [Stack](https://flutter.dart-tutorial.dev/layout/stack/), [ListView](https://flutter.dart-tutorial.dev/layout/listview/) and [GridView](https://flutter.dart-tutorial.dev/layout/gridview/)
4. [Scaffold and AppBar](https://flutter.dart-tutorial.dev/material-design/scaffold-and-appbar/), [themes and dark mode](https://flutter.dart-tutorial.dev/material-design/themes-and-dark-mode/)
5. [TextField](https://flutter.dart-tutorial.dev/user-input/textfield/) and [forms with validation](https://flutter.dart-tutorial.dev/user-input/forms-and-validation/)

**Practice:** run and change all [8 Flutter examples](https://flutter.dart-tutorial.dev/next-steps/flutter-examples/).

## Stage 5: Real apps: navigation, state and data (week 10 to 13)

Goal: build multi-screen apps that load and save real data.

1. [Navigation](https://flutter.dart-tutorial.dev/navigation/navigator-basics/) and [go_router](https://flutter.dart-tutorial.dev/navigation/go-router/)
2. State management: [setState](https://flutter.dart-tutorial.dev/state-management/state-basics/), [Provider](https://flutter.dart-tutorial.dev/state-packages/provider/), [Riverpod](https://flutter.dart-tutorial.dev/state-packages/riverpod/) or [Bloc](https://flutter.dart-tutorial.dev/state-packages/bloc/). Read [choosing a state management approach](https://flutter.dart-tutorial.dev/state-packages/which-state-management/) first.
3. [HTTP in Flutter](https://flutter.dart-tutorial.dev/networking/http-requests/), [JSON models](https://flutter.dart-tutorial.dev/networking/json-and-models/) and [FutureBuilder](https://flutter.dart-tutorial.dev/networking/futurebuilder/)
4. Storage: [shared_preferences](https://flutter.dart-tutorial.dev/data-storage/shared-preferences/), [SQLite](https://flutter.dart-tutorial.dev/data-storage/sqlite/) and [Firebase](https://flutter.dart-tutorial.dev/data-storage/firebase-introduction/)

**Practice:** build a weather app or a notes app from [Flutter project ideas](https://flutter.dart-tutorial.dev/next-steps/flutter-projects/).

## Stage 6: Advanced Flutter and publishing (week 14 and after)

Goal: ship a polished, tested app to real users.

1. [Animations](https://flutter.dart-tutorial.dev/animations/implicit-animations/) and [responsive layouts](https://flutter.dart-tutorial.dev/responsive-design/responsive-layouts/)
2. [Unit and widget testing](https://flutter.dart-tutorial.dev/testing-and-quality/unit-and-widget-testing/) and [performance](https://flutter.dart-tutorial.dev/testing-and-quality/performance/)
3. [App architecture](https://flutter.dart-tutorial.dev/architecture/project-architecture/) with [MVVM and repositories](https://flutter.dart-tutorial.dev/architecture/mvvm-and-repository/)
4. Release on [Android](https://flutter.dart-tutorial.dev/release/build-android/), [iOS](https://flutter.dart-tutorial.dev/release/build-ios/) and the [web](https://flutter.dart-tutorial.dev/release/web-and-desktop/)

**Check yourself:** the [Flutter interview questions](https://flutter.dart-tutorial.dev/next-steps/flutter-interview-questions/).

## Tips that make learning faster

- **Type the code yourself.** Copy-pasting feels fast but teaches little. Every example on this site has a **Run** or **Edit** button, so change it and see what happens.
- **One small project per stage.** Building something, however small, is where the ideas stick.
- **Keep the cheat sheets open:** the [Dart cheat sheet](/next-steps/dart-cheat-sheet/) and the [Flutter cheat sheet](https://flutter.dart-tutorial.dev/next-steps/flutter-cheat-sheet/).
- **Read error messages slowly.** Dart's errors usually say exactly what is wrong and on which line. The [common Dart errors](/next-steps/common-dart-errors/) page explains the ones you will see most, and the [Dart glossary](/next-steps/dart-glossary/) explains new words.
- **Learn in public.** Put your projects on GitHub. It helps you get feedback, and later, a job.

## Frequently asked questions
