import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HabitWidgetProvider {
  static const String appGroupId = 'YOUR_APP_GROUP_ID';

  static Future<void> sendData(String habitName, int streakCount, bool isCompleted) async {
    await HomeWidget.saveWidgetData<String>('habit_name', habitName);
    await HomeWidget.saveWidgetData<int>('streak_count', streakCount);
    await HomeWidget.saveWidgetData<bool>('is_completed', isCompleted);
    await HomeWidget.updateWidget(
        name: 'HabitWidgetProvider', iOSName: 'HabitWidgetProvider');
  }

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  static Widget build(String habitName, int streakCount, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/widget_backgrounds/wb1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Text(
            habitName,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          Text(
            '$streakCount',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
