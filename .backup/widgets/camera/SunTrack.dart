import 'package:flutter/material.dart';

class SunTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    Offset? secondaryOffset,
    required TextDirection textDirection,
    required Offset thumbCenter,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackRadius = trackHeight / 2;
    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!
      ..style = PaintingStyle.fill;

    // 计算滑块覆盖区域
    const double thumbRadius = 22.0;

    final double trackY = thumbCenter.dy - trackRadius;

    // 绘制左侧轨道（active）
    final Rect activeRect = Rect.fromLTWH(
      offset.dx,
      trackY,
      thumbCenter.dx - thumbRadius - offset.dx,
      trackHeight,
    );

    // 绘制右侧轨道（inactive）
    final Rect inactiveRect = Rect.fromLTWH(
      thumbCenter.dx + thumbRadius,
      trackY,
      parentBox.size.width - thumbCenter.dx - thumbRadius,
      trackHeight,
    );

    final Canvas canvas = context.canvas;
    canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, Radius.circular(trackRadius)),
      activePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(inactiveRect, Radius.circular(trackRadius)),
      inactivePaint,
    );
  }
}
