import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/loading_view.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

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

  final watermarkKey = GlobalKey();
  final watermarkBackgroundKey = GlobalKey();
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

  void onTakePhoto() async {
    try {
      final originalPhoto = await onTakePicture();
      if (originalPhoto == null) {
        showInSnackBar('拍照失败');
        return;
      }

      final photoBytes = await MediaService.savePhotoWithWatermark(
        originalPhotoPath: originalPhoto.path,
        aspectRatio: aspectRatio.value.ratio,
        captureWatermark: () => mainWatermarkController.capture(),
        watermarkSize: watermarkKey.currentContext?.size,
        watermarkPosition: watermarkOffset.value,
        captureWatermarkBackground: () =>
            mainWatermarkBackgroundController.capture(),
        watermarkBackgroundSize: watermarkBackgroundKey.currentContext?.size,
        rightBottomWatermarkBytes: rightBottomImageByte.value,
        rightBottomWatermarkSize: rightBottomSize.value,
        rightBottomWatermarkPosition: rightBottomPosition.value,
      );

      if (photoBytes != null) {
        final result = await WatermarkDialog.showSaveImageDialog(photoBytes);
        if (result) {
          final photo = await MediaService.savePhoto(photoBytes);
          if (openSaveNoWatermarkImage) {
            final photoBytes = await ImageUtil.cropImage(
                originalPhoto.path, aspectRatio.value.ratio);
            if (photoBytes != null) {
              final noWatermarkPhoto = await MediaService.savePhoto(photoBytes);
              photos.insert(0, noWatermarkPhoto);
            }
          }
          photos.insert(0, photo);
          photos.refresh();
        }
      } else {
        showInSnackBar('水印检测失败');
      }
    } catch (e, s) {
      Logger.print("e: $e, s: $s");
      showInSnackBar('拍照失败: $e');
    }
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
