// ignore_for_file: slash_for_doc_comments

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:isolate';

import 'package:audioplayers/audioplayers.dart';
import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/core/controller/camera_controller.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/controller/permission_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/core/service/media_service.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
import 'package:watermark_camera/models/qt/qt.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/crop.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/image_process.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/loading_view.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image/image.dart' as img;

import 'dialog/watermark_dialog.dart';
import 'sheet/watermark_sheet.dart';

// 添加 IsolateData 类用于传递数据
class IsolateData {
  final SendPort sendPort;
  final GlobalKey key;

  IsolateData({
    required this.sendPort,
    required this.key,
  });
}

class CameraLogic extends CameraCoreController {
  final watermarkLogic = Get.find<WaterMarkController>();
  final watermarkProtoLogic = Get.find<WatermarkProtoLogic>();
  final locationController = Get.find<LocationController>();

  final mainWatermarkController = WidgetsToImageController();
  final mainWatermarkBackgroundController = WidgetsToImageController();
  final watermarkController = WidgetsToImageController();

  /**
   *问题：
  * currentWatermarkResource ？选择的currentWatermarkResourceList中的水印
    currentWatermarkView？
  */
  final currentWatermarkResource = Rxn<WatermarkResource>();
  final currentWatermarkView = Rxn<WatermarkView>();

  ImageResult? watermarkPhotoResult; //提前缓存水印图片

