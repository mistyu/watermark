import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/watermark.dart';
import 'RYWatermarkBrandLogo.dart';
import 'RYWatermarkLocation.dart';
import 'RYWatermarkTime.dart';
import 'RYWatermarkTimeDivision.dart';
import 'RyWatermarkWeather.dart';
import 'WatermarkCustom1.dart';
import 'WatermarkFrame.dart';
import 'YWatermarkClockInPerson.dart';
import 'YWatermarkCoordinate.dart';
import 'YWatermarkDeviceInfo.dart';
import 'YWatermarkFullScreenWatermark.dart';
import 'YWatermarkHeadline.dart';
import 'YWatermarkPhoneModel.dart';
import 'YWatermarkSignInPerson.dart';
import 'YWatermarkStepNumber.dart';
import 'YWatermarkTitleBar.dart';
import 'YWatermarkWatermark.dart';
import 'YWatermarkWatermarkTop.dart';

class WatermarkDataDynamic extends StatefulWidget {
  final WatermarkData watermarkData;
  final int templateId;
  const WatermarkDataDynamic(
      {super.key, required this.watermarkData, required this.templateId});

  @override
  State<WatermarkDataDynamic> createState() => _WatermarkDynamicState();
}

class _WatermarkDynamicState extends State<WatermarkDataDynamic> {
  Widget generateChild() {
    if (widget.watermarkData.type == 'RYWatermarkTime') {
      if (widget.watermarkData.timeType == 0) {
        return RYWatermarkTime0(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 1) {
        return RYWatermarkTime1(
          watermarkData: widget.watermarkData,
        );
      }

      if (widget.watermarkData.timeType == 4) {
        return RYWatermarkTime4(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 5) {
        return RYWatermarkTime5(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 9) {
        return RYWatermarkTime9(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 10) {
        return RYWatermarkTime10(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 11) {
        if (widget.templateId == 1698049914988) {
          return RYWatermarkTime11(
            watermarkData: widget.watermarkData,
          );
        }
        return RYWatermarkTime11(watermarkData: widget.watermarkData);
      }
      if (widget.watermarkData.timeType == 12) {
        return RYWatermarkTime12(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 13) {
        return RYWatermarkTime13(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 14) {
        return RYWatermarkTime14(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 15) {
        return RYWatermarkTime15(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 16) {
        return RYWatermarkTime16(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 17) {
        return RYWatermarkTime17(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 18) {
        return RYWatermarkTime18(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 19) {
        return RYWatermarkTime19(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 20) {
        return RYWatermarkTime20(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 21) {
        return RYWatermarkTime21(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 24) {
        return RYWatermarkTime24(
          watermarkData: widget.watermarkData,
        );
      }
      if (widget.watermarkData.timeType == 28) {
        return RYWatermarkTime28(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'RYWatermarkTimeDivision') {
      // if (widget.watermarkData.timeType == 7) {
      return RYWatermarkTimeDivision(
        watermarkData: widget.watermarkData,
      );
      // }
    }
    if (widget.watermarkData.type == 'RYWatermarkLocation') {
      if (widget.watermarkData.timeType == 0) {
        return RyWatermarkLocationBox(
          watermarkData: widget.watermarkData,
        );
      }
    }

    if (widget.watermarkData.type == 'YWatermarkStepNumber') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkStepNumber(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'YWatermarkPhoneModel') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkPhoneModel(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'YWatermarkDeviceInfo') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkDeviceInfo(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'YWatermarkClockInPerson') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkClockInPerson(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'YWatermarkSignInPerson') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkSignInPerson(
          watermarkData: widget.watermarkData,
        );
      }
    }
    print(
        "widget.watermarkData.type 治安巡逻 YWatermarkHeadline: ${widget.watermarkData.type}");
    if (widget.watermarkData.type == 'YWatermarkHeadline') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkHeadline(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'YWatermarkTitleBar') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkTitleBar(watermarkData: widget.watermarkData);
      }
    }
    if (widget.watermarkData.type == 'YWatermarkWatermark') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkWatermark(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'YWatermarkWatermarkTop') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkWatermarkTop(
          watermarkData: widget.watermarkData,
        );
      }
    }
    // if (widget.watermarkData.type == 'YWatermarkCoordinate') {
    //   if (widget.watermarkData.timeType == 0) {
    //     return Row(
    //       children: [
    //         YWatermarkLongitude(watermarkData: widget.watermarkData),
    //         YWatermarkLatitude(watermarkData: widget.watermarkData),
    //       ],
    //     );
    //   }
    // }
    if (widget.watermarkData.type == 'YWatermarkCoordinate') {
      return YWatermarkCoordinate(watermarkData: widget.watermarkData);
    }
    if (widget.watermarkData.type == 'YWatermarkFullScreenWatermark') {
      if (widget.watermarkData.timeType == 0) {
        return YWatermarkFullScreenWatermark(
            watermarkData: widget.watermarkData);
      }
    }

    if (widget.watermarkData.type == 'RYWatermarkBrandLogo') {
      if (widget.watermarkData.timeType == 0) {
        return RYWatermarkBrandLogo(
          watermarkData: widget.watermarkData,
        );
      }
    }
    if (widget.watermarkData.type == 'YWatermarkCustom1') {
      return WatermarkCustom1Box(
        watermarkData: widget.watermarkData,
      );
    }
    if (widget.watermarkData.type == 'YWatermarkWeather') {
      return RyWatermarkWeather(
        watermarkData: widget.watermarkData,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final template = context
        .read<ResourceCubit>()
        .templates
        .firstWhereOrNull((e) => e.id == widget.templateId);
    final watermarkData = widget.watermarkData;
    final itemFrame = watermarkData.frame;
    final itemStyle = watermarkData.style;
    final bgImg = watermarkData.background;
    final cid = template?.cid;

    return FutureBuilder(
        future: readImage(widget.templateId.toString(), bgImg),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Visibility(
              visible: (!(watermarkData.isHidden == true) ||
                      !(watermarkData.background == null ||
                          watermarkData.background == '')) &&
                  !(watermarkData.type == 'YWatermarkHeadline' &&
                      widget.templateId == 1698049835340),
              child: WatermarkFrameBox(
                frame: itemFrame,
                style: itemStyle,
                imagePath: cid == 3 ? null : snapshot.data,
                watermarkData: watermarkData,
                child: generateChild(),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
