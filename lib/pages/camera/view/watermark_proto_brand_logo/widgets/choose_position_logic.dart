import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';

class ChoosePositionLogic extends GetxController {
  final watermarkProtoLogic = Get.find<WatermarkProtoLogic>();
  // 当前选中的tab
  final selectedTab = 0.obs;
  final watermarkUpdateId = "watermark_update_id";

  // 图片路径 --- 网络路径
  String? imagePath;
  final watermarkView = Rxn<WatermarkView>();
  final resource = Rxn<WatermarkResource>(); // 资源
  // 是否跟随水印
  final isFollowWatermark = false.obs;
  final logoPosition = Offset.zero.obs;

  final scale = 1.0.obs;
  final opacity = 1.0.obs;

  get isRecordingVideo => null;

  // 切换tab
  void switchTab(int index) {
    selectedTab.value = index;
  }

  // 更新位置
  void updatePosition(Offset newPosition) {
    logoPosition.value = newPosition;
  }

  // 更新大小
  void updateScale(double newScale) {
    scale.value = newScale;
  }

  // 更新透明度
  void updateOpacity(double newOpacity) {
    opacity.value = newOpacity;
  }

  // 确认编辑
  void confirmEdit() {
    Get.back(result: {
      'logoPosition': logoPosition.value,
      'scale': scale.value,
      'opacity': opacity.value,
    });
  }

  @override
  void onInit() {
    super.onInit();
    imagePath = Get.arguments['path'];

    //copy它
    watermarkView.value = watermarkProtoLogic.watermarkView.value;
    resource.value = watermarkProtoLogic.resource.value;
  }
}
