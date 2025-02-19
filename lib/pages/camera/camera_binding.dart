import 'package:get/get.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_style_edit/style_edit_logic.dart';

import 'camera_logic.dart';
import 'sheet/watermark_grid_logic.dart';
import 'sheet/watermark_proto_logic.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CameraLogic());
    Get.lazyPut(() => WatermarkGridViewLogic(), fenix: true);
    Get.lazyPut(() => WatermarkProtoLogic(), fenix: true);
    Get.lazyPut(() => StyleEditLogic(), fenix: true);
  }
}
