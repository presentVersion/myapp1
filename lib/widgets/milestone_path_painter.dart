import 'package:flutter/material.dart';

class MilestonePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF9600) // Streak Orange
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Define path points for the dashed line
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width * 0.5, size.height * 0.2);
    path.lineTo(size.width * 0.2, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    path.lineTo(size.width * 0.5, size.height * 0.8);
    path.lineTo(size.width * 0.5, size.height);

    // Create a dashed path
    final dashWidth = 10;
    final dashSpace = 5;
    final pathMetrics = path.computeMetrics();

    for (var metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }

    // Draw milestone nodes
    final nodePaint = Paint()..color = const Color(0xFF58CC02); // Primary Green
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), 15, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.4), 15, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.6), 15, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.8), 15, nodePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
