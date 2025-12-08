import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import 'package:intl/intl.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
  final BudgetModel budget = BudgetModel.instance;
  late final TabController _tabController;
  final DateFormat _dateFormat = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // seed example history if none exists
    budget.seedHistoryIfEmpty();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCategoriesTab() {
    return ValueListenableBuilder<Map<String, double>>(
      valueListenable: budget.categoryTotals,
      builder: (context, categories, _) {
        if (categories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No purchases yet', style: TextStyle(fontSize: 16)),
          );
        }
        final entries = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
        return ListView(
          padding: const EdgeInsets.all(12),
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
    );
  }

  Widget _buildHistoryTab() {
    return ValueListenableBuilder<List<Purchase>>(
      valueListenable: budget.historyPurchases,
      builder: (context, history, _) {
        if (history.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No history available', style: TextStyle(fontSize: 16)),
          );
        }
        final sorted = List<Purchase>.from(history)..sort((a, b) => b.date.compareTo(a.date));
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final p = sorted[index];
            return Card(
              child: ListTile(
                title: Text(p.category),
                subtitle: Text(p.note.isNotEmpty ? p.note : _dateFormat.format(p.date)),
                trailing: Text('\$${p.amount.toStringAsFixed(2)}'),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black87,
          tabs: const [
            Tab(text: 'Categories'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoriesTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }
}
