import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';

import 'watermark_grid_view.dart';

class WatermarkSheet {
  static Future<int?> showWatermarkGridSheet(
      {WatermarkResource? resource}) async {
    final result = await Get.bottomSheet<int?>(
      WatermarkGridView(resource: resource),
      persistent: true,
      isDismissible: true,
      ignoreSafeArea: false,
      enableDrag: true,
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
      exitBottomSheetDuration: const Duration(milliseconds: 300),
    );

    return result;
  }
}
