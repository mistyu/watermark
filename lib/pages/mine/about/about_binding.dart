import 'package:get/get.dart';
import 'package:watermark_camera/pages/mine/about/about_logic.dart';

class AboutAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AboutAppLogic());
  }
}
