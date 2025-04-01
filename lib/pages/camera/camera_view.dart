import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_grid_logic.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_style_edit/style_edit_logic.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/mask_paint.dart';
import 'dart:math' as math;
import 'camera_logic.dart';
import 'layout/camera_bottom_actions.dart';
import 'layout/camera_top_actions.dart';
import 'widgets/custom_more_actions.dart';
import 'widgets/main_watermark_builder.dart';
import 'widgets/right_bottom_watermark_builder.dart';
import 'widgets/zoom_control.dart';
import 'widgets/focus_control.dart';

class CameraPage extends StatelessWidget with GetLifeCycleBase {
  CameraPage({Key? key}) : super(key: key);

  final CameraLogic logic = Get.find<CameraLogic>();

  Widget get _child => _buildChild();

  Widget get _topActions => _buildTopActions();

  Widget get _cameraPreview => _buildPreview();

  Widget get _zoomControl => _buildZoomControl();

  Widget get _focusControl => _buildFocusControl();

  Alignment get _alignment =>
      logic.aspectRatio.value == CameraPreviewAspectRatio.ratio_9_16
          ? Alignment.topCenter
          : Alignment.center;

  @override
  Widget build(BuildContext context) {
    logic.cacheWatermarkPhoto();
    logic.initWatermark();
    return Scaffold(
        backgroundColor: Styles.c_FFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _topActions,
            Expanded(
                child: Stack(clipBehavior: Clip.hardEdge, children: [
              _cameraPreview,
              _zoomControl,
              _focusControl,
              _buildBottomActions(context),
              _child,
              _noPermissionWidget(),
              //Zoom Control
              //focus Control
            ])),
          ],
        ));
  }

  Widget _noPermissionWidget() {
    return GetBuilder<CameraLogic>(
      id: 'update_watermark_camera_status',
      builder: (logic) {
        print("xiangji 相机权限页面重建: ${logic.hasCameraPermission.value}");
        if (!logic.hasCameraPermission.value) {
          return _buildNoCameraPermissionWidget();
        }
        if (!logic.isCameraInitialized.value) {
          return _buildCameraLoadingWidget();
        }
        if (logic.cameras.isEmpty) {
          return _buildNoCameraWidget();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildZoomControl() {
    Widget buildZoomControl = AspectRatio(
      aspectRatio: logic.aspectRatio.value.ratio,
      child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 50.w,
            height: 210.0.h,
            child: Column(
              children: [
                GetBuilder<CameraLogic>(
                    init: logic,
                    id: 'zoom_circle',
                    builder: (logic) {
                      if (logic.isZoomDragging) {
                        return SizedBox(
                          width: 50.w,
                          height: 40.0.h,
                          child: Text(
                            '${logic.currentZoom.value.toStringAsFixed(1)}x',
                            style: Styles.ts_FFFFFF_16_medium,
                          ),
                        );
                      }
                      return SizedBox(width: 50.w, height: 40.0.h);
                    }),
                const Expanded(child: ZoomControl()),
              ],
            ),
          )),
    );
    return buildZoomControl;
  }

  /**
   * 聚焦控制框
   * 当用户点击点击预览区域时，出现一个竖直的亮度控制条 + 聚焦控制框
   * 用户点击的位置控制决定显示的亮度控制条 + 聚焦控制框位置
   * 亮度控制条用来控制亮度
   * 只要点击就执行一次聚焦，同时显示竖直的亮度控制条 + 聚焦控制框
   */
  Widget _buildFocusControl() {
    Widget focusControl = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (TapDownDetails details) {
        logic.onTapToFocus(details);
      },
      child: AspectRatio(
        aspectRatio: logic.aspectRatio.value.ratio,
        child: GetBuilder<CameraLogic>(
          id: 'focus_circle',
          builder: (logic) {
            return FocusControl(
              position: logic.focusPosition.value ?? Offset.zero,
              exposureValue: logic.exposureValue.value,
              onExposureChanged: logic.onExposureChanged,
              isVisible: logic.isFocusVisible.value,
              logic: logic,
            );
          },
        ),
      ),
    );
    if (logic.aspectRatio.value == CameraPreviewAspectRatio.ratio_1_1) {
      return Align(
        alignment: logic.alignPosiotnInRatio1_1,
        child: focusControl,
      );
    }
    return focusControl;
  }

  /**
   * 水印区域
   */
  Widget _buildChild() {
    return GetBuilder<CameraLogic>(
      id: 'update_watermark_camera_status',
      builder: (logic) {
        // print("xiangji 水印区域重建: ${logic.hasCameraPermission.value}");
        // 用 RepaintBoundary 包装需要截图的内容
        Widget watermarkContent = RepaintBoundary(
            key: logic.watermarkToImageKey,
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
            ));

        if (logic.aspectRatio.value == CameraPreviewAspectRatio.ratio_1_1) {
          return Align(
            alignment: logic.alignPosiotnInRatio1_1,
            child: watermarkContent,
          );
        }
        return watermarkContent;
      },
    );
  }

  Widget _buildPreview() {
    return GetBuilder<CameraLogic>(
        id: 'update_watermark_camera_status',
        builder: (logic) {
          print("xiangji 预览重建: ${logic.hasCameraPermission.value}");
          final screenWidth = 1.sw;
          final targetAspectRatio = logic.aspectRatio.value.ratio;
          final previewHeight = screenWidth / targetAspectRatio;
          if (logic.cameraController == null ||
              !logic.cameraController!.value.isInitialized) {
            return const SizedBox.shrink();
          }
          print(
              "xiangji preview: ${logic.cameraController?.value.previewSize}");
          print("xiangji 预览比例: ${logic.cameraController?.value.aspectRatio}");
          print("xiangji screen: ${screenWidth}x${previewHeight}");
          print("xiangji 目标比例: $targetAspectRatio");

          Widget preview = RepaintBoundary(
              key: logic.watermarkPhotoKey,
              child: SizedBox(
                width: screenWidth,
                height: previewHeight,
                child: _buildCroppedPreview(
                  targetAspectRatio,
                  1 / (logic.cameraController?.value.aspectRatio ?? 4 / 3),
                ),
              ));

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
    final isFrontCamera =
        logic.cameraController?.value.description.lensDirection ==
            CameraLensDirection.front;
    print("xiangji 是否是前置相机: $isFrontCamera");
    // 获取预览尺寸
    final previewSize = logic.cameraController?.value.previewSize;
    if (previewSize == null) return Container(color: Colors.grey[300]);

    // 相机输出是横向的，需要旋转90度
    final sourceWidth = previewSize.height;
    final sourceHeight = previewSize.width;

    // 计算裁剪尺寸，保持原始高度不变
    double cropWidth = sourceWidth;
    double cropHeight = sourceHeight;

    if (targetRatio != originalRatio) {
      if (targetRatio > originalRatio) {
        // 裁剪高度
        cropHeight = sourceWidth / targetRatio;
      } else if (targetRatio < originalRatio) {
        // 裁剪高度
        cropHeight = sourceWidth / targetRatio;
      }
    }

    print("xiangji 原始尺寸: ${sourceWidth}x${sourceHeight}");
    print("xiangji 裁剪尺寸: ${cropWidth}x${cropHeight}");

    /**
     * 最后的拍摄结果也要进行相应的裁剪
     */
    return Align(
        alignment: Alignment.center,
        child: ClipRect(
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
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateY(isFrontCamera ? math.pi : 0),
                child: CameraPreview(
                  logic.cameraController!,
                ),
              ),
            ),
          ),
        )));
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
        context.mediaQueryPadding.bottom -
        kToolbarHeight -
        actionsButtonsHeightTop;
    return Obx(() {
      // 监听一下比例如果是16：9样式要修改一下
      return CameraBottomActions(
          aspectRatio: logic.aspectRatio.value,
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
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        color: Styles.c_0D0D0D,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "相机权限未开启".toText..style = Styles.ts_FFFFFF_24_medium,
            "您需要打开相机权限才能使用水印拍照功能".toText..style = Styles.ts_FFFFFF_16_medium,
            OutlinedButton(
                onPressed: () => {
                      logic.goCameraPermission(),
                      // openAppSettings()
                    },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Styles.c_FFFFFF,
                    side: const BorderSide(color: Styles.c_FFFFFF)),
                child: "点击去开启".toText..style = Styles.ts_0C8CE9_16_medium)
          ],
        ),
      ),
    );
  }

  Widget _buildNoCameraWidget() {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        color: Styles.c_0D0D0D,
        child: Center(
            child: "没有找到可用的相机".toText..style = Styles.ts_FFFFFF_24_medium),
      ),
    );
  }

  Widget _buildCameraLoadingWidget() {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        color: Styles.c_0D0D0D,
        width: double.infinity,
      ),
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
