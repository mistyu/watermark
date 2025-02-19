import 'package:flutter/material.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

import 'package:watermark_camera/utils/library.dart';

class YWatermarkSignInPerson extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkSignInPerson({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];

    return Text(
      "${watermarkData.title}·${watermarkData.content}",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
          fontFamily: font?.name,
          fontSize: font?.size),
    );
  }
}
