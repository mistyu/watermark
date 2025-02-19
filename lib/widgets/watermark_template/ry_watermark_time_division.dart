import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class RYWatermarkTimeDivision extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTimeDivision(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final style = watermarkData.style;
    final frame = watermarkData.frame;
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    var font2 = fonts?['font2'];
    var gradients = watermarkData.style?.gradient;
    var colors = gradients?.colors;
    var color1 = colors?[0].color?.hexToColor(colors[0].alpha?.toDouble()) ??
        Colors.transparent;
    var color2 = colors?[1].color?.hexToColor(colors[1].alpha?.toDouble()) ??
        Colors.transparent;
    final signlineFrame = watermarkData.signLine?.frame;
    final signlineStyle = watermarkData.signLine?.style;

    Widget alignText(String? text) {
      return WatermarkFrameBox(
        style: style,
        frame: frame,
        watermarkData: watermarkData,
        watermarkId: templateId,
        child: IntrinsicWidth(
          child: Align(
            alignment: templateId == 16986609252222
                ? Alignment.center
                : Alignment.centerRight,
            child: Text(
              text ??
                  formatDate(
                      timeContent,
                      templateId == 16986609252222
                          ? [HH, ':', nn, ':', ss]
                          : [
                              HH,
                              ':',
                              nn,
                            ]),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontFamily: font2?.name,
                fontSize: font?.size?.sp,
              ),
            ),
          ),
        ),
      );
    }

    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1), (int count) {
          return formatDate(
              timeContent,
              templateId == 16986609252222
                  ? [HH, ':', nn, ':', ss]
                  : [
                      HH,
                      ':',
                      nn,
                    ]);
        }),
        builder: (context, snapshot) {
          return Column(
            children: [
              gradients != null
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
                      child: alignText(snapshot.data))
                  : templateId == 1698049451122
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            StreamBuilder(
                                stream: Stream.periodic(
                                    const Duration(seconds: 1), (int count) {
                                  return formatDate(timeContent, [HH, ":", nn]);
                                }),
                                builder: (context, snapshot) {
                                  return WatermarkFontBox(
                                    textStyle: style,
                                    text: snapshot.data ??
                                        formatDate(timeContent, [HH, ":", nn]),
                                    font: font?.copyWith(size: 24),
                                    height: 1.2,
                                  );
                                  // Text(
                                  //   snapshot.data ??
                                  //       formatDate(timeContent, [HH, ":", nn]),
                                  //   style: TextStyle(
                                  //       fontSize: 24.0.sp,
                                  //       fontFamily: fonts?['font']?.name,
                                  //       color: textColor?.color?.hexToColor(
                                  //           textColor.alpha?.toDouble()),
                                  //       height: 1.2),
                                  // );
                                }),
                            WatermarkFrameBox(
                              style: signlineStyle,
                              frame: signlineFrame,
                              watermarkId: templateId,
                            )
                          ],
                        )
                      : alignText(snapshot.data),
            ],
          );
        });
  }
}
