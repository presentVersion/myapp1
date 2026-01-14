import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:myapp/models/habit.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/screens/streak_screen.dart';
import 'package:myapp/screens/calendar_screen.dart';
import 'package:myapp/services/home_widget_service.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidgetService.init(); // Initialize the home widget service
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'DINRoundPro', color: Colors.white),
          bodyMedium: TextStyle(fontFamily: 'DINRoundPro', color: Colors.white),
          titleLarge: TextStyle(
            fontFamily: 'DuolingoFeather',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  int _perfectDayStreak = 0;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsString = prefs.getString('habits');
    if (habitsString != null) {
      final List<dynamic> habitsJson = jsonDecode(habitsString);
      setState(() {
        _habits = habitsJson.map((json) => Habit.fromJson(json)).toList();
      });
    }
    for (var habit in _habits) {
      habit.updateStreak();
    }
    _calculateAndSetPerfectDayStreak();
    _saveHabits();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsString = jsonEncode(
      _habits.map((habit) => habit.toJson()).toList(),
    );
    await prefs.setString('habits', habitsString);
  }

  void _calculateAndSetPerfectDayStreak() {
    if (_habits.isEmpty) {
      setState(() {
        _perfectDayStreak = 0;
      });
      HomeWidgetService.update(_perfectDayStreak); // Update widget
      return;
    }

    int streak = 0;
    DateTime checkDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    while (true) {
      bool allHabitsCompletedOnDay = _habits.every((habit) {
        return habit.completedDates.any(
          (completedDate) => DateUtils.isSameDay(completedDate, checkDate),
        );
      });

      if (allHabitsCompletedOnDay) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break; // Streak broken
      }
    }

    setState(() {
      _perfectDayStreak = streak;
    });
    HomeWidgetService.update(_perfectDayStreak); // Update widget
  }

  void _addHabit(String name) {
    if (name.isNotEmpty) {
      final newHabit = Habit(id: _uuid.v4(), name: name);
      setState(() {
        _habits.add(newHabit);
      });
      _calculateAndSetPerfectDayStreak();
      _saveHabits();
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  void _completeHabit(Habit habit) {
    setState(() {
      habit.toggleCompleted();
    });
    _calculateAndSetPerfectDayStreak();
    _saveHabits();
    if (habit.isCompletedToday()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreakScreen(streakCount: habit.streakCount),
        ),
      );
    }
  }

  void _showAddHabitDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a New Habit'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g., Go to the gym'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _addHabit(controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final incompleteHabits = _habits
        .where((habit) => !habit.isCompletedToday())
        .toList();
    final completedHabits = _habits
        .where((habit) => habit.isCompletedToday())
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PERFECT DAY',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'DuolingoFeather',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarScreen(habits: _habits)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/lightning.png', height: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Perfect Day Streak: $_perfectDayStreak',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DINRoundPro',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/Icon=Streak, Size=Medium.png',
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final habit = incompleteHabits[index];
                return _buildHabitItem(habit);
              }, childCount: incompleteHabits.length),
            ),
            if (completedHabits.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'COMPLETED',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DINRoundPro',
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final habit = completedHabits[index];
                return _buildHabitItem(habit);
              }, childCount: completedHabits.length),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _showAddHabitDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ADD HABIT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DINRoundPro',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildHabitItem(Habit habit) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withAlpha(128),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            habit.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'DINRoundPro',
            ),
          ),
          InkWell(
            onTap: () => _completeHabit(habit),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: habit.isCompletedToday()
                    ? Colors.green
                    : Colors.transparent,
              ),
              child: Center(
                child: Image.asset(
                  habit.isCompletedToday()
                      ? 'assets/images/check.png'
                      : 'assets/images/unchecked.png',
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
