import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/calculator_provider.dart';
import 'calculator_button.dart';

class CalculatorKeypad extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            _buildButtonRow(notifier, ['AC', '⌫', '÷', '×'], ['÷', '×']),
            _buildButtonRow(notifier, ['7', '8', '9', '−'], ['−']),
            _buildButtonRow(notifier, ['4', '5', '6', '+'], ['+']),
            _buildButtonRow(notifier, ['1', '2', '3', '='], ['=']),
            _buildButtonRow(notifier, ['0', '.', '%'], ['%']),
            if (state.useScientific) ...[
              const SizedBox(height: 8),
              _buildScientificRow(notifier, state),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(CalculatorNotifier notifier, List<String> labels, List<String> operatorLabels) {
    return Row(
      children: labels.map((label) {
        final isOperator = operatorLabels.contains(label);
        return Expanded(
          child: CalculatorButton(
            label: label,
            onPressed: () => _handleButtonPress(notifier, label),
            isOperator: isOperator,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScientificRow(CalculatorNotifier notifier, CalculatorState state) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSmallButton(notifier, 'sin'),
        _buildSmallButton(notifier, 'cos'),
        _buildSmallButton(notifier, 'tan'),
        _buildSmallButton(notifier, '('),
        _buildSmallButton(notifier, ')'),
        _buildSmallButton(notifier, 'π'),
        _buildSmallButton(notifier, 'e'),
        _buildSmallButton(notifier, 'ln'),
        _buildSmallButton(notifier, 'log'),
      ],
    );
  }

  Widget _buildSmallButton(CalculatorNotifier notifier, String label) {
    return SizedBox(
      width: 60,
      child: CalculatorButton(
        label: label,
        onPressed: () => _handleButtonPress(notifier, label),
      ),
    );
  }

  void _handleButtonPress(CalculatorNotifier notifier, String label) {
    switch (label) {
      case 'AC':
        notifier.clear();
        break;
      case '⌫':
        notifier.delete();
        break;
      case '=':
        notifier.evaluate();
        break;
      case 'sin':
      case 'cos':
      case 'tan':
      case 'ln':
      case 'log':
        notifier.addInput('$label(');
        break;
      case '(':
      case ')':
      case 'π':
      case 'e':
      case '+':
      case '−':
      case '×':
      case '÷':
      case '%':
      case '^':
      case '.':
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        notifier.addInput(label);
        break;
      default:
        notifier.addInput(label);
    }
  }
}