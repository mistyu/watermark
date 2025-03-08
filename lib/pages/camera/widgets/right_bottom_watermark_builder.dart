import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/camera/view/map/smallMap.dart';
import 'package:watermark_camera/utils/library.dart';
import 'dart:math' as math;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //这里的部分为于上方 --- 地图/二维码等等
              _topWidget(controller),

              //这里的部分位于下方
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _signatureWidgetMain(controller),
                  GestureDetector(
                    onTap: logic.toRightBottom,
                    behavior: HitTestBehavior.opaque,
                    child: logic.rightBottomImageByte.value != null
                        ? _buildWatermark(
                            imageBytes: logic.rightBottomImageByte.value!,
                            size: logic.rightBottomSize.value,
                          )
                        : _buildAdd(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _topWidget(CameraLogic controller) {
    print(
        'xiaojianjian controller.mapDataContent: ${controller.mapData?.isHidden}');
    print(
        'xiaojianjian controller.mapDataContent: ${controller.mapData?.content}');
    print('xiaojianjian controller.mapData: ${controller.mapData}');
    return Column(
      children: [
        if (controller.mapData != null &&
            controller.mapData?.isHidden == false &&
            Utils.isNotNullEmptyStr(controller.mapData?.content))
          SmallMap(
            latitude: controller.mapDataContent[0],
            longitude: controller.mapDataContent[1],
          ),
      ],
    );
  }

  Widget _signatureWidgetMain(CameraLogic controller) {
    // 构建签名图片
    return GetBuilder<CameraLogic>(
        init: controller,
        id: controller.watermarkSignatureUpdateMain,
        builder: (logic) {
          if (logic.signatureData != null &&
              logic.signatureData?.isHidden == false &&
              Utils.isNotNullEmptyStr(logic.signatureData?.content)) {
            return Positioned(
                bottom: 0, right: 0, child: _SignatureWidget(controller));
          }
          return const SizedBox();
        });
  }

  Widget _SignatureWidget(CameraLogic controller) {
    // 构建logo
    // 逆时针翻转一下
    return Transform.rotate(
      angle: -90 * (math.pi / 180),
      child: Image.file(File(controller.signatureData?.content ?? ''),
          fit: BoxFit.cover, width: 50, height: 50),
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
