import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class RyWatermarkLocationBox extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RyWatermarkLocationBox({
    super.key,
    required this.watermarkData,
    required this.resource,
  });

  int get watermarkId => resource.id ?? 0;

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
    // WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;

    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];

    final mark = watermarkData.mark;
    final signLine = watermarkData.signLine;
    final titleVisible = watermarkData.isWithTitle;
    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;

    // final markFrame = mark?.frame;
    // if (mark != null && dataFrame != null && markFrame != null) {
    //   if (dataFrame.left != null &&
    //       markFrame.left != null &&
    //       markFrame.width != null) {
    //     dataFrame.left = (dataFrame.left! - markFrame.left! - markFrame.width!).abs();
    //   }
    // }

    Widget imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
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
    return GetBuilder<LocationController>(builder: (logic) {
      return Stack(
        // alignment: Alignment.centerLeft,
        children: [
          mark != null
              ? WatermarkMarkBox(
                  mark: mark,
                )
              : const SizedBox.shrink(),
          WatermarkFrameBox(
              frame: dataFrame,
              style: dataStyle,
              signLine: signLine,
              watermarkData: watermarkData,
              watermarkId: watermarkId,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageWidget,
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: titleVisible ?? false,
                            child: watermarkId == 1698059986262
                                ? Container(
                                    padding: EdgeInsets.only(
                                      left: 5.w,
                                      bottom: 5.h,
                                      right: 5.w,
                                    ),
                                    child: WatermarkFontBox(
                                      textStyle: dataStyle,
                                      text: "${watermarkData.title}",
                                      font: font,
                                    ),
                                  )
                                : watermarkId == 16982153599988
                                    ? Utils.textSpaceBetween(
                                        width: dataStyle?.textMaxWidth?.w,
                                        text: watermarkData.title ?? '',
                                        textStyle: dataStyle,
                                        font: font,
                                        rightSpace: 10.w,
                                        watermarkId: watermarkId)
                                    : WatermarkFontBox(
                                        textStyle: dataStyle,
                                        text: "${watermarkData.title}：",
                                        font: font,
                                      )
                            // Text(
                            //   watermarkId == 1698059986262
                            //       ? "${watermarkData.title}"
                            //       : "${watermarkData.title}：",
                            //   style: TextStyle(
                            //     color: dataStyle?.textColor?.color?.hexToColor(
                            //         dataStyle.textColor?.alpha?.toDouble()),
                            //     fontSize:
                            //         (dataStyle?.fonts?['font']?.size ?? 0).sp,
                            //     fontFamily: dataStyle?.fonts?['font']?.name,
                            //     height: 1
                            //   ),
                            // ),

                            ),
                        Expanded(
                          child: FutureBuilder<String>(
                              future: logic.getDetailAddress(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  String addressText = snapshot.data!;
                                  addressText = getAddressText(addressText);
                                  watermarkData.content = addressText;

                                  return Column(
                                    crossAxisAlignment:
                                        watermarkId == 1698049761079 ||
                                                watermarkId == 1698049776444
                                            ? CrossAxisAlignment.center
                                            : CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      watermarkId == 1698059986262
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  'verticalline'.png,
                                                  //这里找了一上午方法都不行（针对1698059986262，也就是蓝色执勤巡逻水印）
                                                  height: 20.h,
                                                  fit: BoxFit.contain,
                                                ),
                                                Expanded(
                                                    child: Container(
                                                  padding: EdgeInsets.only(
                                                    left: 5.w,
                                                    bottom: 5.h,
                                                    right: 5.w,
                                                  ),
                                                  child: WatermarkFontBox(
                                                      textStyle: dataStyle?.copyWith(
                                                          textColor: watermarkId ==
                                                                  16982153599988
                                                              ? Styles
                                                                  .blackTextColor
                                                              : dataStyle
                                                                  .textColor),
                                                      text: watermarkData
                                                              .content ??
                                                          '',
                                                      font: font),
                                                ))
                                              ],
                                            )
                                          : FutureBuilder(
                                              future: WatermarkService
                                                  .getWatermarkViewByResource<
                                                      WatermarkView>(resource),
                                              builder: (context, snap) {
                                                return WatermarkFontBox(
                                                  textStyle: dataStyle?.copyWith(
                                                      textColor: watermarkId ==
                                                              16982153599988
                                                          ? Styles
                                                              .likeBlackTextColor
                                                          : dataStyle
                                                              .textColor),
                                                  text: addressText,
                                                  font: font,
                                                  // height: 1,
                                                  textAlign: snap.data?.frame
                                                              ?.isCenterX ??
                                                          false
                                                      ? TextAlign.center
                                                      : TextAlign.start,
                                                  isBold: watermarkId ==
                                                      16982153599988,
                                                );
                                                // Text(
                                                //   addressText,
                                                //   style: TextStyle(
                                                //       shadows:
                                                //           // viewShadows,
                                                //           dataStyle?.viewShadow ==
                                                //                   true
                                                //               ? Utils
                                                //                   .getViewShadow()
                                                //               : null,
                                                //       color: watermarkId ==
                                                //               16982153599988
                                                //           ? Colors.black
                                                //           : dataStyle
                                                //               ?.textColor?.color
                                                //               ?.hexToColor(dataStyle
                                                //                   .textColor
                                                //                   ?.alpha
                                                //                   ?.toDouble()),
                                                //       fontSize: (dataStyle
                                                //                   ?.fonts?[
                                                //                       'font']
                                                //                   ?.size ??
                                                //               0)
                                                //           .sp,
                                                //       fontFamily:
                                                //           // "HYQiHeiX2-65W",
                                                //           dataStyle
                                                //               ?.fonts?['font']
                                                //               ?.name,
                                                //       height: 1),
                                                //   textAlign: snap.data?.frame
                                                //               ?.isCenterX ??
                                                //           false
                                                //       ? TextAlign.center
                                                //       : TextAlign.start,
                                                //   // maxLines: 3,
                                                //   softWrap: true,
                                                // );
                                              }),
                                      watermarkId == 16982153599988 ||
                                              watermarkId == 16982153599999
                                          ? Container(
                                              height: 0.8,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: dataStyle
                                                      ?.textColor?.color
                                                      ?.hexToColor(dataStyle
                                                          .textColor?.alpha
                                                          ?.toDouble())),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      );
    });
  }
}
