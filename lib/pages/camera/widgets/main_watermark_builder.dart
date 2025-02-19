import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_dragger.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../camera_logic.dart';

class MainWatermarkBuilder extends StatelessWidget {
  const MainWatermarkBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CameraLogic>();
    return Positioned.fill(
      child: GetBuilder<CameraLogic>(
        id: watermarkUpdateMain,
        init: controller,
        builder: (logic) {
          if (logic.currentWatermarkResource.value != null) {
            return Stack(
              children: [
                WidgetsToImage(
                  controller: logic.mainWatermarkBackgroundController,
                  child: _buildWatermarkBackground(
                      logic.currentWatermarkResource.value!.id.toString(),
                      data: logic.currentWatermarkView.value?.data,
                      widgetKey: logic.watermarkBackgroundKey),
                ),
                WatermarkDragger(
                  offset: logic.watermarkOffset.value,
                  onTap: logic.onEditTap,
                  onChange: logic.onChangeWatermarkPosition,
                  child: WidgetsToImage(
                    controller: logic.mainWatermarkController,
                    child: Transform.scale(
                      scale: logic.watermarkScale.value,
                      alignment: Alignment.topLeft,
                      child: WatermarkPreview(
                        key: logic.watermarkKey,
                        resource: logic.currentWatermarkResource.value!,
                        watermarkView: logic.currentWatermarkView.value,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildWatermarkBackground(String id,
      {List<WatermarkData>? data, GlobalKey? widgetKey}) {
    final liveShootingWatermarkData = data?.firstWhereOrNull((element) =>
        element.type == 'RYWatermarkLiveShooting' && element.isHidden == false);
    if (liveShootingWatermarkData != null) {
      return FutureBuilder(
        future: WatermarkService.getImagePath(id,
            fileName: liveShootingWatermarkData.image),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              key: widgetKey,
              child: ImageUtil.fileImage(
                  file: File(snapshot.data!),
                  fit: BoxFit.cover,
                  width:
                      liveShootingWatermarkData.style?.iconWidth?.toDouble()),
            );
          }
          return const SizedBox.shrink();
        },
      );
    }
    return const SizedBox.shrink();
  }
}
