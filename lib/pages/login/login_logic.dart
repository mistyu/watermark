import 'dart:async';
import 'package:fluwx/fluwx.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/config.dart';
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
  Fluwx fluwx = Fluwx();

  // 微信登录相关
  final wechatAuthStateReceived = false.obs;
  FluwxCancelable? _wechatAuthSubscription;

  // 微信API相关常量
  final String _wxAppId = Config.wxAppId;
  final String _wxAppSecret = Config.wxAppSecret;

  @override
  void onInit() {
    super.onInit();
    // 初始化微信SDK
    initWechatSDK();
  }

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

  // 初始化微信SDK
  void initWechatSDK() async {
    await fluwx.registerApi(
      appId: _wxAppId,
      universalLink: "https://help.wechat.com/app/",
    );

    // 监听微信授权回调
    _wechatAuthSubscription = fluwx.addSubscriber((response) {
      print("微信授权回调: $response");
      if (response is WeChatAuthResponse) {
        // 处理微信授权回调
        handleWechatAuthResponse(response);
      }
    });
  }

  // 处理微信登录
  void handleWechatLogin() async {
    if (!agreeToTerms.value) {
      Utils.showToast("请先同意用户协议和隐私政策");
      return;
    }

    Utils.showLoading("正在唤起微信...");

    try {
      // 发起微信授权
      final result = await fluwx.authBy(
        which: NormalAuth(
          scope: "snsapi_userinfo",
          state: "wechat_sdk_demo_test",
        ),
      );

      if (!result) {
        Utils.dismissLoading();
        Utils.showToast("唤起微信失败，请检查是否安装微信");
      }
    } catch (e) {
      Utils.dismissLoading();
      Utils.showToast("微信登录异常: $e");
    }
  }

  // 处理微信授权回调
  void handleWechatAuthResponse(WeChatAuthResponse response) async {
    Utils.dismissLoading();

    if (response.errCode == 0) {
      // 授权成功，获取到code
      final code = response.code;
      print("xiaojianjian 获取到微信授权code: $code");
      Utils.showLoading("微信授权成功，正在登录...");

      try {
        // 直接调用后端接口进行登录
        final result = await AuthService.wechatLogin(code!);

        if (result) {
          // 登录成功，获取用户信息
          await appController.getUserInfo();
          Utils.dismissLoading();
          Get.back();
        } else {
          Utils.dismissLoading();
          Utils.showToast("微信登录失败，请稍后再试");
        }
      } catch (e) {
        Utils.dismissLoading();
        Utils.showToast("微信登录异常: $e");
      }
    } else {
      // 授权失败
      Utils.showToast("微信授权失败: ${response.errStr}");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _wechatAuthSubscription?.cancel();
    super.onClose();
  }
}
