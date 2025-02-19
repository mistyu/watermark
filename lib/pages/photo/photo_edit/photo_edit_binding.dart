import 'package:get/get.dart';

import 'photo_edit_logic.dart';

class PhotoEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhotoEditLogic());
  }
}
