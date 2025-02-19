import 'package:get/get.dart';
import 'right_bottom_antifake_logic.dart';

class RightBottomAntifakeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RightBottomAntifakeLogic());
  }
}
