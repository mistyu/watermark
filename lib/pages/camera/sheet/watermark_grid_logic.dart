import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/base_tab_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/models/db/watermark/watermark_save.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';
import 'package:watermark_camera/utils/db_helper.dart';

import '../camera_logic.dart';

class WatermarkGridViewLogic extends BaseTabController {
  final watermarkLogic = Get.find<WaterMarkController>();
  final watermarkProtoLogic = Get.find<WatermarkProtoLogic>();
  final savedWatermarks = Rxn<List<WatermarkSaveModel>>();
  final categories = [].obs;

  @override
  List<Category> get tabs => watermarkLogic.watermarkCategoryList;

  List<WatermarkResource> get watermarkResources =>
      watermarkLogic.watermarkResourceList;

  WatermarkResource? get previewWatermarkResource => watermarkResources
      .firstWhereOrNull((element) => element.id == selectedWatermarkId.value);

  final cameraLogic = Get.find<CameraLogic>();

  final selectedWatermarkId = Rxn<int>();

  void selectWatermark(int id) {
    selectedWatermarkId.value = id;
  }

  // 清除当前预览的水印
  void clearPreviewWatermark() {
    selectedWatermarkId.value = null;
  }

  // 退出当前 sheet 直接返回当前选择的id
  void exit() {
    final gridResult = GridResult(
        selectedWatermarkId: selectedWatermarkId.value, showEdit: false);
    Get.back(result: gridResult);
  }

  void exitAndEdit() {
    final gridResult = GridResult(
        selectedWatermarkId: selectedWatermarkId.value, showEdit: true);
    Get.back(result: gridResult);
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    categories.value = [...tabs];
    // categories.insert(0, const Category(id: 0, title: '我的收藏'));
    initTabController(length: categories.length + 1);
  }
}

class GridResult {
  final int? selectedWatermarkId;
  final bool? showEdit;

  GridResult({
    this.selectedWatermarkId,
    this.showEdit,
  });
}
