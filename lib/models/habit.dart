import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

@JsonSerializable()
class Habit {
  final String id;
  String name;
  int streakCount;
  List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    this.streakCount = 0,
    List<DateTime>? completedDates,
  }) : completedDates = completedDates ?? [];

  bool isCompletedToday() {
    final now = DateTime.now();
    return completedDates.any((date) => DateUtils.isSameDay(date, now));
  }

  void toggleCompleted() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isCompletedToday()) {
      // Already completed today, do nothing
    } else {
      completedDates.add(today);
    }
    updateStreak();
  }

  void updateStreak() {
    if (completedDates.isEmpty) {
      streakCount = 0;
      return;
    }

    final uniqueDates = completedDates.map((d) => DateUtils.dateOnly(d)).toSet().toList();
    uniqueDates.sort((a, b) => b.compareTo(a));

    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    int streak = 0;
    int startIndex = -1;

    if (uniqueDates.first.isAtSameMomentAs(today)) {
        startIndex = 0;
    } else if (uniqueDates.first.isAtSameMomentAs(yesterday)) {
        startIndex = 0;
    } else {
        streakCount = isCompletedToday() ? 1 : 0;
        return;
    }

    if(startIndex != -1){
        streak = 1;
        for (int i = startIndex; i < uniqueDates.length - 1; i++) {
            DateTime expectedPreviousDay = uniqueDates[i].subtract(const Duration(days: 1));
            if (uniqueDates[i + 1].isAtSameMomentAs(expectedPreviousDay)) {
                streak++;
            } else {
                break;
            }
        }
    }
    streakCount = streak;
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
