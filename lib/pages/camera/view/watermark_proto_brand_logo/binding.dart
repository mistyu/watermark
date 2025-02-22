import 'package:get/get.dart';
import './logic.dart';

class WatermarkProtoBrandLogoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WatermarkProtoBrandLogoLogic(), permanent: false);
  }
}
