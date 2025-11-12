import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:characters/characters.dart';

import '../../domain/entities/calculation_result.dart';
import '../../infrastructure/services/math_evaluator.dart';
import '../../infrastructure/services/number_formatter.dart';

final calculatorProvider =
StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});

final historyProvider =
StateNotifierProvider<HistoryNotifier, List<CalculationResult>>((ref) {
  return HistoryNotifier();
});

final memoryProvider = StateNotifierProvider<MemoryNotifier, double?>((ref) {
  return MemoryNotifier();
});

class CalculatorState {
  final String expression;
  final String result;
  final String? error;
  final bool useRadians;
  final bool useScientific;
  final bool secondActive;

  CalculatorState({
    this.expression = '0',
    this.result = '0',
    this.error,
    this.useRadians = false,
    this.useScientific = false,
    this.secondActive = false,
  });

  CalculatorState copyWith({
    String? expression,
    String? result,
    String? error,
    bool? useRadians,
    bool? useScientific,
    bool? secondActive,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      error: error ?? this.error,
      useRadians: useRadians ?? this.useRadians,
      useScientific: useScientific ?? this.useScientific,
      secondActive: secondActive ?? this.secondActive,
    );
  }
}

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(CalculatorState()) {
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      useRadians: prefs.getBool('useRadians') ?? false,
      useScientific: prefs.getBool('useScientific') ?? false,
    );
  }

  void addInput(String value) {
    if (state.expression == '0' && value != '.' && !_isOperator(value)) {
      state = state.copyWith(expression: value, error: null);
    } else if (state.expression == '0' && value == '.') {
      state = state.copyWith(expression: '0.', error: null);
    } else {
      state = state.copyWith(
        expression: state.expression + value,
        error: null,
      );
    }
    _evaluate();
  }

  void delete() {
    final expr = state.expression;
    if (expr.length <= 1) {
      state = state.copyWith(expression: '0', result: '0', error: null);
    } else {
      state = state.copyWith(
        expression: expr.substring(0, expr.length - 1),
        error: null,
      );
    }
    _evaluate();
  }

  void clear() {
    state = state.copyWith(expression: '0', result: '0', error: null);
  }

  void toggleRadians() async {
    state = state.copyWith(useRadians: !state.useRadians);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useRadians', state.useRadians);
    _evaluate();
  }

  void toggleScientific() async {
    state = state.copyWith(useScientific: !state.useScientific);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useScientific', state.useScientific);
  }

  void toggleSecond() {
    state = state.copyWith(secondActive: !state.secondActive);
  }

  void _evaluate() {
    final trimmed = state.expression.trim();

    if (trimmed.isEmpty ||
        trimmed == '-' ||
        trimmed == '+' ||
        _isOperator(trimmed.characters.last)) {
      state = state.copyWith(result: '—', error: null);
      return;
    }

    try {
      final value = MathEvaluator.evaluate(
        trimmed,
        useRadians: state.useRadians,
      );
      final formatted = NumberFormatter.format(value);
      state = state.copyWith(result: formatted, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), result: '—');
    }
  }

  void evaluate() {
    _evaluate();
  }

  bool _isOperator(String value) {
    return ['+', '-', '×', '÷', '%', '^'].contains(value);
  }
}

class HistoryNotifier extends StateNotifier<List<CalculationResult>> {
  HistoryNotifier() : super([]) {
    _loadHistory();
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('history') ?? [];
    // TODO: Parse and load history
  }

  void addResult(CalculationResult result) {
    state = [result, ...state.take(19)];
    _saveHistory();
  }

  void _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: Save history
  }
}

class MemoryNotifier extends StateNotifier<double?> {
  MemoryNotifier() : super(null) {
    _loadMemory();
  }

  void _loadMemory() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('memory');
  }

  void store(double value) {
    state = value;
    _saveMemory();
  }

  void recall() => state;

  void add(double value) {
    state = (state ?? 0) + value;
    _saveMemory();
  }

  void subtract(double value) {
    state = (state ?? 0) - value;
    _saveMemory();
  }

  void clear() {
    state = null;
    _saveMemory();
  }

  void _saveMemory() async {
    final prefs = await SharedPreferences.getInstance();
    if (state != null) {
      prefs.setDouble('memory', state!);
    } else {
      prefs.remove('memory');
    }
  }
}