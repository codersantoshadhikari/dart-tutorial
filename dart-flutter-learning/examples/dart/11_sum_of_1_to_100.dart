// Sum of 1 to 100
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 11_sum_of_1_to_100.dart

void main() {
  var sum = 0;
  for (var i = 1; i <= 100; i++) {
    sum += i;
  }
  print('Sum: $sum');
}
