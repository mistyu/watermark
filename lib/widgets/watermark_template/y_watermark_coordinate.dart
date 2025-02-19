import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class YWatermarkCoordinate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final WatermarkView? watermarkView;

  YWatermarkCoordinate(
      {super.key,
      required this.watermarkData,
      required this.resource,
      required this.watermarkView});
  int get watermarkId => resource.id ?? 0;
  final locationLogic = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    final titleVisible = watermarkData.isWithTitle;
    final content = watermarkData.content;
    final mark = watermarkData.mark;
    final isSplit = watermarkData.isSplit;
    final signLine = watermarkData.signLine;
    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;

    String editLongitude = '';
    String editLatitude = '';
    if (content != null && content != '') {
      List<String> parts = content.split(',');
      editLongitude = parts[0];
      editLatitude = parts[1];
    }

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = dataStyle?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right: (layout?.imageTitleSpace ?? 0).w,
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
      final location = logic.locationResult.value;
      final longitude = location?.longitude?.toStringAsFixed(6);
      final latitude = location?.latitude?.toStringAsFixed(6);
      if (Utils.isNullEmptyStr(longitude) || Utils.isNullEmptyStr(latitude)) {
        return Text(
          '未获取到经纬度',
          style: TextStyle(
            color: dataStyle?.textColor?.color
                ?.hexToColor(dataStyle.textColor?.alpha?.toDouble()),
            fontSize: (dataStyle?.fonts?['font']?.size ?? 0).sp,
            fontFamily: dataStyle?.fonts?['font']?.name ?? defultFontFamily,
            // height: 1
          ),
        );
      }

      return Stack(
        // alignment: Alignment.centerLeft,
        children: [
          mark != null
              ? WatermarkMarkBox(
                  mark: mark,
                )
              : const SizedBox.shrink(),
          isSplit ?? false
              ? Column(
                  children: [
                    WatermarkFrameBox(
                      watermarkData: watermarkData,
                      style: dataStyle,
                      frame: dataFrame,
                      child: Row(
                        children: [
                          Visibility(
                              visible: titleVisible ?? false,
                              child: WatermarkFontBox(
                                textStyle: dataStyle,
                                text: watermarkId == 1698049443671
                                    ? "经度 "
                                    : (watermarkId == 16983971077788 ||
                                            watermarkId == 16983971079955 ||
                                            watermarkView?.viewType ==
                                                'RYViewTypeFour'
                                        ? "经\u3000\u3000度："
                                        : "经度："),
                                font: font,
                                //height: 1
                              )
                              // Text(
                              //   watermarkId == 1698049443671
                              //       ? "经度 "
                              //       : (watermarkId == 16983971077788 ||
                              //               watermarkId == 16983971079955 ||
                              //               watermarkView?.viewType ==
                              //                   'RYViewTypeFour'
                              //           ? "经\u3000\u3000度："
                              //           : "经度："),
                              //   softWrap: true,
                              //   style: TextStyle(
                              //       color: dataStyle?.textColor?.color
                              //           ?.hexToColor(dataStyle.textColor?.alpha
                              //               ?.toDouble()),
                              //       fontSize:
                              //           (dataStyle?.fonts?['font']?.size ?? 0).sp,
                              //       fontFamily: dataStyle?.fonts?['font']?.name ??
                              //           defultFontFamily,
                              //       height: 1),
                              // ),

                              ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WatermarkFontBox(
                                  textStyle: dataStyle?.copyWith(
                                      textColor: watermarkId == 16982153599988
                                          ? Styles.blackTextColor
                                          : dataStyle.textColor),
                                  text: watermarkData.content != null &&
                                          watermarkData.content != ''
                                      ? editLongitude
                                      : longitude.toString(),
                                  font: font,
                                  //height: 1
                                ),
                                // Text(
                                //   watermarkData.content != null &&
                                //           watermarkData.content != ''
                                //       ? editLongitude
                                //       : longitude.toString(),
                                //   softWrap: true,
                                //   style: TextStyle(
                                //       color: watermarkId == 16982153599988
                                //           ? Colors.black
                                //           : dataStyle?.textColor?.color
                                //               ?.hexToColor(dataStyle
                                //                   .textColor?.alpha
                                //                   ?.toDouble()),
                                //       fontSize:
                                //           (dataStyle?.fonts?['font']?.size ?? 0)
                                //               .sp,
                                //       fontFamily:
                                //           // "HarmonyOS_Sans"
                                //           // "Wechat_regular"
                                //           dataStyle?.fonts?['font']?.name ??
                                //               defultFontFamily,
                                //       height: 1),
                                // ),

                                watermarkId == 16982153599988
                                    ? Container(
                                        height: 1,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: dataStyle?.textColor?.color
                                                ?.hexToColor(dataStyle
                                                    .textColor?.alpha
                                                    ?.toDouble())),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    WatermarkFrameBox(
                      style: dataStyle,
                      frame: dataFrame,
                      watermarkData: watermarkData,
                      child: Row(
                        children: [
                          Visibility(
                              visible: titleVisible ?? false,
                              child: WatermarkFontBox(
                                textStyle: dataStyle,
                                text: watermarkId == 1698049443671
                                    ? "纬度 "
                                    : (watermarkId == 16983971077788 ||
                                            watermarkId == 16983971079955 ||
                                            watermarkView?.viewType ==
                                                'RYViewTypeFour'
                                        ? "纬\u3000\u3000度："
                                        : "纬度："),
                                font: font,
                                //height: 1
                              )
                              // Text(
                              //   watermarkId == 1698049443671
                              //       ? "纬度 "
                              //       : (watermarkId == 16983971077788 ||
                              //               watermarkId == 16983971079955 ||
                              //               watermarkView?.viewType ==
                              //                   'RYViewTypeFour'
                              //           ? "纬\u3000\u3000度："
                              //           : "纬度："),
                              //   softWrap: true,
                              //   style: TextStyle(
                              //       color: dataStyle?.textColor?.color
                              //           ?.hexToColor(dataStyle.textColor?.alpha
                              //               ?.toDouble()),
                              //       fontSize:
                              //           (dataStyle?.fonts?['font']?.size ?? 0).sp,
                              //       fontFamily: dataStyle?.fonts?['font']?.name ??
                              //           defultFontFamily,
                              //       height: 1),
                              // ),

                              ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WatermarkFontBox(
                                  textStyle: dataStyle?.copyWith(
                                      textColor: watermarkId == 16982153599988
                                          ? Styles.blackTextColor
                                          : dataStyle.textColor),
                                  text: watermarkData.content != null &&
                                          watermarkData.content != ''
                                      ? editLatitude.trim()
                                      : latitude.toString(),
                                  font: font,
                                  //height: 1,
                                ),
                                // Text(
                                //   watermarkData.content != null &&
                                //           watermarkData.content != ''
                                //       ? editLatitude
                                //       : latitude.toString(),
                                //   softWrap: true,
                                //   style: TextStyle(
                                //       color: watermarkId == 16982153599988
                                //           ? Colors.black
                                //           : dataStyle?.textColor?.color
                                //               ?.hexToColor(dataStyle
                                //                   .textColor?.alpha
                                //                   ?.toDouble()),
                                //       fontSize:
                                //           (dataStyle?.fonts?['font']?.size ?? 0)
                                //               .sp,
                                //       fontFamily:
                                //           dataStyle?.fonts?['font']?.name ??
                                //               defultFontFamily,
                                //       height: 1),
                                // ),

                                watermarkId == 16982153599988
                                    ? Container(
                                        height: 1,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: dataStyle?.textColor?.color
                                                ?.hexToColor(dataStyle
                                                    .textColor?.alpha
                                                    ?.toDouble())),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : WatermarkFrameBox(
                  style: dataStyle,
                  frame: dataFrame,
                  watermarkData: watermarkData,
                  child: Row(
                    children: [
                      imageWidget ?? const SizedBox.shrink(),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible: titleVisible ?? false,
                                child: watermarkId == 16982153599988
                                    ? Utils.textSpaceBetween(
                                        width: dataStyle?.textMaxWidth?.w,
                                        text: watermarkData.title ?? '',
                                        textStyle: dataStyle,
                                        font: font,
                                        rightSpace: 10.w,
                                        watermarkId: watermarkId)
                                    : WatermarkFontBox(
                                        textStyle: dataStyle,
                                        text: watermarkId == 1698059986262
                                            ? "${watermarkData.title}"
                                            : "${watermarkData.title}：",
                                        font: font,
                                        //height: 1,
                                      )
                                // Text(
                                //   watermarkId == 1698059986262
                                //       ? "${watermarkData.title}"
                                //       : "${watermarkData.title}：",
                                //   style: TextStyle(
                                //     color: dataStyle?.textColor?.color
                                //         ?.hexToColor(dataStyle.textColor?.alpha
                                //             ?.toDouble()),
                                //     fontSize:
                                //         (dataStyle?.fonts?['font']?.size ?? 0).sp,
                                //     fontFamily: dataStyle?.fonts?['font']?.name ??
                                //         defultFontFamily,
                                //     // height: 1
                                //   ),
                                // ),

                                ),
                            Expanded(
                              child: watermarkId == 16982153599988 ||
                                      watermarkId == 16982153599999
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          // decoration: BoxDecoration(
                                          //     border: Border(
                                          //         bottom: BorderSide(
                                          //   color:
                                          //       // Color.fromRGBO(145, 146, 147, 1)
                                          //       watermarkId ==
                                          //               16982153599988
                                          //           ? "848c89".hex
                                          //           : dataStyle?.textColor
                                          //                   ?.color
                                          //                   ?.hexToColor(dataStyle
                                          //                       .textColor
                                          //                       ?.alpha
                                          //                       ?.toDouble()) ??
                                          //               Colors.transparent,
                                          // ))),
                                          child: WatermarkFontBox(
                                            textStyle: dataStyle?.copyWith(
                                                textColor: watermarkId ==
                                                        16982153599988
                                                    ? Styles.likeBlackTextColor
                                                    : dataStyle.textColor),
                                            text: watermarkData.content != ''
                                                ? watermarkData.content ?? ''
                                                : '${latitude.toString()}°N,${longitude.toString()}°E',
                                            font: font,
                                            isBold:
                                                watermarkId == 16982153599988,
                                            // height: 1,
                                          ),
                                        ),
                                        Container(
                                          // margin: EdgeInsets.only(top: 3.w),
                                          height: 0.8,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: dataStyle?.textColor?.color
                                                  ?.hexToColor(dataStyle
                                                      .textColor?.alpha
                                                      ?.toDouble())),
                                        )
                                      ],
                                    )
                                  : watermarkId == 1698059986262
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.w),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: signlineStyle
                                                              ?.backgroundColor
                                                              ?.color
                                                              ?.hexToColor(signlineStyle
                                                                  .backgroundColor
                                                                  ?.alpha
                                                                  ?.toDouble()) ??
                                                          Colors.transparent,
                                                      width: signlineFrame?.width ??
                                                          0,
                                                      style: ((signlineFrame?.width == null) ||
                                                              (signlineFrame?.width == 0))
                                                          ? BorderStyle.none
                                                          : BorderStyle.solid))),
                                          child: WatermarkFontBox(
                                            textStyle: dataStyle,
                                            text: watermarkData.content != ''
                                                ? watermarkData.content ?? ''
                                                : '${latitude.toString()}°N,${longitude.toString()}°E',
                                            font: font,
                                            // height: 1,
                                          ))
                                      : WatermarkFontBox(
                                          textStyle: dataStyle,
                                          text: watermarkData.content != ''
                                              ? watermarkData.content ?? ''
                                              : '${latitude.toString()}°N,${longitude.toString()}°E',
                                          font: font,
                                          // height: 1,
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      );
    });
  }
}

// class YWatermarkLongitude extends StatelessWidget {
//   final WatermarkData watermarkData;
//   const YWatermarkLongitude({super.key, required this.watermarkData});

//   @override
//   Widget build(BuildContext context) {
//     int watermarkId = context.read<WatermarkCubit>().watermarkId;
//     final dataFrame = watermarkData.frame;
//     final dataStyle = watermarkData.style;
//     final titleVisible = watermarkData.isWithTitle;
//     // final longitude = '139.0000';

//     return LocationViewBuilder(builder: (context, snap) {
//       final longitude = snap.location?['longitude'];
//       return WatermarkFrameBox(
//         style: dataStyle,
//         frame: dataFrame,
//         child: Row(
//           children: [
//             Visibility(
//               visible: titleVisible ?? false,
//               child: Text(
//                 "${watermarkData.title}：",
//                 softWrap: true,
//                 style: TextStyle(
//                   color: dataStyle?.textColor?.color
//                       ?.hexToColor(dataStyle.textColor?.alpha?.toDouble()),
//                   fontSize: dataStyle?.fonts?['font']?.size,
//                   fontFamily: dataStyle?.fonts?['font']?.name,
//                   // height: 1
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     watermarkData.content != null && watermarkData.content != ''
//                         ? watermarkData.content ?? ''
//                         : longitude.toString(),
//                     softWrap: true,
//                     style: TextStyle(
//                       color: watermarkId == 16982153599988
//                           ? Colors.black
//                           : dataStyle?.textColor?.color?.hexToColor(
//                               dataStyle.textColor?.alpha?.toDouble()),
//                       fontSize: dataStyle?.fonts?['font']?.size,
//                       fontFamily: dataStyle?.fonts?['font']?.name,
//                       // height: 1
//                     ),
//                   ),
//                   watermarkId == 16982153599988
//                       ? Container(
//                           height: 1,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: dataStyle?.textColor?.color?.hexToColor(
//                                   dataStyle.textColor?.alpha?.toDouble())),
//                         )
//                       : const SizedBox.shrink(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class YWatermarkLatitude extends StatelessWidget {
//   final WatermarkData watermarkData;
//   const YWatermarkLatitude({super.key, required this.watermarkData});

//   @override
//   Widget build(BuildContext context) {
//     int watermarkId = context.read<WatermarkCubit>().watermarkId;
//     final dataFrame = watermarkData.frame;
//     final dataStyle = watermarkData.style;
//     final titleVisible = watermarkData.isWithTitle;
//     // final latitude = '139.0000';

//     return LocationViewBuilder(builder: (context, snap) {
//       final latitude = snap.latitude;
//       return WatermarkFrameBox(
//         style: dataStyle,
//         frame: dataFrame,
//         child: Row(
//           children: [
//             Visibility(
//                 visible: titleVisible ?? false,
//                 child: WatermarkTimeTypeFont(
//                   text: "${watermarkData.title}：",
//                   font: dataStyle?.fonts?['font'],
//                   textColor: dataStyle?.textColor,
//                 )),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     watermarkData.content != null && watermarkData.content != ''
//                         ? watermarkData.content ?? ''
//                         : latitude.toString(),
//                     softWrap: true,
//                     style: TextStyle(
//                         color: watermarkId == 16982153599988
//                             ? Colors.black
//                             : dataStyle?.textColor?.color?.hexToColor(
//                                 dataStyle.textColor?.alpha?.toDouble()),
//                         fontSize: dataStyle?.fonts?['font']?.size,
//                         fontFamily: dataStyle?.fonts?['font']?.name,
//                         height: 1),
//                   ),
//                   watermarkId == 16982153599988
//                       ? Container(
//                           height: 1,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: dataStyle?.textColor?.color?.hexToColor(
//                                   dataStyle.textColor?.alpha?.toDouble())),
//                         )
//                       : const SizedBox.shrink(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
