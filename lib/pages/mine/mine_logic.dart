import 'dart:io';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/loading_view.dart';

class MineLogic extends GetxController with GetxServiceMixin {
  final appController = Get.find<AppController>();
  final _isVisible = false.obs;

  final cacheSize = "0B".obs;
  final version = "1.0.0".obs;
  String? get visitorId => DataSp.visitorId;

  // 添加用户信息相关的状态
  final _nickname = "".obs;
  final _phone = "".obs;
  final _isMember = false.obs;
  final _memberExpireTime = Rxn<DateTime>();

  // Getters
  String get nickname => _nickname.value;
  String get phone => _phone.value;
  bool get isMember => _isMember.value;
  DateTime? get memberExpireTime => _memberExpireTime.value;

  String get cameraResolutionPreset =>
      appController.cameraResolutionPreset.value.formatReslution;
  bool get openRightBottomWatermark =>
      appController.openRightBottomWatermark.value;
  bool get openSaveNoWatermarkImage =>
      appController.openSaveNoWatermarkImage.value;

  @override
  void onInit() {
    super.onInit();
    // 监听页面可见性变化
    ever(_isVisible, (bool visible) {
      if (visible) {
        getUserInfo();
      }
    });
    getCacheSize();
    getVersion();
  }

  @override
  void onReady() {
    super.onReady();
    getUserInfo();
  }

  void getUserInfo() {
    if (!_isVisible.value) return;

    Apis.getUserInfo().then((value) {
      print("用户信息getUserInfo: $value");
      // 更新用户信息
      if (value != null) {
        _nickname.value = value['nickname'] ?? '';
        _phone.value = value['phone'] ?? '';
        //是不是会员身份
        _isMember.value = value['isMember'] == 0;

        if (value['memberExpireTime'] != null) {
          try {
            _memberExpireTime.value = DateTime.parse(value['memberExpireTime']);
          } catch (e) {
            print("Error parsing memberExpireTime: $e");
          }
        }
      }
    });
  }

  // 新的 nickName getter，使用服务器返回的昵称
  String get nickName => _nickname.value.isNotEmpty
      ? _nickname.value
      : "游客-${visitorId!.substring(0, 8)}";

  String get userId => _phone.value.isNotEmpty
      ? "手机号: ${_phone.value}"
      : "ID: ${visitorId!.substring(0, 8)}";

  void onSwitchCameraResolutionPreset(String value) {
    appController.setCameraResolutionPreset(value);
  }

  void onSwitchRightBottomWatermark(bool value) {
    appController.setOpenRightBottomWatermark(value);
  }

  void onSwitchSaveNoWatermarkImage(bool value) {
    appController.setOpenSaveNoWatermarkImage(value);
  }

  void startResolutionView() {
    AppNavigator.startResolution();
  }

  void startPrivacyView() {
    AppNavigator.startPrivacy();
  }

  void startVipView() {
    AppNavigator.startVip();
  }

  void startLogin() {
    AppNavigator.startLogin();
  }

  void startActivateCode() {
    AppNavigator.startActivateCode();
  }

  void getCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    int size = await _getDirectorySize(tempDir);
    cacheSize.value = Utils.formatBytes(size);
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  Future<int> _getDirectorySize(Directory directory) async {
    int totalSize = 0;
    if (directory.existsSync()) {
      try {
        await for (var file in directory.list(recursive: true)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      } catch (e) {
        Logger.print("Failed to get directory size: $e");
      }
    }
    return totalSize;
  }

  void onClearCache() async {
    await LoadingView.singleton.wrap(asyncFunction: () async {
      Directory tempDir = await getTemporaryDirectory();
      await _deleteDirectory(tempDir);
      cacheSize.value = "0B";
    });

    ToastUtil.show("清除缓存成功");
  }

  Future<void> _deleteDirectory(Directory directory) async {
    await directory.delete(recursive: true);
  }

  @override
  void onClose() {
    print("MineLogic onClose");
    super.onClose();
  }

  // 更新页面可见性状态
  void setVisible(bool visible) {
    _isVisible.value = visible;
  }
}
