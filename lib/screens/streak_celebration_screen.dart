import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/widgets/continue_button.dart';
import 'package:habit_tracker/widgets/weekly_progress_view.dart';

class StreakCelebrationScreen extends StatefulWidget {
  final Habit habit;

  const StreakCelebrationScreen({super.key, required this.habit});

  @override
  State<StreakCelebrationScreen> createState() =>
      _StreakCelebrationScreenState();
}

class _StreakCelebrationScreenState extends State<StreakCelebrationScreen> {
  late VideoPlayerController _controller;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Animation1.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(1.0); // Set volume to full
        _controller.play();
        _controller.setLooping(true);
      });

    // Delay the appearance of the content
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Background
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          // Animated Content
          AnimatedOpacity(
            opacity: _showContent ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.habit.streakCount} Day Streak!',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'DuolingoFeather',
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  WeeklyProgressView(habit: widget.habit),
                ],
              ),
            ),
          ),

          // Continue Button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showContent ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: ContinueButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
