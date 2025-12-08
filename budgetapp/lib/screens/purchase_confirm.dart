// lib/screens/purchase_confirm.dart
import 'package:flutter/material.dart';
import '../models/budget_model.dart';

class PurchaseConfirmScreen extends StatelessWidget {
  const PurchaseConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    final String category = args['category'] as String? ?? 'Other';
    final double amount = (args['amount'] as double?) ?? 0.0;
    final BudgetModel budget = BudgetModel.instance;

    // compute new balance if purchase were added (we do NOT yet commit)
    final double currentRemaining = budget.remaining.value;
    final double newBalance = currentRemaining - amount;

    // Low threshold — you can change this (20% rule kept consistent)
    final bool willBeLow = (budget.totalBudget.value > 0) && (newBalance <= (0.2 * budget.totalBudget.value));

    return Scaffold(
      backgroundColor: const Color(0xFFFFD4B2), // orange-ish
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: BackButton(color: Colors.black),
        title: const Text('Add Purchase'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$category  •  \$${amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text(
                      'This purchase will leave you with little money for anything important that might come up during the month.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    // show the computed new balance preview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current remaining:'),
                        Text('\$${currentRemaining.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('After purchase:'),
                        Text('\$${newBalance.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (willBeLow)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.85), borderRadius: BorderRadius.circular(8)),
                        child: const Text(
                          "Warning: This will leave you with very little money left.",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Buttons: Reject | Add
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Reject: do NOT deduct from remaining, but add the amount to savings
                        budget.addRejectedAmount(amount);
                        // Navigate to the "congrats you saved money" screen
                        Navigator.pushReplacementNamed(context, '/purchaseRejected');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add: commit purchase then return to home
                        budget.addPurchase(category, amount);
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(child: Text('Category: $category', style: const TextStyle(color: Colors.black54))),
            ],
          ),
        ),
      ),
    );
  }
}
