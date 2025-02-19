import 'package:flutter/material.dart';

class CameraPreviewMaskPainter extends CustomPainter {
  final double aspectRatio;
  final Color color;
  final Alignment alignment;

  CameraPreviewMaskPainter(
      {required this.aspectRatio,
      required this.color,
      this.alignment = Alignment.center});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    double rectHeight = size.width / aspectRatio;

    double startY;
    if (alignment == Alignment.topCenter) {
      startY = 0;
    } else {
      // Center alignment
      startY = (size.height - rectHeight) / 2;
    }

    final rect = Rect.fromLTWH(
      0, // left
      startY, // top
      size.width, // width
      rectHeight, // height
    );

    // Draw the outer rectangle
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRect(rect),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
