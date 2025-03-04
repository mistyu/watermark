import 'package:get/get.dart';
import 'customer_logic.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerLogic());
  }
}
