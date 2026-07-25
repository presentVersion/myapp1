import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_widget/home_widget.dart';
import 'package:habit_tracker/models/habit.dart';

class HabitWidgetProvider {
  static const String appGroupId = 'YOUR_APP_GROUP_ID';

  static Future<void> sendData(
    Habit habit,
  ) async {
    // Render the custom widget layout to an image file
    final widget = HabitWidgetView(habit: habit);

    try {
      await HomeWidget.renderFlutterWidget(
        widget,
        key: 'widget_image',
        size: const Size(320, 160),
      );

      // Save additional key-value properties
      await HomeWidget.saveWidgetData<String>('habit_name', habit.name);
      await HomeWidget.saveWidgetData<int>('streak_count', habit.streakCount);
      await HomeWidget.saveWidgetData<bool>('is_completed', habit.isCompletedToday());

      await HomeWidget.updateWidget(
        name: 'HabitTrackerWidgetProvider',
        iOSName: 'HabitTrackerWidgetProvider',
      );
    } catch (e) {
      // Ignored during testing or environment mismatches
    }
  }

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }
}

class HabitWidgetView extends StatelessWidget {
  final Habit habit;

  const HabitWidgetView({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedToday();
    final dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now();

    // Select background SVG based on completed status
    final String backgroundAsset = isCompleted 
        ? 'assets/widget_backgrounds/wb1.svg' 
        : 'assets/widget_backgrounds/wb5.svg';

    // Select mascot owl based on completion status
    final String mascotAsset = isCompleted 
        ? 'assets/images/homepage.svg' 
        : 'assets/images/readbook.svg';

    final String statusText = isCompleted 
        ? 'Way to go!' 
        : 'Time to practice!';

    return Container(
      width: 320,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background graphic
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SvgPicture.asset(
                backgroundAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main layout content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Streak Count + Flame
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/streak.svg',
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${habit.streakCount} day streak',
                            style: const TextStyle(
                              fontFamily: 'DINRoundPro',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFFFF9600),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusText,
                        style: const TextStyle(
                          fontFamily: 'DINRoundPro',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF777777),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Weekly Circles matching references
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          final monday = today.subtract(Duration(days: today.weekday - 1));
                          final checkDay = DateTime(monday.year, monday.month, monday.day + index);
                          final dayCompleted = habit.isCompletedOn(checkDay);
                          final dayScheduled = habit.isScheduledFor(checkDay);
                          
                          Color dotColor = const Color(0xFFE5E5E5);
                          Color borderColor = const Color(0xFFD5D5D5);
                          if (dayCompleted) {
                            dotColor = const Color(0xFF58CC02);
                            borderColor = const Color(0xFF439E02);
                          } else if (!dayScheduled) {
                            dotColor = Colors.transparent;
                            borderColor = Colors.transparent;
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dayNames[index],
                                style: const TextStyle(
                                  fontFamily: 'DINRoundPro',
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B4B4B),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: dayCompleted
                                    ? const Icon(
                                        Icons.check,
                                        size: 8,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Mascot owl
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      mascotAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

