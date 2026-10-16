// Read and write JSON
// Explained at https://www.dart-tutorial.dev/next-steps/dart-programming-examples/
// Run: dart run 30_read_and_write_json.dart

import 'dart:convert';

void main() {
  var text = '{"name": "Dart", "year": 2011}';
  var data = jsonDecode(text) as Map<String, dynamic>;
  print('${data['name']} was first announced in ${data['year']}');

  var output = jsonEncode({'language': 'Dart', 'fast': true});
  print(output);
}
