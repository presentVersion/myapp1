import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:habit_tracker/widgets/milestone_path.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/milestone_provider.dart';

class CelebrationOverlay extends StatefulWidget {
  final Milestone milestone;

  const CelebrationOverlay({super.key, required this.milestone});

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/Animation1.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          _getMotivationalText(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'DuolingoFeather',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                blurRadius: 2.0,
                                color: Color(0xFF58CC02),
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  String _getMotivationalText(BuildContext context) {
    final milestoneProvider = context.read<MilestoneProvider>();
    final currentStreak = milestoneProvider.masterStreak;
    final nextMilestone = widget.milestone.streakGoal;
    final daysLeft = nextMilestone - currentStreak;

    if (daysLeft > 0) {
      if (nextMilestone == 7) {
        return '$daysLeft days until a Perfect Week!';
      } else if (nextMilestone == 30) {
        return 'Only $daysLeft days left to join the Streak Society!';
      } else {
        return '$daysLeft days until your next milestone!';
      }
    }
    return 'You hit a milestone!';
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
