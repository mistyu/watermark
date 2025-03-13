import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/core/service/media_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/dialog/watermark_dialog.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_sheet.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/loading_view.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class PhotoWithWatermarkSlideLogic extends GetxController {
  late ExtendedPageController controller;
  late PhotoAddWatermarkType opType;
  final watermarkLogic = Get.find<WaterMarkController>();

  final mainWatermarkControllers = <int, WidgetsToImageController>{}; // 主水印
  final mainWatermarkBackgroundControllers =
      <int, WidgetsToImageController>{}; // 主水印背景

  final watermarkKeys = <int, GlobalKey<State<StatefulWidget>>>{};
  final watermarkBackgroundKeys = <int, GlobalKey<State<StatefulWidget>>>{};

  final photos = <AssetEntity>[].obs;

  final _videoControllers = <int, VideoPlayerController>{}; // 视频控制器
  final _chewieControllers = <int, ChewieController>{}; // 视频播放控制器

  final watermarkResources = <int, WatermarkResource>{};
  final watermarkViews = <int, WatermarkView>{};

  final watermarkScale = <int, double>{}; // 水印缩放
  final watermarkOffsets = <int, Offset>{}; // 水印偏移量
  final rightBottomWatermarkSizes = <int, Size?>{}; // 水印大小
  final rightBottomWatermarkPositions = <int, Offset?>{}; // 水印位置
  final rightBottomWatermarkImageBytes = <int, Uint8List?>{}; // 水印图片

  final currentPage = 0.obs;

  WatermarkResource get currentWatermarkResource =>
      watermarkResources[currentPage]!;
  WatermarkView get currentWatermarkView => watermarkViews[currentPage]!;

  AssetType assetType = AssetType.image;

  void onSavePhoto() async {
    List<String> results = [];
    try {
      LoadingView.singleton.show();

      for (var i = 0; i < photos.length; i++) {
        // 先滑动到对应页面
        if (i != currentPage.value) {
          await controller.animateToPage(
            i,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          // 等待页面渲染完成
          await Future.delayed(const Duration(milliseconds: 300));
        }

        final asset = photos[i];
        final file = await asset.originFile;
        if (file == null) continue;

        final watermarkKey = watermarkKeys[i];
        final watermarkOffset = watermarkOffsets[i];
        final watermarkBackgroundKey = watermarkBackgroundKeys[i];
        final rightBottomImageByte = rightBottomWatermarkImageBytes[i];
        final rightBottomSize = rightBottomWatermarkSizes[i];
        final rightBottomPosition = rightBottomWatermarkPositions[i];
        final aspectRatio = asset.width / asset.height;

        if (assetType == AssetType.image) {
          final photoBytes = await MediaService.savePhotoWithWatermark(
            originalPhotoPath: file.path,
            aspectRatio: aspectRatio,
            captureWatermark: () => mainWatermarkControllers[i]!.capture(),
            watermarkSize: watermarkKey?.currentContext?.size,
            watermarkPosition: watermarkOffset ??
                const Offset(watermarkMinMargin, watermarkMinMargin),
            captureWatermarkBackground: () =>
                mainWatermarkBackgroundControllers[i]!.capture(),
            watermarkBackgroundSize:
                watermarkBackgroundKey?.currentContext?.size,
            rightBottomWatermarkBytes: rightBottomImageByte,
            rightBottomWatermarkSize: rightBottomSize,
            rightBottomWatermarkPosition: rightBottomPosition,
          );

          if (photoBytes != null) {
            if (opType == PhotoAddWatermarkType.single) {
              LoadingView.singleton.dismiss();
              final result =
                  await WatermarkDialog.showSaveImageDialog(photoBytes);
              if (result) {
                final asset = await MediaService.savePhoto(photoBytes);
                Get.back(result: [asset]);
                return;
              }
            } else {
              final path = await Utils.getTempFileWithBytes(
                  dir: "frame",
                  name: "${DateTime.now().millisecondsSinceEpoch}.png",
                  bytes: photoBytes);
              results.add(path);
            }
          }
        } else {
          // 视频处理逻辑...
          OverlayEntry? dialogId;
          final videoPath = await MediaService.saveVideoWithWatermark(
            originalVideoPath: file.path,
            captureWatermark: () => mainWatermarkControllers[i]!.capture(),
            watermarkSize: watermarkKey?.currentContext?.size,
            watermarkPosition: watermarkOffset ??
                const Offset(watermarkMinMargin, watermarkMinMargin),
            captureWatermarkBackground: () =>
                mainWatermarkBackgroundControllers[i]!.capture(),
            watermarkBackgroundSize:
                watermarkBackgroundKey?.currentContext?.size,
            rightBottomWatermarkBytes: rightBottomImageByte,
            rightBottomWatermarkSize: rightBottomSize,
            rightBottomWatermarkPosition: rightBottomPosition,
            onProgress: (value) {
              if (dialogId == null) {
                LoadingView.singleton.dismiss();
                dialogId = ProgressUtil.show();
              } else {
                ProgressUtil.updateProgress(value * 100);
              }
            },
          );

          if (!Utils.isNullEmptyStr(videoPath)) {
            if (opType == PhotoAddWatermarkType.single) {
              final result =
                  await WatermarkDialog.showSaveVideoDialog(File(videoPath!));
              if (result) {
                final asset = await MediaService.saveVideo(File(videoPath));
                Get.back(result: [asset]);
                return;
              }
            } else {
              results.add(videoPath!);
            }
          }
        }
      }
      LoadingView.singleton.dismiss();

      final assets = await AppNavigator.startPhotoBatchPreview(results);
      if (assets != null && assets.isNotEmpty) {
        Get.back(result: assets);
      }
    } catch (e, s) {
      LoadingView.singleton.dismiss();
      ProgressUtil.dismiss();
      Logger.print("e: $e, s: $s");
      ToastUtil.show('生成失败，请稍后再试或者联系客服: $e');
    }
  }

  //加载视频
  Future<void> _loadVideo({int? index}) async {
    final targetIndex = index ?? currentPage.value;

    if (_videoControllers[targetIndex] != null) return;

    try {
      final asset = photos[targetIndex];
      final file = await asset.file;
      if (file == null) return;

      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      _videoControllers[targetIndex] = controller;
      _chewieControllers[targetIndex] = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        showControls: false,
        showOptions: false,
        allowFullScreen: false,
        materialProgressColors: ChewieProgressColors(
          handleColor: Styles.c_FFFFFF,
          playedColor: Styles.c_FFFFFF.withOpacity(0.75),
          bufferedColor: Styles.c_FFFFFF.withOpacity(0.25),
          backgroundColor: Colors.black.withOpacity(0.05),
        ),
        cupertinoProgressColors: ChewieProgressColors(
          handleColor: Styles.c_FFFFFF,
          playedColor: Styles.c_FFFFFF.withOpacity(0.75),
          bufferedColor: Styles.c_FFFFFF.withOpacity(0.25),
          backgroundColor: Colors.black.withOpacity(0.05),
        ),
      );

      update(); // 通知UI更新
    } catch (e, s) {
      Logger.print("e: $e, s: $s");
    }
  }

  // 预加载水印
  void _preloadWatermark(int index) {
    if (watermarkLogic.firstWatermarkId == null) return;
    watermarkKeys[index] = GlobalKey(debugLabel: 'watermark_$index');
    watermarkBackgroundKeys[index] =
        GlobalKey(debugLabel: 'watermark_background_$index');
    watermarkOffsets[index] =
        const Offset(watermarkMinMargin, watermarkMinMargin);
    mainWatermarkControllers[index] = WidgetsToImageController();
    mainWatermarkBackgroundControllers[index] = WidgetsToImageController();
    setWatermarkById(watermarkLogic.firstWatermarkId!, index);
  }

  // 预加载相邻页面的视频
  void _preloadAdjacentVideos(int currentIndex) {
    if (currentIndex > 0) {
      final prevAsset = photos[currentIndex - 1];
      if (prevAsset.type == AssetType.video) {
        _loadVideo(index: currentIndex - 1);
      }
    }

    if (currentIndex < photos.length - 1) {
      final nextAsset = photos[currentIndex + 1];
      if (nextAsset.type == AssetType.video) {
        _loadVideo(index: currentIndex + 1);
      }
    }
  }

  void setWatermarkById(int id, int index) async {
    final targetIndex = index;
    final resource = watermarkLogic.watermarkResourceList
        .firstWhereOrNull((element) => element.id == id);
    if (resource == null) return;
    watermarkResources[targetIndex] = resource;
    final watermarkSetting =
        watermarkLogic.getDbWatermarkByResourceId(resource.id!);

    if (watermarkSetting != null) {
      watermarkViews[targetIndex] = watermarkSetting.watermarkView;
      watermarkScale[targetIndex] = watermarkSetting.scale ?? 1.0;
    } else {
      final view = await WatermarkView.fromResourceWithId(id);
      if (view == null) return;
      watermarkViews[targetIndex] = view;
      watermarkScale[targetIndex] = 1.0;
    }

    update();
  }

  void onChangeWatermarkPosition(int index, Offset offset) {
    watermarkOffsets[index] = offset;
  }

  void toRightBottom(int index) async {
    final result = await AppNavigator.startRightBottom(
      resource: currentWatermarkResource,
    );
    if (result != null) {
      rightBottomWatermarkImageBytes[index] = result["rightBottomImageByte"];
      rightBottomWatermarkPositions[index] = result["position"];
      rightBottomWatermarkSizes[index] = result["rightBottomSize"];
    } else {
      rightBottomWatermarkImageBytes[index] = null;
      rightBottomWatermarkPositions[index] = null;
      rightBottomWatermarkSizes[index] = null;
    }
    update();
  }

  void onWatermarkTap() async {
    final id = await WatermarkSheet.showWatermarkGridSheet(
        resource: currentWatermarkResource);
    if (id != null) {
      setWatermarkById(id, currentPage.value);
    }
  }

  void onEditTap() {
    print("xiaojianjian 水印弹出框 ${currentWatermarkView}");
    WatermarkDialog.showWatermarkProtoSheet(
        resource: currentWatermarkResource,
        watermarkView: currentWatermarkView);
  }

  void onNextPage() {
    controller.animateToPage(currentPage.value + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn);
  }

  void onPrevPage() {
    controller.animateToPage(currentPage.value - 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn);
  }

  void _initData() {
    controller = ExtendedPageController(shouldIgnorePointerWhenScrolling: false)
      ..addListener(() {
        final page = controller.page;
        if (page == null || page % 1 != 0) return;
        final cPage = page.toInt();
        final cAsset = photos[cPage];
        if (cAsset.type == AssetType.video) {
          _loadVideo(index: cPage);
          _preloadAdjacentVideos(cPage);
        }

        if (cPage != currentPage.value) {
          currentPage.value = cPage;
        }
      });

    final data = Get.arguments['photos'];
    photos.value = data ?? [];

    if (photos.first.type == AssetType.video) {
      _loadVideo(index: 0);
      assetType = AssetType.video;
    } else {
      assetType = AssetType.image;
    }

    for (var i = 0; i < photos.length; i++) {
      _preloadWatermark(i); // 将水印加载到水印列表中
    }
  }

  @override
  void onInit() {
    opType = Get.arguments['type'] ?? PhotoAddWatermarkType.single;
    _initData();
    super.onInit();
  }

  @override
  void onClose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    for (var controller in _chewieControllers.values) {
      controller.dispose();
    }
    controller.dispose();
    _videoControllers.clear();
    _chewieControllers.clear();
    watermarkKeys.clear();
    watermarkBackgroundKeys.clear();
    super.dispose();
  }

  ChewieController? getChewieController(int index) {
    return _chewieControllers[index];
  }
}
