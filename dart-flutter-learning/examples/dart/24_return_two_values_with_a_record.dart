// Return two values with a record
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 24_return_two_values_with_a_record.dart

(int, int) minMax(List<int> numbers) {
  var sorted = [...numbers]..sort();
  return (sorted.first, sorted.last);
}

void main() {
  final (lowest, highest) = minMax([4, 9, 1, 7]);
  print('min $lowest, max $highest');
}
