import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FocusIndicator extends StatelessWidget {
  final Offset position;

  const FocusIndicator({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(position),
        tween: Tween<double>(
          begin: Platform.isIOS ? 120.w : 80.w,
          end: Platform.isIOS ? 100.w : 50.w,
        ),
        duration: const Duration(milliseconds: 2000),
        curve: Curves.fastLinearToSlowEaseIn,
        builder: (_, anim, child) {
          return CustomPaint(
            painter: FocusPainter(
              tapPosition: position,
              rectSize: anim,
            ),
          );
        },
      ),
    );
  }
}

class FocusPainter extends CustomPainter {
  final double rectSize;
  final Offset tapPosition;

  FocusPainter({required this.tapPosition, required this.rectSize});

  @override
  void paint(Canvas canvas, Size size) {
    final isIOS = Platform.isIOS;

    final baseX = tapPosition.dx - rectSize / 2;
    final baseY = tapPosition.dy - rectSize / 2;

    Path pathAndroid = Path()
      ..moveTo(baseX, baseY)
      ..lineTo(baseX + rectSize / 5, baseY)
      ..moveTo(baseX + 4 * rectSize / 5, baseY)
      ..lineTo(baseX + rectSize, baseY)
      ..lineTo(baseX + rectSize, baseY + rectSize / 5)
      ..moveTo(baseX + rectSize, baseY + 4 * rectSize / 5)
      ..lineTo(baseX + rectSize, baseY + rectSize)
      ..lineTo(baseX + 4 * rectSize / 5, baseY + rectSize)
      ..moveTo(baseX + rectSize / 5, baseY + rectSize)
      ..lineTo(baseX, baseY + rectSize)
      ..lineTo(baseX, baseY + 4 * rectSize / 5)
      ..moveTo(baseX, baseY + rectSize / 5)
      ..lineTo(baseX, baseY);

    Path pathIOS = Path()
      ..moveTo(baseX, baseY)
      ..lineTo(baseX + rectSize / 2, baseY)
      ..lineTo(baseX + rectSize / 2, baseY + rectSize / 10)
      ..moveTo(baseX + rectSize / 2, baseY)
      ..lineTo(baseX + rectSize, baseY)
      ..lineTo(baseX + rectSize, baseY + rectSize / 2)
      ..lineTo(baseX + 9 / 10 * rectSize, baseY + rectSize / 2)
      ..moveTo(baseX + rectSize, baseY + rectSize / 2)
      ..lineTo(baseX + rectSize, baseY + rectSize)
      ..lineTo(baseX + rectSize / 2, baseY + rectSize)
      ..lineTo(baseX + rectSize / 2, baseY + 9 / 10 * rectSize)
      ..moveTo(baseX + rectSize / 2, baseY + rectSize)
      ..lineTo(baseX, baseY + rectSize)
      ..lineTo(baseX, baseY + rectSize / 2)
      ..lineTo(baseX + 1 / 10 * rectSize, baseY + rectSize / 2)
      ..moveTo(baseX, baseY + rectSize / 2)
      ..lineTo(baseX, baseY);

    canvas.drawPath(
      isIOS ? pathIOS : pathAndroid,
      Paint()
        ..color = Colors.amberAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant FocusPainter oldDelegate) {
    return rectSize != oldDelegate.rectSize ||
        tapPosition != oldDelegate.tapPosition;
  }
}
