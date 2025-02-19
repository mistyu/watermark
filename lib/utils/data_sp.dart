import 'package:device_info_plus/device_info_plus.dart';
import 'package:watermark_camera/utils/sp_util.dart';
import 'dart:io';

class DataSp {
  static const _isNotInit = 'isNotInit';
  static const _visitorId = 'visitorId';
  static const _token = 'token';
  static const _clientIP = 'clientIP';
  static const _deviceId = 'deviceId';

  static const _openRightBottomWatermark =
      'openRightBottomWatermark'; // 开关右下角水印
  static const _openSaveNoWatermarkImage =
      'openSaveNoWatermarkImage'; // 开关保存无水印图片
  static const _openCameraShutterSound = 'openCameraShutterSound'; // 开关相机快门声

  static const _cameraResolutionPreset = 'cameraResolutionPreset'; // 相机分辨率

  DataSp._();

  static init() async {
    try {
      await SpUtil().init();

      // 添加日志输出来调试
      print('Current deviceId: ${getDeviceId()}');

      if (getDeviceId() == null || getDeviceId()?.isEmpty == true) {
        final deviceId = await _getDeviceUniqueId();
        print('Generated new deviceId: $deviceId');
        await putDeviceId(deviceId);

        // 验证是否成功保存
        final savedId = getDeviceId();
        print('Saved deviceId: $savedId');
      }
    } catch (e) {
      print('DataSp init error: $e');
    }
  }

  static Future<String> _getDeviceUniqueId() async {
    final deviceInfo = DeviceInfoPlugin();
    String id = '';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // 使用 id 作为主要标识符
        if (androidInfo.id != null && androidInfo.id.isNotEmpty) {
          id = androidInfo.id;
        } else {
          // 备选方案：使用设备型号和制造商组合
          id =
              '${androidInfo.brand}_${androidInfo.model}_${androidInfo.product}';
        }

        print('Android Info: \n'
            'id: ${androidInfo.id}\n'
            'brand: ${androidInfo.brand}\n'
            'model: ${androidInfo.model}\n'
            'product: ${androidInfo.product}\n'
            'device: ${androidInfo.device}');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor ?? '';
      }

      if (id.isEmpty) {
        id = DateTime.now().millisecondsSinceEpoch.toString();
      }
    } catch (e) {
      print('Error getting device info: $e');
      id = DateTime.now().millisecondsSinceEpoch.toString();
    }

    return id;
  }

  static bool get isNotInit => getIsNotInit() == true;
  static String? get visitorId => getVisitorId();
  static String? get token => getToken();
  static String? get clientIP => getClientIP();
  static bool? get openRightBottomWatermark => getOpenRightBottomWatermark();
  static bool? get openSaveNoWatermarkImage => getOpenSaveNoWatermarkImage();
  static bool? get openCameraShutterSound => getOpenCameraShutterSound();
  static String? get cameraResolutionPreset => getCameraResolutionPreset();
  static String? get deviceId => getDeviceId();

  static Future<bool>? putToken(String token) {
    return SpUtil().putString(_token, token);
  }

  static String? getToken() {
    return SpUtil().getString(_token);
  }

  //删除token
  static Future<bool>? deleteToken() {
    return SpUtil().delete(_token);
  }

  static Future<bool>? putIsNotInit() {
    return SpUtil().putBool(_isNotInit, true);
  }

  static bool? getIsNotInit() {
    final result = SpUtil().getBool(_isNotInit);
    return result;
  }

  static Future<bool>? putVisitorId(String visitorId) {
    return SpUtil().putString(_visitorId, visitorId);
  }

  static String? getVisitorId() {
    return SpUtil().getString(_visitorId);
  }

  static Future<bool>? putClientIP(String clientIP) {
    return SpUtil().putString(_clientIP, clientIP);
  }

  static String? getClientIP() {
    return SpUtil().getString(_clientIP);
  }

  static Future<bool>? putOpenRightBottomWatermark(bool value) {
    return SpUtil().putBool(_openRightBottomWatermark, value);
  }

  static bool? getOpenRightBottomWatermark() {
    return SpUtil().getBool(_openRightBottomWatermark);
  }

  static Future<bool>? putOpenSaveNoWatermarkImage(bool value) {
    return SpUtil().putBool(_openSaveNoWatermarkImage, value);
  }

  static bool? getOpenSaveNoWatermarkImage() {
    return SpUtil().getBool(_openSaveNoWatermarkImage);
  }

  static Future<bool>? putOpenCameraShutterSound(bool value) {
    return SpUtil().putBool(_openCameraShutterSound, value);
  }

  static bool? getOpenCameraShutterSound() {
    return SpUtil().getBool(_openCameraShutterSound);
  }

  static Future<bool>? putCameraResolutionPreset(String value) {
    return SpUtil().putString(_cameraResolutionPreset, value);
  }

  static String? getCameraResolutionPreset() {
    return SpUtil().getString(_cameraResolutionPreset);
  }

  static Future<bool>? putDeviceId(String deviceId) {
    return SpUtil().putString(_deviceId, deviceId);
  }

  static String? getDeviceId() {
    return SpUtil().getString(_deviceId);
  }

  static Future<bool>? clear() {
    return SpUtil().clear();
  }
}
