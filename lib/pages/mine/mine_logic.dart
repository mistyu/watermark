import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/core/service/auth_service.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/loading_view.dart';
import 'package:watermark_camera/models/user/user_info.dart';

class MineLogic extends GetxController with GetxServiceMixin {
  final appController = Get.find<AppController>();
  final watermarkController = Get.find<WaterMarkController>();
  final _isVisible = false.obs;

  final cacheSize = "缓存计算中...".obs;
  final version = "1.0.0".obs;
  String? get visitorId => DataSp.visitorId;
  final mineUserInfoId = "_mineUserInfoId";
  final mineUserSetting = "mineUserSetting";

  // Getters
  UserInfo? get userInfo => appController.userInfo;

  String get nickName {
    return userInfo?.nickname ?? "游客";
  }

  String? get avatar {
    if (userInfo?.avatar == null) {
      return null;
    }
    return Config.apiUrl + userInfo!.avatar!;
  }

  String get userId {
    return userInfo?.deviceId ?? "游客id";
  }

  bool get isMember => userInfo?.isMember == 1;
  DateTime? get memberExpireTime => userInfo?.memberExpireTime;

  String get cameraResolutionPreset =>
      appController.cameraResolutionPreset.value.formatReslution;
  bool get openRightBottomWatermark =>
      appController.openRightBottomWatermark.value;
  bool get openSaveNoWatermarkImage =>
      appController.openSaveNoWatermarkImage.value;

  //图片选择上传实例
  final _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // 监听页面可见性变化
    getCacheSize();
    getVersion();

    // 确保 userInfo 已加载
    if (appController.userInfo == null) {
      appController.getUserInfo().then((_) {
        update([mineUserInfoId]);
        update([mineUserSetting]);
      });
    }
  }

  @override
  void onReady() {
    print("MineLogic onReady");
    super.onReady();
  }

  Future<bool> selectImageAndUpload() async {
    if (userInfo?.userType == 0) {
      Utils.showToast("请先登录, 才能修改头像");
      return false;
    }
    try {
      Utils.showLoading("上传中...");

      // 选择图片
      XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        print("选择的图片image: ${image.path} ${image.name}");

        // 读取文件
        File file = File(image.path);
        // 获取文件名
        String fileName = image.path.split('/').last;

        // 构建 FormData
        dio.FormData formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        });

        // 上传图片
        final result = await Apis.upLoadFile(formData);

        if (result != null) {
          await appController.getUserInfo();
          Utils.showToast("头像更新成功");
          update([mineUserInfoId]);
          return true;
        } else {
          Utils.showToast("上传失败，请重试");
        }
      }

      return false;
    } catch (e) {
      print("上传头像错误: $e");
      Utils.showToast("上传失败，请重试");
      return false;
    } finally {
      Utils.dismissLoading();
    }
  }

  Future<bool> changeNickName(String name) async {
    if (userInfo?.userType == 0) {
      Utils.showToast("请先登录, 才能修改昵称");
      return false;
    }
    Utils.showLoading("修改中"); // 显示加载
    try {
      final result = await Apis.changeNickName(name);
      if (result != null) {
        final result = await appController.getUserInfo();
        Utils.showToast("修改昵称成功");
        if (result) {
          Get.back();
          return true;
        }
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      Utils.dismissLoading();
    }
    return true;
  }

  /**
   * 获取用户信息，如果存在更新用户信息，则重新调用
   */

  Future<bool> logout() async {
    try {
      Utils.showLoading("退出中..."); // 显示加载

      final deviceId = DataSp.visitorId;
      if (deviceId == null) {
        return false;
      }

      // 执行退出登录操作
      await AuthService.visitorLogin(deviceId);
      final result = await appController.getUserInfo();
      update([mineUserInfoId]);
      update([mineUserSetting]);

      // 所有操作完成后关闭加载
      Utils.dismissLoading();

      if (result) {
        Utils.showToast("退出成功");
      }
      return result;
    } catch (e) {
      // 发生错误时关闭加载
      Utils.dismissLoading();
      return false;
    }
  }

  void onSwitchCameraResolutionPreset(String value) async {
    appController.setCameraResolutionPreset(value);
    update([mineUserSetting]);
  }

  void onSwitchRightBottomWatermark(bool value) {
    appController.setOpenRightBottomWatermark(value);
    update([mineUserSetting]);
  }

  void onSwitchSaveNoWatermarkImage(bool value) {
    appController.setOpenSaveNoWatermarkImage(value);
    update([mineUserSetting]);
  }

  void startResolutionView() async {
    await AppNavigator.startResolution();
    update([mineUserSetting]);
  }

  void startAboutAppPage() async {
    await AppNavigator.startAboutAppPage();
    update([mineUserInfoId]);
    update([mineUserSetting]);
  }

  void startChangeNameView() async {
    await AppNavigator.startChangeName();
    update([mineUserInfoId]);
  }

  void startVipView() async {
    await AppNavigator.startVip();
    update([mineUserInfoId]);
  }

  void startLogin() async {
    await AppNavigator.startLogin();
    update([mineUserInfoId]);
    update([mineUserSetting]);
  }

  void startVipAuthority() async {
    await AppNavigator.startVipAuthority();
    update([mineUserInfoId]);
    update([mineUserSetting]);
  }

  void startActivateCode() async {
    await AppNavigator.startActivateCode();
    update([mineUserInfoId]);
    update([mineUserSetting]);
  }

  void startCustomer() async {
    await AppNavigator.startCustomer();
  }

  void getCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    int size = await _getDirectorySize(tempDir);
    cacheSize.value = Utils.formatBytes(size);
    update([mineUserSetting]);
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
    if (cacheSize.value == "0B") {
      Utils.showToast("缓存已清空");
      return;
    }
    //同时要将水印数据重新获取
    Utils.showLoading("清除中, 可能需要稍等一会...");
    await LoadingView.singleton.wrap(asyncFunction: () async {
      Directory tempDir = await getTemporaryDirectory();
      await _deleteDirectory(tempDir);
      await watermarkController.initWatermarkAfterClear();
      cacheSize.value = "0B";
    });
    update([mineUserInfoId]);
    update([mineUserSetting]);
    Utils.dismissLoading();
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
