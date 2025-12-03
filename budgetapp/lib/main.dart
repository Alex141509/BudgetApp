import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/addPurchase.dart';
import 'screens/finance.dart';
import 'screens/purchase_confirm.dart';
import 'screens/purchase_rejected.dart';

void main() {
  runApp(const BudgetBanditsApp());
}

class BudgetBanditsApp extends StatelessWidget {
  const BudgetBanditsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Bandits',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/addPurchase': (context) => const AddPurchaseScreen(),
        '/finance': (context) => const FinanceScreen(),
        '/purchaseConfirm': (context) => const PurchaseConfirmScreen(),
        '/purchaseRejected': (context) => const PurchaseRejectedScreen(),
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF2B7CEB),
        useMaterial3: false,
      ),
    );
  }
}
