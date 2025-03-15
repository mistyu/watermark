import 'dart:async';
import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/core/service/auth_service.dart';
import 'package:watermark_camera/pages/mine/mine_logic.dart';
import 'package:watermark_camera/utils/utils.dart';

class LoginLogic extends GetxController {
  final appController = Get.find<AppController>();
  // 手机号
  final phoneNumber = "".obs;
  // 验证码
  final verifyCode = "".obs;
  // 是否同意协议
  final agreeToTerms = false.obs;
  // 倒计时
  final countdown = 0.obs;
  Timer? _timer;

  // 验证手机号格式
  bool isValidPhoneNumber() {
    return phoneNumber.value.length == 11;
  }

  // 验证验证码格式
  bool isValidVerifyCode() {
    return verifyCode.value.length == 6;
  }

  // 获取验证码
  void getVerifyCode() async {
    if (!isValidPhoneNumber()) {
      Get.snackbar("提示", "请输入正确的手机号");
      return;
    }
    Utils.showLoading("获取验证码中...");
    if (countdown.value > 0) return;
    // 获取验证码
    final result = await Apis.getCode(phoneNumber.value);
    print("获取验证码结果result: $result");
    Utils.dismissLoading();
    // 开始倒计时
    countdown.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  // 登录处理
  void handleLogin() async {
    if (!agreeToTerms.value) {
      Get.snackbar("提示", "请先同意用户协议和隐私政策");
      return;
    }

    if (!isValidPhoneNumber()) {
      Get.snackbar("提示", "请输入正确的手机号");
      return;
    }

    if (!isValidVerifyCode()) {
      Get.snackbar("提示", "请输入正确的验证码");
      return;
    }

    Utils.showLoading("登录中...");
    final result =
        await AuthService.smsLogin(phoneNumber.value, verifyCode.value);

    if (result) {
      // 注入依赖修改依赖
      await appController.getUserInfo();
      Utils.dismissLoading();
      Get.back();
    } else {
      Utils.showToast("登录失败, 请稍后再试");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
