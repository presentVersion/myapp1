import 'package:flutter/material.dart';

class ThemedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const ThemedButton({super.key, required this.onPressed, required this.text});

  @override
  State<ThemedButton> createState() => _ThemedButtonState();
}

class _ThemedButtonState extends State<ThemedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double depth = 4.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        padding: EdgeInsets.only(top: _isPressed ? depth : 0),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF58CC02),
            borderRadius: BorderRadius.circular(16),
            border: Border(
              top: const BorderSide(color: Colors.transparent),
              left: const BorderSide(color: Colors.transparent),
              right: const BorderSide(color: Colors.transparent),
              bottom: BorderSide(
                color: _isPressed 
                    ? Colors.transparent 
                    : (isDarkMode ? const Color(0xFF327401) : const Color(0xFF439E02)),
                width: _isPressed ? 0 : depth,
              ),
            ),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontFamily: 'DINRoundPro',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

