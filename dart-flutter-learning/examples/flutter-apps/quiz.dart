// Quiz – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/quiz-app/
// Use as lib/main.dart in a new Flutter project

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const QuizPage(),
    ));

class Question {
  const Question(this.text, this.answers, this.correct);
  final String text;
  final List<String> answers;
  final int correct; // index of the right answer
}

const questions = [
  Question('Which language is Flutter written with?', ['Kotlin', 'Dart', 'Swift', 'JavaScript'], 1),
  Question('Which widget can change while the app runs?', ['StatelessWidget', 'Text', 'StatefulWidget', 'Icon'], 2),
  Question('What lays children out horizontally?', ['Column', 'Stack', 'Row', 'ListView'], 2),
  Question('Which method rebuilds a StatefulWidget?', ['build()', 'setState()', 'dispose()', 'runApp()'], 1),
  Question('Which package is a popular state management tool?', ['Riverpod', 'http', 'path', 'intl'], 0),
];

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  int? chosen; // the answer the user tapped, null while choosing

  bool get finished => index >= questions.length;

  void choose(int answer) {
    if (chosen != null) return; // already answered
    setState(() {
      chosen = answer;
      if (answer == questions[index].correct) score++;
    });
  }

  void next() => setState(() {
        index++;
        chosen = null;
      });

  void restart() => setState(() {
        index = 0;
        score = 0;
        chosen = null;
      });

  Color? colorFor(int i) {
    if (chosen == null) return null;
    if (i == questions[index].correct) return Colors.green;
    if (i == chosen) return Colors.red;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (finished) return _result(context);
    final q = questions[index];
    return Scaffold(
      appBar: AppBar(title: Text('Question ${index + 1} of ${questions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: index / questions.length),
            const SizedBox(height: 32),
            Text(q.text, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            for (var i = 0; i < q.answers.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorFor(i),
                    foregroundColor: colorFor(i) == null ? null : Colors.white,
                    padding: const EdgeInsets.all(18),
                  ),
                  onPressed: () => choose(i),
                  child: Text(q.answers[i], style: const TextStyle(fontSize: 18)),
                ),
              ),
            const Spacer(),
            if (chosen != null)
              FilledButton(
                onPressed: next,
                child: Text(index == questions.length - 1 ? 'See result' : 'Next'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _result(BuildContext context) {
    final percent = (score / questions.length * 100).round();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(percent >= 60 ? Icons.emoji_events : Icons.school, size: 96, color: Colors.amber),
            const SizedBox(height: 16),
            Text('You scored $score / ${questions.length}', style: Theme.of(context).textTheme.headlineMedium),
            Text('$percent%', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: restart, icon: const Icon(Icons.replay), label: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
