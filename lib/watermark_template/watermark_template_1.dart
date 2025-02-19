import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_weather.dart';
import 'package:watermark_camera/widgets/watermark_ui/assert_image_builder.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

import 'package:collection/collection.dart';

class WatermarkTemplate1 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;
  final Widget? weatherWidget;

  const WatermarkTemplate1(
      {super.key,
      required this.resource,
      required this.watermarkView,
      this.weatherWidget});

  int get watermarkId => resource.id ?? 0;
  WatermarkData? get timeData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTime');
  WatermarkData? get weatherData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'YWatermarkWeather');
  WatermarkData? get logoData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkBrandLogo');

  WatermarkData? get locationData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkLocation');
  DateTime get timeContent {
    if (timeData?.content != '' && timeData?.content != null) {
      return DateTime.parse(timeData?.content! ?? '');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = timeData?.style?.fonts;
    final font = fonts?['font'];
    final textStyle = timeData?.style;
    final textColor = timeData?.style?.textColor;
    final singleLineFrame = timeData?.signLine?.frame;
    final singleLineStyle = timeData?.signLine?.style;

    final lineStyleImage = "wavyline1b".webp;

    // final timeSpaceWidget = _buildTimeSpaceWidget();
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //时间
          Expanded(
            child: Row(
              children: [
                StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1),
                        (int count) {
                      return formatDate(timeContent, [HH, ':', nn]);
                    }),
                    initialData: formatDate(timeContent, [HH, ':', nn]),
                    builder: (context, snapshot) {
                      return AssertsImageBuilder(
                        watermarkId == 1698049285500 ? lineStyleImage : "",
                        builder: (context, imageInfo) {
                          if (imageInfo != null &&
                              watermarkId == 1698049285500) {
                            return ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) {
                                final image = imageInfo.image;
                                final double scaleX =
                                    bounds.width / image!.width;
                                final double scaleY =
                                    bounds.height / image!.height;
                                // 创建变换矩阵
                                final Matrix4 matrix = Matrix4.identity()
                                  ..scale(scaleX, scaleY);
                                return ImageShader(
                                  imageInfo.image,
                                  TileMode.clamp,
                                  TileMode.clamp,
                                  matrix.storage,
                                );
                              },
                              child: WatermarkFontBox(
                                height: 1,
                                text: snapshot.data ?? '',
                                textStyle: textStyle,
                                font: font,
                              ),
                            );
                          }
                          return WatermarkFontBox(
                            height: 1,
                            text: snapshot.data ?? '',
                            textStyle: textStyle,
                            font: font,
                          );
                        },
                      );
                    }),
                WatermarkFrameBox(
                  watermarkId: watermarkId,
                  frame: singleLineFrame,
                  style: singleLineStyle,
                ),
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WatermarkFontBox(
                          height: 1,
                          text: formatDate(timeContent, [
                            yyyy,
                            '-',
                            mm,
                            "-",
                            dd,
                          ]),
                          font: fonts?['font2'],
                          textStyle: textStyle,
                        ),
                        Row(
                          children: [
                            WatermarkFontBox(
                              text: formatDate(timeContent, [
                                '星期',
                                Lunar.fromDate(timeContent).getWeekInChinese()
                              ]),
                              font: fonts?['font3'],
                              textStyle: textStyle,
                              height: 1,
                            ),
                            Expanded(
                                child: weatherData != null
                                    ? RyWatermarkWeather(
                                        watermarkData: weatherData!,
                                        resource: resource)
                                    : const SizedBox.shrink()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //地点
          Container(
            margin: EdgeInsets.only(top: 4.w),
            child: locationData != null
                ? RyWatermarkLocationBox(
                    watermarkData: locationData!, resource: resource)
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
