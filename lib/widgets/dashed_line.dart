// lib/widgets/dashed_line.dart
import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    required this.color,
    this.dashWidth = 5,
    this.dashSpace = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) =>
      color != oldDelegate.color ||
      dashWidth != oldDelegate.dashWidth ||
      dashSpace != oldDelegate.dashSpace;
}

class DashedLine extends StatelessWidget {
  final Color? color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  const DashedLine({
    Key? key,
    this.color,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpace = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPaint(
      size: Size(double.infinity, height),
      painter: DashedLinePainter(
        color: color ?? theme.colorScheme.onPrimary,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
    );
  }
}
