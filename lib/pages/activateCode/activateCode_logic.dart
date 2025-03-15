import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/utils/utils.dart';

class ActivateCodeLogic extends GetxController {
  final activateCode = ''.obs;
  final captchaCode = ''.obs;
  final isLoading = false.obs;
  final captchaImage = "".obs;
  final captchaResult = ''.obs;

  final appController = Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();
    refreshCaptcha();
  }

  // 刷新验证码
  Future<void> refreshCaptcha() async {
    try {
      final result = await Apis.getCaptcha();
      if (result != null) {
        captchaResult.value = result['verifyCode'] ?? '';
        captchaImage.value = result['verifyCodeImgUrl'];
      }
    } catch (e) {
      print('获取验证码失败: $e');
      Utils.showToast('获取验证码失败，请重试');
    }
  }

  // 兑换激活码
  Future<void> exchangeActivateCode() async {
    if (activateCode.value.isEmpty) {
      Utils.showToast('请输入激活码');
      return;
    }

    if (captchaCode.value.isEmpty) {
      Utils.showToast('请输入验证码');
      return;
    }

    if (captchaResult.value != captchaCode.value) {
      Utils.showToast('验证码错误');
      return;
    }

    Utils.showLoading("兑换中...");
    try {
      final result = await Apis.exchangeActivateCode(
        activateCode.value,
      );

      if (result != null) {
        Utils.showToast("兑换成功");
        // 刷新用户信息
        await appController.getUserInfo();
        Get.back();
      }
    } catch (e) {
      print('兑换失败: $e');
      Utils.showToast("兑换失败, 请您重试或者联系客服");
      // 刷新验证码
      refreshCaptcha();
    } finally {
      Utils.dismissLoading();
    }
  }

  @override
  void onClose() {
    activateCode.value = '';
    captchaCode.value = '';
    super.onClose();
  }
}
