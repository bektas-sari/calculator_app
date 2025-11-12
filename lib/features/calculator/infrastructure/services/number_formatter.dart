import 'package:intl/intl.dart';
import 'dart:math' as math;

class NumberFormatter {
  static String format(
      double value, {
        bool useScientificNotation = false,
        int maxFractionalDigits = 10,
        String locale = 'en_US',
      }) {
    if (value.isNaN) return 'Error';
    if (value.isInfinite) return value > 0 ? 'Infinity' : '-Infinity';

    final absValue = value.abs();

    // Check for scientific notation thresholds
    if (!useScientificNotation &&
        (absValue >= 1e10 || (absValue < 1e-6 && absValue != 0))) {
      return _formatScientific(value);
    }

    if (useScientificNotation) {
      return _formatScientific(value);
    }

    return _formatRegular(value, maxFractionalDigits, locale);
  }

  static String _formatRegular(
      double value,
      int maxFractionalDigits,
      String locale,
      ) {
    // Format with grouping
    final formatter = NumberFormat.decimalPattern(locale);
    String formatted = formatter.format(value);

    // Trim trailing zeros after decimal
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }

    return formatted;
  }

  static String _formatScientific(double value) {
    if (value == 0) return '0';

    final absValue = value.abs();
    final exponent = (math.log(absValue) / math.log(10)).floor();
    final mantissa = value / math.pow(10, exponent);

    return '${mantissa.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}E${exponent >= 0 ? '+' : ''}$exponent';
  }
}

// ignore: unused_import

