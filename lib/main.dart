import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/screens/streak_screen.dart';

void main() {
  // Ensure that plugin services are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'DINRoundPro',
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
  int _streakCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  // Load the streak count from device storage
  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _streakCount = prefs.getInt('streakCount') ?? 0;
    });
  }

  // Save the streak count to device storage
  Future<void> _saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streakCount', _streakCount);
  }

  // Increment the streak and show the celebration screen
  void _completeHabit() {
    setState(() {
      _streakCount++;
    });
    _saveStreak();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StreakScreen(streakCount: _streakCount)),
    ).then((_) {
      // This refreshes the home screen's streak count when you come back
      _loadStreak();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your Current Streak:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_streakCount',
              style: const TextStyle(
                fontFamily: 'DuolingoFeather',
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _completeHabit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Complete Today\'s Habit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
