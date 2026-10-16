// Simple interest
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 07_simple_interest.dart

void main() {
  var principal = 10000;
  var rate = 5;  // percent per year
  var years = 3;

  var interest = principal * rate * years / 100;
  print('Interest: $interest');
  print('Total: ${principal + interest}');
}
