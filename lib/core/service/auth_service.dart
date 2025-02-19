import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/utils/library.dart';

class AuthService {
  static Future<void> register() async {
    try {
      final result = await Apis.register();
      if (Utils.isNotNullEmptyStr(result['token']) &&
          Utils.isNotNullEmptyStr(result['operationId'])) {
        DataSp.putToken(result['token']);
        DataSp.putVisitorId(result['operationId']);
      }
    } catch (e) {
      Logger.print("e: $e");
    }
  }

  static Future<String?> login(String operationId) async {
    try {
      final token = await Apis.login(operationId);
      if (Utils.isNotNullEmptyStr(token)) {
        DataSp.putToken(token!);
      }

      return token;
    } catch (e) {
      Logger.print("e: $e");
    }
    return null;
  }

  /**
   * 游客登入
   */
  static Future<bool> visitorLogin(String deviceId) async {
    final result = await Apis.visitorLogin(deviceId);
    //成功返回 --- 修正token
    final token = result['access_token']; //这里的json要不要之后为dart model
    DataSp.putToken(token);
    return true;
  }

  /**
   * 检查登入 -- 未来可以检测一下token
   */
  static Future<bool> checkLogin() async {
    try {
      final result = await Apis.checkLogin();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> smsLogin(String phone, String code) async {
    final result = await Apis.smsLogin(phone, code);
    if (Utils.isNotNullEmptyStr(result['access_token'])) {
      DataSp.putToken(result['access_token']);
      return true;
    }
    return false;
  }
}
