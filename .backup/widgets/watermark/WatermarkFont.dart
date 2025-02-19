import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';

class WatermarkFontBox extends StatelessWidget {
  final WatermarkStyle? textStyle;
  final String? text;
  const WatermarkFontBox({super.key, this.textStyle, this.text});

  @override
  Widget build(BuildContext context) {
    final fonts = textStyle?.fonts;

    return Text(
      text ?? '',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: textStyle?.textColor?.color
              ?.hexToColor(textStyle?.textColor?.alpha?.toDouble()),
          fontFamily: fonts != null ? fonts["font"]?.name : null,
          fontSize: fonts != null ? fonts["font"]?.size : null,
          height: 1),
    );
  }
}
