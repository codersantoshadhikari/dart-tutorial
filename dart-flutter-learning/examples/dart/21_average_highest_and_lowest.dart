// Average, highest and lowest
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 21_average_highest_and_lowest.dart

void main() {
  var marks = [72, 45, 91, 38, 84];

  var total = marks.fold(0, (sum, m) => sum + m);
  var highest = marks.reduce((a, b) => a > b ? a : b);
  var lowest = marks.reduce((a, b) => a < b ? a : b);

  print('Average: ${(total / marks.length).toStringAsFixed(1)}');
  print('Highest: $highest');
  print('Lowest: $lowest');
}
