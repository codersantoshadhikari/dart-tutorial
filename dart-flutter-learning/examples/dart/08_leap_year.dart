// Leap year
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 08_leap_year.dart

bool isLeapYear(int year) =>
    (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

void main() {
  for (var year in [1900, 2000, 2024, 2026]) {
    print('$year: ${isLeapYear(year)}');
  }
}
