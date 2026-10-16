// Handle a missing value (null safety)
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 25_handle_a_missing_value_null_safety.dart

String? findUser(int id) => id == 1 ? 'Asha' : null;

void main() {
  print(findUser(1) ?? 'Guest');
  print(findUser(2) ?? 'Guest');
  print(findUser(2)?.length);
}
