import 'package:flutter/material.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class YWatermarkWatermark extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const YWatermarkWatermark(
      {super.key, required this.watermarkData, required this.resource});
  int get watermarkId => resource.id ?? 0;
  @override
  Widget build(BuildContext context) {
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;

    return Column(
      children: [
        FutureBuilder(
            future: WatermarkService.getImagePath(watermarkId.toString(),
                fileName: watermarkData.image),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return WatermarkFrameBox(
                  style: dataStyle,
                  frame: dataFrame,
                  imagePath: snapshot.data,
                );
              }

              return const SizedBox.shrink();
            })
      ],
    );
  }
}
