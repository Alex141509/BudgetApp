// lib/screens/purchase_rejected.dart
import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../models/budget_model.dart';

class PurchaseRejectedScreen extends StatefulWidget {
  const PurchaseRejectedScreen({super.key});

  @override
  State<PurchaseRejectedScreen> createState() => _PurchaseRejectedScreenState();
}

class _PurchaseRejectedScreenState extends State<PurchaseRejectedScreen> {
  late final ConfettiController _confettiController;
  final BudgetModel budget = BudgetModel.instance;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    // start confetti immediately
    _confettiController.play();

    // After 2 seconds, navigate to Home
    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFFFD8), // green-ish
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: const SizedBox.shrink(),
        title: const Text('Purchase Rejected'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20),
                child: ValueListenableBuilder<double>(
                  valueListenable: budget.savings,
                  builder: (context, saved, _) {
                    return Column(
                      children: [
                        const Text('🎉 Congrats!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("You saved money — keep trying to reach your goals!", textAlign: TextAlign.center),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              const Text('Savings', style: TextStyle(fontSize: 14)),
                              const SizedBox(height: 6),
                              Text('\$${saved.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 180,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Good job — returning to Home...'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Confetti widget
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                maxBlastForce: 20,
                minBlastForce: 5,
                gravity: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
