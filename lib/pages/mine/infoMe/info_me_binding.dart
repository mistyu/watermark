import 'package:get/get.dart';
import 'info_me_logic.dart';

class InfoMeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InfoMeLogic());
  }
} 