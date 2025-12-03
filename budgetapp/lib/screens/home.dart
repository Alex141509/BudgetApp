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
    // Prepopulate if you want a default; leave 0 for first run
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

  Widget _buildMiniBarChart(double r, Map<String, double> categories) {
    // Very simple visual: four bars for yesterday/two earlier/today if categories match.
    // We'll generate 3 sample bars from the top 3 categories or purchases.
    final combined = categories.entries.toList();
    // sort descending
    combined.sort((a, b) => b.value.compareTo(a.value));
    // pick up to 3 values for display
    final values = <double>[];
    for (var i = 0; i < 3; i++) {
      if (i < combined.length) {
        values.add(combined[i].value);
      } else {
        values.add(0.0);
      }
    }
    // add one representing "today" as remaining/10 as a visual (or last purchase if exists)
    values.add((budget.purchases.value.isNotEmpty) ? budget.purchases.value.last.amount : 0.0);

    // compute max
    final maxVal = (values.fold(0.0, (s, v) => v > s ? v : s)).clamp(1.0, double.infinity);

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < values.length; i++)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 36,
                    height: (values[i] / maxVal) * 120 + 8,
                    decoration: BoxDecoration(
                      color: i == values.length - 1 ? Colors.red[200] : (i == 1 ? Colors.yellow[200] : Colors.green[200]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('\$${values[i].toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
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
                            const Text('\$300', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            const Text('Balance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            ValueListenableBuilder<double>(
                              valueListenable: b.totalBudget,
                              builder: (context, tb, _) {
                                return Text('\$${tb.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold));
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text('Spending Summary This Month', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            // If budget is zero — show input to set budget
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
                                      return _buildMiniBarChart(b.remaining.value, categories);
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  ValueListenableBuilder<double>(
                                    valueListenable: b.remaining,
                                    builder: (context, rem, _) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Remaining: \$${rem.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 6),
                                          // low balance warning:
                                          if (b.isLow)
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.9), borderRadius: BorderRadius.circular(6)),
                                              child: const Text("Warning: if you spend too much you won't have anything left.", style: TextStyle(color: Colors.white)),
                                            ),
                                        ],
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
