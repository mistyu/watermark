import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

class WatermarkFontBoxSeparate extends StatelessWidget {
  final WatermarkFont? font;
  final WatermarkStyle? textStyle;
  final String? text;
  final TextAlign? textAlign;
  final bool? isBold;
  final bool isSingleLine;
  final double? height;
  final double? width;

  const WatermarkFontBoxSeparate({
    super.key,
    required this.textStyle,
    required this.text,
    required this.font,
    this.textAlign,
    this.isBold,
    this.isSingleLine = false,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = textStyle?.textColor;
    final characters = (text ?? '').split('');
    final textLength = characters.length;

    if (textLength <= 1) {
      return Text(
        text ?? '',
        style: TextStyle(
          fontWeight: isBold == true ? FontWeight.w800 : font?.fontWeight,
          shadows: textStyle?.viewShadow == true ? Utils.getViewShadow() : null,
          color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
          fontFamily: font?.name,
          fontSize: font?.size ?? 14.5.sp,
          height: height ?? 1.3,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(textLength, (index) {
        return Text(
          characters[index],
          style: TextStyle(
            fontWeight: isBold == true ? FontWeight.w800 : font?.fontWeight,
            shadows:
                textStyle?.viewShadow == true ? Utils.getViewShadow() : null,
            color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
            fontFamily: font?.name,
            fontSize: font?.size ?? 14.5.sp,
            height: height ?? 1.3,
          ),
        );
      }),
    );
  }
}
