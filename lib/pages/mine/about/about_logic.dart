import 'dart:async';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/models/user/user_info.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/utils.dart';

class AboutAppLogic extends GetxController {
  final appVersion = '1.0.0'.obs;
  final appName = '修改牛水印相机'.obs;
  final packageName = 'com.aiku.super_watermark_camera'.obs;
  final buildNumber = '1'.obs;

  final appController = Get.find<AppController>();

  int? get userType => appController.userInfo?.userType;

  @override
  void onInit() {
    super.onInit();
    getAppInfo();
  }

  Future<void> getAppInfo() async {}

  void startPrivacyView() {
    AppNavigator.startPrivacy();
  }

  void openBetaTest() {
    // 打开版本检测页面
    // 可以实现检查更新功能
    Utils.showLoading("检查版本更新中...");
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 3) {
        timer.cancel();
        Utils.dismissLoading();
        Utils.showToast("已经是最新版本");
      }
    });
  }

  void togglePersonalizedRecommendation(bool value) {
    // 切换个性化推荐开关
    // 可以保存到本地存储
  }

  void logout() {
    // 注销账号逻辑
    Utils.showLoading("注销中...");
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 2) {
        timer.cancel();
        Utils.dismissLoading();
        Utils.showToast("注销成功");
        Get.back();
      }
    });
  }
}
