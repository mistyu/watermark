import 'package:get/get.dart';

import 'photo_slide_logic.dart';

class PhotoSlideBinding extends Bindings {
  @override
  void dependencies() {
    print("PhotoSlideBinding");
    Get.lazyPut(() => PhotoSlideLogic());
  }
}
