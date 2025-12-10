import 'package:flutter/foundation.dart';

class Purchase {
  final String category;
  final double amount;
  final DateTime date;
  final String note;

  Purchase({
    required this.category,
    required this.amount,
    DateTime? date,
    this.note = '',
  }) : date = date ?? DateTime.now();
}

class BudgetModel {
  
  BudgetModel._internal();
  static final BudgetModel instance = BudgetModel._internal();

  // total planned monthly spending
  final ValueNotifier<double> totalBudget = ValueNotifier<double>(0.0);

  // remaining money left from the budget after purchases
  final ValueNotifier<double> remaining = ValueNotifier<double>(0.0);

  // list of purchases (current month)
  final ValueNotifier<List<Purchase>> purchases = ValueNotifier<List<Purchase>>([]);

  // history list for past-month purchases (pre-populated)
  final ValueNotifier<List<Purchase>> historyPurchases = ValueNotifier<List<Purchase>>([]);

  // categories -> totals (computed on demand or via recompute)
  final ValueNotifier<Map<String, double>> categoryTotals =
      ValueNotifier<Map<String, double>>({});

  // savings shown on Home (start at 0 now)
  final ValueNotifier<double> savings = ValueNotifier<double>(0.0);

  // total amount user "rejected" 
  final ValueNotifier<double> rejectedSavings = ValueNotifier<double>(0.0);

  void setBudget(double amount) {
    totalBudget.value = amount;
    remaining.value = amount - _sumPurchases();
    _recomputeCategories();
  }

  void resetBudget() {
    totalBudget.value = 0.0;
    remaining.value = 0.0;
    purchases.value = [];
    categoryTotals.value = {};
    // clear savings on reset so fresh start = 0
    savings.value = 0.0;
    rejectedSavings.value = 0.0;
  }

  void addPurchase(String category, double amount, {String note = ''}) {
    final p = Purchase(category: category, amount: amount, note: note);
    final list = List<Purchase>.from(purchases.value);
    list.add(p);
    purchases.value = list;
    remaining.value = (remaining.value - amount);
    _recomputeCategories();
  }

  
  void addRejectedAmount(double amount) {
    rejectedSavings.value = rejectedSavings.value + amount;
    savings.value = savings.value + amount;
  }

  double _sumPurchases() {
    return purchases.value.fold(0.0, (s, p) => s + p.amount);
  }

  void _recomputeCategories() {
    final map = <String, double>{};
    for (final p in purchases.value) {
      map[p.category] = (map[p.category] ?? 0.0) + p.amount;
    }
    categoryTotals.value = map;
  }


  bool get isLow {
    if (totalBudget.value <= 0) return false;
    return remaining.value <= (0.2 * totalBudget.value);
  }

  // convenience: percent spent
  double get percentSpent {
    if (totalBudget.value <= 0) return 0.0;
    final spent = totalBudget.value - remaining.value;
    return (spent / totalBudget.value).clamp(0.0, 1.0);
  }


  void seedHistoryIfEmpty() {
    if (historyPurchases.value.isNotEmpty) return;
    final now = DateTime.now();
    final lastMonth = now.subtract(const Duration(days: 28));
    historyPurchases.value = [
      Purchase(category: 'Food', amount: 45.50, date: lastMonth.subtract(const Duration(days: 2)), note: 'Lunch & coffee'),
      Purchase(category: 'Gas', amount: 32.00, date: lastMonth.subtract(const Duration(days: 6)), note: 'Fill-up'),
      Purchase(category: 'Entertainment', amount: 20.00, date: lastMonth.subtract(const Duration(days: 12)), note: 'Movies'),
      Purchase(category: 'Groceries', amount: 78.20, date: lastMonth.subtract(const Duration(days: 18)), note: 'Weekly groceries'),
      Purchase(category: 'Subscription', amount: 12.99, date: lastMonth.subtract(const Duration(days: 22)), note: 'Streaming'), 
      Purchase(category: 'Travel', amount: 1000, date: lastMonth.subtract(const Duration(days: 22)), note: 'Travel'),
    ];
  }
}
