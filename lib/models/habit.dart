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
      completedDates.removeWhere((date) => DateUtils.isSameDay(date, today));
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

    final uniqueDates = completedDates
        .map((d) => DateUtils.dateOnly(d))
        .toSet()
        .toList();
    uniqueDates.sort((a, b) => b.compareTo(a));

    final today = DateUtils.dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    int streak = 0;
    int startIndex = -1;

    // A streak is "current" if it includes today or yesterday.
    if (uniqueDates.first.isAtSameMomentAs(today)) {
      startIndex = 0; // Streak includes today
    } else if (uniqueDates.first.isAtSameMomentAs(yesterday)) {
      startIndex = 0; // Streak ended yesterday
    } else {
      // Streak is broken. If completed today, it's a new streak of 1. Otherwise 0.
      streakCount = isCompletedToday() ? 1 : 0;
      return;
    }

    if (startIndex != -1) {
      streak = 1;
      for (int i = startIndex; i < uniqueDates.length - 1; i++) {
        DateTime expectedPreviousDay = uniqueDates[i].subtract(
          const Duration(days: 1),
        );
        if (uniqueDates[i + 1].isAtSameMomentAs(expectedPreviousDay)) {
          streak++;
        } else {
          break; // The streak is broken
        }
      }
    }
    streakCount = streak;
  }
  
  int get longestStreak {
    if (completedDates.isEmpty) {
      return 0;
    }

    final uniqueDates =
        completedDates.map((d) => DateUtils.dateOnly(d)).toSet().toList();
    uniqueDates.sort((a, b) => a.compareTo(b)); // Sort ascending

    if (uniqueDates.isEmpty) {
      return 0;
    }

    int longest = 1;
    int current = 1;

    for (int i = 1; i < uniqueDates.length; i++) {
      if (uniqueDates[i].difference(uniqueDates[i - 1]).inDays == 1) {
        current++;
      } else {
        current = 1; // Reset for a new potential streak
      }
      if (current > longest) {
        longest = current;
      }
    }
    return longest;
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
