import 'package:flutter/material.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'WatermarkFrame.dart';

class WatermarkMarkBox extends StatelessWidget {
  final WatermarkMark mark;
  const WatermarkMarkBox({super.key,required this.mark});

  @override
  Widget build(BuildContext context) {
    return WatermarkFrameBox(
      frame: mark.frame,
      style: mark.style,
    );
  }
}
