// Notes Riverpod – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/notes-app-riverpod/
// Use as lib/main.dart after: flutter pub add flutter_riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: NotesApp()));

// ---------- Model (immutable) ----------
class Note {
  const Note({required this.id, required this.title, required this.body, required this.updated});
  final int id;
  final String title;
  final String body;
  final DateTime updated;

  Note copyWith({String? title, String? body}) => Note(
        id: id,
        title: title ?? this.title,
        body: body ?? this.body,
        updated: DateTime.now(),
      );
}

// ---------- State ----------
class NotesNotifier extends Notifier<List<Note>> {
  int _nextId = 3;

  @override
  List<Note> build() => [
        Note(id: 1, title: 'Welcome', body: 'Tap a note to edit it.', updated: DateTime.now()),
        Note(id: 2, title: 'Riverpod', body: 'State lives in providers, not widgets.', updated: DateTime.now()),
      ];

  int add() {
    final note = Note(id: _nextId++, title: '', body: '', updated: DateTime.now());
    state = [note, ...state];
    return note.id;
  }

  void save(int id, {required String title, required String body}) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(title: title, body: body) else n,
    ];
  }

  void delete(int id) => state = state.where((n) => n.id != id).toList();
}

final notesProvider = NotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}

final searchProvider = NotifierProvider<SearchNotifier, String>(SearchNotifier.new);

// Derived: recalculated only when notes or the search change.
final visibleNotesProvider = Provider<List<Note>>((ref) {
  final query = ref.watch(searchProvider).toLowerCase();
  final notes = ref.watch(notesProvider);
  final filtered = query.isEmpty
      ? notes
      : notes.where((n) => '${n.title} ${n.body}'.toLowerCase().contains(query)).toList();
  return [...filtered]..sort((a, b) => b.updated.compareTo(a.updated));
});

// ---------- UI ----------
class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.amber),
      home: const NotesListPage(),
    );
  }
}

class NotesListPage extends ConsumerWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(visibleNotesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SearchBar(
              hintText: 'Search notes',
              leading: const Icon(Icons.search),
              onChanged: (v) => ref.read(searchProvider.notifier).set(v),
            ),
          ),
        ),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes'))
          : ListView.separated(
              itemCount: notes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final n = notes[i];
                return ListTile(
                  title: Text(n.title.isEmpty ? '(untitled)' : n.title),
                  subtitle: Text(n.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref.read(notesProvider.notifier).delete(n.id),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditNotePage(id: n.id)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = ref.read(notesProvider.notifier).add();
          Navigator.push(context, MaterialPageRoute(builder: (_) => EditNotePage(id: id)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EditNotePage extends ConsumerStatefulWidget {
  const EditNotePage({super.key, required this.id});
  final int id;

  @override
  ConsumerState<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends ConsumerState<EditNotePage> {
  late final Note _note = ref.read(notesProvider).firstWhere((n) => n.id == widget.id);
  late final _title = TextEditingController(text: _note.title);
  late final _body = TextEditingController(text: _note.body);

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(notesProvider.notifier).save(widget.id, title: _title.text, body: _body.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit note'),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _title,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: const InputDecoration(hintText: 'Title', border: InputBorder.none),
            ),
            Expanded(
              child: TextField(
                controller: _body,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(hintText: 'Write something...', border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
