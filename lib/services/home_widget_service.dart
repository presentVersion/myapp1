import 'package:home_widget/home_widget.dart';

class HomeWidgetService {
  static const String appGroupId = 'group.com.example.habit_tracker';
  static const String iOSWidgetName = 'HabitTrackerWidget';
  static const String androidWidgetName = 'HabitTrackerWidgetProvider';

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<void> update(int streakCount) async {
    await HomeWidget.saveWidgetData<int>('streak_count', streakCount);
    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }
}
