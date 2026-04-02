import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreakCard extends StatelessWidget {
  final String title;
  final int streak;
  final String imagePath;

  const StreakCard({
    super.key,
    required this.title,
    required this.streak,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'DuolingoFeather',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '$streak',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    fontFamily: 'DINRoundPro',
                  ),
                ),
                const Text(
                  'Day Streak',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'DINRoundPro',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
