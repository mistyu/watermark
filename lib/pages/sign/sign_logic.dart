import 'package:get/get.dart';
import 'package:watermark_camera/core/service/auth_service.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';

class SignLogic extends GetxController {
  String? get visitorId => DataSp.visitorId;
  String? get token => DataSp.token;
  String? get deviceId => DataSp.deviceId;

  /**
  * 检查登入
  */
  Future<void> checkSign() async {
    try {
      // 没有token
      if (!Utils.isNotNullEmptyStr(token)) {
        print("没有token, 游客登入");
        //直接游客登入 --- 正式登入只有进入登入页面才可以进行
        await AuthService.visitorLogin(deviceId!);
      } else {
        final result = await AuthService.checkLogin();
        if (!result) {
          //false 表示未登入 --- 直接游客登入
          await AuthService.visitorLogin(deviceId!);
        }
      }

      toHome();
    } catch (e) {
      Logger.print("e: $e");
    }
  }

  void toHome() {
    Future.delayed(Duration.zero, () {
      AppNavigator.startSplashToMain();
    });
  }

  @override
  void onInit() {
    checkSign();
    super.onInit();
  }
}
