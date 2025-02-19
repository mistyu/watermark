import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:watermark_camera/models/camera.dart';

class CameraLayout extends StatelessWidget {
  final Widget child;
  final Widget? rightBottom;
  final Widget topActionWidget;
  final Widget bottomActionWidget;
  final CameraPreviewAspectRatio aspectRatio;
  final CameraController? controller;
  final bool isCameraInitialized;

  const CameraLayout(
      {super.key,
      this.controller,
      required this.aspectRatio,
      required this.child,
      required this.topActionWidget,
      required this.bottomActionWidget,
      required this.isCameraInitialized,
      this.rightBottom});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final targetAspectRatio = aspectRatio.ratio;
    final cameraAspectRatio = ((controller?.value.previewSize != null)
            ? controller?.value.aspectRatio
            : (16 / 9)) ??
        16 / 9;

    double scale = 1.0;
    double previewWidth = screenSize.width;
    double previewHeight = previewWidth * cameraAspectRatio;

    if (previewWidth / targetAspectRatio > previewHeight) {
      scale = (screenSize.width * (1 / targetAspectRatio)) / previewHeight;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: ClipRect(
            child: Transform.scale(
              scale: scale,
              child: Center(
                child: isCameraInitialized
                    ? CameraPreview(controller!)
                    : _buildCameraLoadingWidget(),
              ),
            ),
          ),
        ),
        // Mask overlay
        CustomPaint(
          size: Size.infinite,
          painter: MaskPainter(
            aspectRatio: targetAspectRatio,
            color: Colors.white,
          ),
        ),

        bottomActionWidget,
        Center(
          child: AspectRatio(
            aspectRatio: targetAspectRatio,
            child: Stack(
              children: [child, if (rightBottom != null) rightBottom!],
            ),
          ),
        ),
        topActionWidget,
      ],
    );
  }

  Widget _buildCameraLoadingWidget() {
    return Container(
      color: Colors.black,
      width: double.infinity,
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

    double rectHeight = size.width / aspectRatio;

    // 计算起始Y坐标，使裁切区域居中
    final startY = (size.height - rectHeight) / 2;

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
