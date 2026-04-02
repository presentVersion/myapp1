import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Milestone {
  final int streakGoal;
  final String iconAsset;

  Milestone({required this.streakGoal, required this.iconAsset});
}

class MilestonePath extends StatelessWidget {
  final int currentStreak;
  final List<Milestone> milestones;

  const MilestonePath({
    super.key,
    required this.currentStreak,
    required this.milestones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        children: [
          Container(
            height: 4,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(milestones.length, (index) {
              final milestone = milestones[index];
              final isUnlocked = currentStreak >= milestone.streakGoal;

              // Alternating alignment for a zig-zag effect
              final double topPadding = index.isEven ? 0 : 50.0;

              return Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: Column(
                  children: [
                    _MilestoneIcon(
                      asset: milestone.iconAsset,
                      isUnlocked: isUnlocked,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${milestone.streakGoal} days',
                      style: TextStyle(
                        color: isUnlocked ? Colors.orange : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MilestoneIcon extends StatelessWidget {
  final String asset;
  final bool isUnlocked;

  const _MilestoneIcon({required this.asset, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (asset.toLowerCase().endsWith('.svg')) {
      image = SvgPicture.asset(
        asset,
        height: 50,
        width: 50,
        color: isUnlocked ? null : Colors.grey,
      );
    } else {
      image = Image.asset(asset, height: 50, width: 50);
    }

    if (isUnlocked) {
      return image;
    }

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: image,
    );
  }
}
