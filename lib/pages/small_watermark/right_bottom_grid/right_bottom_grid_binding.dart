import 'package:get/get.dart';
import 'right_bottom_grid_logic.dart';

class RightBottomGridBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RightBottomGridLogic());
  }
}
