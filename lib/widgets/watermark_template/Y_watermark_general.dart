import 'package:flutter/material.dart';
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
          child: WatermarkGeneralItem(
            watermarkData: watermarkData,
            suffix: suffix,
            templateId: watermarkId,
          ),
        ),
      ],
    );
  }
}
