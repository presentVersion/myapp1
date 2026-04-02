import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/screens/celebration_overlay.dart';
import 'package:habit_tracker/widgets/milestone_path.dart';

class MilestoneProvider with ChangeNotifier {
  int _masterStreak = 0;
  int _streakFreezes = 0;
  DateTime? _lastStreakUpdateDay;
  List<DateTime> _frozenDays = [];

  int get masterStreak => _masterStreak;
  int get streakFreezes => _streakFreezes;
  List<DateTime> get frozenDays => _frozenDays;

  MilestoneProvider() {
    loadStreakData();
    _startMidnightTimer();
  }

  Future<void> loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    _masterStreak = prefs.getInt('masterStreak') ?? 0;
    _streakFreezes = prefs.getInt('streakFreezes') ?? 0;
    final lastUpdatedString = prefs.getString('lastStreakUpdateDay');
    if (lastUpdatedString != null) {
      _lastStreakUpdateDay = DateTime.parse(lastUpdatedString);
    }
    final frozenDaysString = prefs.getStringList('frozenDays') ?? [];
    _frozenDays = frozenDaysString.map((day) => DateTime.parse(day)).toList();

    _midnightCheck();
    notifyListeners();
  }

  Future<void> _saveStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('masterStreak', _masterStreak);
    await prefs.setInt('streakFreezes', _streakFreezes);
    if (_lastStreakUpdateDay != null) {
      await prefs.setString(
        'lastStreakUpdateDay',
        _lastStreakUpdateDay!.toIso8601String(),
      );
    }
    await prefs.setStringList(
      'frozenDays',
      _frozenDays.map((day) => day.toIso8601String()).toList(),
    );
  }

  void _startMidnightTimer() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    Timer(durationUntilMidnight, () {
      _midnightCheck();
      Timer.periodic(const Duration(days: 1), (timer) {
        _midnightCheck();
      });
    });
  }

  Future<void> _midnightCheck() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (_lastStreakUpdateDay != null &&
        _lastStreakUpdateDay!.isAfter(yesterday)) {
      return; // Already handled
    }

    final prefs = await SharedPreferences.getInstance();
    final String? habitsString = prefs.getString('habits');
    if (habitsString == null) return;

    final List<dynamic> habitsJson = jsonDecode(habitsString);
    final habits = habitsJson.map((json) => Habit.fromJson(json)).toList();

    final habitsScheduledForYesterday = habits
        .where((h) => h.scheduledDays[yesterday.weekday.toString()] ?? false)
        .toList();

    if (habitsScheduledForYesterday.isEmpty) {
      _lastStreakUpdateDay = yesterday;
      _saveStreakData();
      notifyListeners();
      return;
    }

    final allCompletedYesterday = habitsScheduledForYesterday.every(
      (habit) =>
          habit.completedDates.any((d) => DateUtils.isSameDay(d, yesterday)),
    );

    if (!allCompletedYesterday) {
      if (_streakFreezes > 0) {
        _streakFreezes--;
        _frozenDays.add(yesterday);
        _lastStreakUpdateDay = yesterday;
      } else {
        _masterStreak = 0;
      }
    }

    _saveStreakData();
    notifyListeners();
  }

  void checkHabitCompletion(List<Habit> habits, BuildContext context) {
    final today = DateTime.now();
    final habitsScheduledForToday = habits
        .where((h) => h.isScheduledForToday())
        .toList();

    if (habitsScheduledForToday.isEmpty) return;

    final allCompletedToday = habitsScheduledForToday.every(
      (habit) => habit.isCompletedToday(),
    );

    if (!allCompletedToday) {
      return;
    }

    if (_lastStreakUpdateDay != null &&
        DateUtils.isSameDay(_lastStreakUpdateDay, today)) {
      return;
    }

    final yesterday = today.subtract(const Duration(days: 1));

    if (_lastStreakUpdateDay != null &&
        (DateUtils.isSameDay(_lastStreakUpdateDay, yesterday) ||
            _frozenDays.any((d) => DateUtils.isSameDay(d, yesterday)))) {
      _masterStreak++;
    } else {
      _masterStreak = 1;
    }

    _lastStreakUpdateDay = today;
    _saveStreakData();
    notifyListeners();

    final nextMilestone = getNextMilestone();
    if (nextMilestone != null && _masterStreak >= nextMilestone.streakGoal) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              CelebrationOverlay(milestone: nextMilestone),
        ),
      );
    } else if (allCompletedToday) {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => CelebrationOverlay(
            milestone: Milestone(streakGoal: 0, iconAsset: ''),
          ),
        ),
      );
    }
  }

  void addStreakFreeze() {
    _streakFreezes++;
    _saveStreakData();
    notifyListeners();
  }

  Milestone? getNextMilestone() {
    final milestones = [
      Milestone(streakGoal: 10, iconAsset: 'assets/images/streakchamp.svg'),
      Milestone(streakGoal: 30, iconAsset: 'assets/images/streakchamp.svg'),
      Milestone(streakGoal: 50, iconAsset: 'assets/images/streakchamp.svg'),
      Milestone(streakGoal: 100, iconAsset: 'assets/images/streakchamp.svg'),
    ];

    for (var milestone in milestones) {
      if (_masterStreak < milestone.streakGoal) {
        return milestone;
      }
    }
    return null;
  }
}
