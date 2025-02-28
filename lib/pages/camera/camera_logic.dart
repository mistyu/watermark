import 'dart:async';
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/core/controller/camera_controller.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/core/service/media_service.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
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

  WatermarkData? get logoData => currentWatermarkView.value?.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkBrandLogo');

  final watermarkLogoUpdateMain = 'watermark_logo_update_main';

  final watermarkKey = GlobalKey();
  final watermarkToImageKey = GlobalKey();
  final watermarkBackgroundKey = GlobalKey();
  final watermarkPhotoKey = GlobalKey();
  final alignPosiotnInRatio1_1 =
      Alignment.lerp(Alignment.topLeft, Alignment.center, 0.3)!;
  /**
   * 水印的位置
   */
  final watermarkOffset =
      const Offset(watermarkMinMargin, watermarkMinMargin).obs;
  final watermarkScale = 1.0.obs;

  Rxn<Uint8List> rightBottomImageByte = Rxn();
  Rxn<Offset> rightBottomPosition = Rxn();
  Rxn<Size> rightBottomSize = Rxn();

  bool get openSaveNoWatermarkImage =>
      appController.openSaveNoWatermarkImage.value;

  bool get openRightBottomWatermark =>
      appController.openRightBottomWatermark.value;

  // bool get openCameraShutterSound => appController.openCameraShutterSound.value;

  void setWatermarkViewByResource(WatermarkResource? resource) async {
    if (resource?.id == null) return;

    // 从资源中获取水印视图 （水印的一系列的样式属性等等）
    currentWatermarkView.value = await WatermarkView.fromResource(resource!);
    watermarkScale.value = 1.0;

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

  void onThumbnailTap() {
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
    print("xiaojianjian onEditTap ${result}");
    if (result != null) {
      // 更新当前水印视图
      currentWatermarkView.value = result.watermarkView;
      // 更新缩放
      watermarkScale.value = result.scale ?? 1.0;
      // 通知UI更新
      update([watermarkUpdateMain]);
    }
  }

  void onWatermarkTap() async {
    final id = await WatermarkSheet.showWatermarkGridSheet(
        resource: currentWatermarkResource.value);
    if (id != null) {
      setWatermarkResourceById(id);
    }
  }

  /**
    * 拍照
      裁剪图片-图层 水印-图层
      图层合成
      预处理水印图层，这样拍照的时候只需要直接合成就好了
  */
  Future<void> onTakePhoto() async {
    try {
      print("xiaojianjian onTakePhoto开始拍照");
      final decodeStartTime = DateTime.now();
      // if (!isCameraInitialized.value) return;

      final croppedBytes = await watermarkLogic.capturePhoto(watermarkPhotoKey);
      final watermarkBytes =
          await watermarkLogic.captureWatermark(watermarkToImageKey);

      final overlayBytes = await ImageProcess.overlayImages(
          croppedBytes!.image,
          watermarkBytes!.image,
          croppedBytes.width,
          croppedBytes.height,
          watermarkBytes.width,
          watermarkBytes.height);
      await MediaService.savePhoto(overlayBytes);
      print(
          "xiaojianjian 拍照所有内容结束 ${DateTime.now().difference(decodeStartTime).inMilliseconds}ms");
    } catch (e, s) {
      Logger.print("e: $e, s: $s");
      showInSnackBar('拍照失败: $e');
    }
  }

  /**
    * 通过拍照裁剪图片，不是Wight进行截图获取图片， 两边时间差不多
    */
  Future<Uint8List> cropImage(
      Uint8List imageBytes, CropParameters cropParameters) async {
    // 拍照
    print("xiaojianjian onTakePhoto开始裁剪图片");
    final decodeStartTime1 = DateTime.now();
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
    print(
        "xiaojianjian 拍照裁剪图片结束 ${DateTime.now().difference(decodeStartTime1).inMilliseconds}ms");
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
      Logger.print("e: $e, s: $s");
      showInSnackBar('录制视频失败: $e');
    }
  }

  void onLocationTap() {
    ToastUtil.show("开始定位");
    locationController.startLocation();
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
      watermarkScale.value = watermarkSetting.scale ?? 1.0;
      update([watermarkUpdateMain]);
    } else {
      setWatermarkViewByResource(resource);
    }
  }

  @override
  void onInit() {
    super.onInit();
    initWatermark();
    print("camera_logic onInit");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.location.status;
      if (status == PermissionStatus.granted) {
        locationController.startLocation();
      } else {
        if (!locationController.hasLocationPermission) {
          final result = await WatermarkDialog.showNoLocationPermissionBanner(
              onGrantPermission: () async {
            await locationController.requestLocationPermission();
            return locationController.hasLocationPermission;
          });

          if (result) {
            locationController.startLocation();
          }
        }
      }
    });
  }
}
