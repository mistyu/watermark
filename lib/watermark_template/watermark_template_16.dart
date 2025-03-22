import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:collection/collection.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watemark_time.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location_new.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_weather.dart';
import 'package:watermark_camera/widgets/watermark_template/watermark_custom1.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_altitude.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_coordinate.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_notes.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class WatermarkTemplate16 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate16({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  String getAddressText(String? fullAddress) {
    // 检查自定义内容
    if (Utils.isNotNullEmptyStr(locationData?.content)) {
      return locationData?.content! ?? '';
    }

    // 检查地址是否有效
    if (Utils.isNotNullEmptyStr(fullAddress) &&
        !fullAddress!.contains("null")) {
      return fullAddress;
    }

    // 默认返回
    return '中国地址位置定位中';
  }

  int get watermarkId => resource.id ?? 0;
  WatermarkData? get timeData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == watermarkTimeType);

  WatermarkData? get titleData => watermarkView.data
      ?.firstWhereOrNull((data) => (data.type == watermarkTitleType));

  WatermarkData? get locationData => watermarkView.data
      ?.firstWhereOrNull((data) => (data.type == watermarkLocationType));

  WatermarkData? get signInData => watermarkView.data
      ?.firstWhereOrNull((data) => (data.type == watermarkSignInType));

  Map<String, WatermarkTable>? get tables => watermarkView.tables;

  DateTime get timeContent {
    if (timeData?.content != '' && timeData?.content != null) {
      return DateTime.parse(timeData?.content! ?? '');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    LocationController logic = Get.find<LocationController>();
    final timeStyle = timeData?.style;
    final fonts = timeStyle?.fonts;
    final font = fonts?['font'];
    final dataStyle = locationData?.style;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //时间展示部分
        RYWatermarkTime21(
          watermarkData: timeData!,
          resource: resource,
        ),

        // //右边的部分 （签名 + 地址）
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSignInBox(signInData, logic),
              _buildLocationBox(locationData, logic),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSignInBox(WatermarkData? data, LocationController logic) {
    final watermarkData = data;
    final dataStyle = watermarkData?.style;
    final image = watermarkData?.image;

    return WatermarkFrameBox(
        frame: watermarkData?.frame,
        style: dataStyle,
        signLine: watermarkData?.signLine,
        watermarkData: watermarkData,
        watermarkId: watermarkId,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WatermarkFontBox(
              text: watermarkData?.title ?? '',
              textStyle: data?.style,
              font: dataStyle?.fonts?['font'],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: Color(int.parse("#ffffff".replaceAll("#", "0xFF")))),
            ),
            WatermarkFontBox(
              text: watermarkData?.content ?? '',
              textStyle: data?.style,
              font: dataStyle?.fonts?['font'],
            ),
          ],
        ));
  }

  Widget _buildLocationBox(WatermarkData? data, LocationController logic) {
    final watermarkData = data;
    final dataStyle = watermarkData?.style;
    final image = watermarkData?.image;

    Widget imageWidget = const SizedBox.shrink();
    if (image != null && image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = dataStyle?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right:
                        // 5.w,
                        (layout?.imageTitleSpace ?? 0).w,
                    top: (layout?.imageTopSpace?.abs() ?? 0).h),
                child: Image.file(File(snapshot.data!),
                    width: (dataStyle?.iconWidth?.toDouble() ?? 0).w,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }
    return FutureBuilder<String>(
        future: logic.getDetailAddress(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String addressText = logic.getFormatAddress(watermarkId) ?? '';

            addressText = getAddressText(addressText);
            data?.content = addressText;
            String textContent = data?.content ?? '';
            return WatermarkFrameBox(
                frame: watermarkData?.frame,
                style: data?.style,
                signLine: watermarkData?.signLine,
                watermarkData: watermarkData,
                watermarkId: watermarkId,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageWidget,
                    Expanded(
                      child: WatermarkFontBox(
                        text: textContent,
                        textStyle: data?.style,
                        isSingleLine: watermarkId == 1698049556633,
                        font: data?.style?.fonts?['font'],
                        isBold: watermarkId == 16982153599582,
                      ),
                    ),
                  ],
                ));
          }
          return const SizedBox.shrink();
        });
  }
}
