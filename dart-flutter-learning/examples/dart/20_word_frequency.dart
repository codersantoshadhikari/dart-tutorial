// Word frequency
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 20_word_frequency.dart

void main() {
  var sentence = 'dart is fun and dart is fast';
  var counts = <String, int>{};

  for (var word in sentence.split(' ')) {
    counts[word] = (counts[word] ?? 0) + 1;
  }
  print(counts);
}
