// Fibonacci series
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 15_fibonacci_series.dart

void main() {
  var fib = [0, 1];
  while (fib.length < 10) {
    fib.add(fib[fib.length - 1] + fib[fib.length - 2]);
  }
  print(fib.join(', '));
}
