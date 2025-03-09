import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class YWatermarkCoordinateShow1 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const YWatermarkCoordinateShow1({
    super.key,
    required this.watermarkData,
    required this.resource,
  });

  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    // print("xiaojianjian 分行展示 ${watermarkData.type}");
    // WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;

    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];

    final signLine = watermarkData.signLine;

    return GetBuilder<LocationController>(builder: (logic) {
      final location = logic.locationResult.value;
      final longitude = location?.longitude?.toStringAsFixed(6) ?? '0.000000';
      final latitude = location?.latitude?.toStringAsFixed(6) ?? '0.000000';
      String text1 = '经度';
      String text2 = '纬度';

      if (resource.id == 1698049875646) {
        text1 += "   ";
        text2 += "   ";
      } else {
        text1 += '：';
        text2 += '：';
      }

      // // 如果content不为空，则显示content
      if (Utils.isNotNullEmptyStr(watermarkData.content)) {
        //需要对content按照,进行分割出精度和维度
        final list = watermarkData.content!.split(',');
        text1 += list[1];
        text2 += list[0];
      } else {
        text1 += longitude;
        text2 += latitude;
      }

      return Column(
          // alignment: Alignment.centerLeft,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WatermarkFrameBox(
              frame: dataFrame,
              style: dataStyle,
              signLine: signLine,
              watermarkData: watermarkData,
              watermarkId: watermarkId,
              child: WatermarkFontBox(
                text: text1,
                textStyle: dataStyle,
                font: font,
              ),
            ),
            WatermarkFrameBox(
              frame: dataFrame,
              style: dataStyle,
              signLine: signLine,
              watermarkData: watermarkData,
              watermarkId: watermarkId,
              child: WatermarkFontBox(
                text: text2,
                textStyle: dataStyle,
                font: font,
                height: font?.height ?? 0,
              ),
            ),
          ]);
    });
  }
}
