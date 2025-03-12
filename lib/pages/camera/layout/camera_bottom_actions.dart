import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/pages/camera/widgets/camera_mode_selector.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';
import 'package:watermark_camera/widgets/camera_button.dart';

import '../widgets/capture_button.dart';
import '../widgets/thumbnail.dart';

class CameraBottomActions extends StatelessWidget {
  final AssetEntity? thumbnail;
  final CameraMode cameraMode;
  final bool isRecordingVideo;
  final bool isRecordingPaused;
  final String? recordDurationText;
  final Function()? onThumbnailTap;
  final Function()? onWatermarkTap;
  final Function()? onEditTap;
  final Function()? onLocationTap;
  final Function()? onTakePhoto;
  final Function()? onStartRecord;
  final Function()? onStopRecord;
  final Function()? onPauseRecord;
  final Function()? onResumeRecord;
  final Function(CameraMode)? onSelectCameraMode;
  final double? height;
  final double? top;

  const CameraBottomActions(
      {super.key,
      required this.cameraMode,
      required this.isRecordingVideo,
      required this.isRecordingPaused,
      this.recordDurationText,
      this.thumbnail,
      this.onThumbnailTap,
      this.onWatermarkTap,
      this.onEditTap,
      this.onLocationTap,
      this.onTakePhoto,
      this.onStartRecord,
      this.onStopRecord,
      this.onPauseRecord,
      this.onResumeRecord,
      this.onSelectCameraMode,
      this.height,
      this.top});

  TextStyle get _textStyle => Styles.ts_333333_12;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top!,
        left: 0,
        right: 0,
        child: Container(
          color: Colors.transparent,
          height: height,
          child: Column(
            children: [
              SizedBox(
                  height: 60.h,
                  width: 100.sw,
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      text: "水印修改时间地址教程",
                      textColor: Styles.c_FFFFFF,
                      backgroundColor: Styles.c_0C8CE9,
                      image: const AssetImage("assets/images/camera_guid.png"),
                      width: 160.w,
                      borderRadius: true,
                      onTap: () {
                        print("onTap 前往水印修改教程");
                        AppNavigator.startTutorial();
                      },
                    ),
                  )),
              Container(
                  color: Colors.transparent,
                  height: height! - kToolbarHeight - 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                              (isRecordingVideo || isRecordingPaused)
                                  ? MainAxisAlignment.spaceAround
                                  : MainAxisAlignment.spaceBetween,
                          crossAxisAlignment:
                              (isRecordingVideo || isRecordingPaused)
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.end,
                          children: [
                            if (!isRecordingVideo)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Thumbnail(
                                    asset: thumbnail,
                                    onTap: onThumbnailTap,
                                  ),
                                  3.verticalSpace,
                                  "相册".toText..style = _textStyle
                                ],
                              ),
                            if (!isRecordingVideo)
                              Column(
                                children: [
                                  BouncingWidget(
                                      onTap: onWatermarkTap,
                                      child: "home_ico_water".png.toImage
                                        ..width = 32.w),
                                  3.verticalSpace,
                                  "水印".toText..style = _textStyle
                                ],
                              ),
                            if (isRecordingVideo || isRecordingPaused)
                              _buildVideoAction(),
                            CaptureButton(
                              onTakePhoto: onTakePhoto,
                              onStartRecording: onStartRecord,
                              onStopRecording: onStopRecord,
                              cameraMode: cameraMode,
                              isRecordingVideo: isRecordingVideo,
                              isRecordingPaused: isRecordingPaused,
                            ),
                            if (isRecordingVideo || isRecordingPaused)
                              _buildVideoDuration(),
                            if (!isRecordingVideo)
                              Column(
                                children: [
                                  BouncingWidget(
                                      onTap: onEditTap,
                                      child: "home_ico_edit".png.toImage
                                        ..width = 32.w),
                                  3.verticalSpace,
                                  "修改".toText..style = _textStyle
                                ],
                              ),
                            if (!isRecordingVideo)
                              Column(
                                children: [
                                  BouncingWidget(
                                      onTap: onLocationTap,
                                      child: "home_ico_location".png.toImage
                                        ..width = 32.w),
                                  3.verticalSpace,
                                  "定位".toText..style = _textStyle
                                ],
                              ),
                          ],
                        ),
                      ])),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: (!isRecordingVideo && !isRecordingPaused)
                            ? CameraModeSelector(
                                cameraMode: cameraMode,
                                onSelect: onSelectCameraMode)
                            : SizedBox(
                                height: 32.h,
                              )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildVideoDuration() {
    return (recordDurationText ?? '0:00').toText
      ..style = Styles.ts_333333_18_medium.copyWith(letterSpacing: 0.2);
  }

  Widget _buildVideoAction() {
    return Row(
      children: [
        IconButton(
            onPressed: isRecordingPaused ? onResumeRecord : onPauseRecord,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              maximumSize: Size(56.w, 56.w),
            ),
            iconSize: 38.w,
            color: Styles.c_333333,
            icon: isRecordingPaused
                ? const Icon(
                    Icons.play_circle_filled_outlined,
                  )
                : const Icon(
                    Icons.pause_circle_filled_outlined,
                  )),
      ],
    );
  }
}
