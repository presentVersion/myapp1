import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContinueButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ContinueButton({super.key, required this.onPressed});

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: SvgPicture.asset(
        _isPressed
            ? 'assets/images/Continuebuttonstateafterpressed.svg'
            : 'assets/images/Continuebuttonstatebeforepressed.svg',
      ),
    );
  }
}
