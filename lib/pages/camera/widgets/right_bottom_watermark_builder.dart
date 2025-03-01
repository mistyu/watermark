import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

import '../camera_logic.dart';

class RightBottomWatermarkBuilder extends StatelessWidget {
  const RightBottomWatermarkBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CameraLogic>();
    return GetBuilder<CameraLogic>(
      id: watermarkUpdateRightBottom,
      init: controller,
      builder: (logic) {
        if (!logic.openRightBottomWatermark) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
              right: logic.rightBottomPosition.value?.dx ?? 10.w,
              bottom: logic.rightBottomPosition.value?.dy ?? 10.w,
            ),
            child: GestureDetector(
              onTap: logic.toRightBottom,
              behavior: HitTestBehavior.opaque,
              child: logic.rightBottomImageByte.value != null
                  ? _buildWatermark(
                      imageBytes: logic.rightBottomImageByte.value!,
                      size: logic.rightBottomSize.value,
                    )
                  : _buildAdd(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWatermark({required Uint8List imageBytes, Size? size}) {
    return ImageUtil.memoryImage(
      imageBytes: imageBytes,
      width: size?.width,
      fit: BoxFit.contain,
    );
  }

  Widget _buildAdd() {
    return Image.asset(
      'ic_add_r2'.png,
      width: 50.w,
      fit: BoxFit.fitWidth,
    );
  }
}
