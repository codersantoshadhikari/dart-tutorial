// Count vowels
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 19_count_vowels.dart

void main() {
  var text = 'Learn Dart programming';
  var count = text
      .toLowerCase()
      .split('')
      .where((c) => 'aeiou'.contains(c))
      .length;
  print('Vowels: $count');
}