  WatermarkData? get logoData => currentWatermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == watermarkBrandLogoType);

  WatermarkData? get liveShootData => currentWatermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == watermarkLiveShoot);

  WatermarkData? get signatureData => currentWatermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == watermarkSignature);

  WatermarkData? get mapData => currentWatermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == watermarkMap);

  WatermarkData? get qtData => currentWatermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == watermarkQrCode);

  final watermarkLogoUpdateMain = 'watermark_logo_update_main';
  final watermarkSignatureUpdateMain = 'watermark_signature_update_main';
  final watermarkLiveShootUpdateMain = 'watermark_liveShoot_update_main';
  final watermarkMapUpdateMain = 'watermark_map_update_main';
  final audioPlayer = AudioPlayer();
  final watermarkKey = GlobalKey();
  final watermarkBackgroundKey = GlobalKey();
  final watermarkToImageKey = GlobalKey();
  final watermarkPhotoKey = GlobalKey();
  final alignPosiotnInRatio1_1 =
      Alignment.lerp(Alignment.topLeft, Alignment.center, 0.3)!;
  final alignPosiotnInRatio1_1_zoom =
      Alignment.lerp(Alignment.topRight, Alignment.center, 0.5)!;
  /**
   * 水印的位置
   */
  final watermarkOffset =
      const Offset(watermarkMinMargin, watermarkMinMargin).obs;

  Rxn<Uint8List> rightBottomImageByte = Rxn();
  Rxn<Offset> rightBottomPosition = Rxn();
  Rxn<Size> rightBottomSize = Rxn();

  bool get openSaveNoWatermarkImage =>
      appController.openSaveNoWatermarkImage.value;

  bool get openRightBottomWatermark =>
      appController.openRightBottomWatermark.value;

  double get watermarkScale => currentWatermarkView.value?.scale ?? 1;

  // bool get openCameraShutterSound => appController.openCameraShutterSound.value;

  final currentZoom = 1.0.obs;
  bool isZoomDragging = false;
  double zoomPercent = 0.0;

  final focusPosition = Rxn<Offset>();
  final isFocusVisible = false.obs;
  final exposureValue = 0.0.obs;
  final isExposureDragging = false.obs;
  Timer? _focusTimer;

  // 在类的顶部添加这个通道
  static const platform =
      MethodChannel('com.aiku.super_watermark_camera/permissions');

  void setExposureDragging(bool dragging) {
    if (dragging) {
      _focusTimer?.cancel();
      isFocusVisible.value = true;
    } else {
      isFocusVisible.value = false;
      update(['focus_circle']);
    }
    isExposureDragging.value = dragging;
  }

  void onExposureChanged(double value) {
    exposureValue.value = value.clamp(-1.0, 1.0);
    cameraController?.setExposureOffset(value);
    update(['focus_circle']);
  }

  void onTapToFocus(TapDownDetails details) {
    if (!isCameraInitialized.value) {
      Utils.showToast("请您确认相机权限打开");
      return;
    }

    if (isExposureDragging.value) {
      //如果在滑动那么不要进行监听这里的事件了
      _focusTimer?.cancel();
      isFocusVisible.value = true;
      return;
    }

    focusPosition.value = details.localPosition;
    isFocusVisible.value = true;

    // 执行聚焦
    final point = Offset(
      details.localPosition.dx / Get.width,
      details.localPosition.dy / Get.height,
    );

    // 2秒后隐藏
    _focusTimer?.cancel();
    _focusTimer = Timer(const Duration(seconds: 2), () {
      isFocusVisible.value = false;
      update(['focus_circle']);
    });

    update(['focus_circle']);
  }

  void goCameraPermission() async {
    // print("xiaojianjian goCameraPermission");
    pendingCameraPermissionCheck = true;
    addLifecycleListener();
    await openAppSettings();
  }

  QtModel? qtModel() {
    //解析二维码
    final qrData = qtData?.content;
    if (qrData == null) return null;

    final qrModel = QtModel(
      type: qrData.split('&')[0].split('=')[1],
      sender: qrData.split('&')[1].split('=')[1],
      sendTime: qrData.split('&')[2].split('=')[1],
    );
    return qrModel;
  }

  List<double> get mapDataContent =>
      mapData?.content?.split(',').map((e) => double.parse(e)).toList() ?? [];

  void setWatermarkViewByResource(WatermarkResource? resource) async {
    if (resource?.id == null) return;

    // 从资源中获取水印视图 （水印的一系列的样式属性等等）
    currentWatermarkView.value = await WatermarkView.fromResource(resource!);

    // final watermarkSetting =
    //     watermarkLogic.getDbWatermarkByResourceId(resource!.id!);
    // if (watermarkSetting != null) {
    //   currentWatermarkView.value = watermarkSetting.watermarkView;
    //   watermarkScale.value = watermarkSetting.scale ?? 1.0;
    // } else {
    //   currentWatermarkView.value = await WatermarkView.fromResource(resource);
    //   watermarkScale.value = 1.0;
    // }

    update([watermarkUpdateMain]);
  }

  void toRightBottom() async {
    final result = await AppNavigator.startRightBottom(
      resource: currentWatermarkResource.value,
    );
    if (result != null) {
      rightBottomImageByte.value = result["rightBottomImageByte"];
      rightBottomPosition.value = result["position"];
      rightBottomSize.value = result["rightBottomSize"];
    } else {
      rightBottomImageByte.value = null;
      rightBottomPosition.value = null;
      rightBottomSize.value = null;
    }
    update([watermarkUpdateRightBottom]);
  }

  void setWatermarkResourceById(int id) {
    currentWatermarkResource.value = watermarkLogic.watermarkResourceList
        .firstWhere((element) => element.id == id);
    setWatermarkViewByResource(currentWatermarkResource.value);
  }

  Future<void> initWatermark() async {
    print("xiaojianjian 初始化相机initWatermark");
    final resource =
        Get.arguments["resource"]; //接受首页选择的水印资源，主要是读取它的相应的id参数然后找到对应的模板
    currentWatermarkResource.value =
        resource ?? watermarkLogic.firstResource.value;
    setWatermarkViewByResource(currentWatermarkResource.value);
  }

  /**
   * 修改水印的位置
   */
  void onChangeWatermarkPosition(Offset offset) {
    watermarkOffset.value = offset;
  }

  void onWatermarkPanEnd() {
    //缓存水印
    cacheWatermarkPhoto();
  }

  void onThumbnailTap() {
    // 这里要申请相册权限 -- 同时指名用处
    AppNavigator.startPhotoSlide(photos: photos);
  }

  void onEditTap() async {
    if (currentWatermarkResource.value == null ||
        currentWatermarkView.value == null) {
      ToastUtil.show('请先设置水印');
      return;
    }

    final result = await WatermarkDialog.showWatermarkProtoSheet(
        resource: currentWatermarkResource.value!,
        watermarkView: currentWatermarkView.value!) as WatermarkSettingsModel?;

    /**
     * 返回信息进行修改
    */
    if (result != null) {
      // 更新当前水印视图
      currentWatermarkView.value = result.watermarkView;
      cacheWatermarkPhoto();
      // 更新缩放
      // 通知UI更新
      update([watermarkUpdateMain]);
      update([watermarkSignatureUpdateMain]);
      update([watermarkMapUpdateMain]);
      WatermarkService.saveTemplateJson(
          currentWatermarkResource.value!.id.toString(),
          data: result.watermarkView);
    }
  }

  void onWatermarkTap() async {
    final id = await WatermarkSheet.showWatermarkGridSheet(
        resource: currentWatermarkResource.value);
    if (id != null) {
      setWatermarkResourceById(id);
    }
  }

  // 播放音频的函数
  void _playCameraSound() {
    audioPlayer.play(AssetSource('media/camera_kk.mp3'));
  }

  /// 提前缓存水印图片
  void cacheWatermarkPhoto() async {
    Future.microtask(() async {
      watermarkPhotoResult =
          await watermarkLogic.captureWatermark(watermarkToImageKey);
    });
  }

  /// 清除缓存的水印图片
  void clearWatermarkCache() {
    watermarkPhotoResult = null;
  }

  /**
    * 拍照
      裁剪图片-图层 水印-图层
      图层合成
      预处理水印图层，这样拍照的时候只需要直接合成就好了
  */
  Future<void> onTakePhoto() async {
    print("xiaojianjian 拍照开始");
    // //检查次数
    // try {
    //   await Apis.userDeductTimes(1);
    // } catch (e) {
    //   AppNavigator.startVip();
    //   return;
    // }

    try {
      // final decodeStartTime = DateTime.now();
      // if (!isCameraInitialized.value) return;

      _playCameraSound();

      final croppedBytes = await watermarkLogic.capturePhoto(watermarkPhotoKey);

      // 判断一下是否已经被缓存过了
      ImageResult? watermarkBytes = watermarkPhotoResult;
      if (watermarkBytes == null) {
        watermarkBytes =
            await watermarkLogic.captureWatermark(watermarkToImageKey);
      }

      await MediaService.savePhoto(croppedBytes!.image);
      final overlayBytes = await ImageProcess.overlayImages(
          croppedBytes!.image,
          watermarkBytes!.image,
          croppedBytes.width,
          croppedBytes.height,
          watermarkBytes.width,
          watermarkBytes.height);
      final result = await WatermarkDialog.showSaveImageDialog(overlayBytes);
      if (result) {
        if (openSaveNoWatermarkImage) {
          final noWatermarkPhoto =
              await MediaService.savePhoto(croppedBytes!.image);

          photos.insert(0, noWatermarkPhoto);
          photos.refresh();
        }
        final photo = await MediaService.savePhoto(overlayBytes);
        photos.insert(0, photo);
        photos.refresh();
      }
      // print(
      //     "xiaojianjian 拍照所有内容结束 ${DateTime.now().difference(decodeStartTime).inMilliseconds}ms");
    } catch (e, s) {
      Logger.print("e: $e, s: $s");
      Utils.showToast("拍照失败, 请联系客服");
    }
  }

  /**
    * 通过拍照裁剪图片，不是Wight进行截图获取图片， 两边时间差不多
    */
  Future<Uint8List> cropImage(
      Uint8List imageBytes, CropParameters cropParameters) async {
    // 拍照
    // final decodeStartTime1 = DateTime.now();
    final originalPhoto = await cameraController?.takePicture();

    // 使用 exif 包快速读取图片尺寸
    final imageFile = File(originalPhoto!.path);
    final bytes = await imageFile.readAsBytes();
    final exifData = await readExifFromBytes(bytes);

    // 从 EXIF 数据中获取图片尺寸
    final width = exifData['Image ImageWidth']?.values.firstAsInt() ?? 0;
    final height = exifData['Image ImageLength']?.values.firstAsInt() ?? 0;
    final originalRatio = 1 / cameraController!.value.aspectRatio;
    final targetRatio = aspectRatio.value.ratio;
    if (targetRatio == originalRatio) {
      await MediaService.savePhoto(bytes);
      return bytes;
    }

    final cropParams = _calculateCropParameters(
      width,
      height,
      originalRatio,
      targetRatio,
    );

    // 使用 FFmpeg 裁剪图片
    final croppedBytes = await ImageProcess.cropImage(
      originalPhoto.path,
      x: cropParams.x,
      y: cropParams.y,
      width: cropParams.width,
      height: cropParams.height,
    );
    // print(
    //     "xiaojianjian 拍照裁剪图片结束 ${DateTime.now().difference(decodeStartTime1).inMilliseconds}ms");
    return croppedBytes;
  }

  // 将裁剪参数计算抽离出来
  CropParameters _calculateCropParameters(
    int sourceWidth,
    int sourceHeight,
    double originalRatio,
    double targetRatio,
  ) {
    int cropWidth = sourceWidth;
    int cropHeight = sourceHeight;
    int offsetX = 0;
    int offsetY = 0;

    if (targetRatio > originalRatio) {
      cropHeight = (sourceWidth / targetRatio).toInt();
      offsetY = ((sourceHeight - cropHeight) / 2).toInt();
    } else if (targetRatio < originalRatio) {
      cropWidth = (sourceHeight * targetRatio).toInt();
      offsetX = ((sourceWidth - cropWidth) / 2).toInt();
    }

    return CropParameters(
      x: offsetX,
      y: offsetY,
      width: cropWidth,
      height: cropHeight,
    );
  }

  // 计算裁剪区域
  Rect _calculateCropRect(double width, double height, double targetRatio) {
    double cropWidth = width;
    double cropHeight = height;
    double left = 0;
    double top = 0;

    if (targetRatio == 1) {
      // 1:1，保持宽度，裁剪高度
      cropHeight = width;
      top = (height - cropHeight) / 2;
    } else if (targetRatio == 9 / 16) {
      // 9:16，保持高度，裁剪宽度
      cropWidth = height * (9 / 16);
      left = (width - cropWidth) / 2;
    }

    return Rect.fromLTWH(left, top, cropWidth, cropHeight);
  }

  void onTakeVideo() async {
    try {
      LoadingView.singleton.show();
      final originVideo = await onStopRecord();
      var originalVideoPath = originVideo!.path;
      if (originalVideoPath.contains('.temp')) {
        final newPath = originalVideoPath.replaceAll('.temp', '.mp4');
        await File(originalVideoPath).rename(newPath);
        originalVideoPath = newPath;
      }

      OverlayEntry? dialogId;
      final videoPath = await MediaService.saveVideoWithWatermark(
        originalVideoPath: originalVideoPath,
        captureWatermark: () => mainWatermarkController.capture(),
        watermarkSize: watermarkKey.currentContext?.size,
        watermarkPosition: watermarkOffset.value,
        captureWatermarkBackground: () =>
            mainWatermarkBackgroundController.capture(),
        watermarkBackgroundSize: watermarkBackgroundKey.currentContext?.size,
        rightBottomWatermarkBytes: rightBottomImageByte.value,
        rightBottomWatermarkSize: rightBottomSize.value,
        rightBottomWatermarkPosition: rightBottomPosition.value,
        onProgress: (value) {
          if (dialogId == null) {
            LoadingView.singleton.dismiss();
            dialogId = ProgressUtil.show();
          } else {
            ProgressUtil.updateProgress(value * 100);
          }
        },
      );

      if (Utils.isNullEmptyStr(videoPath)) {
        final result =
            await WatermarkDialog.showSaveVideoDialog(File(videoPath!));
        if (result) {
          final video = await MediaService.saveVideo(File(videoPath));
          photos.insert(0, video);
          photos.refresh();
        }
      }
    } catch (e, s) {
      LoadingView.singleton.dismiss();
      ProgressUtil.dismiss();
      Utils.showToast("录制视频失败, 请联系客服");
    }
  }

  void onLocationTap() async {
    ToastUtil.show("定位中，请您稍等");
    await locationController.startLocation();
    update([watermarkUpdateCameraStatus]);
  }

  // 开关右下角水印
  void onSwitchRightBottomWatermark(bool value) {
    appController.setOpenRightBottomWatermark(value);
    update([watermarkUpdateRightBottom]);
  }

  // 开关保存无水印照片
  void onSwitchSaveNoWatermarkImage(bool value) {
    appController.setOpenSaveNoWatermarkImage(value);
  }

  Future<void> loadSavedSettings(WatermarkResource? resource) async {
    if (resource?.id == null) return;

    final watermarkSetting =
        watermarkLogic.getDbWatermarkByResourceId(resource!.id!);

    if (watermarkSetting != null) {
      currentWatermarkView.value = watermarkSetting.watermarkView;
      update([watermarkUpdateMain]);
    } else {
      setWatermarkViewByResource(resource);
    }
  }

  void setZoomDragging(bool dragging) {
    isZoomDragging = dragging;
    update(['zoom_track']);
  }

  void updateZoom(double percent) {
    zoomPercent = percent;
    final zoom = 1.0 + (percent * 9.0);
    setZoom(zoom);
  }

  Future<void> setZoom(double zoom) async {
    try {
      if (cameraController != null) {
        await cameraController!.setZoomLevel(zoom);
        currentZoom.value = zoom;
        update(['zoom_circle']);
      }
    } catch (e) {
      Utils.showToast("设置缩放失败, 请联系客服");
    }
  }

  Future<void> requestCameraPermissionWithRetry() async {
    await permissionController.requestCameraPermission(
      onSuccess: () {
        hasCameraPermission.value = true;
        update([watermarkUpdateCameraStatus]);
      },
      onFailed: () {
        // 可以在这里显示提示或其他操作
      },
    );
  }

  Future<void> requestLocationPermissionWithRetry() async {
    await permissionController.requestLocationPermission(
      onSuccess: () async {
        await locationController.startLocation();
        update([watermarkUpdateCameraStatus]);
      },
      onFailed: () {
        // 可以在这里显示提示或其他操作
      },
    );
  }

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.camera.status;
      if (status == PermissionStatus.granted) {
        hasCameraPermission.value = true;
        update([watermarkUpdateCameraStatus]);
      } else {
        await requestCameraPermissionWithRetry();
      }

      final statusLocation = await Permission.location.status;
      if (statusLocation == PermissionStatus.granted) {
        await locationController.startLocation();
        update([watermarkUpdateCameraStatus]);
      } else {
        await requestLocationPermissionWithRetry();
      }
      // 做一次redis缓存
      Apis.userDeductTimes(0);
    });

    currentZoom.value = 1.0;
    zoomPercent = 0.0;
  }

  @override
  void onReady() {
    super.onReady();
    print("xiaojianjian onReady");
    // 添加页面生命周期监听
  }

  @override
  void onClose() {
    // 清理资源
    super.onClose();
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // 释放资源
    _focusTimer?.cancel();
    super.dispose();
  }
}
