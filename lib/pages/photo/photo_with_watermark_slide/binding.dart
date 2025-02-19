import 'package:get/get.dart';

import 'logic.dart';

class PhotoWithWatermarkSlideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhotoWithWatermarkSlideLogic());
  }
}
