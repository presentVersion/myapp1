import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Badge {
  final String title;
  final String iconAsset;

  Badge({required this.title, required this.iconAsset});
}

class BadgeWidget extends StatelessWidget {
  final Badge badge;

  const BadgeWidget({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          SvgPicture.asset(badge.iconAsset, height: 60),
          const SizedBox(height: 8),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
