import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/pages/mine/mine_logic.dart';

class HomeLogic extends GetxController {
  final locationController = Get.find<LocationController>();
  final waterMarkController = Get.find<WaterMarkController>();

  final isAutoCamera = false.obs; // 是否自动进入相机

  final activeIndex = 0.obs;

  void switchPage(int index) {
    if (activeIndex.value == index) return;

    activeIndex.value = index;

    // 当切换到设置页面时，刷新用户信息
    if (index == 1) {
      // 1 是设置页面的索引
      Get.find<MineLogic>().getUserInfo();
    }
  }

  @override
  void onReady() {
    // ever(waterMarkController.firstResource, (_) {
    //   Future.delayed(const Duration(milliseconds: 1000), () {
    //     if (isAutoCamera.value) {
    //       AppNavigator.startCamera();
    //     }
    //   });
    // });

    super.onReady();
  }

  @override
  void onInit() {
    locationController.startLocation();
    waterMarkController.getWaterMarkAllData();
    final arguments = Get.arguments;
    if (arguments != null) {
      isAutoCamera.value = arguments["isAutoCamera"] ?? false;
    }

    super.onInit();
  }
}
