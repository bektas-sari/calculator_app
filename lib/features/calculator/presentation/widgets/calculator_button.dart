import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOperator;

  const CalculatorButton({
    required this.label,
    required this.onPressed,
    this.isOperator = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        Future.delayed(const Duration(milliseconds: 80), () {
          if (mounted) setState(() => _isPressed = false);
        });
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: widget.isOperator ? const Color(0xFF2F6BFF) : const Color(0xFF1A1F27),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: widget.isOperator ? Colors.white : const Color(0xFF9AA4B2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
