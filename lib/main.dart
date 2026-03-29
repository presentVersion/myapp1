import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/screens/progress_screen.dart';
import 'package:habit_tracker/screens/streak_celebration_screen.dart';
import 'package:habit_tracker/theme_provider.dart';
import 'package:habit_tracker/widgets/themed_button.dart';
import 'package:uuid/uuid.dart';
import 'package:habit_tracker/widgets/habit_widget_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitWidgetProvider.init(); // Initialize the home widget provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Habit Tracker',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF0F0F0),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1A1A),
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'DuolingoFeather',
                color: Colors.white,
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontFamily: 'DINRoundPro',
                color: Colors.black,
              ),
              bodyMedium: TextStyle(
                fontFamily: 'DINRoundPro',
                color: Colors.black,
              ),
              titleLarge: TextStyle(
                fontFamily: 'DuolingoFeather',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1A1A),
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'DuolingoFeather',
                color: Colors.white,
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontFamily: 'DINRoundPro',
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                fontFamily: 'DINRoundPro',
                color: Colors.white,
              ),
              titleLarge: TextStyle(
                fontFamily: 'DuolingoFeather',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
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
    if (_habits.isNotEmpty) {
      final habit = _habits.first;
      HabitWidgetProvider.sendData(
          habit.name, habit.streakCount, habit.isCompletedToday());
    }
  }

  void _calculateAndSetPerfectDayStreak() {
    if (_habits.isEmpty) {
      setState(() {
        _perfectDayStreak = 0;
      });
      return;
    }

    int streak = 0;
    DateTime checkDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Don't count streak if not all habits for today are complete yet.
    // Check if yesterday was a perfect day, if so, the streak continues.
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    bool allCompletedToday = _habits.every((h) => h.completedDates.any((d) => DateUtils.isSameDay(d, today)));

    if (!allCompletedToday) {
       checkDate = checkDate.subtract(const Duration(days: 1));
    }

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
          builder: (context) => StreakCelebrationScreen(habit: habit),
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
          backgroundColor: const Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add a New Habit',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'DuolingoFeather',
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'DINRoundPro',
            ),
            decoration: const InputDecoration(
              hintText: 'e.g., Go to the gym',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'DINRoundPro',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DINRoundPro',
                ),
              ),
            ),
            ThemedButton(onPressed: () => _addHabit(controller.text), text: 'ADD'),
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
      appBar: AppBar(
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/calendarpageviewbutton.svg',
              height: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressScreen(habits: _habits),
                ),
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
                  SvgPicture.asset('assets/images/lightning.svg', height: 24),
                  const SizedBox(width: 8),
                  Text(
                    '$_perfectDayStreak Day Streak',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DINRoundPro',
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/images/streak.svg', height: 24),
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
              child: GestureDetector(
                onTap: _showAddHabitDialog,
                child: SvgPicture.asset('assets/images/add.svg'),
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
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2C2C2C)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            habit.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'DINRoundPro',
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          GestureDetector(
            onTap: () => _completeHabit(habit),
            child: SvgPicture.asset(
              habit.isCompletedToday()
                  ? 'assets/images/checked.svg'
                  : 'assets/images/unchecked.svg',
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
