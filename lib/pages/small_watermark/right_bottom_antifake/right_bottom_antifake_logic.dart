import 'dart:ui';

import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_logic.dart';

class RightBottomAntifakeLogic extends GetxController {
  final rightBottomLogic = Get.find<SmallWatermarkLogic>();
  Rx<bool> antifakeSwitch = false.obs;
  Rx<double> verticalOffset = 0.0.obs;
  Rx<double> horizontalOffset = 0.0.obs;

  void changeSwitch(bool? value) {
    antifakeSwitch.value = value ?? false;
    rightBottomLogic.onChangeAntiFack(value == true);
  }

  void resetAntifake() {
    rightBottomLogic.antifakeController.text =
        rightBottomLogic.getRandomString(14);
  }

  void saveAntifake() {
    rightBottomLogic.antifakeText.value =
        rightBottomLogic.antifakeController.text;
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

    rightBottomLogic.antifakePosition.value =
        Offset(horizontalOffset.value, verticalOffset.value);
  }

  double add(double number) {
    return number += 1;
  }

  double minus(double number) {
    return number -= 1;
  }
  void resetPosition() {
    changePosition(dx: 0, dy: 0);
  }
}
