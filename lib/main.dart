import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'models/habit.dart';
import 'habit_provider.dart';
import 'milestone_provider.dart';
import 'theme_provider.dart';
import 'screens/progress_screen.dart';
import 'widgets/habit_card.dart';
import 'widgets/duolingo_app_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitProvider()),
        ChangeNotifierProvider(create: (context) => MilestoneProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const HabitTrackerApp(),
    ),
  );
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return MaterialApp(
      title: 'Habit Tracker',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF58CC02),
          primary: const Color(0xFF58CC02),
          secondary: const Color(0xFF1CB0F6),
          tertiary: const Color(0xFFFF9600),
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        // Design Law: No Sharp Corners (Global 16.0)
        cardTheme: CardThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE5E5E5), width: 2),
          ),
          elevation: 0,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        fontFamily: 'DINRoundPro', // As per assets
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF58CC02),
          primary: const Color(0xFF58CC02),
          secondary: const Color(0xFF1CB0F6),
          tertiary: const Color(0xFFFF9600),
          surface: const Color(0xFF1E1E1E),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF2C2C2C), width: 2),
          ),
          elevation: 0,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        fontFamily: 'DINRoundPro',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final List<Widget> screens = [
      const HomeScreen(),
      ProgressScreen(habits: habitProvider.habits),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5), 
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/home_icon.svg', 
                width: 30, 
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.grey[700]! : Colors.grey, 
                  BlendMode.srcIn,
                ),
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/home_icon.svg', 
                width: 30, 
                colorFilter: const ColorFilter.mode(Color(0xFF58CC02), BlendMode.srcIn),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/Goals.svg', 
                width: 30, 
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.grey[700]! : Colors.grey, 
                  BlendMode.srcIn,
                ),
              ),
              activeIcon: SvgPicture.asset(
                'assets/images/Goals.svg', 
                width: 30, 
                colorFilter: const ColorFilter.mode(Color(0xFF1CB0F6), BlendMode.srcIn),
              ),
              label: 'Progress',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final milestoneProvider = Provider.of<MilestoneProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Filter Logic: ONLY show habits/tasks scheduled for today's weekday
    final String todayWeekday = DateTime.now().weekday.toString();
    final todaysHabits = habitProvider.habits.where((h) => h.scheduledDays[todayWeekday] ?? false).toList();

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: DuolingoAppBar(
        streakCount: milestoneProvider.masterStreak,
        gemCount: 150, // Static gem count or dynamic if added later
        heartCount: milestoneProvider.streakFreezes,
        onStreakTap: () {
          // Progress Hub (Accessed via Streak Icon)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgressScreen(habits: habitProvider.habits),
            ),
          );
        },
      ),
      body: todaysHabits.isEmpty 
          ? _buildRestDayView(isDarkMode) 
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: todaysHabits.length,
              itemBuilder: (context, index) {
                final habit = todaysHabits[index];
                return HabitCard(
                  habit: habit,
                  onCompleted: () {
                    habitProvider.toggleHabitCompletion(habit.id);
                    // Check if it triggered daily completions for streaks
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      milestoneProvider.checkHabitCompletion(habitProvider.habits, context);
                    });
                  },
                  onSkipped: () {
                    habitProvider.skipHabitToday(habit.id);
                  },
                );
              },
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 8),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? const Color(0xFF327401) : const Color(0xFF439E02),
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddHabitModal(context, habitProvider),
          backgroundColor: const Color(0xFF58CC02),
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SvgPicture.asset(
            'assets/images/add.svg', 
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            width: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildRestDayView(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/homepage.svg', 
              width: 220, 
              placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
            ),
            const SizedBox(height: 32),
            Text(
              "Enjoy your rest day!",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'DINRoundPro',
                color: isDarkMode ? Colors.white : const Color(0xFF4B4B4B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your streak is protected.",
              style: TextStyle(
                fontSize: 16, 
                fontFamily: 'DINRoundPro',
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddHabitModal(BuildContext context, HabitProvider habitProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return const AddHabitDialog();
      },
    );
  }
}

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _nameController = TextEditingController();
  final Map<String, bool> _scheduledDays = {
    '1': true,
    '2': true,
    '3': true,
    '4': true,
    '5': true,
    '6': true,
    '7': true,
  };

  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
          width: 2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create New Habit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'DINRoundPro',
                color: isDarkMode ? Colors.white : const Color(0xFF4B4B4B),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              autofocus: true,
              style: TextStyle(
                fontFamily: 'DINRoundPro',
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Habit Name',
                labelStyle: const TextStyle(fontFamily: 'DINRoundPro'),
                hintText: 'e.g., Hit the Gym',
                hintStyle: TextStyle(
                  fontFamily: 'DINRoundPro',
                  color: isDarkMode ? Colors.grey[600] : Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF58CC02),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Schedule Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'DINRoundPro',
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final dayKey = (index + 1).toString();
                final isSelected = _scheduledDays[dayKey] ?? false;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _scheduledDays[dayKey] = !isSelected;
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFF58CC02) 
                          : (isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF7F7F7)),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFF439E02) 
                            : (isDarkMode ? const Color(0xFF3C3C3C) : const Color(0xFFE5E5E5)),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _dayLabels[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DINRoundPro',
                        color: isSelected 
                            ? Colors.white 
                            : (isDarkMode ? Colors.grey[300] : const Color(0xFF4B4B4B)),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? const Color(0xFF222222) : const Color(0xFFD5D5D5),
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                        foregroundColor: isDarkMode ? Colors.white : const Color(0xFF777777),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isDarkMode ? const Color(0xFF3C3C3C) : const Color(0xFFE5E5E5),
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontFamily: 'DINRoundPro', fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? const Color(0xFF327401) : const Color(0xFF439E02),
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.trim().isNotEmpty) {
                          final newHabit = Habit(
                            id: const Uuid().v4(),
                            name: _nameController.text.trim(),
                            scheduledDays: Map<String, bool>.from(_scheduledDays),
                          );
                          habitProvider.addHabit(newHabit);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFF439E02),
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text('Create', style: TextStyle(fontFamily: 'DINRoundPro', fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
