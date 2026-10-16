// Star pyramid
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 13_star_pyramid.dart

void main() {
  var rows = 4;
  for (var i = 1; i <= rows; i++) {
    print(' ' * (rows - i) + '*' * (2 * i - 1));
  }
}
