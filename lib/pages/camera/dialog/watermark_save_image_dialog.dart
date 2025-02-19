import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

class WatermarkSaveImageDialog extends StatelessWidget {
  final Uint8List imageBytes;
  const WatermarkSaveImageDialog({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("save_blue_img".webp),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          "拍照成功".toText..style = Styles.ts_0C8CE9_20_medium,
          16.verticalSpace,
          ImageUtil.memoryImage(imageBytes: imageBytes),
          32.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Styles.c_FFFFFF,
                  ),
                  child: '重 拍'.toText..style = Styles.ts_333333_16,
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Styles.c_0C8CE9,
                    side: BorderSide(color: Styles.c_0C8CE9.withOpacity(0.5)),
                  ),
                  child: '保存图片'.toText..style = Styles.ts_FFFFFF_16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
