// Factorial
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 14_factorial.dart

int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);

void main() {
  print('5! = ${factorial(5)}');
  print('10! = ${factorial(10)}');
}
