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

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await player.setAsset('assets/audio/Continue.mp3');
        player.play();
        widget.onPressed();
      },
      child: SvgPicture.asset('assets/images/Continue.svg', height: 50),
    );
  }
}
