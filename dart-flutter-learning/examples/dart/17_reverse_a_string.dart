// Reverse a string
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 17_reverse_a_string.dart

void main() {
  var word = 'Flutter';
  var reversed = word.split('').reversed.join();
  print(reversed);
}
