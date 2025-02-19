import 'package:get/get.dart';
import 'activateCode_logic.dart';

class ActivateCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivateCodeLogic>(() => ActivateCodeLogic());
  }
}
