import 'package:get/get.dart';
import 'package:watermark_camera/pages/tutorial/tutorial_logic.dart';

class TutorialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
     Get.lazyPut(() => TutorialLogic());
  }
}
