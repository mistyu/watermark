import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:watermark_camera/apis.dart';
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

  set currentWatermarkView(WatermarkView value) {
    watermarkViews[currentPage.value] = value;
  }

  AssetType assetType = AssetType.image;

  void onSavePhoto() async {
    try {
      await Apis.userDeductTimes(photos.length);
    } catch (e) {
      AppNavigator.startVip();
      return;
    }
    Utils.showLoading("正在处理中...");
    List<String> results = [];
    try {
      // 确保临时目录存在
      final tempDir = await Directory(
              "${(await getApplicationDocumentsDirectory()).path}/frame")
          .create(recursive: true);
      print("xiaojianjian 临时目录创建成功: ${tempDir.path}");

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
              // LoadingView.singleton.dismiss();
              final result =
                  await WatermarkDialog.showSaveImageDialog(photoBytes);
              if (result) {
                final asset = await MediaService.savePhoto(photoBytes);
                Get.back(result: [asset]);
                return;
              }
            } else {
              // 使用安全的文件保存方法
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              final fileName = "$timestamp.png";
              final filePath = "${tempDir.path}/$fileName";

              // 直接写入文件
              await File(filePath).writeAsBytes(photoBytes);
              print("xiaojianjian 文件保存成功: $filePath");

              results.add(filePath);
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
                // LoadingView.singleton.dismiss();
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
      // LoadingView.singleton.dismiss();
      Utils.dismissLoading();

      final assets = await AppNavigator.startPhotoBatchPreview(results);
      if (assets != null && assets.isNotEmpty) {
        Get.back(result: assets);
      }
    } catch (e, s) {
      // LoadingView.singleton.dismiss();
      Utils.dismissLoading();
      ProgressUtil.dismiss();
      // Logger.print("e: $e, s: $s");
      print("xiaojianjian 生成失败，请稍后再试或者联系客服: $e");
      ToastUtil.show('生成失败，请重试一次或联系客服');
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

      // 获取视频的原始宽高比
      final videoAspectRatio = controller.value.aspectRatio;

      _videoControllers[targetIndex] = controller;
      _chewieControllers[targetIndex] = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        showControls: true,
        allowFullScreen: false, // 禁用全屏
        allowMuting: false, // 禁用静音
        allowPlaybackSpeedChanging: false, // 禁用播放速度更改
        customControls: const CupertinoControls(
          // 使用iOS风格控件，通常更简洁
          backgroundColor: Colors.black26,
          iconColor: Colors.white,
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.white,
          handleColor: Colors.white,
          backgroundColor: Colors.grey.shade800,
          bufferedColor: Colors.grey.shade500,
        ),
        placeholder: const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );

      update();
    } catch (e) {
      print("视频控制器初始化失败: $e");
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

  void onWatermarkPanEnd(Offset offset) async {
    bool result = await CommonDialog.showConfirmDialog(
      title: "调整位置",
      content: "检测到您调整了水印位置，是否需要覆盖到全部图片上?",
      cancelText: "只改当前",
      confirmText: "全部覆盖",
    );
    if (result) {
      for (var i = 0; i < photos.length; i++) {
        watermarkOffsets[i] = offset;
      }
    }
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
    final gridResult = await WatermarkSheet.showWatermarkGridSheet(
        resource: currentWatermarkResource);
    if (gridResult != null) {
      bool result = await CommonDialog.showConfirmDialog(
        title: "切换水印",
        content: "检测到您进行了水印的切换，是否需要切换水印到全部图片上?",
        cancelText: "只改当前",
        confirmText: "全部覆盖",
      );
      if (result) {
        //更新全部水印
        for (var i = 0; i < photos.length; i++) {
          setWatermarkById(gridResult.selectedWatermarkId!, i);
        }
      } else {
        //只更新当前页面的水印
        setWatermarkById(gridResult.selectedWatermarkId!, currentPage.value);
      }
      if (gridResult.showEdit!) {
        onEditTap();
      }
    }
  }

  void onEditTap() async {
    print("xiaojianjian 水印弹出框 ${currentWatermarkView}");
    final result = await WatermarkDialog.showWatermarkProtoSheet(
        resource: currentWatermarkResource,
        watermarkView: currentWatermarkView);
    if (result != null) {
      bool dialogResult = await CommonDialog.showConfirmDialog(
        title: "修改水印属性",
        content: "检测到您进行了水印的修改，是否需要修改水印到全部图片上?",
        cancelText: "只改当前",
        confirmText: "全部覆盖",
      );
      if (dialogResult) {
        for (var i = 0; i < photos.length; i++) {
          // 第一步：将所有水印都修改成本步的水印
          for (int i = 0; i < photos.length; i++) {
            setWatermarkById(currentWatermarkResource.id!, i);
          }
          // 第二步：将所有的水印的属性都修改成本水印属性
          for (int i = 0; i < photos.length; i++) {
            watermarkViews[i] = result.watermarkView;
          }
        }
      } else {
        watermarkViews[currentPage.value] = result.watermarkView;
      }
    }
    update();
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
    controller = ExtendedPageController(
      initialPage: 0,
      shouldIgnorePointerWhenScrolling: false,
      keepPage: true,
    )..addListener(() {
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
    initWatermarkList();
  }

  void initWatermarkList() {
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
