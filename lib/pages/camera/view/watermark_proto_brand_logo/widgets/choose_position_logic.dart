import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';

class ChoosePositionLogic extends GetxController {
  final watermarkProtoLogic = Get.find<WatermarkProtoLogic>();
  // 当前选中的tab
  final selectedTab = 0.obs;
  final watermarkUpdateId = "watermark_logo_id";
  final logoPositonId = "logo_position_id";

  // 图片路径 --- 网络路径
  String? imagePath;
  final watermarkView = Rxn<WatermarkView>();
  final resource = Rxn<WatermarkResource>(); // 资源
  final itemMap = Rxn<WatermarkDataItemMap>();

  Offset logoPosition = Offset.zero;
  int logoPostionType = 1; // 1: 左上角 2: 右上角 3: 左下角 4: 右下角 5: 居中 0: 跟随水印

  final scale = 1.0.obs;
  final opacity = 1.0.obs;

  get isRecordingVideo => null;

  // 切换tab
  void switchTab(int index) {
    selectedTab.value = index;
  }

  int get brandLogoIndex =>
      watermarkView.value?.data
          ?.indexWhere((e) => e.type == 'RYWatermarkBrandLogo') ??
      -1;
  // 更新位置
  void updatePosition(int type) {
    int index = brandLogoIndex;
    if (type == 0) {
      //增加水印里面的水印数据
      watermarkView.update((v) {
        if (index >= 0) {
          v?.data?[index].isHidden = false;
          v?.data?[index].content = imagePath;
        }
      });
    } else {
      // 更新水印视图
      watermarkView.update((v) {
        if (index >= 0) {
          v?.data?[index].isHidden = true;
        }
      });
    }
    if (logoPostionType == 0) update([watermarkUpdateId]);
    if (type == 0) update([watermarkUpdateId]);
    logoPostionType = type;
    update([logoPositonId]);
  }

  // 更新大小
  void updateScale(double value) {
    scale.value = value;
    itemMap.value?.data.scale = value;
    update([logoPositonId]);
  }

  // 更新透明度
  void updateOpacity(double value) {
    opacity.value = value;
    itemMap.value?.data.opacity = value;
    update([logoPositonId]);
  }

  // 确认编辑
  void confirmEdit() {
    // 更新相应的数据
    itemMap.value?.data.logoPositionType = logoPostionType;
    itemMap.value?.data.content = imagePath;
    print("xiaojianjian 确认返回");
    Get.back(result: itemMap.value);
  }

  @override
  void onInit() {
    super.onInit();
    imagePath = Get.arguments['path'];
    itemMap.value = Get.arguments['itemMap'];

    //copy
    watermarkView.value = watermarkProtoLogic.watermarkView.value?.copyWith();
    watermarkView.value?.data?[brandLogoIndex].logoPositionType = 1;
    resource.value = watermarkProtoLogic.resource.value;
  }
}
