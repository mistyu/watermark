import 'package:get/get.dart';

import 'mine_logic.dart';

class MineBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MineLogic(), permanent: false); // 使用 put 而不是 lazyPut
  }
}
