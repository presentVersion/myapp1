import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onCompleted;
  final VoidCallback onSkipped; // New callback for skipping

  const HabitCard({
    super.key,
    required this.habit,
    required this.onCompleted,
    required this.onSkipped,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: isDarkMode ? const Color(0xFF424242) : const Color(0xFFE5E5E5), width: 4),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCompleted,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/Weights.svg', height: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'DINRoundPro', color: textColor)),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/streak.svg', height: 16),
                          const SizedBox(width: 4),
                          Text('${habit.streakCount}', style: TextStyle(fontSize: 14, fontFamily: 'DINRoundPro', color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onCompleted,
                  child: SvgPicture.asset(
                    habit.isCompletedOn(DateTime.now())
                        ? 'assets/images/checked.svg'
                        : 'assets/images/unchecked.svg',
                    height: 40,
                  ),
                ),
                const SizedBox(width: 8),
                // Dropdown menu for skipping
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'skip') {
                      onSkipped();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'skip',
                      child: Text('Skip for today'),
                    ),
                  ],
                  icon: Icon(Icons.more_vert, color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
