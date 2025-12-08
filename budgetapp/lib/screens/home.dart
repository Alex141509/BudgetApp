import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import 'addPurchase.dart';
import 'finance.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BudgetModel budget = BudgetModel.instance;
  final TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _setBudgetFromInput() {
    final text = _budgetController.text.trim();
    final value = double.tryParse(text);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid positive number')));
      return;
    }
    budget.setBudget(value);
    FocusScope.of(context).unfocus();
    _budgetController.clear();
  }

  Widget _buildMiniBarChart(Map<String, double> categories) {
    // Build 4 example bars from category totals and purchases:
    final combined = categories.entries.toList();
    combined.sort((a, b) => b.value.compareTo(a.value));
    final values = <double>[];
    for (var i = 0; i < 3; i++) {
      if (i < combined.length) {
        values.add(combined[i].value);
      } else {
        values.add(0.0);
      }
    }
    // add one representing "today" as last purchase amount (or zero)
    values.add((budget.purchases.value.isNotEmpty) ? budget.purchases.value.last.amount : 0.0);

    final maxVal = (values.fold(0.0, (s, v) => v > s ? v : s)).clamp(1.0, double.infinity);

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // For each bar: show a vertical bar and a label to the side with '-' prefix
          for (int i = 0; i < values.length; i++)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // left label showing the value (more visible)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Text(
                          values[i] == 0 ? '' : '-\$${values[i].toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      // the bar
                      Expanded(
                        child: Container(
                          height: (values[i] / maxVal) * 120 + 8,
                          decoration: BoxDecoration(
                            color: i == values.length - 1 ? Colors.red[200] : (i == 1 ? Colors.yellow[200] : Colors.green[200]),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(i == values.length - 1 ? 'Today' : (i == 1 ? 'Yesterday' : 'Earlier'), style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = budget;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xFFB8D1FF)), // background
          SafeArea(
            child: Column(
              children: [
                Container(height: 64, color: const Color(0xFFDFEFFF), alignment: Alignment.center, child: const Text('Home', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                Expanded(
                  child: ValueListenableBuilder<double>(
                    valueListenable: b.totalBudget,
                    builder: (context, total, _) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text('Savings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            ValueListenableBuilder<double>(
                              valueListenable: b.savings,
                              builder: (context, s, _) {
                                return Text('\$${s.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text('Balance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            // Balance now shows remaining (so purchases immediately reduce it)
                            ValueListenableBuilder<double>(
                              valueListenable: b.remaining,
                              builder: (context, rem, _) {
                                return Text('\$${rem.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text('Spending Summary This Month', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            if (total <= 0)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _budgetController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(labelText: 'Enter monthly budget (\$)'),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _setBudgetFromInput,
                                          child: const Text('Save Budget'),
                                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: [
                                  ValueListenableBuilder<Map<String, double>>(
                                    valueListenable: b.categoryTotals,
                                    builder: (context, categories, _) {
                                      return _buildMiniBarChart(categories);
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  ValueListenableBuilder<double>(
                                    valueListenable: b.totalBudget,
                                    builder: (context, tb, _) {
                                      // show low-balance warning (optional)
                                      return ValueListenableBuilder<double>(
                                        valueListenable: b.remaining,
                                        builder: (context, rem, __) {
                                          if (b.isLow) {
                                            return Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.9), borderRadius: BorderRadius.circular(6)),
                                              child: const Text("Warning: if you spend too much you won't have anything left.", style: TextStyle(color: Colors.white)),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            // Buttons at bottom
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/addPurchase').then((_) => setState(() {})),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                ),
                                child: const Text('Add Purchase'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/finance').then((_) => setState(() {})),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.blue[400],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                ),
                                child: const Text('See Finances'),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
