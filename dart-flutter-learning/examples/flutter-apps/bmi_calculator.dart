// Bmi Calculator – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/bmi-calculator/
// Use as lib/main.dart in a new Flutter project

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const BmiPage(),
    ));

enum Units { metric, imperial }

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  Units units = Units.metric;
  double heightCm = 170;
  double weightKg = 65;

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  (String, Color) get category => switch (bmi) {
        < 18.5 => ('Underweight', Colors.blue),
        < 25 => ('Normal', Colors.green),
        < 30 => ('Overweight', Colors.orange),
        _ => ('Obese', Colors.red),
      };

  String get heightLabel {
    if (units == Units.metric) return '${heightCm.round()} cm';
    final totalInches = heightCm / 2.54;
    return "${totalInches ~/ 12} ft ${(totalInches % 12).round()} in";
  }

  String get weightLabel =>
      units == Units.metric ? '${weightKg.round()} kg' : '${(weightKg * 2.20462).round()} lb';

  @override
  Widget build(BuildContext context) {
    final (label, color) = category;
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SegmentedButton<Units>(
            segments: const [
              ButtonSegment(value: Units.metric, label: Text('Metric')),
              ButtonSegment(value: Units.imperial, label: Text('Imperial')),
            ],
            selected: {units},
            onSelectionChanged: (s) => setState(() => units = s.first),
          ),
          const SizedBox(height: 24),
          Text('Height: $heightLabel', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 120,
            max: 220,
            value: heightCm,
            onChanged: (v) => setState(() => heightCm = v),
          ),
          Text('Weight: $weightLabel', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 30,
            max: 150,
            value: weightKg,
            onChanged: (v) => setState(() => weightKg = v),
          ),
          const SizedBox(height: 24),
          Card(
            color: color.withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Your BMI'),
                  Text(
                    bmi.toStringAsFixed(1),
                    style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(label, style: TextStyle(fontSize: 22, color: color)),
                  const SizedBox(height: 12),
                  const Text('Healthy range: 18.5 to 24.9', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
