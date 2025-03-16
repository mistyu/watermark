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
      await permission.request();
    }
  }

  /// 申请存储权限
  Future<bool> requestStoragePermission() async {
    return await Permission.storage.request().isGranted;
  }

  /// 申请相册权限
  Future<bool> requestPhotoPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt <= 32) {
      return await requestStoragePermission();
    }
    var status = await Permission.photos.status;
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      status = await Permission.photos.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 申请媒体库权限
  Future<bool> requestMediaLibraryPermission() async {
    var status = await Permission.mediaLibrary.status;
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      status = await Permission.photos.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 申请定位权限
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 申请相机权限
  Future<bool> requestCameraPermission() async {
    print("xiaojianjian 权限页面进行中");
    var status = await Permission.camera.status;
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void onInit() {
    // requestPermission();
    super.onInit();
  }
}
