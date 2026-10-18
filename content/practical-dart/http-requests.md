---
title: "HTTP Requests in Dart: GET, POST and Calling REST APIs"
linkTitle: "HTTP requests"
description: "Learn to call web APIs in Dart with the http package: GET and POST requests, headers, JSON bodies, status codes, errors and timeouts."
weight: 2
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart http request"
  - "http get"
  - "http post"
  - "rest api dart"
  - "fetch data dart"
  - "package:http"
  - "api call"
---

Most apps talk to a server: to log in, load a feed, or save an order. In Dart the standard tool is the `http` package.

```bash
dart pub add http
```

The examples use [JSONPlaceholder](https://jsonplaceholder.typicode.com/), a free practice API.

## A GET request

```dart
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');

  final response = await http.get(url);

  print(response.statusCode);
  print(response.headers['content-type']);
  print(response.body);
}
```

```output
200
application/json; charset=utf-8
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit..."
}
```

`http.get` returns a `Future<Response>`. The `body` is a string; decode it to use the data.

## Status codes

A response arriving does not mean the request succeeded. Always check the status code.

| Range | Meaning | Examples |
| --- | --- | --- |
| 2xx | Success | 200 OK, 201 Created, 204 No Content |
| 3xx | Redirect | 301, 304 |
| 4xx | The request was wrong | 400 Bad Request, 401 Unauthorized, 404 Not Found |
| 5xx | The server failed | 500, 503 |

## Decoding the response into objects

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  final int id;
  final String title;
  Post({required this.id, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) =>
      Post(id: json['id'] as int, title: json['title'] as String);
}

Future<List<Post>> fetchPosts() async {
  final url = Uri.https('jsonplaceholder.typicode.com', '/posts', {'userId': '1'});
  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Failed to load posts: ${response.statusCode}');
  }

  final list = jsonDecode(response.body) as List<dynamic>;
  return [for (final item in list) Post.fromJson(item as Map<String, dynamic>)];
}

Future<void> main() async {
  final posts = await fetchPosts();
  print('Loaded ${posts.length} posts');
  print(posts.first.title);
}
```

`Uri.https(host, path, queryParameters)` builds the address and encodes the query string correctly, which is safer than joining strings.

## A POST request with a JSON body

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({'title': 'Hello', 'body': 'My first post', 'userId': 1}),
  );

  if (response.statusCode == 201) {
    final created = jsonDecode(response.body) as Map<String, dynamic>;
    print('Created post with id ${created['id']}');
  } else {
    print('Failed: ${response.statusCode}');
  }
}
```

```output
Created post with id 101
```

`http.put`, `http.patch` and `http.delete` work the same way.

## Sending headers

Authentication tokens and other metadata travel in headers.

```dart
import 'package:http/http.dart' as http;

Future<http.Response> fetchProfile(String token) {
  return http.get(
    Uri.parse('https://api.example.com/me'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );
}
```

Never hard-code real tokens or API keys in source code.

## Handling everything that can go wrong

Three things can fail: the network, the server and the data.

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

Future<Map<String, dynamic>> getJson(Uri url) async {
  try {
    final response = await http.get(url).timeout(Duration(seconds: 10));

    return switch (response.statusCode) {
      200 => jsonDecode(response.body) as Map<String, dynamic>,
      401 => throw ApiException('Please log in again.'),
      404 => throw ApiException('We could not find that.'),
      >= 500 => throw ApiException('The server has a problem. Try later.'),
      final code => throw ApiException('Unexpected response ($code).'),
    };
  } on SocketException {
    throw ApiException('No internet connection.');
  } on TimeoutException {
    throw ApiException('The request took too long.');
  } on FormatException {
    throw ApiException('The server sent data we could not read.');
  }
}

Future<void> main() async {
  try {
    final post = await getJson(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/999999'),
    );
    print(post);
  } on ApiException catch (e) {
    print(e);
  }
}
```

```output
We could not find that.
```

## Reusing a connection with Client

Each top-level `http.get` opens a new connection. When making several requests to the same server, a `Client` keeps the connection open, which is faster. Close it when finished.

```dart
import 'package:http/http.dart' as http;

Future<void> main() async {
  final client = http.Client();
  try {
    for (var id = 1; id <= 3; id++) {
      final response = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos/$id'),
      );
      print('$id: ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}
```

## Structuring API code

Keep HTTP details in one class. The rest of the app asks for `Post` objects and never sees a URL or a status code. Taking the `Client` as a parameter makes the class easy to test with a fake.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostApi {
  PostApi(this._client, {this.baseUrl = 'https://jsonplaceholder.typicode.com'});

  final http.Client _client;
  final String baseUrl;

  Future<String> fetchTitle(int id) async {
    final response = await _client.get(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Post $id not found');
    }
    return (jsonDecode(response.body) as Map<String, dynamic>)['title'] as String;
  }
}
```

## Good habits

- Check `statusCode` on every response.
- Put a timeout on every request.
- Convert JSON into model classes straight away.
- Use HTTPS, always.
- Do not block the user: show a loading state, and an error state with a retry button.
- For large projects, the `dio` package adds interceptors, cancellation and upload progress.

## Try it yourself

Using JSONPlaceholder, fetch `/users`, decode the list into `User` objects with `name`, `email` and `address.city`, and print each one on a line. Then fetch a user id that does not exist and print a friendly message instead of crashing.
