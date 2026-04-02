import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'models/habit.dart';
import 'screens/progress_screen.dart';
import 'widgets/habit_card.dart';
import 'widgets/duolingo_app_bar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: const HabitTrackerApp(),
    ),
  );
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        use_material3: true,
        // Design Law: Duolingo Color Palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF58CC02),
          primary: const Color(0xFF58CC02),
          secondary: const Color(0xFF1CB0F6),
          tertiary: const Color(0xFFFF9600),
          surface: Colors.white,
        ),
        // Design Law: No Sharp Corners (Global 16.0)
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        fontFamily: 'DINRoundPro', // As per assets
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

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 2)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/home_icon.svg', width: 30, color: Colors.grey),
              activeIcon: SvgPicture.asset('assets/images/home_icon.svg', width: 30, color: const Color(0xFF58CC02)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/Goals.svg', width: 30, color: Colors.grey),
              activeIcon: SvgPicture.asset('assets/images/Goals.svg', width: 30, color: const Color(0xFF1CB0F6)),
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
    
    // Blueprint Rule: The Battle Station (Filter by current weekday)
    final String today = DateFormat('EEEE').value; 
    final todaysHabits = habitProvider.habits.where((h) => h.scheduledDays[today] ?? false).toList();

    return Scaffold(
      appBar: const DuolingoAppBar(),
      body: todaysHabits.isEmpty 
          ? _buildRestDayView() 
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todaysHabits.length,
              itemBuilder: (context, index) => HabitCard(habit: todaysHabits[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { /* Implementation for adding habit */ },
        backgroundColor: const Color(0xFF58CC02),
        child: SvgPicture.asset('assets/images/add.svg', color: Colors.white),
      ),
    );
  }

  Widget _buildRestDayView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/homepage.svg', width: 200),
          const SizedBox(height: 24),
          const Text(
            "Enjoy your rest day!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4B4B4B)),
          ),
          const Text(
            "Your streak is protected.",
            style: TextStyle(fontSize: 16, color: Color(0xFF777777)),
          ),
        ],
      ),
    );
  }
}