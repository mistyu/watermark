import 'package:get/get.dart';

import 'logic.dart';

class PhotoBatchPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhotoBatchPreviewLogic());
  }
}
