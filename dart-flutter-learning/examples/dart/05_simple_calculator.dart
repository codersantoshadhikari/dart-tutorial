// Simple calculator
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 05_simple_calculator.dart

double calculate(double a, String op, double b) => switch (op) {
      '+' => a + b,
      '-' => a - b,
      '*' => a * b,
      '/' => a / b,
      _ => throw ArgumentError('Unknown operator $op'),
    };

void main() {
  for (var op in ['+', '-', '*', '/']) {
    print('8 $op 2 = ${calculate(8, op, 2)}');
  }
}
