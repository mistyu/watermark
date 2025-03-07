import 'package:get/get.dart';
import 'map_logic.dart';

class WatermarkMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapLogic());
  }
}
