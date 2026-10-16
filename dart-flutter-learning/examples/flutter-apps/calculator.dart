// Calculator – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/calculator-app/
// Use as lib/main.dart in a new Flutter project

import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    ));

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  double? first;     // the number before the operator
  String? operator;  // + − × ÷
  bool fresh = true; // the next digit starts a new number

  static const rows = [
    ['C', '±', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['0', '.', '='],
  ];

  double calculate(double a, double b, String op) => switch (op) {
        '+' => a + b,
        '−' => a - b,
        '×' => a * b,
        '÷' => b == 0 ? double.nan : a / b,
        _ => b,
      };

  String format(double v) {
    if (v.isNaN || v.isInfinite) return 'Error';
    if (v == v.roundToDouble() && v.abs() < 1e12) return v.toInt().toString();
    var s = v.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '');
    return s.endsWith('.') ? s.substring(0, s.length - 1) : s;
  }

  void press(String key) {
    setState(() {
      if (display == 'Error') {
        display = '0';
        first = null;
        operator = null;
        fresh = true;
        if (key == 'C') return;
      }
      switch (key) {
        case 'C':
          display = '0';
          first = null;
          operator = null;
          fresh = true;
        case '±':
          if (display != '0') {
            display = display.startsWith('-') ? display.substring(1) : '-$display';
          }
        case '%':
          display = format(double.parse(display) / 100);
        case '+' || '−' || '×' || '÷':
          if (first != null && operator != null && !fresh) {
            display = format(calculate(first!, double.parse(display), operator!));
          }
          first = double.tryParse(display);
          operator = key;
          fresh = true;
        case '=':
          if (first != null && operator != null) {
            display = format(calculate(first!, double.parse(display), operator!));
            first = null;
            operator = null;
            fresh = true;
          }
        case '.':
          if (fresh) {
            display = '0.';
            fresh = false;
          } else if (!display.contains('.')) {
            display += '.';
          }
        default: // a digit
          if (fresh || display == '0') {
            display = key;
            fresh = false;
          } else if (display.length < 12) {
            display += key;
          }
      }
    });
  }

  Color colorFor(String key, ColorScheme c) {
    if ('÷×−+='.contains(key)) return c.primary;
    if ('C±%'.contains(key)) return c.secondaryContainer;
    return c.surfaceContainerHighest;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        first == null ? '' : '${format(first!)} ${operator ?? ''}',
                        style: TextStyle(fontSize: 22, color: colors.outline),
                      ),
                      FittedBox(
                        child: Text(display, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                ),
              ),
              for (final row in rows)
                Row(
                  children: [
                    for (final key in row)
                      Expanded(
                        flex: key == '0' ? 2 : 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 68,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: colorFor(key, colors),
                                foregroundColor: '÷×−+='.contains(key) ? colors.onPrimary : colors.onSurface,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              ),
                              onPressed: () => press(key),
                              child: Text(key, style: const TextStyle(fontSize: 26)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
