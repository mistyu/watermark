import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_logic.dart';

class RightBottomSizeLogic extends GetxController {
  final rightBottomLogic = Get.find<SmallWatermarkLogic>();
  Rx<double> sizePercent = 100.0.obs;
  Rx<double> antiFakePercent = 100.0.obs;

  void resetSize() {
    changeSize(100.0);
  }

  void resetAntiFake() {
    changeAntiFake(100.0);
  }

  void changeSize(newValue) {
    sizePercent.value = newValue;
    rightBottomLogic.onChangeMainScale(sizePercent.value * 0.01);
  }

  void changeAntiFake(newValue) {
    antiFakePercent.value = newValue;
    rightBottomLogic.onChangeAntiFakeScale(antiFakePercent.value * 0.01);
  }
}
