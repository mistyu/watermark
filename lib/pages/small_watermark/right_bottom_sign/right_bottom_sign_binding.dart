import 'package:get/get.dart';
import 'right_bottom_sign_logic.dart';

class RightBottomSignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RightBottomSignLogic());
  }
}
