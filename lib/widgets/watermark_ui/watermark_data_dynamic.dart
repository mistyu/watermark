import 'package:flutter/material.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watemark_time.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_brandlogo.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_time_division.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_weather.dart';
import 'package:watermark_camera/widgets/watermark_template/watermark_custom1.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_clockIn_person.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_coordinate.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_full_screen.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_headline.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_signInperson.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_step_number.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_titleBar.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_watermark.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_watermark_top.dart';

import 'watermark_frame_box.dart';

class WatermarkDataDynamic extends StatelessWidget {
  final WatermarkResource resource;
  final WatermarkData watermarkData;
  final WatermarkView? watermarkView;

  const WatermarkDataDynamic(
      {super.key,
      required this.resource,
      required this.watermarkData,
      required this.watermarkView});

  int get watermarkId => resource.id ?? 0;

  Widget get _child {
    print(
        "xiaojianjian 达瓦达瓦 WatermarkDataDynamic _child ${watermarkData.type}");
    if (watermarkData.type == 'RYWatermarkTime') {
      if (watermarkData.timeType == 0) {
        return RYWatermarkTime0(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 1) {
        return RYWatermarkTime1(
          watermarkData: watermarkData,
          resource: resource,
        );
      }

      if (watermarkData.timeType == 4) {
        return RYWatermarkTime4(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 5) {
        return RYWatermarkTime5(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 6) {
        return RYWatermarkTime6(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 9) {
        return RYWatermarkTime9(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 10) {
        return RYWatermarkTime10(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 11) {
        if (resource.id == 1698049914988) {
          return RYWatermarkTime11(
            watermarkData: watermarkData,
            resource: resource,
          );
        }
        return RYWatermarkTime11(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 12) {
        return RYWatermarkTime12(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 13) {
        return RYWatermarkTime13(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 14) {
        return RYWatermarkTime14(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 15) {
        return RYWatermarkTime15(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 16) {
        return RYWatermarkTime16(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 17) {
        return RYWatermarkTime17(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 18) {
        return RYWatermarkTime18(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 19) {
        return RYWatermarkTime19(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 20) {
        return RYWatermarkTime20(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 21) {
        return RYWatermarkTime21(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 24) {
        return RYWatermarkTime24(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
      if (watermarkData.timeType == 28) {
        return RYWatermarkTime28(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
    }
    if (watermarkData.type == 'RYWatermarkTimeDivision') {
      // if (widget.watermarkData.timeType == 7) {
      return RYWatermarkTimeDivision(
        watermarkData: watermarkData,
        resource: resource,
      );
      // }
    }
    if (watermarkData.type == 'RYWatermarkLocation') {
      if (watermarkData.timeType == 0) {
        return RyWatermarkLocationBox(
          watermarkData: watermarkData,
          resource: resource,
        );
      }
    }

    if (watermarkData.type == 'YWatermarkStepNumber') {
      return YWatermarkStepNumber(
        watermarkData: watermarkData,
        resource: resource,
      );
    }

    if (watermarkData.type == 'YWatermarkClockInPerson') {
      return YWatermarkClockInPerson(
        watermarkData: watermarkData,
      );
    }
    if (watermarkData.type == 'YWatermarkSignInPerson') {
      return YWatermarkSignInPerson(
        watermarkData: watermarkData,
      );
    }
    if (watermarkData.type == 'YWatermarkHeadline') {
      return YWatermarkHeadline(
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    if (watermarkData.type == 'YWatermarkTitleBar') {
      return YWatermarkTitleBar(
        watermarkView: watermarkView,
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    if (watermarkData.type == 'YWatermarkWatermark') {
      return YWatermarkWatermark(
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    if (watermarkData.type == 'YWatermarkWatermarkTop') {
      return YWatermarkWatermarkTop(
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    // if (widget.watermarkData.type == 'YWatermarkCoordinate') {
    //     return Row(
    //       children: [
    //         YWatermarkLongitude(watermarkData: widget.watermarkData),
    //         YWatermarkLatitude(watermarkData: widget.watermarkData),
    //       ],
    //     );
    // }
    if (watermarkData.type == 'YWatermarkCoordinate') {
      return YWatermarkCoordinate(
        watermarkView: watermarkView,
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    if (watermarkData.type == 'YWatermarkFullScreenWatermark') {
      return YWatermarkFullScreenWatermark(
        watermarkData: watermarkData,
        resource: resource,
      );
    }

    if (watermarkData.type == 'RYWatermarkBrandLogo') {
      return RYWatermarkBrandLogo(
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    if (watermarkData.type == 'YWatermarkCustom1') {
      return WatermarkCustom1Box(
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    if (watermarkData.type == 'YWatermarkWeather') {
      return RyWatermarkWeather(
        watermarkData: watermarkData,
        resource: resource,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    print("xiaojianjian 达瓦达瓦 WatermarkDataDynamic build ${watermarkData.type}");
    final itemFrame = watermarkData.frame;
    final itemStyle = watermarkData.style;
    final backgroundName = watermarkData.background;
    final cid = resource.cid;

    return FutureBuilder(
        future: WatermarkService.getImagePath(resource.id.toString(),
            fileName: backgroundName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Visibility(
              visible: (!(watermarkData.isHidden == true) ||
                      !(watermarkData.background == null ||
                          watermarkData.background == '')) &&
                  !(watermarkData.type == 'YWatermarkHeadline' &&
                      resource.id == 1698049835340),
              child: WatermarkFrameBox(
                watermarkId: watermarkId,
                frame: itemFrame,
                style: itemStyle,
                imagePath: cid == 3 ? null : snapshot.data,
                watermarkData: watermarkData,
                isAdaptTextWidth: (resource.id == 1698125672 ||
                        resource.id == 1698125120 ||
                        resource.id == 1698125930) &&
                    watermarkData.title == "打卡标题",
                child: _child,
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
