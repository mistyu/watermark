import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  Future<void> requestPermission() async {
    final permissions = [
      Permission.storage,
      Permission.camera,
      Permission.photos,
      Permission.location,
    ];

    for (var permission in permissions) {
      await requestPermissionWithTimer(permission);
    }
    print("xiaojianjian PermissionController 权限请求完成");
  }

  /// 通用权限请求方法（使用定时器）
  Future<bool> requestPermissionWithTimer(
    Permission permission, {
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    print("xiaojianjian 请求权限: ${permission.toString()}");

    // 先检查当前权限状态
    var status = await permission.status;
    print("xiaojianjian 当前权限状态: $status");

    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      print("xiaojianjian 权限已授予");
      onSuccess?.call();
      return true;
    }

    try {
      // 使用计时器在请求权限后检查状态
      Completer<bool> completer = Completer<bool>();
      Timer? checkTimer;

      checkTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
        final currentStatus = await permission.status;
        print("xiaojianjian 定时检查权限状态: $currentStatus");

        if (currentStatus == PermissionStatus.granted ||
            currentStatus == PermissionStatus.limited) {
          timer.cancel();
          checkTimer = null;
          print("xiaojianjian 权限已授予 - 通过定时器检测");
          onSuccess?.call();
          if (!completer.isCompleted) completer.complete(true);
        } else if (timer.tick > 10) {
          // 5秒后停止检查
          timer.cancel();
          checkTimer = null;
          print("xiaojianjian 权限检查超时");
          onFailed?.call();
          if (!completer.isCompleted) completer.complete(false);
        }
      });

      // 请求权限
      await permission.request();

      // 立即检查一次
      final immediateCheck = await permission.status;
      print("xiaojianjian 立即检查权限状态: $immediateCheck");

      if (immediateCheck == PermissionStatus.granted ||
          immediateCheck == PermissionStatus.limited) {
        if (checkTimer != null) {
          checkTimer?.cancel();
          checkTimer = null;
        }
        print("xiaojianjian 权限已授予 - 立即检查");
        onSuccess?.call();
        if (!completer.isCompleted) completer.complete(true);
      }

      // 等待结果
      return await completer.future.timeout(Duration(seconds: 6),
          onTimeout: () {
        print("xiaojianjian 权限请求超时");
        onFailed?.call();
        return false;
      });
    } catch (e) {
      print("xiaojianjian 请求权限出错: $e");
      onFailed?.call();
      return false;
    }
  }

  /// 申请存储权限
  Future<bool> requestStoragePermission({
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    return await requestPermissionWithTimer(Permission.storage);
  }

  /// 申请相册权限
  Future<bool> requestPhotoPermission({
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    print("xiaojianjian PermissionController 相册权限请求");
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt <= 32) {
      return await requestStoragePermission();
    }
    return await requestPermissionWithTimer(Permission.photos);
  }

  /// 申请媒体库权限
  Future<bool> requestMediaLibraryPermission({
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    print("xiaojianjian PermissionController 媒体库权限请求");
    return await requestPermissionWithTimer(
      Permission.mediaLibrary,
      onSuccess: onSuccess,
      onFailed: onFailed,
    );
  }

  /// 申请定位权限
  Future<bool> requestLocationPermission({
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    return await requestPermissionWithTimer(
      Permission.location,
      onSuccess: onSuccess,
      onFailed: onFailed,
    );
  }

  /// 申请相机权限
  Future<bool> requestCameraPermission({
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    print("xiaojianjian PermissionController 请求相机权限");
    return await requestPermissionWithTimer(
      Permission.camera,
      onSuccess: onSuccess,
      onFailed: onFailed,
    );
  }

  @override
  void onInit() {
    // requestPermission();
    super.onInit();
  }
}
