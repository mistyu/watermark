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
        return Visibility(
          visible: logic.openRightBottomWatermark,
          child: Positioned(
            right: logic.rightBottomPosition.value?.dx ?? 10,
            bottom: logic.rightBottomPosition.value?.dy ?? 10,
            child: GestureDetector(
              onTap: logic.toRightBottom,
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
      // fit: BoxFit.fitWidth
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
