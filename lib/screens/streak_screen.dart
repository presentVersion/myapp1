
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/widgets/themed_button.dart';
import 'package:video_player/video_player.dart';

class StreakScreen extends StatefulWidget {
  final int streak;
  final Habit habit;

  const StreakScreen({super.key, required this.streak, required this.habit});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/streak.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get motivationalMessage {
    if (widget.streak < 3) {
      return "You're just getting started!";
    } else if (widget.streak < 7) {
      return "You're on a roll!";
    } else if (widget.streak < 14) {
      return "Amazing! Keep it up!";
    } else {
      return "You're a legend!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Text(
                  '${widget.streak}',
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DuolingoFeather',
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.orange,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Day Streak!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DuolingoFeather',
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 40),
                _buildWeekProgress(),
                const SizedBox(height: 20),
                Text(
                  motivationalMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'DINRoundPro',
                    color: Colors.white,
                  ),
                ),
                const Spacer(flex: 3),
                ThemedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'CONTINUE',
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekProgress() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final days = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final day = days[index];
        final dayName = dayNames[index];
        final isCompleted = widget.habit.completedDates.any((d) => DateUtils.isSameDay(d, day));
        const isFrozen = false; // Replace with your logic for frozen days

        String assetName;
        if (isCompleted) {
          assetName = 'assets/images/${dayName}checked.svg';
        } else if (isFrozen) {
          assetName = 'assets/images/${dayName}freezed.svg';
        } else {
          assetName = 'assets/images/${dayName}unchecked.svg';
        }

        return SvgPicture.asset(assetName, height: 40);
      }),
    );
  }
}
