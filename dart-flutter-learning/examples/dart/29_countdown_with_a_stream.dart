// Countdown with a stream
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 29_countdown_with_a_stream.dart

Stream<int> countdown(int from) async* {
  for (var i = from; i > 0; i--) {
    await Future.delayed(const Duration(milliseconds: 500));
    yield i;
  }
}

void main() async {
  await for (var n in countdown(3)) {
    print(n);
  }
  print('Lift off!');
}
