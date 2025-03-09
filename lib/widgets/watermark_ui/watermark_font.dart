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
  final bool isSingleLine;

  const WatermarkFontBox({
    super.key,
    required this.textStyle,
    required this.text,
    this.height,
    required this.font,
    this.textAlign,
    this.isBold,
    this.isSingleLine = false,
  });

  @override
  Widget build(BuildContext context) {
    print("xiaojianjian font?.fontWeight: ${font?.fontWeight}");
    final textColor = textStyle?.textColor;
    return Text(
      text ?? '',
      textAlign: textAlign,
      maxLines: isSingleLine ? 1 : null, // 根据 isSingleLine 设置 maxLines
      overflow: isSingleLine ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: isBold == true ? FontWeight.w800 : font?.fontWeight,
        shadows: textStyle?.viewShadow == true ? Utils.getViewShadow() : null,
        color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
        fontFamily: font?.name,
        fontSize: font?.size ?? 13.5.sp,
        height: height,
      ),
      softWrap: true,
    );
  }
}
