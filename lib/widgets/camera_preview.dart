import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:watermark_camera/models/camera.dart';

class CameraPreviewWidget extends StatelessWidget {
  final Widget? rightbottom;
  final Widget child;
  final CameraPreviewAspectRatio aspectRatio;
  final CameraController controller;

  const CameraPreviewWidget({
    super.key,
    required this.controller,
    required this.aspectRatio,
    this.rightbottom,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final targetAspectRatio = aspectRatio.ratio;
    final cameraAspectRatio = controller.value.aspectRatio;

    double scale = 1.0;
    double previewWidth = screenSize.width;
    double previewHeight = previewWidth * cameraAspectRatio;

    if (previewWidth / targetAspectRatio > previewHeight) {
      scale = (screenSize.width * (1 / targetAspectRatio)) / previewHeight;
    }

    return Stack(
      children: [
        Center(
          child: ClipRect(
            child: Transform.scale(
              scale: scale,
              child: Center(
                child: CameraPreview(controller),
              ),
            ),
          ),
        ),
        // Mask overlay
        CustomPaint(
          size: Size.infinite,
          painter: MaskPainter(
            aspectRatio: targetAspectRatio,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        // Child widget can now be displayed normally
        child,
        if (rightbottom != null) rightbottom!,
      ],
    );
  }
}

class MaskPainter extends CustomPainter {
  final double aspectRatio;
  final Color color;

  MaskPainter({required this.aspectRatio, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final rectHeight = size.width / aspectRatio;
    final rectWidth = size.width;

    final rect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: rectWidth,
      height: rectHeight,
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
