import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

class WatermarkFontBox extends StatelessWidget {
  final WatermarkFont? font;
  final WatermarkStyle? textStyle;
  final String? text;
  final TextAlign? textAlign;
  final bool? isBold;
  final bool isSingleLine;
  double? height;
  final String? hexColor;

  WatermarkFontBox({
    super.key,
    required this.textStyle,
    required this.text,
    required this.font,
    this.textAlign,
    this.isBold,
    this.isSingleLine = false,
    this.height,
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
    textColor ??= Colors.white;
    // 如果height没有传，则使用font的height
    height ??= font?.height ?? 1.3;
    // print("xiaojianjian height: ${height} ${font?.height}");
    return Text(
      text ?? '',
      textAlign: textAlign,
      maxLines: isSingleLine ? 1 : null, // 根据 isSingleLine 设置 maxLines
      overflow: isSingleLine ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: font?.fontWeight,
        shadows: textStyle?.viewShadow == true ? Utils.getViewShadow() : null,
        color: textColor,
        fontFamily: font?.name,
        fontSize: font?.size ?? 14.5.sp,
        height: height ?? 1.3,
      ),
      softWrap: true,
    );
  }
}
