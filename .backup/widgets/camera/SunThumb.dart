import 'package:flutter/material.dart';
import 'dart:math';

const int numRays = 8;

const double angleStep = 2 * pi / numRays;

class SunSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  SunSliderThumbShape({this.thumbRadius = 12.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    // 绘制空心圆
    final Paint circlePaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(center, thumbRadius, circlePaint);

    // 绘制太阳光芒
    final Paint rayPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double maxRayLength = thumbRadius * 1.5;
    final double rayLength = maxRayLength * (1 - value);

    for (int i = 0; i < numRays; i++) {
      final double angle = i * angleStep;
      final double startX = center.dx + (thumbRadius + 6) * cos(angle);
      final double startY = center.dy + (thumbRadius + 6) * sin(angle);
      final double endX =
          center.dx + (thumbRadius + 6 + rayLength) * cos(angle);
      final double endY =
          center.dy + (thumbRadius + 6 + rayLength) * sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        rayPaint,
      );
    }
  }
}
