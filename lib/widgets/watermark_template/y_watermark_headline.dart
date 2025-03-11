import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class YWatermarkHeadline extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const YWatermarkHeadline(
      {super.key, required this.watermarkData, required this.resource});
  int get watermarkId => resource.id ?? 0;
  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final frame = watermarkData.frame;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    final dataStyle = watermarkData.style;
    final layout = dataStyle?.layout;

    Widget? imageWidget = const SizedBox.shrink();
    print(
        "xiaojianjian 达瓦达瓦 YWatermarkHeadline image: ${watermarkData.content}");
    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                margin: EdgeInsets.only(
                    right: (layout?.imageTitleSpace ?? 0).w,
                    top: (layout?.imageTopSpace?.abs() ?? 0).h),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble() ?? 30,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return WatermarkFrameBox(
      style: watermarkData.style,
      frame: frame,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: watermarkId == 1698059986262
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          imageWidget,
          WatermarkFontBox(
              textStyle: dataStyle,
              text: watermarkData.content ?? '',
              font: font),
        ],
      ),
    );
  }
}
