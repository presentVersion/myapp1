import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/models/habit.dart';

class HabitListItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onComplete;

  const HabitListItem({
    super.key,
    required this.habit,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onComplete,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/widgetbackground1.svg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(_getHabitIcon(habit.name), height: 40),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DINRoundPro',
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${habit.streakCount} day streak',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'DINRoundPro',
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    habit.isCompletedToday()
                        ? 'assets/images/checked.svg'
                        : 'assets/images/unchecked.svg',
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHabitIcon(String habitName) {
    if (habitName.toLowerCase().contains('gym') ||
        habitName.toLowerCase().contains('weights')) {
      return 'assets/images/weights.svg';
    }
    if (habitName.toLowerCase().contains('read') ||
        habitName.toLowerCase().contains('book')) {
      return 'assets/images/readbook.svg';
    }
    return 'assets/images/target.svg';
  }
}
