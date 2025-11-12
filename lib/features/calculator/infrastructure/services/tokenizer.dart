import '../models/token.dart';

class Tokenizer {
  static List<Token> tokenize(String expression, {bool useRadians = false}) {
    final tokens = <Token>[];
    int i = 0;
    bool expectOperand = true;

    while (i < expression.length) {
      final char = expression[i];

      // Skip whitespace
      if (char == ' ') {
        i++;
        continue;
      }

      // Numbers
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57 || char == '.') {
        final start = i;
        while (i < expression.length &&
            (expression[i].codeUnitAt(0) >= 48 && expression[i].codeUnitAt(0) <= 57 ||
                expression[i] == '.')) {
          i++;
        }
        // Handle scientific notation
        if (i < expression.length && (expression[i] == 'E' || expression[i] == 'e')) {
          i++;
          if (i < expression.length && (expression[i] == '+' || expression[i] == '-')) {
            i++;
          }
          while (i < expression.length &&
              (expression[i].codeUnitAt(0) >= 48 && expression[i].codeUnitAt(0) <= 57)) {
            i++;
          }
        }
        tokens.add(Token(TokenType.number, expression.substring(start, i)));
        expectOperand = false;
        continue;
      }

      // Operators
      if (char == '+' && !expectOperand) {
        tokens.add(Token(TokenType.operator, '+'));
        expectOperand = true;
        i++;
        continue;
      }
      if (char == '-' && !expectOperand) {
        tokens.add(Token(TokenType.operator, '-'));
        expectOperand = true;
        i++;
        continue;
      }
      if (char == '-' && expectOperand) {
        tokens.add(Token(TokenType.unaryMinus, '-'));
        i++;
        continue;
      }
      if (char == '+' && expectOperand) {
        tokens.add(Token(TokenType.unaryPlus, '+'));
        i++;
        continue;
      }
      if (char == '×' || char == '*') {
        tokens.add(Token(TokenType.operator, '×'));
        expectOperand = true;
        i++;
        continue;
      }
      if (char == '÷' || char == '/') {
        tokens.add(Token(TokenType.operator, '÷'));
        expectOperand = true;
        i++;
        continue;
      }
      if (char == '%') {
        tokens.add(Token(TokenType.operator, '%'));
        expectOperand = true;
        i++;
        continue;
      }
      if (char == '^') {
        tokens.add(Token(TokenType.operator, '^'));
        expectOperand = true;
        i++;
        continue;
      }

      // Parentheses
      if (char == '(') {
        tokens.add(Token(TokenType.leftParen, '('));
        expectOperand = true;
        i++;
        continue;
      }
      if (char == ')') {
        tokens.add(Token(TokenType.rightParen, ')'));
        expectOperand = false;
        i++;
        continue;
      }

      // Factorial
      if (char == '!') {
        tokens.add(Token(TokenType.factorial, '!'));
        expectOperand = true;
        i++;
        continue;
      }

      // Functions and constants
      if (char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) {
        final start = i;
        while (i < expression.length &&
            (expression[i].codeUnitAt(0) >= 97 && expression[i].codeUnitAt(0) <= 122)) {
          i++;
        }
        final word = expression.substring(start, i);

        if (_isFunctionOrConstant(word)) {
          if (word == 'π' || word == 'e') {
            tokens.add(Token(TokenType.constant, word));
            expectOperand = false;
          } else {
            tokens.add(Token(TokenType.function, word));
            expectOperand = true;
          }
          continue;
        }
      }

      // Greek letters and special constants
      if (char == 'π') {
        tokens.add(Token(TokenType.constant, 'π'));
        expectOperand = false;
        i++;
        continue;
      }
      if (char == 'e' && (i + 1 >= expression.length || !_isAlphaNum(expression[i + 1]))) {
        tokens.add(Token(TokenType.constant, 'e'));
        expectOperand = false;
        i++;
        continue;
      }

      i++;
    }

    // Extra validation: detect invalid patterns like number followed by number
    for (int j = 1; j < tokens.length; j++) {
      final prev = tokens[j - 1];
      final curr = tokens[j];

      if (prev.type == TokenType.number && curr.type == TokenType.number) {
        throw Exception('Invalid expression: missing operator between numbers');
      }

      if (prev.type == TokenType.constant && curr.type == TokenType.number) {
        throw Exception('Invalid expression: missing operator after constant');
      }

      if (prev.type == TokenType.number && curr.type == TokenType.constant) {
        throw Exception('Invalid expression: missing operator before constant');
      }
    }

    return tokens;
  }

  static bool _isFunctionOrConstant(String word) {
    return ['sin', 'cos', 'tan', 'asin', 'acos', 'atan', 'ln', 'log', 'sqrt', 'cbrt', 'abs', 'exp']
        .contains(word);
  }

  static bool _isAlphaNum(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122) || (code >= 48 && code <= 57);
  }
}