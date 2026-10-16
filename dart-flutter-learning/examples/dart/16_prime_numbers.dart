// Prime numbers
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 16_prime_numbers.dart

bool isPrime(int n) {
  if (n < 2) return false;
  for (var i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}

void main() {
  var primes = List.generate(30, (i) => i + 1).where(isPrime).toList();
  print(primes);
}
