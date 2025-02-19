import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_logic.dart';

class RightBottomSignLogic extends GetxController {
  final rightBottomLogic = Get.find<SmallWatermarkLogic>();
  Rx<bool> signSwitch = false.obs;

  void changeSignSwitch(bool? value) {
    signSwitch.value = value ?? false;
    rightBottomLogic.onChangeSign(value == true);
  }

  void saveSign() {
    rightBottomLogic.signText.value = rightBottomLogic.signController.text;
  }
}
