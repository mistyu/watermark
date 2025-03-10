import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font_spe.dart';

class WatermarkGeneralItem extends StatelessWidget {
  final WatermarkData watermarkData;
  final String? suffix;
  final int templateId;
  final TextAlign? textAlign;

  const WatermarkGeneralItem({
    Key? key,
    required this.watermarkData,
    this.suffix,
    required this.templateId,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    print("xiaojianjian 进入了 WatermarkGeneralItem区分也 ${textAlign}");
    String textContent = watermarkData.title ?? '';
    if (textAlign == TextAlign.justify) {
      print("xiaojianjian 进入了 WatermarkFontBoxSeparate字体");
      return Container(
        child: WatermarkFontBoxSeparate(
          text: textContent,
          textStyle: dataStyle,
          font: font,
          height: font?.height,
        ),
      );
    }
    return WatermarkFontBox(
      text: textContent,
      textStyle: dataStyle,
      font: font,
      height: font?.height,
    );
  }
}
