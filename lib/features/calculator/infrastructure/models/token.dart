enum TokenType {
  number,
  operator,
  function,
  constant,
  leftParen,
  rightParen,
  factorial,
  unaryMinus,
  unaryPlus,
}

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);

  @override
  String toString() => 'Token($type, $value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Token &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              value == other.value;

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}
