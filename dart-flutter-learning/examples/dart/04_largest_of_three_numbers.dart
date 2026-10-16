// Largest of three numbers
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 04_largest_of_three_numbers.dart

import 'dart:math';

void main() {
  var a = 14, b = 27, c = 9;

  var largest = a;
  if (b > largest) largest = b;
  if (c > largest) largest = c;
  print('Largest: $largest');

  // The same thing in one line:
  print('Largest: ${[a, b, c].reduce(max)}');
}
