import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/core/controller/permission_controller.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/utils/library.dart';

class CameraCoreController extends GetxController with WidgetsBindingObserver {
  final appController = Get.find<AppController>();
  final permissionController = Get.find<PermissionController>();

  CameraController? cameraController;
  List<CameraDescription> get cameras => appController.cameras;

  bool pendingCameraPermissionCheck = false;

  final hasCameraPermission = false.obs;

  final minAvailableExposureOffset = 0.0.obs;
  final maxAvailableExposureOffset = 0.0.obs;
  final currentExposureOffset = 0.0.obs;
  final minAvailableZoom = 1.0.obs;
  final maxAvailableZoom = 1.0.obs;
  final currentScale = 1.0.obs;
  final baseScale = 1.0.obs;

  final isCameraInitialized = false.obs;
  final isRecordingVideo = false.obs;
  final isRecordingPaused = false.obs;
  final isTakingPicture = false.obs;
  final recordDuration = 0.obs;
  Timer? recordDurationTimer;
  final photos = <AssetEntity>[].obs; // 最近照片
  CameraImage? recordImage;

  // 录制时长文本 [格式化为 0:00]
  String get recordDurationText =>
      '${recordDuration.value ~/ 60}:${recordDuration.value % 60}';

  AssetEntity? get firstPhoto => photos.isNotEmpty ? photos.first : null;

  final cameraMode = CameraMode.photo.obs; // 相机模式
  final aspectRatio = CameraPreviewAspectRatio.ratio_3_4.obs; // 预览比例
  final resolution = ResolutionPreset.ultraHigh.obs; // 分辨率
  final cameraDelay = CameraDelay.off.obs; // 拍照延时
  final flashMode = FlashMode.off.obs; // 闪光灯模式

  // 添加一个标志位，表示是否需要在应用恢复时检查权限
  bool pendingPermissionCheck = false;

  // 拍照
  // Future<XFile?> onTakePicture() async {
  //   final result = await permissionController.requestCameraPermission();

  //   if (result) {
  //     final CameraController? controller = cameraController;
  //     if (controller == null || !controller.value.isInitialized) {
  //       showInSnackBar('没有相机！');
  //       return null;
  //     }

  //     if (controller.value.isTakingPicture) {
  //       return null;
  //     }

  //     try {
  //       final XFile file = await controller.takePicture();
  //       return file;
  //     } on CameraException catch (e) {
  //       showInSnackBar('Error: ${e.code}\n${e.description}');
  //       return null;
  //     }
  //   } else {
  //     Utils.showToast('缺少相机权限，请前往应用设置打开权限');
  //     return null;
  //   }
  // }

  // 切换相机模式
  void onSelectCameraMode(CameraMode mode) {
    cameraMode.value = mode;
    if (mode == CameraMode.video) {
      aspectRatio.value = CameraPreviewAspectRatio.ratio_9_16;
    } else {
      aspectRatio.value = CameraPreviewAspectRatio.ratio_3_4;
    }

    update([watermarkUpdateCameraStatus]);
  }

