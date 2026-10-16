// Remove duplicates
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 22_remove_duplicates.dart

void main() {
  var numbers = [3, 1, 3, 2, 1];
  print(numbers.toSet().toList());
}
