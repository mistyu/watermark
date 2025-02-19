import 'package:get/get.dart';
import 'right_bottom_style_logic.dart';

class RightBottomStyleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RightBottomStyleLogic());
  }
}
