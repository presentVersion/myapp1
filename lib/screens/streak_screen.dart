import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as developer;

class StreakScreen extends StatefulWidget {
  final int streakCount;

  const StreakScreen({super.key, required this.streakCount});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // --- Video Logic ---
    // Choose the video based on the streak count.
    bool isMilestone = widget.streakCount > 0 && widget.streakCount % 10 == 0;
    String videoPath = isMilestone
        ? 'assets/videos/Streak2.mp4'
        : 'assets/videos/Streak1.mp4';

    _controller = VideoPlayerController.asset(videoPath)
      ..initialize()
          .then((_) {
            setState(() {});
            _controller.play();
            _controller.setLooping(true);
          })
          .catchError((error, stackTrace) {
            developer.log(
              'Video not found. Please upload video files.',
              name: 'myapp.streak_screen',
              error: error,
              stackTrace: stackTrace,
            );
          });

    // --- Animation Logic ---
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showText = true;
          _animationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  if (_showText)
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(
                        widget.streakCount
                            .toString(), // Display the actual streak count
                        style: const TextStyle(
                          fontFamily: 'DuolingoFeather',
                          fontSize: 150,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
