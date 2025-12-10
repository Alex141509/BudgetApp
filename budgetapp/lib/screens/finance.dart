// lib/screens/finance.dart
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

  // Colors to match the app look
  final Color appBg = const Color(0xFFB8D1FF);
  final Color categoriesCard = const Color(0xFFFFF7D6); // pale yellow
  final Color historyCard = const Color(0xFFFFE6E6); // pale red/pink

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('No purchases yet', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          );
        }
        final entries = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
        return ListView(
          padding: const EdgeInsets.all(12),
          children: entries.map((e) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: categoriesCard,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(1,1))],
              ),
              child: ListTile(
                title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Text('-\$${e.value.toStringAsFixed(2)}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
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
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('No history available', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          );
        }
        final sorted = List<Purchase>.from(history)..sort((a, b) => b.date.compareTo(a.date));
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final p = sorted[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: historyCard,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(1,1))],
              ),
              child: ListTile(
                title: Text(p.category, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(p.note.isNotEmpty ? p.note : _dateFormat.format(p.date)),
                trailing: Text('-\$${p.amount.toStringAsFixed(2)}', style: const TextStyle(color: Color.fromARGB(255, 198, 40, 40), fontWeight: FontWeight.bold)),
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
      backgroundColor: appBg, // match app background
      appBar: AppBar(
        title: const Text('Finances'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black87,
          indicatorColor: Colors.blueAccent,
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
