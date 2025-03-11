import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';

class YWatermarkCoordinateShow1TwoDeiv extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  const YWatermarkCoordinateShow1TwoDeiv({
    super.key,
    required this.watermarkData,
    required this.resource,
    this.suffix,
  });

  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];

    final signLine = watermarkData.signLine;

    return GetBuilder<LocationController>(builder: (logic) {
      final location = logic.locationResult.value;
      String longitude = location?.longitude?.toStringAsFixed(6) ?? '0.000000';
      String latitude = location?.latitude?.toStringAsFixed(6) ?? '0.000000';
      String text1 = '经度';
      String text2 = '纬度';
      if (resource.id == 1698125685119) {
        text1 = '经\u0020\u0020\u0020\u0020度';
        text2 = '纬\u0020\u0020\u0020\u0020度';
      }

      // // 如果content不为空，则显示content
      if (Utils.isNotNullEmptyStr(watermarkData.content)) {
        //需要对content按照,进行分割出精度和维度
        final list = watermarkData.content!.split(',');
        longitude += list[1];
        latitude += list[0];
      } else {
        longitude += "°N";
        latitude += "°E";
      }

      bool haveContainerunderline = true;
      if (watermarkId == 1698049456677 || watermarkId == 1698049855544) {
        haveContainerunderline = false;
      }

      return Column(
          // alignment: Alignment.centerLeft,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
                    minWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
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
                      text: text1,
                      hexColor: "#ffffff",
                    ),
                  ),
                ),
                if (watermarkId == 1698049456677 ||
                    watermarkId == 1698049855544)
                  WatermarkFrameBox(
                    watermarkId: watermarkId,
                    frame: WatermarkFrame(
                        left: 0, top: watermarkData.frame?.top ?? 0),
                    style: watermarkData.style,
                    child: WatermarkGeneralItem(
                      watermarkData: watermarkData,
                      suffix: suffix,
                      templateId: watermarkId,
                      textAlign: TextAlign.justify,
                      text: ":",
                      hexColor: "#ffffff",
                    ),
                  ),
                Expanded(
                  child: WatermarkFrameBox(
                    watermarkId: watermarkId,
                    frame: watermarkData.frame,
                    style: watermarkData.style,
                    child: _buildContentText(
                        longitude, "#ffffff", haveContainerunderline),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
                    minWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
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
                      text: text2,
                      hexColor: "#ffffff",
                    ),
                  ),
                ),
                if (watermarkId == 1698049456677 ||
                    watermarkId == 1698049855544)
                  WatermarkFrameBox(
                    watermarkId: watermarkId,
                    frame: WatermarkFrame(
                        left: 0, top: watermarkData.frame?.top ?? 0),
                    style: watermarkData.style,
                    child: WatermarkGeneralItem(
                      watermarkData: watermarkData,
                      suffix: suffix,
                      templateId: watermarkId,
                      textAlign: TextAlign.justify,
                      text: ":",
                      hexColor: "#ffffff",
                    ),
                  ),
                Expanded(
                  child: WatermarkFrameBox(
                    watermarkId: watermarkId,
                    frame: watermarkData.frame,
                    style: watermarkData.style,
                    child: _buildContentText(
                        latitude, "#ffffff", haveContainerunderline),
                  ),
                )
              ],
            )
          ]);
    });
  }

  Widget _buildContentText(
      String text, String? contentColor, bool haveContainerunderline) {
    return WatermarkGeneralItem(
      watermarkData: watermarkData,
      suffix: suffix,
      templateId: watermarkId,
      containerunderline: haveContainerunderline,
      text: text,
      hexColor: contentColor,
    );
  }
}
