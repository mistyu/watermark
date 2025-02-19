import 'package:get/get.dart';

import 'small_watermark_logic.dart';

class SmallWatermarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SmallWatermarkLogic());
  }
}
