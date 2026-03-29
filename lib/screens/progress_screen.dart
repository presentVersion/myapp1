import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/widgets/badge_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ProgressScreen extends StatefulWidget {
  final List<Habit> habits;

  const ProgressScreen({super.key, required this.habits});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Badge> _badges = [
    Badge(title: 'Perfect Week', iconAsset: 'assets/images/perfect_week.svg'),
    Badge(title: '10 Day Streak', iconAsset: 'assets/images/10_day_streak.svg'),
    Badge(title: 'Perfect Month', iconAsset: 'assets/images/perfect_month.svg'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final isCompleted = widget.habits.any((habit) => habit.completedDates.any((completedDate) => isSameDay(completedDate, date)));
                if (isCompleted) {
                  return Positioned(
                    bottom: 1,
                    child: _buildEventMarker(date, Colors.green),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildBadgesSection(),
        ],
      ),
    );
  }

  Widget _buildEventMarker(DateTime date, Color color) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Badges',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _badges.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: BadgeWidget(badge: _badges[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
