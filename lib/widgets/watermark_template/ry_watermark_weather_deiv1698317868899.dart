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

/**
 * 天气图标 + 度数 + 风向
 */
class YWatermarWatherSeparate1698317868899 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  YWatermarWatherSeparate1698317868899({
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

    // final status = await Permission.location.isGranted;
    // if (status) {
    //   final weather = locationLogic.weather.value;
    //   if (weather?.weather == null) {
    //     return '天气获取中...';
    //   }
    //   if (showTemperature && showWeather) {
    //     if (weather?.weather != null && weather?.temperature != null) {
    //       return "${weather?.weather} ${weather?.temperature}℃";
    //     }
    //     return '';
    //   }
    //   if (showTemperature) {
    //     return "${weather?.temperature}℃";
    //   }
    //   if (showWeather) {
    //     return weather?.weather ?? '';
    //   }
    //   return '天气获取中...';
    // }
    return "20~30℃ 东北风";
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

    String titleText = "${watermarkData.title}：";

    bool haveContainerunderline = FormUtils.haveContainerunderline(watermarkId);
    bool haveColon = FormUtils.haveColon(watermarkId);

    return WatermarkFrameBox(
      watermarkId: watermarkId,
      frame: watermarkData.frame,
      style: watermarkData.style,
      child: Row(
        children: [
          WatermarkGeneralItem(
            watermarkData: watermarkData,
            suffix: suffix,
            templateId: watermarkId,
            textAlign: TextAlign.justify,
            text: titleText,
            hexColor: titleColor,
          ),
          Expanded(
            child: _buildWeatherText(
                watermarkData, contentColor, haveContainerunderline),
          )
        ],
      ),
    );
  }

  Widget _buildWeatherText(WatermarkData watermarkData, String? contentColor,
      bool haveContainerunderline) {
    return FutureBuilder(
      future:
          getWeatherText(locationLogic.weather.value, showTemperature: true),
      builder: (context, snapshot) {
        //解析input
        if (snapshot.hasData) {
          String weatherImage = watermarkData.image ?? '';
          print("xiaojianjian 天气图标: $weatherImage");
          bool isShowWeatherImage = true;
          if (Utils.isNullEmptyStr(weatherImage)) {
            isShowWeatherImage = false;
          }
          String text = " ${snapshot.data!}";
          return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                //图标
                if (isShowWeatherImage)
                  Image.asset(
                    weatherImage,
                    width: 16.w,
                    height: 16.w,
                  ),
                Flexible(
                  child: WatermarkGeneralItem(
                    watermarkData: watermarkData,
                    suffix: suffix,
                    templateId: watermarkId,
                    containerunderline: haveContainerunderline,
                    text: text,
                    hexColor: contentColor,
                  ),
                )
              ]);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
