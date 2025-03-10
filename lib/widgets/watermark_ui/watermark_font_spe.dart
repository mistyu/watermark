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
  final String? hexColor; //优先这里的颜色

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
    this.hexColor,
  });

  @override
  Widget build(BuildContext context) {
    Color? textColor;

    if (Utils.isNullEmptyStr(hexColor)) {
      textColor = textStyle?.textColor?.color
          ?.hexToColor(textStyle?.textColor?.alpha?.toDouble());
    } else {
      textColor = Color(int.parse(hexColor!.replaceAll("#", "0xFF")));
    }

    final characters = (text ?? '').split('');
    final textLength = characters.length;
    if (textLength <= 1) {
      return Text(
        text ?? '',
        style: TextStyle(
          fontWeight: isBold == true ? FontWeight.w800 : font?.fontWeight,
          shadows: textStyle?.viewShadow == true ? Utils.getViewShadow() : null,
          color: textColor,
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
            color: textColor,
            fontFamily: font?.name,
            fontSize: font?.size ?? 14.5.sp,
            height: height ?? 1.3,
          ),
        );
      }),
    );
  }
}
