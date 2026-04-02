import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/widgets/milestone_path_painter.dart';

enum ProgressView {
  perfectDays,
  specificHabit,
}

class ProgressScreen extends StatefulWidget {
  final List<Habit> habits;
  const ProgressScreen({super.key, this.habits = const []});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  ProgressView _currentView = ProgressView.perfectDays;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Hub'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildViewToggle(),
            const SizedBox(height: 20),
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
        const SizedBox(width: 10),
        _buildToggleButton('Specific Habit', ProgressView.specificHabit),
      ],
    );
  }

  Widget _buildToggleButton(String text, ProgressView view) {
    final isSelected = _currentView == view;
    return GestureDetector(
      onTap: () => setState(() => _currentView = view),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/Continuebuttonstatebeforepressed.svg', 
            ),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPerfectDaysView() {
    return Column(
      children: [
        _buildCalendarGrid(),
        const SizedBox(height: 30),
        _buildMilestonePath(),
        const SizedBox(height: 30),
        _buildTrophyCase(),
      ],
    );
  }

  Widget _buildSpecificHabitView() {
    return Column(
      children: [
        // Dropdown to select a habit
        // Calendar showing completions for that habit
        const Text('Specific Habit View - Coming Soon!'),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    // Placeholder for Duolingo Calendar
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('Duolingo Calendar Grid'),
      ),
    );
  }

  Widget _buildMilestonePath() {
    return Column(
      children: [
        const Text(
          'MILESTONE PATH',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'DuolingoFeather',
          ),
        ),
        const SizedBox(height: 20),
        CustomPaint(
          size: const Size(double.infinity, 200),
          painter: MilestonePathPainter(),
        ),
      ],
    );
  }

  Widget _buildTrophyCase() {
    return Column(
      children: [
        const Text(
          'TROPHY CASE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'DuolingoFeather',
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 12, // Placeholder
          itemBuilder: (context, index) {
            final isLocked = index > 3;
            return ColorFiltered(
              colorFilter: isLocked
                  ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: SvgPicture.asset('assets/images/Trophy.svg'),
            );
          },
        ),
      ],
    );
  }
}
