import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class YWatermarkAltitudeNew extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const YWatermarkAltitudeNew({
    super.key,
    required this.watermarkData,
    required this.resource,
  });

  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    // WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;
    print(
        "xiaojianjian RyWatermarkLocationBoxNew watermarkData.content ${watermarkData.content}");
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];

    final signLine = watermarkData.signLine;

    return GetBuilder<LocationController>(builder: (logic) {
      return Stack(children: [
        WatermarkFrameBox(
          frame: dataFrame,
          style: dataStyle,
          signLine: signLine,
          watermarkData: watermarkData,
          watermarkId: watermarkId,
          child: FutureBuilder<String>(
              future: logic.getAltitude(),
              builder: (context, snapshot) {
                String textContent = watermarkData.title ?? '';
                textContent += "：";
                String altitude = '0';
                if (snapshot.hasData) {
                  altitude = snapshot.data!;
                }
                altitude += "米";
                textContent += altitude;
                return WatermarkFontBox(
                  text: textContent,
                  textStyle: dataStyle,
                  font: font,
                );
              }),
        ),
      ]);
    });
  }
}
