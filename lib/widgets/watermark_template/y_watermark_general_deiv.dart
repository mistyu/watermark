import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/form.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font_spe.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class YWatermarTableGeneralSeparate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  String? titleColor;
  String? contentColor;
  String? tableKey;
  final locationLogic = Get.find<LocationController>();
  YWatermarTableGeneralSeparate({
    super.key,
    required this.watermarkData,
    required this.resource,
    this.suffix,
    this.tableKey,
  });

  int get watermarkId => resource.id ?? 0;

  // 新增特殊布局Widget --- title(两端对齐无法实现) + content
  // Widget buildSpecialLayout({
  //   required String title,
  //   required String content,
  //   required double maxWidth,
  //   required double titleWidth,
  // }) {
  //   return Container(
  //     width: maxWidth,
  //     child: RichText(
  //       text: TextSpan(
  //         children: [
  //           WidgetSpan(
  //             child: Container(
  //               width: titleWidth,
  //               child: Text(
  //                 title,
  //                 textAlign: TextAlign.justify,
  //                 style: TextStyle(
  //                   fontSize: 14.sp,
  //                   height: 1.5,
  //                   color: Styles.c_FFFFFF,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           TextSpan(
  //             text: content,
  //             style: TextStyle(
  //               fontSize: 14.sp,
  //               height: 1.5,
  //               color: Styles.c_FFFFFF,
  //             ),
  //           ),
  //         ],
  //       ),
  //       textAlign: TextAlign.left,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // 获取frame的宽度，如果没有则使用默认值
    final frameWidth = watermarkData.frame?.width?.toDouble() ?? 200.w;

    if (watermarkId == 16982153599999) {
      titleColor = "#45526c";
      contentColor = "#3c3942";
      if (tableKey == "table2") {
        titleColor = "#ebd7a6";
        contentColor = "#ffffff";
      }
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
                left: 0, top: (watermarkData.frame?.top ?? 0) + 2),
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
            child: _buildGeneralText(
                titleText, contentColor, haveContainerunderline),
          ),
        )
      ],
    );
  }

  Widget _buildGeneralText(
      String? titleText, String? contentColor, bool haveContainerunderline) {
    if (titleText != "方位角") {
      return WatermarkGeneralItem(
        watermarkData: watermarkData,
        suffix: suffix,
        templateId: watermarkId,
        containerunderline: haveContainerunderline,
        text: watermarkData.content ?? '',
        hexColor: contentColor,
      );
    }
    return FutureBuilder(
      future: locationLogic.getCompass(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double heading =
              locationLogic.normalizeHeading(double.parse(snapshot.data!));

          String angle = heading.toStringAsFixed(2);
          String direction =
              locationLogic.getDirectionFromHeading(double.parse(angle));
          String text = "$direction-$angle";

          if (Utils.isNotNullEmptyStr(watermarkData.content)) {
            text = "${watermarkData.content}";
          }

          return WatermarkGeneralItem(
            watermarkData: watermarkData,
            suffix: suffix,
            templateId: watermarkId,
            containerunderline: haveContainerunderline,
            text: text,
            hexColor: contentColor,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
