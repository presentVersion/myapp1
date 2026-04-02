import 'package:flutter/material.dart';

class ThemedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ThemedButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF58CC02),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
        ),
        shadowColor: const Color(0xFF439E02),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'DuolingoFeather',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
