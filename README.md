# Learn Dart and Flutter: free tutorials, examples and game source code

[![Learn at Dart Tutorial](https://www.dart-tutorial.dev/images/badge.svg)](https://www.dart-tutorial.dev/)
[![Learn at Flutter Tutorial](https://flutter.dart-tutorial.dev/images/badge.svg)](https://flutter.dart-tutorial.dev/)

Source code and a full lesson index for two free courses:

- 📘 **[Dart Tutorial](https://www.dart-tutorial.dev/)**: Dart programming from beginner to advanced, with an [online Dart compiler](https://www.dart-tutorial.dev/playground/)
- 📱 **[Flutter Tutorial](https://flutter.dart-tutorial.dev/)**: Flutter apps, every state management approach, and 2D games with Flame

<!-- counts:start -->**107 Dart lessons** and **135 Flutter lessons**<!-- counts:end --> are listed in [LESSONS.md](LESSONS.md). Every lesson is free, needs no sign-up, and most examples run right in the browser.

## What is in this repository

| Folder | Contents | Learn more |
| --- | --- | --- |
| [`examples/dart`](examples/dart) | 30 beginner Dart programs: factorial, Fibonacci, primes, palindromes, classes, async, streams, JSON | [30 Dart programming examples](https://www.dart-tutorial.dev/next-steps/dart-programming-examples/) |
| [`examples/flutter-apps`](examples/flutter-apps) | 8 complete Flutter apps: calculator, to-do, quiz, weather API, notes (Riverpod), cart (Provider), expenses (Cubit), BMI | [Flutter app projects](https://flutter.dart-tutorial.dev/projects/) |
| [`examples/flutter-games`](examples/flutter-games) | 5 complete Flame games: Snake, Flappy Bird, Space Shooter, Brick Breaker, Endless Runner | [Flutter game projects](https://flutter.dart-tutorial.dev/game-projects/) |

## Run the examples

**Dart:** install the [Dart SDK](https://www.dart-tutorial.dev/getting-started/install-dart/), then

```bash
dart run examples/dart/14_factorial.dart
```

**Flutter apps and games:** create a project, add the package named at the top of the file, and replace `lib/main.dart`:

```bash
flutter create my_game
cd my_game
flutter pub add flame
# copy examples/flutter-games/snake.dart over lib/main.dart
flutter run
```

No install? Every example has a **Run** button on its lesson page.

## Start learning

| If you want to... | Start here |
| --- | --- |
| Learn programming with Dart | [Dart roadmap](https://www.dart-tutorial.dev/learn-dart-and-flutter/) |
| Look up Dart syntax | [Dart syntax](https://www.dart-tutorial.dev/getting-started/dart-syntax/) and [cheat sheet](https://www.dart-tutorial.dev/next-steps/dart-cheat-sheet/) |
| Build your first app | [Flutter roadmap](https://flutter.dart-tutorial.dev/flutter-roadmap/) |
| Choose a state management package | [Riverpod vs Bloc vs Provider vs GetX](https://flutter.dart-tutorial.dev/state-packages/which-state-management/) |
| Make a game | [Flutter game development with Flame](https://flutter.dart-tutorial.dev/flame-games/) |
| Prepare for interviews | [Dart](https://www.dart-tutorial.dev/next-steps/dart-interview-questions/) and [Flutter](https://flutter.dart-tutorial.dev/next-steps/flutter-interview-questions/) interview questions |

## Contributing

Found a bug in an example or want a topic covered? Open an issue or a pull request. ⭐ Star the repo if it helped you, so other learners can find it.

## License

Code in `examples/` is released under the MIT License (see [LICENSE](LICENSE)). Lesson text belongs to [dart-tutorial.dev](https://www.dart-tutorial.dev/).
