import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:todolist/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];
  final List<String> _categories = [
    'Alimentation',
    'Transport',
    'Logement',
    'Loisirs',
    'Santé',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _expenses.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('expenses', encoded);
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString('expenses');
    if (encoded != null) {
      final List decoded = jsonDecode(encoded);
      setState(() {
        _expenses.clear();
        _expenses.addAll(decoded.map((e) => Expense.fromJson(e)));
      });
    }
  }

  void _addExpense() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedCategory = _categories[0];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setStateDialog) => AlertDialog(
                  title: const Text('Ajouter une dépense'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Titre'),
                        ),
                        TextField(
                          controller: amountController,
                          decoration: const InputDecoration(
                            labelText: 'Montant',
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          items:
                              _categories
                                  .map(
                                    (cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setStateDialog(() {
                              selectedCategory = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Catégorie',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Date : ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setStateDialog(() {
                                    selectedDate = picked;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        TextField(
                          controller: descController,
                          decoration: const InputDecoration(
                            labelText: 'Description (facultatif)',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        final amount =
                            double.tryParse(amountController.text.trim()) ??
                            0.0;
                        final desc = descController.text.trim();
                        if (title.isEmpty || amount <= 0) return;
                        setState(() {
                          _expenses.add(
                            Expense(
                              title,
                              amount,
                              desc,
                              selectedDate,
                              selectedCategory,
                            ),
                          );
                        });
                        _saveExpenses();
                        Navigator.pop(context);
                      },
                      child: const Text('Ajouter'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showExpenseDetails(Expense expense) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(expense.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Montant : ${expense.amount.toStringAsFixed(2)} FCFA',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Catégorie : ${expense.category}'),
                const SizedBox(height: 8),
                Text(
                  'Date : ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                ),
                const SizedBox(height: 12),
                Text(
                  'Description :\n${expense.description.isEmpty ? "Aucune" : expense.description}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
    );
  }

  void _removeExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
    _saveExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final total = _expenses.fold<double>(0, (sum, e) => sum + e.amount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Dépenses'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF3F5FA),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total des dépenses : ${total.toStringAsFixed(2)} FCFA',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DashboardPage(
                              expenses: List<Expense>.from(_expenses),
                            ),
                      ),
                    );
                  },
                  child: const Text('Dashboard'),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child:
                      _expenses.isEmpty
                          ? const Center(
                            child: Text('Aucune dépense enregistrée.'),
                          )
                          : Builder(
                            builder: (context) {
                              final sortedExpenses = List<Expense>.from(
                                _expenses,
                              )..sort((a, b) => b.date.compareTo(a.date));
                              return ListView.separated(
                                itemCount: sortedExpenses.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final expense = sortedExpenses[index];
                                  return InkWell(
                                    onTap: () => _showExpenseDetails(expense),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.04,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          expense.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${expense.amount.toStringAsFixed(2)} FCFA',
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed:
                                              () => _removeExpense(
                                                _expenses.indexOf(expense),
                                              ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Expense {
  final String title;
  final double amount;
  final String description;
  final DateTime date;
  final String category;

  Expense(this.title, this.amount, this.description, this.date, this.category);

  Map<String, dynamic> toJson() => {
    'title': title,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(),
    'category': category,
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    json['title'],
    (json['amount'] as num).toDouble(),
    json['description'],
    DateTime.parse(json['date']),
    json['category'],
  );
}
