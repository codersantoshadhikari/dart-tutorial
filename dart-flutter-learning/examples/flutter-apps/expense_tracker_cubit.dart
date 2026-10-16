// Expense Tracker Cubit – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/expense-tracker-bloc/
// Use as lib/main.dart after: flutter pub add flutter_bloc

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------- Model ----------
enum Category {
  food(Icons.restaurant, Colors.orange),
  transport(Icons.directions_bus, Colors.blue),
  shopping(Icons.shopping_bag, Colors.purple),
  bills(Icons.receipt_long, Colors.red),
  other(Icons.category, Colors.grey);

  const Category(this.icon, this.color);
  final IconData icon;
  final Color color;
}

class Expense {
  const Expense({required this.title, required this.amount, required this.category, required this.date});
  final String title;
  final double amount;
  final Category category;
  final DateTime date;
}

// ---------- State (immutable) ----------
class ExpensesState {
  const ExpensesState(this.expenses);
  final List<Expense> expenses;

  double get total => expenses.fold(0, (sum, e) => sum + e.amount);

  Map<Category, double> get byCategory {
    final map = <Category, double>{};
    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }
}

// ---------- Cubit: the only place that changes state ----------
class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit()
      : super(ExpensesState([
          Expense(title: 'Lunch', amount: 8.5, category: Category.food, date: DateTime.now()),
          Expense(title: 'Bus pass', amount: 30, category: Category.transport, date: DateTime.now()),
        ]));

  void add(Expense e) => emit(ExpensesState([e, ...state.expenses]));

  void remove(Expense e) =>
      emit(ExpensesState(state.expenses.where((x) => x != e).toList()));
}

// ---------- UI ----------
void main() {
  runApp(BlocProvider(
    create: (_) => ExpensesCubit(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const ExpensesPage(),
    ),
  ));
}

String money(double v) => '\$${v.toStringAsFixed(2)}';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: BlocBuilder<ExpensesCubit, ExpensesState>(
        builder: (context, state) {
          final byCat = state.byCategory;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total spent'),
                      Text(money(state.total), style: Theme.of(context).textTheme.displaySmall),
                      const SizedBox(height: 12),
                      for (final c in Category.values)
                        if (byCat[c] != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(c.icon, color: c.color, size: 18),
                                const SizedBox(width: 8),
                                SizedBox(width: 90, child: Text(c.name)),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: byCat[c]! / state.total,
                                    color: c.color,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(money(byCat[c]!)),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final e in state.expenses)
                Dismissible(
                  key: ObjectKey(e),
                  onDismissed: (_) => context.read<ExpensesCubit>().remove(e),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e.category.color.withValues(alpha: 0.15),
                      child: Icon(e.category.icon, color: e.category.color),
                    ),
                    title: Text(e.title),
                    subtitle: Text('${e.date.day}/${e.date.month}/${e.date.year}'),
                    trailing: Text(money(e.amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => BlocProvider.value(
            value: context.read<ExpensesCubit>(),
            child: const AddExpenseSheet(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
    );
  }
}

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  Category _category = Category.food;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ExpensesCubit>().add(Expense(
          title: _title.text.trim(),
          amount: double.parse(_amount.text),
          category: _category,
          date: DateTime.now(),
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
            ),
            TextFormField(
              controller: _amount,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final n = double.tryParse(v ?? '');
                return (n == null || n <= 0) ? 'Enter an amount above 0' : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Category>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final c in Category.values)
                  DropdownMenuItem(value: c, child: Row(children: [Icon(c.icon, color: c.color), const SizedBox(width: 8), Text(c.name)])),
              ],
              onChanged: (c) => setState(() => _category = c!),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _submit, child: const Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
