import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

import '../watermark_ui/watermark_font.dart';

class YWatermarkStepNumber extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const YWatermarkStepNumber(
      {super.key, required this.watermarkData, required this.resource});
  int get watermarkId => resource.id ?? 0;
  @override
  Widget build(BuildContext context) {
    final dataStyle = watermarkData.style;
    final fonts = dataStyle?.fonts;
    final font = fonts?['font'];
    final textColor = dataStyle?.textColor;

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = dataStyle?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right: layout?.imageTitleSpace ?? 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble(), fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            imageWidget,
            SizedBox(
              width: 8.0.w,
            ),
            WatermarkFontBox(
              text: watermarkData.title ?? '',
              textStyle: dataStyle,
              font: font,
            ),
          ],
        ),
        Text(
          '21658',
          style: TextStyle(
              fontSize: 28.0.sp,
              color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
              fontFamily: font?.name,
              height: 1.8),
        ),
      ],
    );
  }
}
