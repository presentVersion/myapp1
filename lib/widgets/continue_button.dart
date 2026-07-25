import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

class ContinueButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ContinueButton({super.key, required this.onPressed});

  @override
  State<ContinueButton> createState() => ContinueButtonState();
}

class ContinueButtonState extends State<ContinueButton> {
  final player = AudioPlayer();
  bool _isPressed = false;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) async {
        setState(() => _isPressed = false);
        try {
          await player.setAsset('assets/audio/Continue.mp3');
          player.play();
        } catch (e) {
          // Fallback if audio fails to load
        }
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        child: SvgPicture.asset(
          _isPressed
              ? 'assets/images/Continuebuttonstateafterpressed.svg'
              : 'assets/images/Continuebuttonstatebeforepressed.svg',
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

