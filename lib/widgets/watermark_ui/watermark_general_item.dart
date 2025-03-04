import 'package:flutter/material.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';

class WatermarkGeneralItem extends StatelessWidget {
  final WatermarkData watermarkData;
  final String? suffix; // 可选的后缀，比如"米"等单位

  const WatermarkGeneralItem({
    Key? key,
    required this.watermarkData,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    final content = watermarkData.content ?? '';

    String textContent = watermarkData.title ?? '';
    textContent += "：";
    textContent += content;
    return WatermarkFontBox(
      text: textContent,
      textStyle: dataStyle,
      font: font,
    );
  }
}
