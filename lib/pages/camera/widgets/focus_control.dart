import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/pages/camera/camera_logic.dart';

class FocusControl extends StatelessWidget {
  final Offset position;
  final double exposureValue;
  final Function(double) onExposureChanged;
  final bool isVisible;
  final CameraLogic logic;

  const FocusControl({
    Key? key,
    required this.position,
    required this.exposureValue,
    required this.onExposureChanged,
    required this.isVisible,
    required this.logic,
  }) : super(key: key);

  static const double _exposureBarHeight = 170.0;
  static const double _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Stack(
      children: [
        // 聚焦框
        Positioned(
          left: position.dx - 40.w,
          top: position.dy - 40.w,
          child: DashedBorderContainer(
            width: 80.w,
            height: 80.w,
          ),
        ),
        // 亮度控制条
        Positioned(
          left: position.dx + 50.w,
          top: position.dy - (_exposureBarHeight / 2).h,
          child: GestureDetector(
              onVerticalDragStart: (_) => logic.setExposureDragging(true),
              onVerticalDragEnd: (_) => logic.setExposureDragging(false),
              onVerticalDragCancel: () => logic.setExposureDragging(false),
              onVerticalDragUpdate: (details) {
                // 计算滑块的 delta
                final delta = details.delta.dy / _exposureBarHeight;

                // 更新 exposureValue，并限制其范围在 -1 到 1 之间
                final newExposureValue = logic.exposureValue.value - delta;
                logic.onExposureChanged(newExposureValue.clamp(-1.0, 1.0));
              },
              child: Container(
                width: 30.w,
                height: _exposureBarHeight.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Stack(
                  children: [
                    // 背景线条
                    Center(
                      child: Container(
                        width: 2.w,
                        height: _exposureBarHeight.h - _iconSize.h * 2,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    // 滑动的太阳图标
                    Positioned(
                      left: 0,
                      right: 0,
                      // 根据exposureValue计算太阳图标的位置
                      top: (_exposureBarHeight.h - _iconSize.h) *
                          ((1 - logic.exposureValue.value.clamp(-1.0, 1.0)) / 2)
                              .clamp(0.0, 1.0), // 将-1到1映射到0到1
                      child: SizedBox(
                        height: _iconSize.h,
                        child: Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                          size: _iconSize.w,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    this.color = Colors.yellow,
    this.strokeWidth = 1.5,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final dashWidth = this.dashWidth;
    final dashSpace = this.dashSpace;

    // 绘制顶部虚线
    _drawDashedLine(canvas, paint, Offset(0, 0), Offset(size.width, 0),
        dashWidth, dashSpace);

    // 绘制右侧虚线
    _drawDashedLine(canvas, paint, Offset(size.width, 0),
        Offset(size.width, size.height), dashWidth, dashSpace);

    // 绘制底部虚线
    _drawDashedLine(canvas, paint, Offset(0, size.height),
        Offset(size.width, size.height), dashWidth, dashSpace);

    // 绘制左侧虚线
    _drawDashedLine(canvas, paint, Offset(0, 0), Offset(0, size.height),
        dashWidth, dashSpace);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end,
      double dashWidth, double dashSpace) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx, end.dy);

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedBorderContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  const DashedBorderContainer({
    Key? key,
    required this.width,
    required this.height,
    this.color = Colors.yellow,
    this.strokeWidth = 1.5,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
    );
  }
}
