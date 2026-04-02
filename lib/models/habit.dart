import 'package:json_annotation/json_annotation.dart';

part 'habit.g.dart';

@JsonSerializable()
class Habit {
  String id;
  String name;
  List<DateTime> completedDates;
  List<DateTime> skippedDates;
  Map<String, bool> scheduledDays;

  Habit({
    required this.id,
    required this.name,
    this.completedDates = const [],
    this.skippedDates = const [],
    Map<String, bool>? scheduledDays,
  }) : this.scheduledDays = scheduledDays ??
            {'1': true, '2': true, '3': true, '4': true, '5': true, '6': true, '7': true};

  bool isCompletedOn(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return completedDates.any((d) => d.isAtSameMomentAs(dateOnly));
  }

  bool isCompletedToday() {
    return isCompletedOn(DateTime.now());
  }

  bool isSkippedOn(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return skippedDates.any((d) => d.isAtSameMomentAs(dateOnly));
  }

  void toggleCompleted() {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    if (isCompletedOn(todayDateOnly)) {
      completedDates.removeWhere((date) => date.isAtSameMomentAs(todayDateOnly));
    } else {
      completedDates.add(todayDateOnly);
      skippedDates.removeWhere((date) => date.isAtSameMomentAs(todayDateOnly));
    }
  }

  void skipToday() {
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    if (!isSkippedOn(todayDateOnly)) {
      skippedDates.add(todayDateOnly);
      completedDates.removeWhere((date) => date.isAtSameMomentAs(todayDateOnly));
    }
  }

  bool isScheduledFor(DateTime date) {
    return scheduledDays[date.weekday.toString()] ?? false;
  }

  bool isScheduledForToday() {
    return isScheduledFor(DateTime.now());
  }

  int get streakCount {
    if (completedDates.isEmpty) {
      return 0;
    }

    final completedSet =
        completedDates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    final skippedSet =
        skippedDates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
    
    int streak = 0;
    DateTime checkDate = DateTime.now();

    final todayDateOnly = DateTime(checkDate.year, checkDate.month, checkDate.day);
    if (!isScheduledFor(todayDateOnly) || (!completedSet.contains(todayDateOnly) && !skippedSet.contains(todayDateOnly))) {
        checkDate = checkDate.subtract(const Duration(days: 1));
    }
    
    while (true) {
      final dateOnly = DateTime(checkDate.year, checkDate.month, checkDate.day);
      
      if (isScheduledFor(dateOnly)) {
        if (completedSet.contains(dateOnly) || skippedSet.contains(dateOnly)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      } else {
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      if (streak > (completedSet.length + skippedSet.length) || DateTime.now().difference(checkDate).inDays > (365 * 2)) {
          break;
      }
    }
    return streak;
  }

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
