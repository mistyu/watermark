import 'package:get/get.dart';
import './choose_position_logic.dart';

class ChoosePositionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChoosePositionLogic(), permanent: false);
  }
}
