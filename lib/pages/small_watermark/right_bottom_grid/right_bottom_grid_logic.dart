import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_logic.dart';

import '../../../models/watermark/watermark.dart';
import '../right_bottom_dialog/right_bottom_dialog_logic.dart';
import '../right_bottom_dialog/right_bottom_dialog_view.dart';

class RightBottomGridLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final rightBottomLogic = Get.find<SmallWatermarkLogic>();
  final watermarkController = Get.find<WaterMarkController>();

  List<RightBottomResource> get rightBottomList =>
      watermarkController.watermarkRightBottomResourceList;

  final selectedRightBottomId = Rxn<int>(26986609252200);

  Future<void> onChangePreviewWatermark(
      RightBottomView rightBottomView, RightBottomResource res) async {
    final currentId = res.id ?? 0;
    rightBottomLogic.rightBottomView.value = rightBottomView;
    selectedRightBottomId.value = currentId;
    rightBottomLogic.setRightBottomResourceById(currentId);
    // 有个右下角水印没有内容不需要弹窗
    if (!(rightBottomView.content == '' ||
        rightBottomView.content == null && rightBottomView.image == '')) {
      showEditDialog(rightBottomView);
    }
  }

  Future<void> showEditDialog(RightBottomView rightBottomView) async {
    final tag = DateTime.timestamp().toString();
    Get.put(RightBottomDialogLogic(), tag: tag);
    await Get.dialog<String?>(
      RightBottomDialogView(
        rightBottomView: rightBottomView,
      ),
    );
    Get.delete(tag: tag);
  }
}
