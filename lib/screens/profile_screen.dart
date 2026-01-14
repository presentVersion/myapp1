import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'DuolingoFeather',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/trophy.jpg',
                ), // Placeholder
              ),
              const SizedBox(height: 20),
              const Text(
                'YOU',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DuolingoFeather',
                ),
              ),
              const SizedBox(height: 30),
              _buildStatsCard(),
              const SizedBox(height: 30),
              _buildAchievements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      color: Colors.grey[800]?.withAlpha(128),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _StatItem(
              icon: 'assets/images/lightning.png',
              title: 'Longest Streak',
              value: '10 days',
            ),
            _StatItem(
              icon: 'assets/images/target.png',
              title: 'Habits Completed',
              value: '120',
            ),
            _StatItem(
              icon: 'assets/images/book.png',
              title: 'Completion Rate',
              value: '85%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, bottom: 10),
          child: Text(
            'Achievements',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'DuolingoFeather',
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              SizedBox(width: 20),
              _AchievementItem(
                icon: 'assets/images/streak.png',
                title: '100 Days',
              ),
              _AchievementItem(
                icon: 'assets/images/target.png',
                title: 'Perfect Week',
              ),
              _AchievementItem(
                icon: 'assets/images/weights.png',
                title: 'All Habits',
              ),
              _AchievementItem(
                icon: 'assets/images/book.png',
                title: 'First Habit',
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  const _StatItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(icon, height: 24),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontFamily: 'DINRoundPro'),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'DINRoundPro',
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final String icon;
  final String title;

  const _AchievementItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withAlpha(128),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, height: 50),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'DINRoundPro',
            ),
          ),
        ],
      ),
    );
  }
}
