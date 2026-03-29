import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const ThemedButton({super.key, required this.onPressed, required this.text});

  @override
  State<ThemedButton> createState() => _ThemedButtonState();
}

class _ThemedButtonState extends State<ThemedButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            _isPressed
                ? 'assets/images/Continuebuttonstateafterpressed.svg'
                : 'assets/images/Continuebuttonstatebeforepressed.svg',
          ),
          Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'DINRoundPro',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
