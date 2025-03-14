import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/camera/camera_logic.dart';
import 'package:watermark_camera/pages/camera/dialog/watermark_dialog.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';

class StyleEditLogic extends GetxController {
  final protoLogic = Get.find<WatermarkProtoLogic>();
  final cameraLogic = Get.find<CameraLogic>();
  Rxn<double> maxWatermarkWidth = Rxn();
  Rxn<double> watermarkWidth = Rxn();

  Rx<double> scalePercent = 100.0.obs;
  Rx<double> widthPercent = 100.0.obs;
  Rx<Color> pickerColor = const Color(0xffffffff).obs;

  //缩放
  void changeScale(double n) {
    scalePercent.value = n;
    protoLogic.onChangeScale(scalePercent.value * 0.01);
  }

// 宽窄
  void changeWidth(double width) {
    widthPercent.value = width;
    protoLogic.onChangeWidth(widthPercent.value * 0.01);
  }

  void initMaxWidth() {
    watermarkWidth.value =
        (protoLogic.watermarkView.value?.frame?.width ?? 100).w;
    maxWatermarkWidth.value = (1.sw / watermarkWidth.value!) * 100;
  }

  void changeColor(Color color) {
    pickerColor.value = color;
    protoLogic.updateFontsColor(pickerColor.value);
  }

  // 重置
  void resetAll() {
    scalePercent.value = 100;
    widthPercent.value = 100;
    pickerColor.value = Colors.white;
    if (cameraLogic.currentWatermarkView.value != null) {
      protoLogic.setWatermarkView(cameraLogic.currentWatermarkView.value!);
    } else {
      protoLogic.onChangeScale(scalePercent.value * 0.01);
      protoLogic.onChangeWidth(widthPercent.value * 0.01);
      protoLogic.updateFontsColor(Colors.white);
    }
  }

  void onSubmittedColor() {
    Get.back(result: pickerColor.value);
  }

  @override
  void onInit() {
    initMaxWidth();
    super.onInit();
  }
}
