import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/screens/progress_screen.dart';
import 'package:habit_tracker/theme_provider.dart';
import 'package:habit_tracker/widgets/duolingo_app_bar.dart';
import 'package:habit_tracker/widgets/habit_card.dart';
import 'package:uuid/uuid.dart';
import 'package:habit_tracker/widgets/habit_widget_provider.dart';
import 'package:habit_tracker/milestone_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  await HabitWidgetProvider.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MilestoneProvider()),
      ],
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
            primaryColor: const Color(0xFF58CC02),
            scaffoldBackgroundColor: const Color(0xFFFFFFFF),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFFFFF),
              elevation: 1,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'DuolingoFeather',
                color: Colors.black,
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontFamily: 'DINRoundPro', color: Colors.black),
              bodyMedium: TextStyle(fontFamily: 'DINRoundPro', color: Colors.black),
              titleLarge: TextStyle(fontFamily: 'DuolingoFeather', color: Colors.black, fontWeight: FontWeight.bold),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF58CC02), // Primary Green
              unselectedItemColor: Colors.grey[400],
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF58CC02),
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1A1A),
              elevation: 1,
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
              bodyLarge: TextStyle(fontFamily: 'DINRoundPro', color: Colors.white),
              bodyMedium: TextStyle(fontFamily: 'DINRoundPro', color: Colors.white),
              titleLarge: TextStyle(fontFamily: 'DuolingoFeather', color: Colors.white, fontWeight: FontWeight.bold),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: const Color(0xFF2C2C2C),
              selectedItemColor: const Color(0xFF58CC02), // Primary Green
              unselectedItemColor: Colors.grey[600],
            ),
            dialogBackgroundColor: const Color(0xFF2C2C2C),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [HomeScreen(), ProgressScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/home_icon.svg', height: 24, color: _currentIndex == 0 ? Theme.of(context).primaryColor : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/Goals.svg', height: 24, color: _currentIndex == 1 ? Theme.of(context).primaryColor : Colors.grey),
            label: 'Calendar',
          ),
        ],
      ),
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
    if (mounted) {
      context.read<MilestoneProvider>().checkHabitCompletion(_habits, context);
      _saveHabits();
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsString = jsonEncode(
      _habits.map((habit) => habit.toJson()).toList(),
    );
    await prefs.setString('habits', habitsString);
  }

  void _addHabit(
    String name,
    Map<String, bool> scheduledDays,
  ) {
    if (name.isNotEmpty) {
      final newHabit = Habit(
        id: _uuid.v4(),
        name: name,
        scheduledDays: scheduledDays,
      );
      setState(() {
        _habits.add(newHabit);
      });
      _saveHabits();
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  void _completeHabit(Habit habit) {
    setState(() {
      habit.toggleCompleted();
    });
    _saveHabits();
    context.read<MilestoneProvider>().checkHabitCompletion(_habits, context);
  }

  void _skipHabit(Habit habit) {
    setState(() {
      habit.skipToday();
    });
    _saveHabits();
  }

  void _showAddHabitDialog() {
    final TextEditingController controller = TextEditingController();
    Map<String, bool> scheduledDays = {
      '1': true, '2': true, '3': true, '4': true, '5': true, '6': true, '7': true
    };
    final TextEditingController restDaysController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Add a New Habit'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(hintText: 'e.g., Go to the gym'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Repeat on:'),
                    Wrap(
                      children: List.generate(7, (index) {
                        final day = (index + 1).toString();
                        final dayName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              scheduledDays[day] = !scheduledDays[day]!;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: scheduledDays[day]! ? Theme.of(context).primaryColor : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Text(dayName, style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: restDaysController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Rest days per week',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                TextButton(
                  onPressed: () => _addHabit(
                    controller.text,
                    scheduledDays,
                  ),
                  child: const Text('ADD')
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final milestoneProvider = context.watch<MilestoneProvider>();
    final habitsForToday = _habits.where((habit) => habit.isScheduledForToday()).toList();
    final incompleteHabits = habitsForToday.where((habit) => !habit.isCompletedToday() && !habit.isSkippedOn(DateTime.now())).toList();
    final completedHabits = habitsForToday.where((habit) => habit.isCompletedToday()).toList();
    final skippedHabits = habitsForToday.where((habit) => habit.isSkippedOn(DateTime.now())).toList();

    return Scaffold(
      appBar: DuolingoAppBar(
        streakCount: milestoneProvider.masterStreak,
        gemCount: 12, // Placeholder
        heartCount: milestoneProvider.streakFreezes,
        onStreakTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProgressScreen(habits: _habits)),
          );
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final habit = incompleteHabits[index];
              return HabitCard(habit: habit, onCompleted: () => _completeHabit(habit), onSkipped: () => _skipHabit(habit));
            }, childCount: incompleteHabits.length),
          ),
          if (completedHabits.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('COMPLETED', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: 'DINRoundPro')),
                    ),
                    const Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final habit = completedHabits[index];
              return HabitCard(habit: habit, onCompleted: () => _completeHabit(habit), onSkipped: () => _skipHabit(habit));
            }, childCount: completedHabits.length),
          ),
          if (skippedHabits.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('SKIPPED', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontFamily: 'DINRoundPro')),
                    ),
                    const Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final habit = skippedHabits[index];
              return HabitCard(habit: habit, onCompleted: () => _completeHabit(habit), onSkipped: () => _skipHabit(habit));
            }, childCount: skippedHabits.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: const Color(0xFF58CC02),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
