import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/models/habit.dart';

class WeeklyProgressView extends StatelessWidget {
  final Habit habit;

  const WeeklyProgressView({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekDays = List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));
    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekDays.map((day) {
        final dayName = dayNames[day.weekday - 1];
        final isCompleted = habit.completedDates.any((completedDate) => DateUtils.isSameDay(completedDate, day));
        const isFrozen = false; // Replace with your logic for frozen days

        String assetName;
        if (isCompleted) {
          assetName = 'assets/images/${dayName}checked.svg';
        } else if (isFrozen) {
          assetName = 'assets/images/${dayName}freezed.svg';
        } else {
          assetName = 'assets/images/${dayName}unchecked.svg';
        }

        return SvgPicture.asset(assetName, height: 40);
      }).toList(),
    );
  }
}
