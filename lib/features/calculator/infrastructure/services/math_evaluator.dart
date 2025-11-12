import 'dart:math' as math;
import '../models/token.dart';
import 'tokenizer.dart';

class MathEvaluator {
  static const double epsilon = 1e-12;

  static double evaluate(
      String expression, {
        bool useRadians = false,
        double? memoryValue,
      }) {
    final tokens = Tokenizer.tokenize(expression, useRadians: useRadians);
    if (tokens.isEmpty) throw Exception('Empty expression');

    final rpn = _shuntingYard(tokens, useRadians);
    return _evaluateRPN(rpn, useRadians);
  }

  static List<Token> _shuntingYard(List<Token> tokens, bool useRadians) {
    final output = <Token>[];
    final operatorStack = <Token>[];

    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];

      if (token.type == TokenType.number) {
        output.add(token);
      } else if (token.type == TokenType.constant) {
        output.add(token);
      } else if (token.type == TokenType.function) {
        operatorStack.add(token);
      } else if (token.type == TokenType.leftParen) {
        operatorStack.add(token);
      } else if (token.type == TokenType.rightParen) {
        while (operatorStack.isNotEmpty && operatorStack.last.type != TokenType.leftParen) {
          output.add(operatorStack.removeLast());
        }
        if (operatorStack.isNotEmpty) operatorStack.removeLast();
        if (operatorStack.isNotEmpty && operatorStack.last.type == TokenType.function) {
          output.add(operatorStack.removeLast());
        }
      } else if (token.type == TokenType.operator || token.type == TokenType.factorial) {
        while (operatorStack.isNotEmpty &&
            _shouldPopOperator(token, operatorStack.last, useRadians)) {
          output.add(operatorStack.removeLast());
        }
        operatorStack.add(token);
      } else if (token.type == TokenType.unaryMinus || token.type == TokenType.unaryPlus) {
        operatorStack.add(token);
      }
    }

    while (operatorStack.isNotEmpty) {
      output.add(operatorStack.removeLast());
    }

    return output;
  }

  static bool _shouldPopOperator(Token current, Token last, bool useRadians) {
    if (last.type == TokenType.leftParen) return false;
    if (last.type == TokenType.function) return current.type != TokenType.leftParen;

    final currentPrecedence = _precedence(current.value);
    final lastPrecedence = _precedence(last.value);

    if (currentPrecedence != lastPrecedence) {
      return lastPrecedence > currentPrecedence;
    }

    return current.value != '^';
  }

  static int _precedence(String op) {
    if (op == '!') return 3;
    if (op == '^') return 2;
    if (op == '×' || op == '÷' || op == '%') return 1;
    if (op == '+' || op == '-') return 0;
    return -1;
  }

  static double _evaluateRPN(List<Token> rpn, bool useRadians) {
    final stack = <double>[];

    for (final token in rpn) {
      if (token.type == TokenType.number) {
        stack.add(double.parse(token.value));
      } else if (token.type == TokenType.constant) {
        if (token.value == 'π') {
          stack.add(math.pi);
        } else if (token.value == 'e') {
          stack.add(math.e);
        }
      } else if (token.type == TokenType.function) {
        final arg = stack.removeLast();
        stack.add(_evaluateFunction(token.value, arg, useRadians));
      } else if (token.type == TokenType.operator) {
        final b = stack.removeLast();
        final a = stack.removeLast();
        stack.add(_evaluateOperator(token.value, a, b));
      } else if (token.type == TokenType.factorial) {
        final n = stack.removeLast();
        stack.add(_factorial(n));
      } else if (token.type == TokenType.unaryMinus) {
        stack.last = -stack.last;
      } else if (token.type == TokenType.unaryPlus) {
        // No-op
      }
    }

    if (stack.length != 1) throw Exception('Invalid expression');
    return stack.first;
  }

  static double _evaluateFunction(String func, double arg, bool useRadians) {
    final radArg = useRadians ? arg : arg * math.pi / 180;

    switch (func) {
      case 'sin':
        return _roundToEpsilon(math.sin(radArg));
      case 'cos':
        return _roundToEpsilon(math.cos(radArg));
      case 'tan':
        if ((arg % 180 - 90).abs() < epsilon) throw Exception('Domain error: tan(90°)');
        return _roundToEpsilon(math.tan(radArg));
      case 'asin':
        if (arg < -1 || arg > 1) throw Exception('Domain error: asin($arg)');
        final result = math.asin(arg);
        return useRadians ? result : result * 180 / math.pi;
      case 'acos':
        if (arg < -1 || arg > 1) throw Exception('Domain error: acos($arg)');
        final result = math.acos(arg);
        return useRadians ? result : result * 180 / math.pi;
      case 'atan':
        final result = math.atan(arg);
        return useRadians ? result : result * 180 / math.pi;
      case 'ln':
        if (arg <= 0) throw Exception('Domain error: ln($arg)');
        return math.log(arg);
      case 'log':
        if (arg <= 0) throw Exception('Domain error: log($arg)');
        return math.log(arg) / math.ln10;
      case 'sqrt':
        if (arg < 0) throw Exception('Domain error: sqrt($arg)');
        return math.sqrt(arg);
      case 'cbrt':
        return arg < 0 ? -math.pow(arg.abs(), 1 / 3).toDouble() : math.pow(arg, 1 / 3).toDouble();
      case 'abs':
        return arg.abs();
      case 'exp':
        return math.exp(arg);
      default:
        throw Exception('Unknown function: $func');
    }
  }

  static double _evaluateOperator(String op, double a, double b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b.abs() < epsilon) throw Exception('Divide by zero');
        return a / b;
      case '%':
        return a % b;
      case '^':
        return math.pow(a, b).toDouble();
      default:
        throw Exception('Unknown operator: $op');
    }
  }

  static double _factorial(double n) {
    if (n < 0 || n != n.toInt()) throw Exception('Factorial domain error');
    final ni = n.toInt();
    if (ni > 170) throw Exception('Overflow');
    if (ni == 0 || ni == 1) return 1;
    double result = 1;
    for (int i = 2; i <= ni; i++) {
      result *= i;
    }
    return result;
  }

  static double _roundToEpsilon(double value) {
    if (value.abs() < epsilon) return 0;
    return value;
  }
}
