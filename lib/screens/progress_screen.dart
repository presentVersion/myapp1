import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/habit_provider.dart';
import 'package:habit_tracker/milestone_provider.dart';

enum ProgressView {
  perfectDays,
  specificHabit,
}

enum DayStatus {
  perfect,
  freezed,
  missed,
  rest,
  unchecked,
}

class ProgressScreen extends StatefulWidget {
  final List<Habit> habits;
  const ProgressScreen({super.key, this.habits = const []});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  ProgressView _currentView = ProgressView.perfectDays;
  Habit? _selectedHabitForView;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final habitProvider = Provider.of<HabitProvider>(context);

    // Default target habit if not initialized
    if (_selectedHabitForView == null && habitProvider.habits.isNotEmpty) {
      _selectedHabitForView = habitProvider.habits.first;
    }

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text(
          'Progress Hub',
          style: TextStyle(fontFamily: 'DINRoundPro', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
            height: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            _buildViewToggle(),
            const SizedBox(height: 32),
            if (_currentView == ProgressView.perfectDays)
              _buildPerfectDaysView(),
            if (_currentView == ProgressView.specificHabit)
              _buildSpecificHabitView(),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton('Perfect Days', ProgressView.perfectDays),
        const SizedBox(width: 16),
        _buildToggleButton('Specific Habit', ProgressView.specificHabit),
      ],
    );
  }

  Widget _buildToggleButton(String text, ProgressView view) {
    final isSelected = _currentView == view;
    return GestureDetector(
      onTap: () => setState(() => _currentView = view),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Use SVG with opacity for selected/unselected overlay effect
          Opacity(
            opacity: isSelected ? 1.0 : 0.6,
            child: SvgPicture.asset(
              isSelected
                  ? 'assets/images/Continuebuttonstatebeforepressed.svg'
                  : 'assets/images/Continuebuttonstateafterpressed.svg',
              height: 48,
              width: 155,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: isSelected ? 14 : 10,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'DINRoundPro',
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerfectDaysView() {
    final habitProvider = Provider.of<HabitProvider>(context);
    final milestoneProvider = Provider.of<MilestoneProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('DUOLINGO CALENDAR'),
        const SizedBox(height: 12),
        _buildCalendarGrid(habitProvider.habits, milestoneProvider),
        const SizedBox(height: 40),
        _buildMilestonePath(milestoneProvider.masterStreak),
        const SizedBox(height: 40),
        _buildTrophyCase(milestoneProvider.masterStreak),
      ],
    );
  }

  Widget _buildSpecificHabitView() {
    final habitProvider = Provider.of<HabitProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (habitProvider.habits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Create a habit first to see individual progress!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'DINRoundPro',
              color: isDarkMode ? Colors.grey[400] : const Color(0xFF777777),
            ),
          ),
        ),
      );
    }

    final selectedHabit = _selectedHabitForView ?? habitProvider.habits.first;

    // We can show calendar just for this habit
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('SELECT HABIT'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
              width: 2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Habit>(
              value: selectedHabit,
              isExpanded: true,
              dropdownColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              style: TextStyle(
                fontFamily: 'DINRoundPro',
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              items: habitProvider.habits.map((habit) {
                return DropdownMenuItem<Habit>(
                  value: habit,
                  child: Text(habit.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedHabitForView = value;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('HABIT HISTORY'),
        const SizedBox(height: 12),
        _buildHabitCalendarGrid(selectedHabit),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Longest Streak', '${selectedHabit.streakCount} days', const Color(0xFFFF9600)),
                _buildStatItem('Total Complets', '${selectedHabit.completedDates.length}', const Color(0xFF58CC02)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'DuolingoFeather',
        color: isDarkMode ? Colors.white70 : const Color(0xFF4B4B4B),
        letterSpacing: 1.2,
      ),
    );
  }

  List<DateTime> _getCurrentWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => DateTime(monday.year, monday.month, monday.day + i));
  }

  DayStatus _getDayStatus(DateTime date, List<Habit> habits, MilestoneProvider milestoneProvider) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAfter(todayDate)) {
      return DayStatus.unchecked;
    }

    final scheduled = habits.where((h) => h.isScheduledFor(checkDate)).toList();
    if (scheduled.isEmpty) {
      return DayStatus.rest;
    }

    final allCompleted = scheduled.every((h) => h.isCompletedOn(checkDate));
    if (allCompleted) {
      return DayStatus.perfect;
    }

    final wasFrozen = milestoneProvider.frozenDays.any((d) => DateUtils.isSameDay(d, checkDate)) ||
        scheduled.every((h) => h.isSkippedOn(checkDate));
    if (wasFrozen) {
      return DayStatus.freezed;
    }

    return DayStatus.missed;
  }

  Widget _buildCalendarGrid(List<Habit> habits, MilestoneProvider milestoneProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final weekDays = _getCurrentWeekDays();
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    // Map each day to status
    final List<DayStatus> statuses = weekDays.map((date) => _getDayStatus(date, habits, milestoneProvider)).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(7, (index) {
              final date = weekDays[index];
              final dayName = dayNames[index];
              final status = statuses[index];

              // Determine Asset Name
              String assetName = 'assets/images/${dayName}unchecked.svg';
              if (status == DayStatus.perfect) {
                assetName = 'assets/images/${dayName}checked.svg';
              } else if (status == DayStatus.freezed) {
                assetName = 'assets/images/${dayName}freezed.svg';
              }

              final isToday = DateUtils.isSameDay(date, DateTime.now());

              return Expanded(
                child: Column(
                  children: [
                    Text(
                      dayName.substring(0, 3).toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'DINRoundPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isToday
                            ? const Color(0xFF58CC02)
                            : (isDarkMode ? Colors.grey[400] : const Color(0xFF777777)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: isToday
                          ? BoxDecoration(
                              border: Border.all(color: const Color(0xFF58CC02), width: 2),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: SvgPicture.asset(
                        assetName,
                        width: 36,
                        height: 36,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          // Connection check row (Bridges)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(6, (index) {
              final leftPerfect = statuses[index] == DayStatus.perfect;
              final rightPerfect = statuses[index + 1] == DayStatus.perfect;
              final bothPerfect = leftPerfect && rightPerfect;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  decoration: BoxDecoration(
                    color: bothPerfect ? const Color(0xFFFF9600) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          if (statuses.contains(DayStatus.perfect)) ...[
            const SizedBox(height: 12),
            Text(
              "Gold bridges connect your Perfect Days!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DINRoundPro',
                fontSize: 13,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF777777),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHabitCalendarGrid(Habit habit) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final weekDays = _getCurrentWeekDays();
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final date = weekDays[index];
          final dayLabel = dayNames[index].substring(0, 3).toUpperCase();
          final isCompleted = habit.isCompletedOn(date);
          final isScheduled = habit.isScheduledFor(date);

          return Column(
            children: [
              Text(
                dayLabel,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              if (!isScheduled)
                Icon(Icons.remove, color: Colors.grey[400])
              else if (isCompleted)
                SvgPicture.asset('assets/images/checked.svg', width: 32, height: 32)
              else
                SvgPicture.asset('assets/images/unchecked.svg', width: 32, height: 32),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMilestonePath(int currentStreak) {
    final milestones = [10, 30, 50, 100];
    final double pathHeight = 400.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('MILESTONE PATH'),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final offsets = [
              Offset(width * 0.5, pathHeight * 0.1),
              Offset(width * 0.2, pathHeight * 0.35),
              Offset(width * 0.8, pathHeight * 0.6),
              Offset(width * 0.5, pathHeight * 0.85),
            ];

            return SizedBox(
              height: pathHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MilestonePathLinePainter(),
                    ),
                  ),
                  ...List.generate(4, (index) {
                    final goal = milestones[index];
                    final isUnlocked = currentStreak >= goal;
                    final pos = offsets[index];
                    final nodeSize = 64.0;

                    return Positioned(
                      left: pos.dx - (nodeSize / 2),
                      top: pos.dy - (nodeSize / 2),
                      child: Tooltip(
                        message: '$goal-Day Milestone',
                        child: Container(
                          width: nodeSize,
                          height: nodeSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isUnlocked ? const Color(0xFFFF9600) : Colors.grey[400]!,
                              width: 3,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: isUnlocked ? const Color(0x33FF9600) : Colors.transparent,
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                isUnlocked ? Colors.transparent : Colors.grey,
                                isUnlocked ? BlendMode.dst : BlendMode.saturation,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  'assets/images/streakchamp.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrophyCase(int currentStreak) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> achievements = [
      {'title': '3-Day Jump Start', 'goal': 3},
      {'title': '7-Day Perfect Streak', 'goal': 7},
      {'title': '15-Day Routine Expert', 'goal': 15},
      {'title': '30-Day Gym King', 'goal': 30},
      {'title': '50-Day Marathon Runner', 'goal': 50},
      {'title': '100-Day Super Learner', 'goal': 100},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('TROPHY CASE'),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final ach = achievements[index];
            final title = ach['title'] as String;
            final goal = ach['goal'] as int;
            final isUnlocked = currentStreak >= goal;

            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isUnlocked ? Colors.transparent : Colors.grey,
                        isUnlocked ? BlendMode.dst : BlendMode.saturation,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/Trophy.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'DINRoundPro',
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: isUnlocked 
                        ? (isDarkMode ? Colors.white : const Color(0xFF4B4B4B)) 
                        : Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class MilestonePathLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF9600) // Streak Orange
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.2, size.height * 0.35);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width * 0.5, size.height * 0.85);
    path.lineTo(size.width * 0.5, size.height);

    // Create a dashed path
    final dashWidth = 10.0;
    final dashSpace = 8.0;
    final pathMetrics = path.computeMetrics();

    for (var metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

