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

  // 竟然是这样蒙版来剪切，不同的预览比例
  Widget get _maskPaint => _buildMaskPaint();

  Widget get _topActions => _buildTopActions();

  Widget get _cameraPreview => _buildPreview();

  Alignment get _alignment =>
      logic.aspectRatio.value == CameraPreviewAspectRatio.ratio_9_16
          ? Alignment.topCenter
          : Alignment.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _topActions,
            Expanded(
                child: Stack(clipBehavior: Clip.hardEdge, children: [
              _cameraPreview,
              // _maskPaint,
              _buildBottomActions(context),
              // 如果Stack里面的子元素不设置大小那么就是以父元素为准
              _child
            ])),
          ],
        ));
  }

  Widget _buildChild() {
    print("xiangji _buildChild ${logic.aspectRatio.value.ratio}");
    return GetBuilder<CameraLogic>(
      id: watermarkUpdateCameraStatus, //标识这个GetBuilder 在更新是保证只更新它
      init: logic, //初始化Controller
      builder: (logic) {
        IgnorePointer ignorePointer = IgnorePointer(
          //忽略指针事件
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
        );
        if (logic.aspectRatio.value == CameraPreviewAspectRatio.ratio_1_1) {
          return Align(
            alignment: logic.alignPosiotnInRatio1_1,
            child: ignorePointer,
          );
        }
        return ignorePointer;
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

      final screenWidth = 1.sw;
      final targetAspectRatio = logic.aspectRatio.value.ratio;
      final previewHeight = screenWidth / targetAspectRatio;

      print("xiangji preview: ${logic.cameraController?.value.previewSize}");
      print("xiangji screen: ${screenWidth}x${previewHeight}");
      print("xiangji 目标比例: $targetAspectRatio");

      SizedBox preview = SizedBox(
        width: screenWidth,
        height: previewHeight,
        child: _buildCroppedPreview(
          targetAspectRatio,
          1 / (logic.cameraController?.value.aspectRatio ?? 4 / 3),
        ),
      );

      if (logic.aspectRatio.value == CameraPreviewAspectRatio.ratio_1_1) {
        return Align(
          alignment: logic.alignPosiotnInRatio1_1,
          child: preview,
        );
      }
      return preview;
    });
  }

  Widget _buildCroppedPreview(double targetRatio, double originalRatio) {
    print("xiangji 目标比例: $targetRatio");
    print("xiangji 原始比例: $originalRatio");

    // 获取预览尺寸
    final previewSize = logic.cameraController?.value.previewSize;
    if (previewSize == null) return Container(color: Colors.grey[300]);

    // 相机输出是横向的，需要旋转90度
    final sourceWidth = previewSize.height; // 1200
    final sourceHeight = previewSize.width; // 1600

    // 计算裁剪尺寸，保持原始高度不变
    double cropWidth = sourceWidth; // 默认1200
    double cropHeight = sourceHeight; // 默认1600

    if (targetRatio != 3 / 4) {
      // 如果目标比例不是3:4
      if (targetRatio == 1) {
        // 1:1，保持宽度，裁剪高度
        cropHeight = sourceWidth; // 1200
      } else if (targetRatio == 9 / 16) {
        // 9:16，保持高度，裁剪宽度
        cropWidth = sourceHeight * (9 / 16); // 1600 * 9/16 = 900
      }
    }

    print("xiangji 原始尺寸: ${sourceWidth}x${sourceHeight}");
    print("xiangji 裁剪尺寸: ${cropWidth}x${cropHeight}");

    /**
     * 最后的拍摄结果也要进行相应的裁剪
     */
    return ClipRect(
        child: Transform.scale(
      scale: 1.sw / cropWidth,
      child: SizedBox(
        width: cropWidth,
        height: cropHeight,
        /**
         * SizedBox 定义了一个固定大小的空间 (cropWidth x cropHeight) 给 OverflowBox。
         * 然而，由于 OverflowBox 的特性，它的子部件可以超出这个限定的空间而不被裁剪或导致布局错误
         * 这样就不会出现任何的缩放情况，然后再按照SizedBox直接裁剪
         */
        child: OverflowBox(
          alignment: Alignment.center,
          maxWidth: sourceWidth,
          maxHeight: sourceHeight,
          child: RotatedBox(
            quarterTurns: 1,
            child:
                logic.cameraController!.buildPreview(), //初始宽高是1600:1200, 所以要翻转
          ),
        ),
      ),
    ));
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

  Widget _buildBottomActions(BuildContext context) {
    /**计算高度和相应的top值 */
    final actionsButtonsHeightTop = 1.sw * 4 / 3;
    final actionsButtonsHeight = 1.sh -
        context.mediaQueryPadding.top -
        kToolbarHeight -
        actionsButtonsHeightTop;
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
          onSelectCameraMode: logic.onSelectCameraMode,
          height: actionsButtonsHeight,
          top: actionsButtonsHeightTop);
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
