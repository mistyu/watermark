import 'dart:ui';

import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_logic.dart';

class RightBottomStyleLogic extends GetxController {
  final rightBottomLogic = Get.find<SmallWatermarkLogic>();

  Rx<double> opacityPercent = 100.0.obs;
  Rx<double> verticalOffset = 10.0.obs;
  Rx<double> horizontalOffset = 10.0.obs;

  void resetOpacity() {
    changeOpacity(100);
  }

  void resetPosition() {
    changePosition(dx: 10, dy: 10);
  }

  void changeOpacity(double newValue) {
    opacityPercent.value = newValue;
    rightBottomLogic.opacity.value = opacityPercent.value * 0.01;
  }

  void changePosition({required double dx, required double dy, int? status}) {
    switch (status) {
      case 1:
        verticalOffset.value = minus(dy);
        break;
      case 2:
        verticalOffset.value = add(dy);
        break;
      case 3:
        horizontalOffset.value = minus(dx);
        break;
      case 4:
        horizontalOffset.value = add(dx);
        break;
      default:
        verticalOffset.value = dy;
        horizontalOffset.value = dx;
        break;
    }

    rightBottomLogic.position.value =
        Offset(horizontalOffset.value, verticalOffset.value);
  }

  double add(double number) {
    return number += 1;
  }

  double minus(double number) {
    return number -= 1;
  }
}
