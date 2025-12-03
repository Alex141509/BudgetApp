// lib/screens/add_purchase.dart
import 'package:flutter/material.dart';
import '../models/budget_model.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final BudgetModel budget = BudgetModel.instance;
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Other';
  final List<String> _categories = ['Food', 'Gas', 'Rent', 'Entertainment', 'Savings', 'Other'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final text = _amountController.text.trim();
    final val = double.tryParse(text);
    if (val == null || val <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid positive number')));
      return;
    }

    // Navigate to the full-screen confirmation (Option C)
    // Pass amount and category as arguments
    Navigator.pushNamed(
      context,
      '/purchaseConfirm',
      arguments: {
        'category': _selectedCategory,
        'amount': val,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Purchase'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: BackButton(color: Colors.black),
      ),
      body: Container(
        color: const Color(0xFFB8D1FF),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCategory,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v ?? 'Other'),
                underline: const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter amount (\$)', filled: true, fillColor: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSavePressed,
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
