import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/habit.dart';
import 'widgets/habit_widget_provider.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  HabitProvider() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsString = prefs.getString('habits');
    if (habitsString != null) {
      try {
        final List<dynamic> json = jsonDecode(habitsString);
        _habits = json.map((h) => Habit.fromJson(h)).toList();
      } catch (e) {
        _habits = [];
      }
    } else {
      _habits = [];
    }
    updateHomeWidget();
    notifyListeners();
  }

  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsString = jsonEncode(_habits.map((h) => h.toJson()).toList());
    await prefs.setString('habits', habitsString);
    updateHomeWidget();
  }

  void updateHomeWidget() {
    if (_habits.isNotEmpty) {
      HabitWidgetProvider.sendData(_habits.first);
    }
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    saveHabits();
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    saveHabits();
    notifyListeners();
  }

  void toggleHabitCompletion(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].toggleCompleted();
      saveHabits();
      notifyListeners();
    }
  }

  void skipHabitToday(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].skipToday();
      saveHabits();
      notifyListeners();
    }
  }
}
