import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
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
    if (Utils.isNotNullEmptyStr(watermarkData.content)) {
      return watermarkData.content!;
    }
    if (Utils.isNotNullEmptyStr(fullAddress)) {
      return fullAddress ?? '中国地址位置定位中';
    }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
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
              text: watermarkData.title,
              hexColor: titleColor,
            ),
          ),
        ),
        Expanded(
          child: WatermarkFrameBox(
              watermarkId: watermarkId,
              frame: watermarkData.frame,
              style: watermarkData.style,
              child: _buildLocationText(contentColor)),
        )
      ],
    );
  }

  Widget _buildLocationText(String? contentColor) {
    return FutureBuilder(
      future: locationLogic.getDetailAddress(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String addressText = snapshot.data as String;
          addressText = getAddressText(addressText);
          watermarkData.content = addressText;
          return WatermarkGeneralItem(
            watermarkData: watermarkData,
            suffix: suffix,
            templateId: watermarkId,
            containerunderline: true,
            hexColor: contentColor,
            text: snapshot.data as String,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
