import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/utils/styles.dart';

import 'splash_logic.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final logic = Get.find<SplashLogic>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("app_bg".webp),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    width: 124.w,
                    height: 124.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      image: DecorationImage(image: AssetImage("LOGO".png))
                    ),
                  ),
                ),
                const Spacer(),
                "修改牛水印相机".toText..style = Styles.ts_A8ABB0_24_medium,
                64.verticalSpace
              ],
            ),
          ),
        ),
      ),
    );
  }
}
