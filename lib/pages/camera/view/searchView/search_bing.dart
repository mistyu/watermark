import 'package:get/get.dart';
import 'search_logic.dart';

class SearchBingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchLogic());
  }
}
