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

class YWatermarkNotes extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const YWatermarkNotes(
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

    String title = watermarkData.title!;
    if (resource.id == 1698049875646 && title != null) {
      title += "   ";
    } else {
      title += "：";
    }

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
                    right: (layout?.imageTitleSpace ?? 0).w,
                    top: (layout?.imageTopSpace?.abs() ?? 0).h),
                child: Image.file(File(snapshot.data!),
                    width: (dataStyle?.iconWidth?.toDouble())?.w,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

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
          child: Row(
            children: [
              imageWidget,
              ...richTextWidgets,
              Expanded(
                child: Row(
                  // mainAxisAlignment:
                  //     // WrapAlignment.center,
                  //     watermarkView?.frame?.isCenterX ?? false
                  //         ? MainAxisAlignment.center
                  //         : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: titleVisible ?? false,
                        child: watermarkId == 1698059986262
                            ? Container(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                  top: 10.h,
                                  right: 5.w,
                                ),
                                child: WatermarkFontBox(
                                  textStyle: dataStyle,
                                  text: title,
                                  font: font,
                                ),
                              )
                            : watermarkId == 16982153599988
                                ? Utils.textSpaceBetween(
                                    width: dataStyle?.textMaxWidth?.w,
                                    text: title ?? '',
                                    textStyle: dataStyle,
                                    font: font,
                                    rightSpace: 10.w,
                                    watermarkId: watermarkId)
                                : WatermarkFontBox(
                                    textStyle: dataStyle,
                                    text: title,
                                    font: font,
                                  )),
                    Expanded(
                      child: watermarkId == 16982153599988 ||
                              watermarkId == 16982153599999
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        textColor: watermarkId == 16982153599988
                                            ? Styles.likeBlackTextColor
                                            : dataStyle.textColor),
                                    text: watermarkData.content ?? '',
                                    font: font,
                                    isBold: watermarkId == 16982153599988,
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
                              ? IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'verticalline'.png,
                                        height: 25.h,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 5.w,
                                          top: 10.h,
                                          right: 5.w,
                                        ),
                                        child: WatermarkFontBox(
                                            textStyle: dataStyle?.copyWith(
                                                textColor: watermarkId ==
                                                        16982153599988
                                                    ? Styles.blackTextColor
                                                    : dataStyle.textColor),
                                            text: watermarkData.content ?? '',
                                            font: font),
                                      )
                                    ],
                                  ),
                                )
                              : WatermarkFontBox(
                                  textStyle: dataStyle,
                                  text: watermarkData.content ?? '',
                                  font: font),
                    )
                  ],
                ),
              ),
              ...endWidgets,
            ],
          ),
        ),
      ],
    );
  }
}
