---
title: "Build a REST API in Dart with Shelf: Routes, JSON and Middleware"
seoTitle: "Dart REST API with Shelf: Server Tutorial"
linkTitle: "Web server with Shelf"
description: "Build a Dart back end with the shelf package: create a server, add routes with shelf_router, read and return JSON, use middleware, and deploy it."
weight: 8
level: "Advanced"
date: 2026-10-16
lastmod: 2026-10-16
keywords:
  - "dart server"
  - "dart shelf tutorial"
  - "dart rest api"
  - "shelf_router"
  - "dart backend"
faq:
  - q: "Can Dart be used for the back end?"
    a: "Yes. Dart runs well on servers and compiles to a small native executable. The shelf package from the Dart team is the standard way to build HTTP servers, and frameworks such as Dart Frog and Serverpod are built on similar ideas."
  - q: "Which Dart back-end framework should I use?"
    a: "Use shelf and shelf_router to learn and for small APIs. Use Dart Frog for a file-based routing framework, or Serverpod for a full back end with a database, authentication and generated Flutter client code."
---

Dart is not only for apps. With the official **[shelf](https://pub.dev/packages/shelf)** package you can write an HTTP server, and the same language then powers both your Flutter app and its back end. In this lesson you build a small **to-do REST API**.

You need Dart installed on your computer for this lesson, because a server cannot run in the browser. See [install Dart](/getting-started/install-dart/).

## 1. Create the project

```bash
dart create -t server-shelf todo_api
cd todo_api
dart run bin/server.dart
```

The `server-shelf` template already includes `shelf` and `shelf_router`. Open `http://localhost:8080/` in your browser and you will see `Hello, World!`.

To add the packages to an existing project instead:

```bash
dart pub add shelf shelf_router
```

## 2. The smallest server

```dart
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Response hello(Request request) => Response.ok('Hello from Dart!');

Future<void> main() async {
  final server = await io.serve(hello, InternetAddress.anyIPv4, 8080);
  print('Listening on http://localhost:${server.port}');
}
```

Three ideas make up every shelf app:

| Idea | What it is |
| --- | --- |
| **Handler** | A function that takes a `Request` and returns a `Response` (or a `Future<Response>`). |
| **Middleware** | Code that wraps a handler, for logging, CORS, authentication and so on. |
| **Pipeline** | Joins middleware and a handler together. |

## 3. Routes with shelf_router

```dart
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

Future<void> main() async {
  final router = Router()
    ..get('/', (Request request) => Response.ok('Todo API'))
    ..get('/hello/<name>', (Request request, String name) {
      return Response.ok('Hello, $name!');
    });

  final handler = const Pipeline()
      .addMiddleware(logRequests())   // prints each request in the terminal
      .addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Listening on http://localhost:${server.port}');
}
```

`<name>` in the path is a **URL parameter**; shelf_router passes it to your function as an extra argument. Visit `http://localhost:8080/hello/Asha`.

Reading the port from the `PORT` environment variable lets hosting services choose it.

## 4. A JSON to-do API

```dart
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

final _todos = <int, Map<String, dynamic>>{
  1: {'id': 1, 'title': 'Learn Dart', 'done': true},
  2: {'id': 2, 'title': 'Build an API', 'done': false},
};
var _nextId = 3;

const _json = {'content-type': 'application/json'};

Response jsonResponse(Object? body, {int status = 200}) =>
    Response(status, body: jsonEncode(body), headers: _json);

Future<void> main() async {
  final router = Router()
    // GET /todos: list all
    ..get('/todos', (Request req) => jsonResponse(_todos.values.toList()))

    // GET /todos/1: one item
    ..get('/todos/<id>', (Request req, String id) {
      final todo = _todos[int.tryParse(id)];
      return todo == null
          ? jsonResponse({'error': 'Not found'}, status: 404)
          : jsonResponse(todo);
    })

    // POST /todos with {"title": "..."}
    ..post('/todos', (Request req) async {
      Object? body;
      try {
        body = jsonDecode(await req.readAsString());
      } on FormatException {
        return jsonResponse({'error': 'Body must be JSON'}, status: 400);
      }
      if (body is! Map || body['title'] is! String || (body['title'] as String).trim().isEmpty) {
        return jsonResponse({'error': 'title is required'}, status: 400);
      }
      final todo = {'id': _nextId, 'title': body['title'], 'done': false};
      _todos[_nextId++] = todo;
      return jsonResponse(todo, status: 201);
    })

    // DELETE /todos/1
    ..delete('/todos/<id>', (Request req, String id) {
      final removed = _todos.remove(int.tryParse(id));
      return removed == null
          ? jsonResponse({'error': 'Not found'}, status: 404)
          : Response(204);
    });

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Todo API on http://localhost:${server.port}');
}
```

Test it from a second terminal:

```bash
curl http://localhost:8080/todos
curl -X POST http://localhost:8080/todos -H "content-type: application/json" -d '{"title":"Write tests"}'
curl -X DELETE http://localhost:8080/todos/1
```

```output
[{"id":1,"title":"Learn Dart","done":true},{"id":2,"title":"Build an API","done":false}]
{"id":3,"title":"Write tests","done":false}
```

The data lives in memory, so it resets when the server restarts. A real app stores it in a database such as PostgreSQL (package [`postgres`](https://pub.dev/packages/postgres)) or SQLite.

### HTTP status codes used above

| Code | Meaning |
| --- | --- |
| `200 OK` | Success |
| `201 Created` | A new item was created |
| `204 No Content` | Success, nothing to return (after a delete) |
| `400 Bad Request` | The client sent invalid data |
| `404 Not Found` | No such item |

## 5. Write your own middleware

Middleware is a function that takes a handler and returns a new handler. This one allows a Flutter **web** app on another domain to call the API (CORS):

```dart
// Not standalone: add it to the pipeline in the server above.
Middleware cors() => (Handler inner) => (Request request) async {
      const headers = {
        'access-control-allow-origin': '*',
        'access-control-allow-methods': 'GET, POST, DELETE, OPTIONS',
        'access-control-allow-headers': 'content-type',
      };
      if (request.method == 'OPTIONS') return Response.ok('', headers: headers);
      final response = await inner(request);
      return response.change(headers: headers);
    };

// final handler = const Pipeline()
//     .addMiddleware(logRequests())
//     .addMiddleware(cors())
//     .addHandler(router.call);
```

In production, replace `'*'` with your app's real domain.

## 6. Call the API from Dart or Flutter

```dart
// Not standalone: needs the http package and the running server.
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final res = await http.get(Uri.parse('http://localhost:8080/todos'));
  final todos = jsonDecode(res.body) as List;
  for (final t in todos) {
    print('${t['done'] ? '✓' : '·'} ${t['title']}');
  }
}
```

See [HTTP requests in Dart](/practical-dart/http-requests/). In a Flutter app, the same code works with [HTTP in Flutter](https://flutter.dart-tutorial.dev/networking/http-requests/). On the Android emulator, use `http://10.0.2.2:8080` instead of `localhost`.

## 7. Build and deploy

Compile the server to one fast native file:

```bash
dart compile exe bin/server.dart -o server
./server
```

The `server-shelf` template also includes a `Dockerfile`, so you can deploy to any service that runs containers, such as Google Cloud Run, Fly.io, Railway or a VPS:

```bash
docker build -t todo-api .
docker run -p 8080:8080 todo-api
```

## Test the API

shelf handlers are plain functions, so you can test them without starting a server:

```dart
// Not standalone: test/server_test.dart, run with dart test
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

Response hello(Request request) => Response.ok('Hello from Dart!');

void main() {
  test('hello returns 200', () async {
    final res = hello(Request('GET', Uri.parse('http://localhost/')));
    expect(res.statusCode, 200);
    expect(await res.readAsString(), 'Hello from Dart!');
  });
}
```

More in [testing in Dart](/practical-dart/testing/).

## Try it yourself

1. Add `PUT /todos/<id>` that marks a to-do as done.
2. Add a middleware that rejects requests without the header `x-api-key: secret` with status `401`.
3. Save the to-dos to a JSON file with `dart:io` so they survive a restart (see [writing files](/files-and-io/writing-files/)).
