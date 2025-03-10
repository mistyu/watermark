import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class YWatermarTableGeneralSeparate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  const YWatermarTableGeneralSeparate({
    super.key,
    required this.watermarkData,
    required this.resource,
    this.suffix,
  });

  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    // 获取frame的宽度，如果没有则使用默认值
    final frameWidth = watermarkData.frame?.width?.toDouble() ?? 200.w;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 80.w,
        minWidth: 80.w,
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
        ),
      ),
    );
  }
}
