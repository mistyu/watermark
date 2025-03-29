import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/models/weather/weather.dart';
import 'package:watermark_camera/utils/form.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:watermark_camera/utils/weatherUtil.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class YWatermarWatherSeparate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  YWatermarWatherSeparate({
    super.key,
    required this.watermarkData,
    required this.resource,
    this.suffix,
  });

  int get watermarkId => resource.id ?? 0;

  final locationLogic = Get.find<LocationController>();

  Future<String> getWeatherText(Weather? weather,
      {bool showTemperature = false, bool showWeather = false}) async {
    if (Utils.isNotNullEmptyStr(watermarkData.content)) {
      //watermarkData.content的格式是"icon:$weatherIcon;temperature:$temperature;temperaturewindDirection:$windDirection";
      return watermarkData.content!;
    }

    final status = await Permission.location.isGranted;
    if (status) {
      final weather = locationLogic.weather.value;
      if (weather?.weather == null) {
        return WeatherUtils.defaultWeather(watermarkId);
      }
      if (showTemperature && showWeather) {
        if (weather?.weather != null && weather?.temperature != null) {
          return "${weather?.weather} ${weather?.temperature}°";
        }
        return WeatherUtils.defaultWeather(watermarkId);
      }
      if (showTemperature) {
        return "${weather?.temperature}℃";
      }
      if (showWeather) {
        return weather?.weather ?? '';
      }
      return WeatherUtils.defaultWeather(watermarkId);
    }
    return WeatherUtils.defaultWeather(watermarkId);
  }

  @override
  Widget build(BuildContext context) {
    // 获取frame的宽度，如果没有则使用默认值
    final frameWidth = watermarkData.frame?.width?.toDouble() ?? 200.w;
    String? titleColor;
    String? contentColor;
    if (watermarkId == 16982153599999) {
      titleColor = "#45526c";
      contentColor = "#3c3942";
    }

    String titleText = watermarkData.title ?? "";

    bool haveContainerunderline = FormUtils.haveContainerunderline(watermarkId);
    bool haveColon = FormUtils.haveColon(watermarkId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //标题
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
            minWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
          ),
          child: WatermarkFrameBox(
            watermarkId: watermarkId,
            frame: watermarkData.frame,
            style: watermarkData.style,
            child: WatermarkGeneralItem(
              watermarkData: watermarkData,
              suffix: suffix,
              templateId: watermarkId,
              textAlign: TextAlign.justify,
              text: titleText,
              hexColor: titleColor,
            ),
          ),
        ),
        //内容
        if (haveColon)
          WatermarkFrameBox(
            watermarkId: watermarkId,
            frame: WatermarkFrame(
                left: 0, top: (watermarkData.frame?.top ?? 0) + 1),
            style: watermarkData.style,
            child: WatermarkGeneralItem(
              watermarkData: watermarkData,
              suffix: suffix,
              templateId: watermarkId,
              textAlign: TextAlign.justify,
              text: ":",
              hexColor: titleColor,
            ),
          ),
        Expanded(
          child: WatermarkFrameBox(
            watermarkId: watermarkId,
            frame: watermarkData.frame,
            style: watermarkData.style,
            child: _buildWeatherText(contentColor, haveContainerunderline),
          ),
        )
      ],
    );
  }

  Widget _buildWeatherText(String? contentColor, bool haveContainerunderline) {
    return FutureBuilder(
      future:
          getWeatherText(locationLogic.weather.value, showTemperature: true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WatermarkGeneralItem(
            watermarkData: watermarkData,
            suffix: suffix,
            templateId: watermarkId,
            containerunderline: haveContainerunderline,
            text: snapshot.data as String,
            hexColor: contentColor,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
