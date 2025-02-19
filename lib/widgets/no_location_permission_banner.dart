import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

class NoLocationPermissionBanner extends StatelessWidget {
  final Future<bool> Function() onGrantPermission;
  const NoLocationPermissionBanner({
    super.key,
    required this.onGrantPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Container(
          color: const Color.fromARGB(255, 226, 251, 255),
          padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 10.h + MediaQuery.of(context).viewPadding.top,
              bottom: 10.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  "一键授权地点位置".toText..style = Styles.ts_333333_16_medium,
                  GestureDetector(
                    onTap: () {
                      Get.back(result: false);
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      color: Styles.c_333333,
                    ),
                  ),
                ],
              ),
              6.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  "可在水印中显示精准位置及天气".toText..style = Styles.ts_999999_14,
                  FilledButton(
                    onPressed: () async {
                      final result = await onGrantPermission();
                      if (result) {
                        Get.back(result: true);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Styles.c_0481DC,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: "立即授权".toText..style = Styles.ts_FFFFFF_14_medium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
