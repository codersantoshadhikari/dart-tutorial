// Grade from marks
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 09_grade_from_marks.dart

String grade(int score) => switch (score) {
      >= 90 => 'A',
      >= 75 => 'B',
      >= 50 => 'C',
      _ => 'F',
    };

void main() {
  for (var score in [95, 80, 62, 30]) {
    print('$score: ${grade(score)}');
  }
}
