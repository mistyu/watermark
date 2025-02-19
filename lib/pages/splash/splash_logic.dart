import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';

class SplashLogic extends GetxController {
  final AppController appController = Get.find<AppController>();

  void checkInit() async {
    try {
      // 如果isNotInit为真，那么就是第一次进入app， 需要弹出隐私协议
      if (!DataSp.isNotInit) {
        // 检查隐私协议
        final result = await CommonDialog.checkPrivacyPolicy(
            controller: appController.webViewController);
        if (result) {
          DataSp.putIsNotInit();
        } else {
          SystemNavigator.pop(animated: true);
        }
      }
      Future.delayed(Duration.zero, () {
        AppNavigator.startSign();
      });
    } catch (e) {
      Logger.print("e: $e");
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInit();
    });
    super.onInit();
  }
}
