import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class YWatermarTableGeneral extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  const YWatermarTableGeneral({
    super.key,
    required this.watermarkData,
    required this.resource,
    this.suffix,
  });

  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    final mark = watermarkData.mark;
    String text = watermarkData.title ?? '';
    if (resource.id == 1698049875646) {
      text += "   ";
    } else {
      text += "：";
    }
    text += watermarkData.content ?? '';
    final dataStyle = watermarkData.style;

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
                    right: (layout?.imageTitleSpace ?? 0).w,
                    top: (layout?.imageTopSpace?.abs() ?? 0).h),
                child: Image.file(File(snapshot.data!),
                    width: (dataStyle?.iconWidth?.toDouble())?.w,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return Stack(
      children: [
        mark != null
            ? WatermarkMarkBox(
                mark: mark,
              )
            : const SizedBox.shrink(),
        WatermarkFrameBox(
          watermarkId: watermarkId,
          frame: watermarkData.frame,
          style: watermarkData.style,
          child: Row(
            children: [
              imageWidget,
              WatermarkGeneralItem(
                watermarkData: watermarkData,
                suffix: suffix,
                templateId: watermarkId,
                text: text,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
