import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DuolingoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int streakCount;
  final int gemCount;
  final int heartCount;
  final VoidCallback onStreakTap;

  const DuolingoAppBar({
    super.key,
    required this.streakCount,
    required this.gemCount,
    required this.heartCount,
    required this.onStreakTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set a background color for the AppBar container
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Streak Counter
              GestureDetector(
                onTap: onStreakTap,
                child: _buildPillStat(
                  'assets/images/streak.svg',
                  streakCount.toString(),
                  const Color(0xFFFF9600), // Streak Orange
                ),
              ),
              const SizedBox(width: 8),
              // Gem Counter
              _buildPillStat(
                'assets/images/lightning.svg', 
                gemCount.toString(),
                const Color(0xFF1CB0F6), // Gem Blue
              ),
              const SizedBox(width: 8),
              // Heart/Freeze Counter
              _buildPillStat(
                'assets/images/freezed.svg', // Using freezed.svg as per blueprint
                heartCount.toString(),
                Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillStat(String assetName, String count, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // As per the blueprint: Border.all(color: Color(0xFFE5E5E5), width: 2)
        border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
        // As per the blueprint: borderRadius: 12
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(assetName, height: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            count,
            style: const TextStyle(
              fontFamily: 'DINRoundPro', // Using a more standard font for clarity
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
