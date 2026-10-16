// Multiplication table
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 10_multiplication_table.dart

void main() {
  var n = 5;
  for (var i = 1; i <= 10; i++) {
    print('$n x $i = ${n * i}');
  }
}
