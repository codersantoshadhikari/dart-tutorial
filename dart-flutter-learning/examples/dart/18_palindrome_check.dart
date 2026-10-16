// Palindrome check
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 18_palindrome_check.dart

bool isPalindrome(String s) {
  var clean = s.toLowerCase();
  return clean == clean.split('').reversed.join();
}

void main() {
  for (var word in ['level', 'dart', 'Racecar']) {
    print('$word: ${isPalindrome(word)}');
  }
}
