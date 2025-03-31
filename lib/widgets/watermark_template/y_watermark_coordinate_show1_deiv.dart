import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/form.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';

class YWatermarkCoordinateShow1Separate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  const YWatermarkCoordinateShow1Separate({
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
    String? titleColor;
    String? contentColor;
    if (watermarkId == 16982153599999 || 16982153599988 == watermarkId) {
      titleColor = "#384f77";
      contentColor = "#3c3942";
    }

    bool haveContainerunderline = FormUtils.haveContainerunderline(watermarkId);
    bool haveColon = FormUtils.haveColon(watermarkId);
    bool havaBlack = FormUtils.haveBlack(watermarkId);
    final signLine = watermarkData.signLine;

    return GetBuilder<LocationController>(builder: (logic) {
      final location = logic.locationResult.value;
      String longitude = location?.longitude?.toStringAsFixed(6) ?? '0.000000';
      String latitude = location?.latitude?.toStringAsFixed(6) ?? '0.000000';
      String text = '经纬度';

      // // 如果content不为空，则显示content
      if (Utils.isNotNullEmptyStr(watermarkData.content)) {
        //需要对content按照,进行分割出精度和维度
        final list = watermarkData.content!.split(',');
        longitude = list[1];
        latitude = list[0];
      } else {
        longitude += "°N";
        latitude += "°E";
      }
      String content = "$longitude,$latitude";

      return Row(
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
                text: text,
                hexColor: titleColor,
              ),
            ),
          ),
          if (haveColon)
            WatermarkFrameBox(
              watermarkId: watermarkId,
              frame: WatermarkFrame(
                  left: 0, top: (watermarkData.frame?.top ?? 0) + 1),
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
          havaBlack == true
              ? const SizedBox(width: 10)
              : const SizedBox.shrink(),
          Expanded(
            child: WatermarkFrameBox(
              watermarkId: watermarkId,
              frame: watermarkData.frame,
              style: watermarkData.style,
              child: _buildContentText(
                  content, contentColor, haveContainerunderline),
            ),
          )
        ],
      );
    });
  }

  Widget _buildContentText(
      String text, String? contentColor, bool haveContainerunderline) {
    return WatermarkGeneralItem(
      watermarkData: watermarkData,
      suffix: suffix,
      templateId: watermarkId,
      containerunderline: haveContainerunderline,
      text: text as String,
      hexColor: contentColor,
    );
  }
}
