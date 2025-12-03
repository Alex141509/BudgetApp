import 'package:flutter/material.dart';
import '../models/budget_model.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final BudgetModel budget = BudgetModel.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: BackButton(color: Colors.black),
        elevation: 1,
      ),
      body: Container(
        color: const Color(0xFF9FC3FF),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ValueListenableBuilder<Map<String, double>>(
              valueListenable: budget.categoryTotals,
              builder: (context, categories, _) {
                if (categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text('No purchases yet', style: TextStyle(fontSize: 16)),
                  );
                }
                final entries = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
                return Column(
                  children: entries.map((e) {
                    return Card(
                      child: ListTile(
                        title: Text(e.key),
                        trailing: Text('\$${e.value.toStringAsFixed(2)}'),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            const Spacer(),
            ValueListenableBuilder<double>(
              valueListenable: budget.remaining,
              builder: (context, rem, _) {
                return Column(
                  children: [
                    Text('Total Bills left: \$${rem.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
