import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/mask_paint.dart';

import 'camera_logic.dart';
import 'layout/camera_bottom_actions.dart';
import 'layout/camera_top_actions.dart';
import 'widgets/custom_more_actions.dart';
import 'widgets/main_watermark_builder.dart';
import 'widgets/right_bottom_watermark_builder.dart';

class CameraPage extends StatelessWidget {
  CameraPage({Key? key}) : super(key: key);

  final CameraLogic logic = Get.find<CameraLogic>();

  Widget get _child => _buildChild();

  Widget get _maskPaint => _buildMaskPaint();

  Widget get _topActions => _buildTopActions();

  Widget get _bottomActions => _buildBottomActions();

  Widget get _cameraPreview => _buildPreview();

  Alignment get _alignment =>
      logic.aspectRatio.value == CameraPreviewAspectRatio.ratio_9_16
          ? Alignment.topCenter
          : Alignment.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          _cameraPreview,
          _maskPaint,
          _bottomActions,
          _topActions,
          _child,
        ],
      ),
    );
  }

  Widget _buildChild() {
    return GetBuilder<CameraLogic>(
      id: watermarkUpdateCameraStatus,
      init: logic,
      builder: (logic) {
        return Align(
          alignment: _alignment,
          child: IgnorePointer(
            ignoring:
                logic.isRecordingVideo.value || logic.isRecordingPaused.value,
            child: AspectRatio(
              aspectRatio: logic.aspectRatio.value.ratio,
              child: const Stack(
                children: [
                  MainWatermarkBuilder(),
                  RightBottomWatermarkBuilder(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreview() {
    return Obx(() {
      if (!logic.hasCameraPermission.value) {
        return _buildNoCameraPermissionWidget();
      }
      if (!logic.isCameraInitialized.value) {
        return _buildCameraLoadingWidget();
      }
      if (logic.cameras.isEmpty) {
        return _buildNoCameraWidget();
      }

      final targetAspectRatio = logic.aspectRatio.value.ratio;
      final cameraAspectRatio =
          ((logic.cameraController?.value.previewSize != null)
                  ? logic.cameraController?.value.aspectRatio
                  : (16 / 9)) ??
              16 / 9;

      double scale = 1.0;
      double previewWidth = 1.sw;
      double previewHeight = previewWidth * cameraAspectRatio;

      if (previewWidth / targetAspectRatio > previewHeight) {
        scale = (1.sw * (1 / targetAspectRatio)) / previewHeight;
      }

      return Transform.scale(
          scale: scale,
          alignment: _alignment,
          child: Align(
              alignment: _alignment,
              child: CameraPreview(logic.cameraController!)));
    });
  }

  Widget _buildTopActions() {
    return Obx(() {
      return CameraTopActions(
        moreActionWidget: _buildMoreActions(),
        cameraMode: logic.cameraMode.value,
        aspectRatio: logic.aspectRatio.value,
        onSwitchAspectRatio: logic.onSwitchAspectRatio,
        onSwitchCamera: logic.onSwitchCamera,
      );
    });
  }

  Widget _buildBottomActions() {
    return Obx(() {
      return CameraBottomActions(
          recordDurationText: logic.recordDurationText,
          thumbnail: logic.firstPhoto,
          cameraMode: logic.cameraMode.value,
          isRecordingVideo: logic.isRecordingVideo.value,
          isRecordingPaused: logic.isRecordingPaused.value,
          onThumbnailTap: logic.onThumbnailTap,
          onTakePhoto: logic.onTakePhoto,
          onStartRecord: logic.onStartRecord,
          onStopRecord: logic.onTakeVideo,
          onWatermarkTap: logic.onWatermarkTap,
          onEditTap: logic.onEditTap,
          onLocationTap: logic.onLocationTap,
          onPauseRecord: logic.onPauseRecord,
          onResumeRecord: logic.onResumeRecord,
          onSelectCameraMode: logic.onSelectCameraMode);
    });
  }

  Widget _buildMoreActions() {
    return Obx(() {
      return CustomMoreActions(
        resolution: logic.resolution.value,
        cameraDelay: logic.cameraDelay.value,
        flashMode: logic.flashMode.value,
        saveNoWatermarkImage: logic.openSaveNoWatermarkImage,
        // cameraShutterSound: logic.openCameraShutterSound,
        showRightBottomWatermark: logic.openRightBottomWatermark,
        onSwitchResolution: logic.onSwitchResolution,
        onSwitchCameraDelay: logic.onSwitchCameraDelay,
        onSwitchFlash: logic.onSwitchFlash,
        onSwitchSaveNoWatermarkImage: logic.onSwitchSaveNoWatermarkImage,
        // onSwitchCameraShutterSound: logic.onSwitchCameraShutterSound,
        onSwitchRightBottomWatermark: logic.onSwitchRightBottomWatermark,
      );
    });
  }

  Widget _buildNoCameraPermissionWidget() {
    return Container(
      color: Styles.c_0D0D0D,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "相机权限未开启".toText..style = Styles.ts_FFFFFF_24_medium,
          OutlinedButton(
              onPressed: () {
                openAppSettings();
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: Styles.c_FFFFFF,
                  side: const BorderSide(color: Styles.c_FFFFFF)),
              child: "点击去开启".toText..style = Styles.ts_0C8CE9_16_medium)
        ],
      ),
    );
  }

  Widget _buildNoCameraWidget() {
    return Container(
      color: Styles.c_0D0D0D,
      child:
          Center(child: "没有找到可用的相机".toText..style = Styles.ts_FFFFFF_24_medium),
    );
  }

  Widget _buildCameraLoadingWidget() {
    return Container(
      color: Colors.white,
      width: double.infinity,
    );
  }

  Widget _buildMaskPaint() {
    return Obx(() {
      return CustomPaint(
        size: Size.infinite,
        painter: CameraPreviewMaskPainter(
          alignment: _alignment,
          aspectRatio: logic.aspectRatio.value.ratio,
          color: Colors.white,
        ),
      );
    });
  }
}
