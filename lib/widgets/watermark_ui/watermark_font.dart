import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

class WatermarkFontBox extends StatelessWidget {
  final WatermarkFont? font;
  final WatermarkStyle? textStyle;
  final String? text;
  final double? height;
  final TextAlign? textAlign;
  final bool? isBold;
  const WatermarkFontBox(
      {super.key,
      required this.textStyle,
      required this.text,
      this.height,
      required this.font,
      this.textAlign,
      this.isBold});

  @override
  Widget build(BuildContext context) {
    final textColor = textStyle?.textColor;

    return Text(
      text ?? '',
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: isBold == true ? FontWeight.bold : null,
        shadows:
            // viewShadows,
            textStyle?.viewShadow == true ? Utils.getViewShadow() : null,
        color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
        fontFamily:
            // 'OPPOSans-Regular',
            font?.name,
        fontSize: 14.5.sp,
        height: height,
      ),
      softWrap: true,
    );
  }
}
