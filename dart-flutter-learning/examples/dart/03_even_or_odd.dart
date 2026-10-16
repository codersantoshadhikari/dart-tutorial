// Even or odd
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 03_even_or_odd.dart

void main() {
  for (var n in [7, 10]) {
    print('$n is ${n.isEven ? 'even' : 'odd'}');
  }
}
