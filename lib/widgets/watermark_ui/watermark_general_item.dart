import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font_spe.dart';

class WatermarkGeneralItem extends StatelessWidget {
  final WatermarkData watermarkData;
  final String? suffix;
  final int templateId;
  final TextAlign? textAlign;
  final String? text;
  final bool containerunderline;
  final String? hexColor;

  const WatermarkGeneralItem({
    Key? key,
    required this.watermarkData,
    this.suffix,
    required this.templateId,
    this.textAlign,
    this.text,
    this.containerunderline = false,
    this.hexColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    String textContent = text ?? '';

    if (textAlign == TextAlign.justify) {
      return WatermarkFontBoxSeparate(
        text: textContent,
        textStyle: dataStyle,
        font: font,
        height: font?.height,
        hexColor: hexColor,
      );
    }

    BoxDecoration? decoration;
    if (containerunderline) {
      decoration = const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Styles.c_666666, // 下划线颜色
            width: 0.5, // 下划线宽度
          ),
        ),
      );
    }

    return Container(
      decoration: decoration,
      child: WatermarkFontBox(
        text: textContent,
        textStyle: dataStyle,
        font: font,
        height: font?.height,
        hexColor: hexColor,
      ),
    );
  }
}
