import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/form.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class YWatermarLoactionSeparate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  const YWatermarLoactionSeparate({
    super.key,
    required this.watermarkData,
    required this.resource,
    this.suffix,
  });

  int get watermarkId => resource.id ?? 0;

  LocationController get locationLogic => Get.find<LocationController>();

  String getAddressText(String? fullAddress) {
    // 检查自定义内容
    if (Utils.isNotNullEmptyStr(watermarkData?.content)) {
      return watermarkData?.content! ?? '';
    }

    // 检查地址是否有效
    if (Utils.isNotNullEmptyStr(fullAddress) &&
        !fullAddress!.contains("null")) {
      print("xiaojianjian 地址，地址中存在null: $fullAddress");
      return fullAddress;
    }

    // 默认返回
    return '中国地址位置定位中';
  }

  @override
  Widget build(BuildContext context) {
    // 获取frame的宽度，如果没有则使用默认值
    final frameWidth = watermarkData.frame?.width?.toDouble() ?? 200.w;
    String? titleColor;
    String? contentColor;
    if (watermarkId == 16982153599999) {
      titleColor = "#45526c";
      contentColor = "#3c3942";
    }
    bool haveContainerunderline = FormUtils.haveContainerunderline(watermarkId);
    bool haveColon = FormUtils.haveColon(watermarkId);
    String titleText = watermarkData.title ?? "";

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
              text: titleText,
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
        Expanded(
          child: WatermarkFrameBox(
              watermarkId: watermarkId,
              frame: watermarkData.frame,
              style: watermarkData.style,
              child: _buildLocationText(contentColor, haveContainerunderline)),
        )
      ],
    );
  }

  Widget _buildLocationText(String? contentColor, bool haveContainerunderline) {
    return FutureBuilder(
      future: locationLogic.getDetailAddress(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String addressText =
              locationLogic.getFormatAddress(watermarkId) ?? '';
          addressText = getAddressText(addressText);
          watermarkData.content = addressText;
          return WatermarkGeneralItem(
            watermarkData: watermarkData,
            suffix: suffix,
            templateId: watermarkId,
            containerunderline: haveContainerunderline,
            hexColor: contentColor,
            text: snapshot.data as String,
          );
        }
        return WatermarkGeneralItem(
          watermarkData: watermarkData,
          suffix: suffix,
          templateId: watermarkId,
          containerunderline: haveContainerunderline,
          hexColor: contentColor,
          text: "中国地址位置定位中",
        );
      },
    );
  }
}
