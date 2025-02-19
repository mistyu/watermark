import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class WatermarkCustom1Box extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const WatermarkCustom1Box(
      {super.key, required this.watermarkData, required this.resource});
  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    final mark = watermarkData.mark;
    final titleVisible = watermarkData.isWithTitle;

    final signLine = watermarkData.signLine;
    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;
    final bgImg = watermarkData.background;
    // final markFrame = mark?.frame;
    // if (mark != null && dataFrame != null && markFrame != null) {
    //   if (dataFrame.left != null &&
    //       markFrame.left != null &&
    //       markFrame.width != null) {
    //     dataFrame.left = dataFrame.left! - markFrame.left! - markFrame.width!;
    //   }
    // }

    List<Widget> richTextWidgets = [];
    List<Widget> endWidgets = [];
    List<WatermarkRichText> richTextData = dataStyle?.richText ?? [];

    richTextData.sort((a, b) {
      if (a.index == -1) return 1;
      if (b.index == -1) return -1;
      return a.index.compareTo(b.index);
    });

    for (var item in richTextData) {
      var component = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: item.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                margin: item.topSpace >= 0
                    ? EdgeInsets.only(bottom: item.topSpace.abs())
                    : EdgeInsets.only(top: item.topSpace.abs()),
                child: Image.file(
                  File(snapshot.data!),
                  width: dataStyle?.fonts?["font"]?.size?.toDouble(),
                  fit: BoxFit.cover,
                  scale: 0.8,
                ),
              );
            }

            return const SizedBox.shrink();
          });
      if (item.index == -1) {
        endWidgets.add(component);
      } else {
        richTextWidgets.add(component);
      }
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
                    right: (layout?.imageTitleSpace?.abs() ?? 0).w,
                    top: (layout?.imageTopSpace?.abs() ?? 0).h),
                child: Image.file(File(snapshot.data!),
                    height: dataStyle?.iconHeight?.toDouble().h,
                    width: dataStyle?.iconWidth?.toDouble().w,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }
    //watermarkId == 1698059986262（蓝色执勤巡逻水印）
    Widget specialWatermark() {
      return IntrinsicHeight(
        child: Row(
          children: [
            Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: dataStyle?.textColor?.color
                    ?.hexToColor(dataStyle.textColor?.alpha?.toDouble()),
              ),
              child: Visibility(
                  visible: titleVisible ?? false,
                  child: Center(
                    child: WatermarkFontBox(
                        textAlign: TextAlign.center,
                        //height: 1,
                        textStyle: dataStyle?.copyWith(
                            textColor: Styles.whiteTextColor),
                        text: "${watermarkData.title}",
                        font: font),
                  )),
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.w),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: dataStyle?.textColor?.color?.hexToColor(
                              dataStyle.textColor?.alpha?.toDouble()) ??
                          Colors.transparent,
                      width: 2.h)),
              child: WatermarkFontBox(
                textStyle: dataStyle,
                text: watermarkData.content ?? '',
                font: font?.copyWith(size: 10),
                height: 1,
              ),
            ))
          ],
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
        FutureBuilder(
            future: WatermarkService.getImagePath(watermarkId.toString(),
                fileName: bgImg),
            builder: (context, snapshot) {
              // final a=Utils.getTextSize(context: context,text: '施工责任人');
              return WatermarkFrameBox(
                frame: dataFrame,
                style: dataStyle,
                imagePath: snapshot.data,
                child: watermarkId == 1698059986262
                    ? specialWatermark()
                    : Row(
                        // crossAxisAlignment: watermarkId == 1698125672
                        //     ? CrossAxisAlignment.center
                        //     : CrossAxisAlignment.start,
                        children: [
                          imageWidget ?? const SizedBox.shrink(),
                          ...richTextWidgets,
                          Expanded(
                            child: Row(
                              mainAxisAlignment: watermarkId == 1698215359120
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                              // mainAxisAlignment:
                              //     // WrapAlignment.center,
                              //     watermarkView?.frame?.isCenterX ?? false
                              //         ? MainAxisAlignment.center
                              //         : MainAxisAlignment.start,
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
                                            watermarkId: watermarkId,
                                          )
                                        : WatermarkFontBox(
                                            //height: 1,
                                            textStyle: dataStyle,
                                            text: "${watermarkData.title}：",
                                            font: font)

                                    // Text(
                                    //   watermarkId == 1698059986262
                                    //       ? "${watermarkData.title}"
                                    //       : "${watermarkData.title}：",
                                    //   style: TextStyle(
                                    //     color: watermarkId == 1698059986262
                                    //         ? Colors.white
                                    //         : dataStyle?.textColor?.color
                                    //             ?.hexToColor(dataStyle
                                    //                 .textColor?.alpha
                                    //                 ?.toDouble()),
                                    //     fontSize: dataStyle?.fonts?['font']?.size !=
                                    //             null
                                    //         ? (dataStyle?.fonts?['font']!.size?.sp)
                                    //         : null,
                                    //     fontFamily: dataStyle?.fonts?['font']?.name,
                                    //     height: 1
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
                                                      :
                                                      // Color(0xB3ffffff),
                                                      dataStyle.textColor,
                                                ),
                                                text:
                                                    watermarkData.content ?? '',
                                                font: font,
                                                isBold: watermarkId ==
                                                    16982153599988,
                                                //height: 1,
                                              ),
                                            ),
                                            Container(
                                              // margin: EdgeInsets.only(top: 3.w),
                                              height: 0.8,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: dataStyle
                                                      ?.textColor?.color
                                                      ?.hexToColor(dataStyle
                                                          .textColor?.alpha
                                                          ?.toDouble())),
                                            )
                                          ],
                                        )
                                      : WatermarkFontBox(
                                          textStyle: dataStyle,
                                          text: watermarkData.content ?? '',
                                          font: font,
                                          //height: 1,
                                        ),

                                  // Column(
                                  //   crossAxisAlignment:
                                  //       watermarkData.title == '打卡标题'
                                  //           ? CrossAxisAlignment.center
                                  //           : CrossAxisAlignment.start,
                                  //   mainAxisAlignment:
                                  //       watermarkData.title == '打卡标题' ||
                                  //               watermarkId == 1698215359120
                                  //           ? MainAxisAlignment.center
                                  //           : MainAxisAlignment.start,
                                  //   children: [
                                  //     Container(
                                  //       width: double.infinity,
                                  //       decoration: watermarkId ==
                                  //                   16982153599988 ||
                                  //               watermarkId == 16982153599999
                                  //           ? BoxDecoration(
                                  //               border: Border(
                                  //                   bottom: BorderSide(
                                  //                       color: dataStyle
                                  //                               ?.textColor
                                  //                               ?.color
                                  //                               ?.hexToColor(dataStyle
                                  //                                   .textColor
                                  //                                   ?.alpha
                                  //                                   ?.toDouble()) ??
                                  //                           Colors
                                  //                               .transparent)))
                                  //           : null,
                                  //       child: WatermarkFontBox(
                                  //         textStyle: dataStyle?.copyWith(
                                  //           textColor:
                                  //               watermarkId == 16982153599988
                                  //                   ? Styles.blackTextColor
                                  //                   :
                                  //                   // Color(0xB3ffffff),
                                  //                   dataStyle.textColor,
                                  //         ),
                                  //         text: watermarkData.content ?? '',
                                  //         font: font,
                                  //         //height: 1,
                                  //       ),
                                  //     ),

                                  //     // Text(
                                  //     //     watermarkData.content ?? '',
                                  //     //     style: TextStyle(
                                  //     //         shadows:
                                  //     //             // viewShadows,
                                  //     //             dataStyle?.viewShadow == true
                                  //     //                 ? Utils.getViewShadow()
                                  //     //                 : null,
                                  //     //         color: watermarkId ==
                                  //     //                 16982153599988
                                  //     //             ? Colors.black
                                  //     //             :
                                  //     //             // Color(0xB3ffffff),
                                  //     //             dataStyle?.textColor?.color
                                  //     //                 ?.hexToColor(dataStyle
                                  //     //                     .textColor?.alpha
                                  //     //                     ?.toDouble()),
                                  //     //         fontSize: dataStyle
                                  //     //                     ?.fonts?['font']
                                  //     //                     ?.size !=
                                  //     //                 null
                                  //     //             ? (dataStyle?.fonts?['font']!
                                  //     //                 .size?.sp)
                                  //     //             : null,
                                  //     //         fontFamily:
                                  //     //             // 'YouSheBiaoTiHei'
                                  //     //             dataStyle
                                  //     //                 ?.fonts?['font']?.name,
                                  //     //         height: 1),
                                  //     //     softWrap: false,
                                  //     //   ),

                                  //     // watermarkId == 16982153599988 ||
                                  //     //         watermarkId == 16982153599999
                                  //     //     ? Container(
                                  //     //         height: 1,
                                  //     //         width: double.infinity,
                                  //     //         decoration: BoxDecoration(
                                  //     //             color: dataStyle
                                  //     //                 ?.textColor?.color
                                  //     //                 ?.hexToColor(dataStyle
                                  //     //                     .textColor?.alpha
                                  //     //                     ?.toDouble())),
                                  //     //       )
                                  //     //     : const SizedBox.shrink(),
                                  //   ],
                                  // ),
                                )
                              ],
                            ),
                          ),
                          ...endWidgets,
                        ],
                      ),
              );
            }),
      ],
    );
  }
}
