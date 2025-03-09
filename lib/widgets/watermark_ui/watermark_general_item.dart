import 'package:flutter/material.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';

class WatermarkGeneralItem extends StatelessWidget {
  final WatermarkData watermarkData;
  final String? suffix; // 可选的后缀，比如"米"等单位
  final int templateId;

  const WatermarkGeneralItem({
    Key? key,
    required this.watermarkData,
    this.suffix,
    required this.templateId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    final content = watermarkData.content ?? '';

    String textContent = watermarkData.title ?? '';

    if (templateId == 1698049875646) {
      textContent += "   ";
    } else {
      textContent += "：";
    }

    textContent += content;
    return WatermarkFontBox(
      text: textContent,
      textStyle: dataStyle,
      font: font,
      height: font?.height,
    );
  }
}
