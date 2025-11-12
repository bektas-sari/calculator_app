import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/calculator_display.dart';
import '../widgets/calculator_keypad.dart';

class CalculatorPage extends ConsumerWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0B0E12),
                const Color(0xFF11151B),
              ],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const CalculatorDisplay(),
              const SizedBox(height: 24),
              Expanded(
                child: CalculatorKeypad(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
