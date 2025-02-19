import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/models/weather/weather.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class RyWatermarkWeather extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  RyWatermarkWeather(
      {super.key, required this.watermarkData, required this.resource});

  final locationLogic = Get.find<LocationController>();

  int get templateId => resource.id ?? 0;

  Future<String> getWeatherText(Weather? weather,
      {bool showTemperature = false, bool showWeather = false}) async {
    if (Utils.isNotNullEmptyStr(watermarkData.content)) {
      return watermarkData.content!;
    }

    final status = await Permission.location.isGranted;
    if (status) {
      final weather = locationLogic.weather.value;
      if (showTemperature && showWeather) {
        if (weather?.weather != null && weather?.temperature != null) {
          return "${weather?.weather} ${weather?.temperature}℃";
        }
        return '';
      }
      if (showTemperature) {
        return "${weather?.temperature}℃";
      }
      if (showWeather) {
        return weather?.weather ?? '';
      }
      return '天气获取中...';
    }
    return '未授权定位.无法获取天气';
  }

// 特殊处理天气文本（有天气图标的水印）
  String? weatherIconText(String? originText) {
    final list = originText?.split(' ');
    //  去掉分离出的在weatherNames中包含的文字
    list?.removeWhere((name) => weatherNames.contains(name));
    final text = list?.join(' ');
    return text;
  }

  String? getWeatherIcon(String? originText) {
    // 找到天气（中文）对应的图片名（英文）索引
    final weatherIndex =
        weatherNames.indexWhere((name) => originText?.contains(name) ?? false);
    // 根据索引再找到图片名称
    final weatherIcon = weatherIcons.elementAtOrNull(
        weatherIndex.isNegative ? weatherIcons.length : weatherIndex);
    return weatherIcon;
  }

  @override
  Widget build(BuildContext context) {
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    final font2 = dataStyle?.fonts?['font2'];
    final font3 = dataStyle?.fonts?['font3'];
    final mark = watermarkData.mark;
    final titleVisible = watermarkData.isWithTitle;

    Widget imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(templateId.toString(),
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
      return Stack(
        // alignment:
        // templateId == 1698049285500
        //     ? Alignment.bottomRight
        //     :
        // Alignment.centerLeft,
        children: [
          mark != null
              ? WatermarkMarkBox(
                  mark: mark,
                )
              : const SizedBox.shrink(),
          WatermarkFrameBox(
              frame: dataFrame,
              style: dataStyle,
              watermarkId: templateId,
              child: Row(
                children: [
                  imageWidget,
                  Visibility(
                      visible: titleVisible ?? false,
                      child: templateId == 16982153599988
                          ? Utils.textSpaceBetween(
                              width: dataStyle?.textMaxWidth?.w,
                              text: watermarkData.title ?? '',
                              textStyle: dataStyle,
                              font: font,
                              rightSpace: 10.w,
                              watermarkId: templateId)
                          : WatermarkFontBox(
                              textStyle: dataStyle,
                              text: "${watermarkData.title}：",
                              font: font,
                              // height: 1
                            )
                      // Text(
                      //   "${watermarkData.title}：",
                      //   style: TextStyle(
                      //       color: dataStyle?.textColor?.color?.hexToColor(
                      //           dataStyle.textColor?.alpha?.toDouble()),
                      //       fontSize: (dataStyle?.fonts?['font']?.size ?? 0).sp,
                      //       fontFamily: dataStyle?.fonts?['font']?.name,
                      //       height: 1),
                      // ),

                      ),
                  templateId == 16983178686921
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FutureBuilder(
                                future: getWeatherText(logic.weather.value,
                                    showTemperature: true),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final weatherText = snapshot.data as String;
                                    return Text(
                                      // '20~37℃',
                                      weatherText.replaceAll('℃', '°'),
                                      style: TextStyle(
                                        fontSize: (font?.size ?? 0).sp,
                                        fontFamily: font?.name,
                                        color: dataStyle?.textColor?.color
                                            ?.hexToColor(dataStyle
                                                .textColor?.alpha
                                                ?.toDouble()),
                                        // height: 1
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                            FutureBuilder(
                                future: getWeatherText(logic.weather.value,
                                    showWeather: true),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final weatherText = snapshot.data as String;
                                    return Text(
                                      weatherText,
                                      style: TextStyle(
                                          fontSize: (font2?.size ?? 0).sp,
                                          fontFamily: font2?.name,
                                          color: dataStyle?.textColor?.color
                                              ?.hexToColor(dataStyle
                                                  .textColor?.alpha
                                                  ?.toDouble()),
                                          height: 2),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                          ],
                        )
                      : Expanded(
                          child: templateId == 16982153599988 ||
                                  templateId == 16982153599999
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FutureBuilder(
                                        future: getWeatherText(
                                            logic.weather.value,
                                            showTemperature: true,
                                            showWeather: true),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            String? weatherText =
                                                snapshot.data as String;
                                            return WatermarkFontBox(
                                              textStyle: dataStyle?.copyWith(
                                                  textColor: templateId ==
                                                          16982153599988
                                                      ? Styles
                                                          .likeBlackTextColor
                                                      : dataStyle.textColor),
                                              text: weatherText ?? '',
                                              font: font,
                                              isBold:
                                                  templateId == 16982153599988,
                                              // height: 1,
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }),
                                    Container(
                                      height: 0.8,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: dataStyle?.textColor?.color
                                              ?.hexToColor(dataStyle
                                                  .textColor?.alpha
                                                  ?.toDouble())),
                                    ),
                                  ],
                                )
                              : FutureBuilder(
                                  future: getWeatherText(logic.weather.value,
                                      showTemperature: true, showWeather: true),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String? weatherText =
                                          snapshot.data as String;
                                      String? weatherIcon;
                                      if (templateId == 1698049876666) {
                                        weatherText =
                                            weatherIconText(snapshot.data);
                                        weatherIcon =
                                            getWeatherIcon(snapshot.data);
                                      }
                                      return Row(
                                        children: [
                                          weatherIcon != null &&
                                                  templateId == 1698049876666
                                              ? Row(
                                                  children: [
                                                    Image.asset(
                                                      weatherIcon.png,
                                                      fit: BoxFit.fitHeight,
                                                      height:
                                                          (font?.size?.sp ?? 0),
                                                    ),
                                                    4.w.horizontalSpace,
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                          WatermarkFontBox(
                                            textStyle: dataStyle?.copyWith(
                                                textColor:
                                                    templateId == 16982153599988
                                                        ? Styles.blackTextColor
                                                        : dataStyle.textColor),
                                            text: weatherText ?? '',
                                            font: font,
                                            // height: 1,
                                          )
                                          // Text(
                                          //   weatherText ?? '',
                                          //   style: TextStyle(
                                          //       fontSize: font?.size?.sp,
                                          //       fontFamily: font?.name,
                                          //       color: templateId ==
                                          //               16982153599988
                                          //           ? Colors.black
                                          //           : dataStyle
                                          //               ?.textColor?.color
                                          //               ?.hexToColor(dataStyle
                                          //                   .textColor?.alpha
                                          //                   ?.toDouble()),
                                          //       height: 1),
                                          // )
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),
                        ),
                ],
              ))
        ],
      );
    });
  }
}
