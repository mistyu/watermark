import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoosePositionLogic extends GetxController {
  // 当前选中的tab
  final selectedTab = 0.obs;
  
  // 图片路径
  final String? imagePath = Get.arguments['path'];
  
  // 位置、大小、透明度的状态
  final position = Offset.zero.obs;
  final scale = 1.0.obs;
  final opacity = 1.0.obs;

  get isRecordingVideo => null;

  // 切换tab
  void switchTab(int index) {
    selectedTab.value = index;
  }

  // 更新位置
  void updatePosition(Offset newPosition) {
    position.value = newPosition;
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
      'position': position.value,
      'scale': scale.value,
      'opacity': opacity.value,
    });
  }

  @override
  void onInit() {
    super.onInit();
    // 可以在这里初始化默认值
    if (Get.arguments != null) {
      position.value = Get.arguments['position'] ?? Offset.zero;
      scale.value = Get.arguments['scale'] ?? 1.0;
      opacity.value = Get.arguments['opacity'] ?? 1.0;
    }
  }
}
