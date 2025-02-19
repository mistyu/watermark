import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'RYWatermarkTime.dart';
import 'WatermarkFrame.dart';

class RYWatermarkTimeDivision extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTimeDivision({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int templateId = context.read<WatermarkCubit>().watermarkId;
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
    final signLine_frame = watermarkData.signLine?.frame;
    final signline_style = watermarkData.signLine?.style;

    Widget alignText(String? text) {
      return WatermarkFrameBox(
        style: style,
        frame: frame,
        watermarkData: watermarkData,
        child: Align(
          alignment: templateId == 1698049556633 || templateId == 16986609252222
              ? Alignment.center
              : Alignment.centerRight,
          child: Text(
            text ??
                formatDate(
                    DateTime.now(),
                    templateId == 16986609252222
                        ? [HH, ':', nn, ':', ss]
                        : [
                            HH,
                            ':',
                            nn,
                          ]),
            textAlign: TextAlign.right,
            style: TextStyle(
                color: templateId == 1698049556633
                    ? textColor?.color?.hexToColor(textColor.alpha?.toDouble())
                    : Colors.white,
                fontFamily:
                    templateId == 1698049556633 ? font2?.name : font2?.name,
                fontSize:
                    templateId == 1698049556633 ? font2?.size : font?.size,
                height: 1),
          ),
        ),
      );
    }

    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1), (int count) {
          return formatDate(
              DateTime.now(),
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
              Visibility(
                visible: templateId == 1698049556633,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: "18b4ef".hex,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(5.0.r)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "打卡记录",
                        style: TextStyle(
                            color: Colors.white, fontSize: font?.size),
                      ),
                    ],
                  ),
                ),
              ),
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
                                  return formatDate(
                                      DateTime.now(), [HH, ":", nn]);
                                }),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data ??
                                        formatDate(
                                            DateTime.now(), [HH, ":", nn]),
                                    style: TextStyle(
                                        fontSize: 30.0.sp,
                                        fontFamily: fonts?['font']?.name,
                                        color: textColor?.color?.hexToColor(
                                            textColor.alpha?.toDouble()),
                                        height: 1.2),
                                  );
                                }),
                            WatermarkFrameBox(
                              style: signline_style,
                              frame: signLine_frame,
                            )
                          ],
                        )
                      : alignText(snapshot.data),
            ],
          );
        });
  }
}
