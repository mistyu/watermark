import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'signature_logic.dart';
import 'signature_pad.dart';

class SignaturePage extends StatelessWidget {
  final logic = Get.find<SignatureLogic>();

  SignaturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 签名区域
            Container(
              width: 1.sw,
              height: 1.sh,
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: RepaintBoundary(
                key: logic.signatureKey,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SignaturePad(),
                ),
              ),
            ),

            // 底部按钮区域
            Transform.translate(
                offset: Offset(-1.sw / 2 + 40.w, 1.sh - 240.h),
                child: Transform.rotate(
                  alignment: Alignment.center,
                  angle: 90 * (3.1415926535 / 180),
                  child: Positioned(
                      left: 0,
                      top: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(
                            '清空',
                            onTap: logic.clearSignature,
                            backgroundColor: Styles.c_777777,
                            textColor: Colors.white,
                          ),
                          SizedBox(width: 16.w),
                          _buildButton(
                            '返回',
                            onTap: () => Get.back(),
                            backgroundColor: Styles.c_777777,
                            textColor: Colors.white,
                          ),
                          SizedBox(width: 16.w),
                          _buildButton(
                            '提交',
                            onTap: () async {
                              final path = await logic.saveSignature();
                              if (path != null) {
                                Get.back(result: path);
                              } else {
                                Utils.showToast('保存签名失败');
                              }
                            },
                            backgroundColor: Styles.c_0C8CE9,
                            textColor: Colors.white,
                          ),
                        ],
                      )),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String text, {
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
