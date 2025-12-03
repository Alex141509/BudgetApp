import 'package:flutter/foundation.dart';

class Purchase {
  final String category;
  final double amount;
  final DateTime date;

  Purchase({
    required this.category,
    required this.amount,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

class BudgetModel {
  // singleton
  BudgetModel._internal();
  static final BudgetModel instance = BudgetModel._internal();

  // total planned monthly spending
  final ValueNotifier<double> totalBudget = ValueNotifier<double>(0.0);

  // remaining money left from the budget after purchases
  final ValueNotifier<double> remaining = ValueNotifier<double>(0.0);

  // list of purchases
  final ValueNotifier<List<Purchase>> purchases = ValueNotifier<List<Purchase>>([]);

  // categories -> totals (computed on demand or via recompute)
  final ValueNotifier<Map<String, double>> categoryTotals =
      ValueNotifier<Map<String, double>>({});

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
  }

  void addPurchase(String category, double amount) {
    final p = Purchase(category: category, amount: amount);
    final list = List<Purchase>.from(purchases.value);
    list.add(p);
    purchases.value = list;
    remaining.value = (remaining.value - amount);
    _recomputeCategories();
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

  // convenience helper: low balance threshold (20% of total)
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
}
