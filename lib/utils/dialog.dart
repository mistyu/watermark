import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
}
