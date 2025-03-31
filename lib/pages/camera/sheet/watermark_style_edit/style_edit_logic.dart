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

  // 文字颜色
  Rx<Color> pickerColor = const Color(0xffffffff).obs;
  // 标题颜色
  Rx<Color> titlePickerColor = const Color(0xffff8e59).obs;
  // 底部底色
  Rx<Color> backgroundPickerColor = const Color(0xffff8e59).obs;

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

  // 更新文字颜色
  void changeColor(Color color) {
    pickerColor.value = color;
    protoLogic.updateFontsColor(pickerColor.value);
  }

  // 更新标题颜色
  void changeTitleColor(Color color) {
    titlePickerColor.value = color;
    protoLogic.updateTitleColor(titlePickerColor.value);
  }

  // 更新底部底色
  void changeBackgroundColor(Color color) {
    backgroundPickerColor.value = color;
    protoLogic.updateBackgroundColor(backgroundPickerColor.value);
  }

  // 重置
  void resetAll() {
    scalePercent.value = 100;
    widthPercent.value = 100;
    pickerColor.value = Colors.white;
    titlePickerColor.value = const Color(0xffff8e59);
    backgroundPickerColor.value = const Color(0xffff8e59);

    if (cameraLogic.currentWatermarkView.value != null) {
      protoLogic.setWatermarkView(cameraLogic.currentWatermarkView.value!);
    } else {
      protoLogic.onChangeScale(scalePercent.value * 0.01);
      protoLogic.onChangeWidth(widthPercent.value * 0.01);
      protoLogic.updateFontsColor(Colors.white);
      protoLogic.updateTitleColor(const Color(0xffff8e59));
      protoLogic.updateBackgroundColor(const Color(0xffff8e59));
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
