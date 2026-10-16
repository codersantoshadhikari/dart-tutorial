// Todo With Storage – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/todo-app-with-storage/
// Use as lib/main.dart after: flutter pub add shared_preferences

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const TodoPage(),
    ));

class Task {
  Task({required this.title, this.done = false});
  final String title;
  bool done;

  Map<String, dynamic> toJson() => {'title': title, 'done': done};
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(title: json['title'] as String, done: json['done'] as bool);
}

enum Filter { all, active, done }

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  List<Task> _tasks = [];
  Filter _filter = Filter.all;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('tasks');
    setState(() {
      if (saved != null) {
        _tasks = (jsonDecode(saved) as List)
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      _loading = false;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks.map((t) => t.toJson()).toList()));
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _tasks.insert(0, Task(title: text)));
    _controller.clear();
    _save();
  }

  void _toggle(Task task) {
    setState(() => task.done = !task.done);
    _save();
  }

  void _delete(Task task) {
    final index = _tasks.indexOf(task);
    setState(() => _tasks.removeAt(index));
    _save();
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text('Deleted "${task.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() => _tasks.insert(index, task));
            _save();
          },
        ),
      ));
  }

  List<Task> get _visible => switch (_filter) {
        Filter.all => _tasks,
        Filter.active => _tasks.where((t) => !t.done).toList(),
        Filter.done => _tasks.where((t) => t.done).toList(),
      };

  @override
  Widget build(BuildContext context) {
    final left = _tasks.where((t) => !t.done).length;
    return Scaffold(
      appBar: AppBar(title: Text('My tasks ($left left)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _add(),
                    decoration: InputDecoration(
                      hintText: 'What do you need to do?',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _add),
                    ),
                  ),
                ),
                SegmentedButton<Filter>(
                  segments: const [
                    ButtonSegment(value: Filter.all, label: Text('All')),
                    ButtonSegment(value: Filter.active, label: Text('Active')),
                    ButtonSegment(value: Filter.done, label: Text('Done')),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (s) => setState(() => _filter = s.first),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _visible.isEmpty
                      ? const Center(child: Text('Nothing here. Add a task above!'))
                      : ListView.builder(
                          itemCount: _visible.length,
                          itemBuilder: (context, i) {
                            final task = _visible[i];
                            return Dismissible(
                              key: ObjectKey(task),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) => _delete(task),
                              child: CheckboxListTile(
                                value: task.done,
                                onChanged: (_) => _toggle(task),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.done ? TextDecoration.lineThrough : null,
                                    color: task.done ? Colors.grey : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
