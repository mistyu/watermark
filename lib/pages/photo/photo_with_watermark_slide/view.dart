import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';
import 'package:watermark_camera/widgets/title_bar.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_dragger.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import 'logic.dart';

class PhotoWithWatermarkSlidePage extends StatelessWidget {
  PhotoWithWatermarkSlidePage({Key? key}) : super(key: key);

  final PhotoWithWatermarkSlideLogic _logic =
      Get.find<PhotoWithWatermarkSlideLogic>();

  TextStyle get _textStyle => Styles.ts_333333_14_medium;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: TitleBar.back(
          title:
              "编辑图片加水印(${_logic.currentPage.value + 1}/${_logic.photos.length})",
          right: TextButton(
              onPressed: _logic.onSavePhoto,
              child: "预览".toText..style = Styles.ts_0C8CE9_16_medium),
        ),
        body: ExtendedImageSlidePage(
            slideAxis: SlideAxis.both,
            slideType: SlideType.onlyImage,
            child: Column(
              children: [
                Expanded(child: _pageView),
                _buildSlideBottom(context)
              ],
            ))));
  }

  Widget _buildSlideBottom(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: context.mediaQueryPadding.bottom,
      ),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              BouncingWidget(
                  onTap: _logic.onWatermarkTap,
                  child: "home_ico_water".png.toImage..width = 24.w),
              3.verticalSpace,
              "水印".toText..style = _textStyle
            ],
          ),
          Row(
            children: [
              TextButton(onPressed: _logic.onPrevPage, child: "上一页".toText),
              TextButton(onPressed: _logic.onNextPage, child: "下一页".toText)
            ],
          ),
          Column(
            children: [
              BouncingWidget(
                  onTap: _logic.onEditTap,
                  child: "home_ico_edit".png.toImage..width = 24.w),
              3.verticalSpace,
              "修改".toText..style = _textStyle
            ],
          ),
        ],
      ),
    );
  }

  Widget get _pageView => ExtendedImageGesturePageView.builder(
        controller: _logic.controller,
        itemCount: _logic.photos.length,
        itemBuilder: (BuildContext context, int index) {
          final photo = _logic.photos.elementAt(index);

          return Center(
            child: GetBuilder<PhotoWithWatermarkSlideLogic>(
                init: _logic,
                builder: (logic) {
                  final watermarkView = logic.watermarkViews[index];
                  final watermarkResource = logic.watermarkResources[index];
                  final mainWatermarkController =
                      logic.mainWatermarkControllers[index];
                  final mainWatermarkBackgroundController =
                      logic.mainWatermarkBackgroundControllers[index];
                  final watermarkOffset = logic.watermarkOffsets[index];
                  final watermarkScale = logic.watermarkScale[index];

                  ChewieController? chewieController;

                  if (photo.type == AssetType.video) {
                    chewieController = logic.getChewieController(index);
                  }
                  return Stack(
                    children: [
                      _buildAsset(photo, chewieController: chewieController),
                      _buildRightBottomWatermark(index),
                      _buildMainWatermark(index,
                          mainWatermarkController: mainWatermarkController!,
                          mainWatermarkBackgroundController:
                              mainWatermarkBackgroundController!,
                          watermarkView: watermarkView,
                          watermarkResource: watermarkResource,
                          watermarkOffset: watermarkOffset,
                          watermarkScale: watermarkScale),
                    ],
                  );
                }),
          );
        },
      );

  Widget _buildMainWatermark(int index,
      {WatermarkView? watermarkView,
      WatermarkResource? watermarkResource,
      Offset? watermarkOffset,
      double? watermarkScale,
      required WidgetsToImageController mainWatermarkController,
      required WidgetsToImageController mainWatermarkBackgroundController}) {
    if (watermarkView != null && watermarkResource != null) {
      return Positioned.fill(
          child: Stack(
        children: [
          WidgetsToImage(
            controller: mainWatermarkBackgroundController,
            child: _buildWatermarkBackground(
              watermarkResource.id.toString(),
              data: watermarkView.data,
              widgetKey: _logic.watermarkBackgroundKeys[index],
            ),
          ),
          WatermarkDragger(
            onTap: _logic.onEditTap,
            offset: watermarkOffset ?? Offset.zero,
            onChange: (offset) =>
                _logic.onChangeWatermarkPosition(index, offset),
            child: WidgetsToImage(
              controller: mainWatermarkController,
              child: Transform.scale(
                scale: watermarkScale ?? 1.0,
                alignment: Alignment.topLeft,
                child: WatermarkPreview(
                  key: _logic.watermarkKeys[index],
                  resource: watermarkResource,
                  watermarkView: watermarkView,
                ),
              ),
            ),
          ),
        ],
      ));
    }
    return const SizedBox.shrink();
  }

  Widget _buildRightBottomWatermark(
    int index,
  ) {
    final rightBottomWatermarkPosition =
        _logic.rightBottomWatermarkPositions[index];
    final rightBottomWatermarkSize = _logic.rightBottomWatermarkSizes[index];
    final rightBottomWatermarkImageBytes =
        _logic.rightBottomWatermarkImageBytes[index];
    return Positioned(
      right: rightBottomWatermarkPosition?.dx ?? 10,
      bottom: rightBottomWatermarkPosition?.dy ?? 10,
      child: GestureDetector(
        onTap: () => _logic.toRightBottom(index),
        child: rightBottomWatermarkImageBytes != null
            ? _buildWatermark(
                imageBytes: rightBottomWatermarkImageBytes,
                size: rightBottomWatermarkSize,
              )
            : _buildAdd(),
      ),
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

  FutureBuilder<File?> _buildAsset(AssetEntity photo,
      {ChewieController? chewieController}) {
    return FutureBuilder<File?>(
        future: photo.file,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (photo.type == AssetType.video) {
              if (chewieController != null) {
                return Chewie(controller: chewieController);
              }
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return ImageUtil.fileImage(
              file: snapshot.data!,
              fit: BoxFit.contain,
              heroBuilderForSlidingPage: (Widget result) {
                return Hero(
                  tag: snapshot.data!.path,
                  child: result,
                );
              },
            );
          }
          return const SizedBox.shrink();
        });
  }
}
