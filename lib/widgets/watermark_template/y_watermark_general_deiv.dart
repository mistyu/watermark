import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class YWatermarTableGeneralSeparate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  String? titleColor;
  String? contentColor;
  String? tableKey;

  YWatermarTableGeneralSeparate({
    super.key,
    required this.watermarkData,
    required this.resource,
    this.suffix,
    this.tableKey,
  });

  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    // 获取frame的宽度，如果没有则使用默认值
    final frameWidth = watermarkData.frame?.width?.toDouble() ?? 200.w;

    if (watermarkId == 16982153599999) {
      titleColor = "#45526c";
      contentColor = "#3c3942";
      if (tableKey == "table2") {
        titleColor = "#ebd7a6";
        contentColor = "#ffffff";
      }
    }
    bool haveContainerunderline = true;
    if (watermarkId == 1698049456677) {
      haveContainerunderline = false;
    }

    String titleText = watermarkData.title ?? "";

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 75.w,
            minWidth: 75.w,
          ),
          child: WatermarkFrameBox(
            watermarkId: watermarkId,
            frame: watermarkData.frame,
            style: watermarkData.style,
            child: WatermarkGeneralItem(
              watermarkData: watermarkData,
              suffix: suffix,
              templateId: watermarkId,
              textAlign: TextAlign.justify,
              text: titleText,
              hexColor: titleColor,
            ),
          ),
        ),
        if (watermarkId == 1698049456677)
          WatermarkFrameBox(
            watermarkId: watermarkId,
            frame: WatermarkFrame(left: 0, top: watermarkData.frame?.top ?? 0),
            style: watermarkData.style,
            child: WatermarkGeneralItem(
              watermarkData: watermarkData,
              suffix: suffix,
              templateId: watermarkId,
              textAlign: TextAlign.justify,
              text: ":",
              hexColor: titleColor,
            ),
          ),
        Expanded(
          child: WatermarkFrameBox(
            watermarkId: watermarkId,
            frame: watermarkData.frame,
            style: watermarkData.style,
            child: WatermarkGeneralItem(
              watermarkData: watermarkData,
              suffix: suffix,
              templateId: watermarkId,
              containerunderline: haveContainerunderline,
              text: watermarkData.content ?? '',
              hexColor: contentColor,
            ),
          ),
        )
      ],
    );
  }
}
