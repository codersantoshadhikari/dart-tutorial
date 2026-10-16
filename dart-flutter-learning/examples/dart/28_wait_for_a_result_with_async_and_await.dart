// Wait for a result with async and await
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 28_wait_for_a_result_with_async_and_await.dart

Future<String> fetchGreeting() async {
  await Future.delayed(const Duration(seconds: 1)); // pretend to call a server
  return 'Hello from the server';
}

void main() async {
  print('Fetching...');
  var message = await fetchGreeting();
  print(message);
}
