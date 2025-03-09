import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:collection/collection.dart';

class WatermarkTemplate5 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate5({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;
  WatermarkData? get timeDivisionData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTimeDivision');

  WatermarkData? get logoData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkBrandLogo');
  WatermarkData? get titleData => watermarkView.data?.firstWhereOrNull(
      (data) => (data.type == 'YWatermarkCustom1' && data.title == '打卡标题'));
  DateTime get timeContent {
    if (timeDivisionData?.content != '' && timeDivisionData?.content != null) {
      return DateTime.parse(timeDivisionData?.content! ?? '');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final timeStyle = timeDivisionData?.style;
    final fonts = timeStyle?.fonts;
    final font = fonts?['font'];
    final font2 = fonts?['font2'];
    final gradients = timeStyle?.gradient;
    final colors = gradients?.colors;
    final color1 = colors?[0].color?.hexToColor(colors[0].alpha?.toDouble()) ??
        Colors.transparent;
    final color2 = colors?[1].color?.hexToColor(colors[1].alpha?.toDouble()) ??
        Colors.transparent;

    final titleText = titleData?.content;
    final titleStyle = titleData?.style;

    TextStyle? timeTextStyle = TextStyle(
        color: timeStyle?.textColor?.color
            ?.hexToColor(timeStyle.textColor?.alpha?.toDouble()),
        fontFamily:
            // "akshar",
            font?.name,
        // fontWeight: FontWeight.bold,
        fontSize:
            // 24.sp,
            font?.size?.sp,
        height: watermarkId != 16982153599582 ? 1 : null,
        leadingDistribution: TextLeadingDistribution.proportional,
        shadows:
            // timeStyle?.viewShadow == true?
            Utils.getViewShadow(
                color: timeStyle?.textColor?.color?.hexToColor(0.5))
        // : null,
        );
    TextStyle? titleTextStyle = TextStyle(
        color: titleStyle?.textColor?.color
            ?.hexToColor(titleStyle.textColor?.alpha?.toDouble()),
        fontSize:
            // 18.sp,
            titleStyle?.fonts?['font']!.size?.sp,
        fontFamily:
            // 'YouSheBiaoTiHei'
            titleStyle?.fonts?['font']?.name,
        height: 1);

    Widget alignText() {
      return StreamBuilder<String>(
          stream: Stream.periodic(const Duration(seconds: 1), (count) {
            return formatDate(timeContent, [HH, ':', nn]);
          }),
          builder: (context, snap) {
            return Align(
              alignment: watermarkId != 16982153599582
                  ? Alignment.center
                  : Alignment.centerRight,
              child: Text(
                snap.data ??
                    formatDate(timeContent, [
                      HH,
                      ':',
                      nn,
                    ]),
                textAlign: TextAlign.center,
                style: timeTextStyle,
              ),
            );
          });
    }

    return FutureBuilder(
        future: WatermarkService.getImagePath(watermarkId.toString(),
            fileName: timeDivisionData?.background),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final timeTextSize = Utils.getTextSize(
                text: formatDate(timeContent, [
                  HH,
                  ':',
                  nn,
                ]),
                textStyle: timeTextStyle,
                context: context);
            final titleTextSize = Utils.getTextSize(
                text: titleText == '' ? ' ' : titleText,
                textStyle: titleTextStyle,
                context: context);
            return Container(
                // color: Colors.blue,
                height: 35.h,
                width: 100.w,
                padding: watermarkId != 16982153599582
                    ? EdgeInsets.symmetric(horizontal: 4.w)
                    : EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(timeStyle?.radius ?? 0).r,
                  color: snapshot.data == null ? Colors.white : null,
                  image: snapshot.data != null
                      ? DecorationImage(
                          alignment: Alignment.centerLeft,
                          // fit: watermarkId != 16982153599582
                          //     ? BoxFit.fill
                          //     : BoxFit.contain,
                          fit: BoxFit.fill,
                          image: FileImage(File(snapshot.data!)),
                        )
                      : null,
                ),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 打卡
                        Visibility(
                          visible: watermarkId != 16982153599582,
                          child: FutureBuilder(
                              future: WatermarkService.getImagePath(
                                  watermarkId.toString(),
                                  fileName: titleData?.image),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  return Container(
                                    width: titleTextSize.width,
                                    height: titleTextSize.height.h,
                                    // 标题是“打卡”时才会有内边距，显示打卡图片
                                    padding:
                                        titleText != null && titleText != '打卡'
                                            ? null
                                            : EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          // BorderRadius.circular(3)
                                          BorderRadius.circular(
                                                  titleStyle?.radius ?? 0)
                                              .r,
                                      color: titleStyle?.backgroundColor?.color
                                          ?.hexToColor(titleStyle
                                              .backgroundColor?.alpha
                                              ?.toDouble()),
                                      // image: snap.data != null
                                      //     ? DecorationImage(
                                      //         // scale: 0.8,
                                      //         image: FileImage(File(snap.data!),
                                      //             scale: 0.2),
                                      //       )
                                      //     : null,
                                    ),
                                    child:
                                        titleText == '打卡' && snap.data != null
                                            ? Image.file(File(snap.data!))
                                            : Center(
                                                child: Text(
                                                  titleText ?? '',
                                                  // textAlign: TextAlign.center,
                                                  style: titleTextStyle,
                                                ),
                                              ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                        ),
                        // 时间
                        FutureBuilder(
                            future: Utils.calculateImageWidth(
                                imagePath: snapshot.data,
                                height: timeTextSize.height),
                            builder: (context, snap) {
                              return Container(
                                  width: watermarkId != 16982153599582
                                      ? null
                                      : snap.data?.w,
                                  // width: timeTextSize.width.w,
                                  margin: watermarkId != 16982153599582
                                      ? EdgeInsets.only(left: 5.w)
                                      : null,
                                  // height: timeTextSize.height.h,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: gradients != null &&
                                            gradients.colors != null
                                        ? ShaderMask(
                                            shaderCallback: (bouns) {
                                              return LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  stops: [
                                                    gradients.from?["y"] ?? 0.0,
                                                    gradients.to?["y"] ?? 0.0
                                                  ],
                                                  colors: [
                                                    color1,
                                                    color2
                                                  ]).createShader(bouns);
                                            },
                                            child: alignText())
                                        : alignText(),
                                  ));
                            })
                      ]),
                ));
          }
          return const SizedBox.shrink();
        });
  }
}
