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

class YWatermarkAltitude extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const YWatermarkAltitude(
      {super.key, required this.watermarkData, required this.resource});
  int get watermarkId => resource.id ?? 0;
  @override
  Widget build(BuildContext context) {
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final mark = watermarkData.mark;
    final titleVisible = watermarkData.isWithTitle;
    final font = dataStyle?.fonts?['font'];

    final signLine = watermarkData.signLine;
    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;

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
                    right: layout?.imageTitleSpace ?? 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble(), fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return Stack(
      alignment: Alignment.centerLeft,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                height: watermarkId == 1698059986262 ? 2.5 : 1)
                        // Text(
                        //   watermarkId == 1698059986262
                        //       ? "${watermarkData.title}"
                        //       : "${watermarkData.title}：",
                        //   style: TextStyle(
                        //       color: dataStyle?.textColor?.color?.hexToColor(
                        //           dataStyle.textColor?.alpha?.toDouble()),
                        //       fontSize: dataStyle?.fonts?['font']?.size?.sp,
                        //       fontFamily: dataStyle?.fonts?['font']?.name,
                        //       height: watermarkId == 1698059986262 ? 2.5 : 1),
                        // ),

                        ),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color:
                                                  signlineStyle?.backgroundColor?.color?.hexToColor(signlineStyle.backgroundColor?.alpha?.toDouble()) ??
                                                      Colors.transparent,
                                              width: signlineFrame?.width ?? 0,
                                              style: ((signlineFrame?.width == null) ||
                                                      (signlineFrame?.width ==
                                                          0))
                                                  ? BorderStyle.none
                                                  : BorderStyle.solid))),
                                  child: WatermarkFontBox(
                                      textStyle: dataStyle?.copyWith(
                                          textColor: watermarkId == 16982153599988
                                              ? Styles.blackTextColor
                                              : dataStyle.textColor),
                                      text: watermarkData.content ?? '',
                                      font: font,
                                      height: watermarkId == 1698059986262 ? 2.5 : 1)
                                  // Text(
                                  //   watermarkData.content ?? '',
                                  //   style: TextStyle(
                                  //       color: watermarkId == 16982153599988
                                  //           ? Colors.black
                                  //           : dataStyle?.textColor?.color
                                  //               ?.hexToColor(dataStyle
                                  //                   .textColor?.alpha
                                  //                   ?.toDouble()),
                                  //       fontSize:
                                  //           dataStyle?.fonts?['font']?.size?.sp,
                                  //       fontFamily:
                                  //           dataStyle?.fonts?['font']?.name,
                                  //       height: watermarkId == 1698059986262
                                  //           ? 2.5
                                  //           : 1.5),
                                  //   softWrap: true,
                                  // ),

                                  )
                              : WatermarkFontBox(
                                  textStyle: dataStyle,
                                  text: watermarkData.content ?? '',
                                  font: font,
                                  // height: 1,
                                ),
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
