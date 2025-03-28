import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_liveShoot.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_dragger.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../camera_logic.dart';

/**
 * 主水印
 * 水印合成的过程原理：
 * 一张图片叠加水印图片进行合成新的图片，就和ps软件的图层的概念是一样的
 */
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
                // if (logic.liveShootData != null &&
                //     logic.liveShootData?.isHidden == false)
                //   RyWatermarkLiveshoot(
                //       controller: controller,
                //       resource: logic.currentWatermarkResource.value!),
                _logoWidgetMain(controller),
                WidgetsToImage(
                  controller: logic.mainWatermarkBackgroundController,
                  child: _buildWatermarkBackground(
                      logic.currentWatermarkResource.value!.id.toString(),
                      data: logic.currentWatermarkView.value?.data,
                      widgetKey: logic.watermarkBackgroundKey),
                ),
                // 图层-水印
                WatermarkDragger(
                  // 水印拖动
                  offset: logic.watermarkOffset.value,
                  onTap: logic.onEditTap,
                  onChange: logic.onChangeWatermarkPosition,
                  onPanEnd: logic.onWatermarkPanEnd,
                  child: WidgetsToImage(
                    controller: logic.mainWatermarkController,
                    child: Transform.scale(
                      scale: logic.watermarkScale,
                      alignment: Alignment.bottomLeft,
                      child: WatermarkPreview(
                        key: logic.watermarkKey,
                        resource: logic.currentWatermarkResource.value!,
                        watermarkView: logic.currentWatermarkView.value,
                      ),
                    ),
                  ),
                ),

                //特殊的
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _logoWidgetMain(CameraLogic controller) {
    // 构建logo
    return GetBuilder<CameraLogic>(
        init: controller,
        id: controller.watermarkLogoUpdateMain,
        builder: (logic) {
          if (logic.logoData != null &&
              logic.logoData?.isHidden == false &&
              logic.logoData?.logoPositionType != 0) {
            if (logic.logoData != null &&
                logic.logoData?.isHidden == false &&
                logic.logoData?.logoPositionType != 0) {
              if (logic.logoData?.logoPositionType == 0) {
                return const SizedBox();
              }
              if (logic.logoData?.logoPositionType == 1) {
                return Positioned(
                    top: 0, left: 0, child: _LogoWidget(controller));
              }
              if (logic.logoData?.logoPositionType == 2) {
                return Positioned(
                    top: 0, right: 0, child: _LogoWidget(controller));
              }
              if (logic.logoData?.logoPositionType == 3) {
                return Positioned(
                    bottom: 0, left: 0, child: _LogoWidget(controller));
              }
              if (logic.logoData?.logoPositionType == 4) {
                return Positioned(
                    bottom: 0, right: 0, child: _LogoWidget(controller));
              }
              if (logic.logoData?.logoPositionType == 5) {
                return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _LogoWidget(controller));
              }
            }
          }
          return const SizedBox();
        });
  }

  /**
   * 拍照后的图片，这里要根据预览进行切割然后在形成底图
   */
  Widget _buildWatermarkBackground(String id,
      {List<WatermarkData>? data, GlobalKey? widgetKey}) {
    final liveShootingWatermarkData = data?.firstWhereOrNull((element) =>
        element.type == 'RYWatermarkLiveShooting' && element.isHidden == false);
    if (liveShootingWatermarkData != null) {
      return FutureBuilder(
        future: WatermarkService.getImagePath(id,
            fileName: liveShootingWatermarkData.image), //监听这个异步任务
        builder: (context, snapshot) {
          // 任务完成
          if (snapshot.hasData) {
            print(
                "xiaojianjian 目前的放缩情况是 scale ${liveShootingWatermarkData?.scale}");
            return Center(
                key: widgetKey,
                child: Transform.scale(
                  scale: liveShootingWatermarkData?.scale,
                  child: ImageUtil.fileImage(
                      file: File(snapshot.data!),
                      fit: BoxFit.cover,
                      width: liveShootingWatermarkData.style?.iconWidth
                          ?.toDouble()),
                ));
          }
          return const SizedBox.shrink();
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _LogoWidget(CameraLogic controller) {
    // 构建logo
    return FutureBuilder<Widget>(
      future: ImageUtil.loadNetworkImage(controller.logoData?.content ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(color: Colors.grey[300]);
        }

        // 应用缩放和透明度
        return Opacity(
          opacity: 1,
          child: Transform.scale(
            scale: 1,
            child: snapshot.data!,
          ),
        );
      },
    );
  }
}
