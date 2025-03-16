import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/services/sse_service.dart';

import 'home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.put<LocationController>(LocationController());
    Get.put<WaterMarkController>(WaterMarkController());
    Get.put<SSEService>(SSEService());
  }
}
