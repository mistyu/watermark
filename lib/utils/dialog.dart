import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';

class CommonDialog {
  static Future<bool> checkPrivacyPolicy(
      {required WebViewController controller}) async {
    controller.loadFlutterAsset('assets/html/privacy_policy.html');
    final result = await Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
      insetPadding: const EdgeInsets.all(24).w,
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(26.0.r))),
      content: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("guide_agreement".webp),
                fit: BoxFit.contain)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            24.verticalSpace,
            "《个人信息保护协议》".toText..style = Styles.ts_333333_24_bold,
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: "为了让您更好的使用修改牛水印相机，请充分阅读并理解 隐私协议".toText
                ..style = Styles.ts_999999_14,
            ),
            8.verticalSpace,
            Container(
              height: 375.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: WebViewWidget(controller: controller),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: "不同意".toText..style = Styles.ts_333333_16),
                  16.horizontalSpace,
                  OutlinedButton(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Styles.c_0C8CE9,
                          shape: const StadiumBorder()),
                      child: "已阅读并同意".toText..style = Styles.ts_FFFFFF_16),
                ],
              ),
            )
          ],
        ),
      ),
    ));
    return result ?? false;
  }

  /// 显示权限请求对话框
  /// [title] 对话框标题
  /// [content] 对话框内容
  /// [permission] 需要请求的权限
  /// 返回值: 如果用户授予了权限则返回true，否则返回false
  static Future<bool> showPermissionDialog({
    required String title,
    required String content,
    required Permission permission,
  }) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid &&
        androidInfo.version.sdkInt <= 32 &&
        permission == Permission.photos) {
      permission = Permission.storage;
    }
    final result = await Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        insetPadding: const EdgeInsets.all(24).w,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
        ),
        title: Text(title, style: Styles.ts_333333_18_bold),
        content: Text(content, style: Styles.ts_666666_14),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text("取消", style: Styles.ts_999999_16),
          ),
          TextButton(
            onPressed: () async {
              Get.back(result: true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Styles.c_0C8CE9,
            ),
            child: Text("去设置", style: Styles.ts_0C8CE9_16),
          ),
        ],
      ),
    );

    if (result == true) {
      openAppSettings();

      // 使用Completer等待应用回到前台
      final completer = Completer<bool>();

      // 设置生命周期监听
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        if (msg == AppLifecycleState.resumed.toString()) {
          // 应用回到前台，检查权限状态
          final isGranted = await permission.isGranted;
          if (!completer.isCompleted) {
            completer.complete(isGranted);
          }
          // 移除监听器
          SystemChannels.lifecycle.setMessageHandler(null);
        }
        return null;
      });

      // 设置超时保护，防止监听器永远不被触发
      Future.delayed(const Duration(seconds: 60), () {
        if (!completer.isCompleted) {
          completer.complete(false);
          // 移除监听器
          SystemChannels.lifecycle.setMessageHandler(null);
        }
      });

      return await completer.future;
    }
    return false;
  }
}
