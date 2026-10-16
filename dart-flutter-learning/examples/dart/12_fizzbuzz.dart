// FizzBuzz
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 12_fizzbuzz.dart

void main() {
  var out = List.generate(15, (index) {
    var i = index + 1;
    if (i % 15 == 0) return 'FizzBuzz';
    if (i % 3 == 0) return 'Fizz';
    if (i % 5 == 0) return 'Buzz';
    return '$i';
  });
  print(out.join(' '));
}
