import 'package:get/get.dart';
import 'right_bottom_size_logic.dart';

class RightBottomSizeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RightBottomSizeLogic());
  }
}
