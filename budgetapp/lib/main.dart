import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/addPurchase.dart';
import 'screens/finance.dart';

void main() {
  runApp(const BudgetBanditsApp());
}

class BudgetBanditsApp extends StatelessWidget {
  const BudgetBanditsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Bandits',
      initialRoute: '/login',   // START on login screen
      routes: {
        '/login': (context) => const LoginScreen(),
       // '/home': (context) => const HomeScreen(),
        // '/addPurchase': (context) => const AddPurchaseScreen(),
       //  '/finance': (context) => const FinanceScreen(),
      },
    );
  }
}
