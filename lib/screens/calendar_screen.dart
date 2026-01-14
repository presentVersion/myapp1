import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/models/habit.dart';

class CalendarScreen extends StatelessWidget {
  final List<Habit> habits;

  const CalendarScreen({super.key, required this.habits});

  Set<DateTime> getCompletedDays() {
    final Set<DateTime> completedDays = {};
    for (final habit in habits) {
      for (final date in habit.completedDates) {
        completedDays.add(DateTime.utc(date.year, date.month, date.day));
      }
    }
    return completedDays;
  }

  @override
  Widget build(BuildContext context) {
    final completedDays = getCompletedDays();

    return Scaffold(
      appBar: AppBar(title: const Text('Streak Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orange.withAlpha(128),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            // Style for days with completed habits
            markerDecoration: const BoxDecoration(
              color: Colors.green, // You can customize this
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: (day) {
            if (completedDays.contains(
              DateTime.utc(day.year, day.month, day.day),
            )) {
              return [
                'Completed',
              ]; // Return a list with an event to show a marker
            }
            return [];
          },
          // This builder is what customizes the calendar days
          calendarBuilders: CalendarBuilders(
            // Custom builder for days with events
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(
                        255,
                        30,
                        209,
                        169,
                      ), // Teal-like color from the image
                    ),
                    width: 10.0,
                    height: 10.0,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
