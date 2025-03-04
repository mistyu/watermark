import 'package:get/get.dart';
import 'signature_logic.dart';

class SignatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignatureLogic());
  }
}
