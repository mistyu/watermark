import 'package:get/get.dart';
import './logic.dart';

class WatermarkProtoLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WatermarkProtoLocationLogic(), permanent: true);
  }
}
