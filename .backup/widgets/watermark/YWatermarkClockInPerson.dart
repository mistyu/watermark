import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'WatermarkFrame.dart';

class YWatermarkClockInPerson extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkClockInPerson({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final frame = watermarkData.frame;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WatermarkFrameBox(
          frame: frame,
          style: watermarkData.style,
          child: Text(
            watermarkData.content ?? '',
            style: TextStyle(
                color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                fontFamily: font?.name,
                fontSize: font?.size),
          ),
        )
      ],
    );
  }
}
