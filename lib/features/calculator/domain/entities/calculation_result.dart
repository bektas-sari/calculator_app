class CalculationResult {
  final String expression;
  final String result;
  final String? error;
  final DateTime timestamp;

  CalculationResult({
    required this.expression,
    required this.result,
    this.error,
    required this.timestamp,
  });

  bool get hasError => error != null;

  CalculationResult copyWith({
    String? expression,
    String? result,
    String? error,
    DateTime? timestamp,
  }) {
    return CalculationResult(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      error: error ?? this.error,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