  // 开始计时录制时长
  void onStartRecordDuration() {
    recordDuration.value = 0;
    recordDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordDuration.value++;
    });
  }

  // 停止计时录制时长
  void onStopRecordDuration() {
    recordDuration.value = 0;
    recordDurationTimer?.cancel();
  }

  // 暂停计时录制时长
  void onPauseRecordDuration() {
    recordDurationTimer?.cancel();
  }

  // 恢复计时录制时长
  void onResumeRecordDuration() {
    recordDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordDuration.value++;
    });
  }

  // 开始录制
  void onStartRecord() async {
    final permission =
        await permissionController.requestMediaLibraryPermission();
    if (!permission) {
      showInSnackBar('没有媒体库权限');
      return;
    }
    if (cameraController == null || cameraController!.value.isRecordingVideo) {
      return;
    }
    await cameraController?.startVideoRecording();
    onStartRecordDuration();
    update([watermarkUpdateCameraStatus]);
  }

  // 暂停录制
  void onPauseRecord() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }
    await cameraController?.pauseVideoRecording();
    update([watermarkUpdateCameraStatus]);
    onPauseRecordDuration();
  }

  // 恢复录制
  void onResumeRecord() async {
    if (cameraController == null ||
        !cameraController!.value.isRecordingPaused) {
      return;
    }
    await cameraController?.resumeVideoRecording();
    update([watermarkUpdateCameraStatus]);
    onResumeRecordDuration();
  }

  // 停止录制
  Future<XFile?> onStopRecord() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return Future.value(null);
    }
    final result = await cameraController?.stopVideoRecording();
    recordImage = null;
    onStopRecordDuration();
    update([watermarkUpdateCameraStatus]);
    return result;
  }

  // 切换拍照延时
  void onSwitchCameraDelay() {
    if (cameraController == null) return;
    CameraDelay delay;
    switch (cameraDelay.value) {
      case CameraDelay.off:
        delay = CameraDelay.three;
        break;
      case CameraDelay.three:
        delay = CameraDelay.five;
        break;
      case CameraDelay.five:
        delay = CameraDelay.ten;
        break;
      case CameraDelay.ten:
        delay = CameraDelay.off;
        break;
    }
    cameraDelay.value = delay;
  }

  // 切换预览比例
  void onSwitchAspectRatio() async {
    if (cameraController == null) return;

    switch (aspectRatio.value) {
      case CameraPreviewAspectRatio.ratio_3_4:
        aspectRatio.value = CameraPreviewAspectRatio.ratio_9_16;
        break;
      case CameraPreviewAspectRatio.ratio_9_16:
        aspectRatio.value = CameraPreviewAspectRatio.ratio_1_1;
        break;
      case CameraPreviewAspectRatio.ratio_1_1:
        aspectRatio.value = CameraPreviewAspectRatio.ratio_3_4;
        break;
    }

    update([watermarkUpdateCameraStatus]);
  }

  // 切换摄像头
  void onSwitchCamera() async {
    final currentCamera = cameraController!.description;
    CameraDescription? nextCamera;
    try {
      nextCamera =
          cameras.firstWhere((element) => element.name != currentCamera.name);
    } catch (e) {
      showInSnackBar('请您检查您的手机是否有前置相机');
      return;
    }

    await cameraController?.dispose();
    initializeCameraController(nextCamera);
  }

  // 切换分辨率
  void onSwitchResolution() {
    if (cameraController == null) return;
    ResolutionPreset currentResolution;
    switch (resolution.value) {
      case ResolutionPreset.low:
        currentResolution = ResolutionPreset.low;
        break;
      case ResolutionPreset.medium:
        currentResolution = ResolutionPreset.medium;
        break;
      case ResolutionPreset.high:
        currentResolution = ResolutionPreset.high;
        break;
      case ResolutionPreset.veryHigh:
        currentResolution = ResolutionPreset.veryHigh;
        break;
      case ResolutionPreset.ultraHigh:
        currentResolution = ResolutionPreset.ultraHigh;
        break;
      case ResolutionPreset.max:
        currentResolution = ResolutionPreset.max;
        break;
    }
    resolution.value = currentResolution;
    appController.setCameraResolutionPreset(currentResolution.name);
    initializeCameraController(cameraController!.description);
  }

  // 切换闪光灯模式
  void onSwitchFlash() {
    if (cameraController == null) return;
    FlashMode currentFlashMode;
    switch (flashMode.value) {
      case FlashMode.off:
        currentFlashMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        currentFlashMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        currentFlashMode = FlashMode.off;
        break;
      case FlashMode.always:
        currentFlashMode = FlashMode.off;
        break;
    }
    cameraController?.setFlashMode(currentFlashMode);
  }

  // // 开关相机快门声音
  // void onSwitchCameraShutterSound(bool value) {
  //   appController.setOpenCameraShutterSound(value);
  // }

  Future<void> loadPhotos() async {
    // 请求权限
    final permission = await permissionController.requestPhotoPermission();
    if (!permission) {
      photos.value = [];
      update();
      return;
    }
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.hasAccess) {
      // 获取相册列表
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: FilterOptionGroup(
          orders: [
            const OrderOption(
              type: OrderOptionType.createDate,
              asc: false, // false 表示降序，最新的在前
            ),
          ],
        ),
      );

      if (paths.isNotEmpty) {
        // 获取第一个相册（通常是"最近"或"所有照片"）
        final AssetPathEntity recentAlbum = paths.first;

        // 获取相册中的照片
        final List<AssetEntity> photoList = await recentAlbum.getAssetListRange(
          start: 0,
          end: 50,
        );

        photos.value = photoList;
      }
    }
  }

  Future<void> initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController controller = CameraController(
      cameraDescription,
      resolution.value,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    cameraController = controller;

    controller.addListener(() {
      isRecordingVideo.value = controller.value.isRecordingVideo;
      isRecordingPaused.value = controller.value.isRecordingPaused;
      isTakingPicture.value = controller.value.isTakingPicture;
      flashMode.value = controller.value.flashMode;
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      isCameraInitialized.value = true;

      await Future.wait(<Future<Object?>>[
        ...!kIsWeb
            ? <Future<Object?>>[
                controller.getMinExposureOffset().then(
                    (double value) => minAvailableExposureOffset.value = value),
                controller.getMaxExposureOffset().then(
                    (double value) => maxAvailableExposureOffset.value = value)
              ]
            : <Future<Object?>>[],
        controller
            .getMaxZoomLevel()
            .then((double value) => maxAvailableZoom.value = value),
        controller
            .getMinZoomLevel()
            .then((double value) => minAvailableZoom.value = value),
      ]);
      update([watermarkUpdateCameraStatus]);
    } on CameraException catch (e) {
      handleCameraException(e);
    }
  }

  void handleCameraException(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
        Utils.showToast('您已拒绝相机访问权限');
        break;
      case 'CameraAccessDeniedWithoutPrompt':
        Utils.showToast('请您前往设置打开相机权限');
        break;
      case 'CameraAccessRestricted':
        Utils.showToast('相机访问权限受限');
        break;
      case 'AudioAccessDenied':
        Utils.showToast('音频访问权限受限');
        break;
      case 'AudioAccessDeniedWithoutPrompt':
        Utils.showToast('请您前往设置打开音频权限');
        break;
      case 'AudioAccessRestricted':
        Utils.showToast('音频访问权限受限');
        break;
      default:
        showInSnackBar('Error: ${e.code}\n${e.description}');
    }
  }

  void showInSnackBar(String message) {
    Get.showSnackbar(
        GetSnackBar(message: message, duration: const Duration(seconds: 2)));
  }

  void addLifecycleListener() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString() &&
          pendingCameraPermissionCheck) {
        pendingCameraPermissionCheck = false;

        final status = await Permission.camera.status;
        if (status.isGranted) {
          hasCameraPermission.value = true;
          initializeCameraController(cameraController!.description);
        }
        removeLifecycleListener();
      }
    });
  }

  void removeLifecycleListener() {
    // 移除监听器
    SystemChannels.lifecycle.setMessageHandler(null);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      isCameraInitialized.value = false;
      cameraController?.dispose();
      onStopRecordDuration();
    } else if (state == AppLifecycleState.resumed) {
      initializeCameraController(cameraController!.description);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    isCameraInitialized.value = false;
    cameraController?.dispose();
    onStopRecordDuration();
    removeLifecycleListener();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    if (cameras.isNotEmpty) {
      final descriptionIndex = cameras.indexWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      if (descriptionIndex != -1) {
        initializeCameraController(cameras[descriptionIndex]);
      } else {
        initializeCameraController(cameras.first);
      }
    }

    loadPhotos();
  }
}
