import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme/app_theme.dart';
import 'features/calculator/presentation/pages/calculator_page.dart';

void main() {
  runApp(const ProviderScope(child: CalculatorApp()));
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: AppTheme.darkTheme,
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
