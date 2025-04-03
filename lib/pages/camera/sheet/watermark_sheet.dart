import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_grid_logic.dart';

import 'watermark_grid_view.dart';

class WatermarkSheet {
  static Future<GridResult?> showWatermarkGridSheet(
      {WatermarkResource? resource}) async {
    final result = await Get.bottomSheet<GridResult?>(
      WatermarkGridView(resource: resource),
      persistent: true,
      isDismissible: true,
      ignoreSafeArea: true,
      enableDrag: true,
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );

    return result;
  }
}
