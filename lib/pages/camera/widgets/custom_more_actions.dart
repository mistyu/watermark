import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';
import 'package:watermark_camera/widgets/gradient_button.dart';

class CustomMoreActions extends StatefulWidget {
  final ResolutionPreset resolution; // 质量
  final CameraDelay cameraDelay; // 延迟
  final FlashMode flashMode; // 闪光
  final bool saveNoWatermarkImage; // 同时保存无水印照片
  // final bool cameraShutterSound; // 相机快门声音
  final bool showRightBottomWatermark; // 右下角水印
  final Function() onSwitchResolution; // 切换分辨率
  final Function() onSwitchCameraDelay; // 切换延迟
  final Function() onSwitchFlash; // 切换闪光
  final Function(bool value) onSwitchSaveNoWatermarkImage; // 切换同时保存无水印照片
  // final Function(bool value) onSwitchCameraShutterSound; // 切换相机快门声音
  final Function(bool value) onSwitchRightBottomWatermark; // 切换右下角水印
  const CustomMoreActions(
      {super.key,
      required this.resolution,
      required this.cameraDelay,
      required this.flashMode,
      required this.saveNoWatermarkImage,
      // required this.cameraShutterSound,
      required this.showRightBottomWatermark,
      required this.onSwitchResolution,
      required this.onSwitchCameraDelay,
      required this.onSwitchFlash,
      required this.onSwitchSaveNoWatermarkImage,
      // required this.onSwitchCameraShutterSound,
      required this.onSwitchRightBottomWatermark});

  @override
  State<CustomMoreActions> createState() => _CustomMoreActionsState();
}

class _CustomMoreActionsState extends State<CustomMoreActions> {
  StateSetter? _popupSetState;
  @override
  void didUpdateWidget(CustomMoreActions oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 如果任何相关属性发生变化，强制重建widget
    if (oldWidget.resolution != widget.resolution ||
        oldWidget.cameraDelay != widget.cameraDelay ||
        oldWidget.flashMode != widget.flashMode ||
        oldWidget.saveNoWatermarkImage != widget.saveNoWatermarkImage ||
        oldWidget.showRightBottomWatermark != widget.showRightBottomWatermark) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _popupSetState?.call(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopup(
        arrowColor: Styles.c_FFFFFF,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        contentRadius: 8.r,
        contentPadding: EdgeInsets.zero,
        content: StatefulBuilder(builder: (context, setState) {
          _popupSetState = setState;
          return Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
              decoration: BoxDecoration(
                  color: Styles.c_FFFFFF,
                  borderRadius: BorderRadius.circular(8.r)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildPopupActionIcon(
                            label: widget.cameraDelay.text,
                            icon: cameraDelayIcon,
                            onTap: widget.onSwitchCameraDelay),
                        _buildPopupActionIcon(
                            label: widget.flashMode.text,
                            icon: flashModeIcon,
                            onTap: widget.onSwitchFlash),
                        _buildPopupActionIcon(
                            label: widget.resolution.text,
                            icon: resolutionIcon,
                            onTap: widget.onSwitchResolution),
                        _buildPopupActionIcon(
                            label: "在线客服",
                            icon: "icon_kf".png,
                            onTap: () {
                              AppNavigator.startCustomer();
                            }),
                      ],
                    ),
                    12.verticalSpace,
                    Column(
                      children: [
                        _buildPopupMenuItem(
                            label: "右下角水印",
                            icon: "pop_yxj".png,
                            active: widget.showRightBottomWatermark,
                            hint: "可修改水印防伪名称",
                            onTap: widget.onSwitchRightBottomWatermark),
                        _buildPopupMenuItem(
                            label: "同时保存无水印照片",
                            icon: "pop_save".png,
                            active: widget.saveNoWatermarkImage,
                            onTap: widget.onSwitchSaveNoWatermarkImage),
                        // _buildPopupMenuItem(
                        //     label: "相机快门声音",
                        //     icon: "pop_voice".png,
                        //     active: widget.cameraShutterSound,
                        //     onTap: widget.onSwitchCameraShutterSound),
                        _buildPopupMenuItem(
                            label: "会员权益",
                            icon: "pop_vip".png,
                            active: false,
                            onTap: (_) {
                              ToastUtil.show("会员权益暂未开放");
                            },
                            extra: Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  "会员最低 ¥0.01/天".toText
                                    ..style = Styles.ts_CFAC74_12,
                                  GradientButton(
                                      tapCallback: () {
                                        ToastUtil.show("会员权益暂未开放");
                                      },
                                      child: "查看权益".toText
                                        ..style = Styles.ts_FFFFFF_12)
                                ],
                              ),
                            )),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ToastUtil.show("会员权益暂未开放");
                      },
                      child: Container(
                        constraints: BoxConstraints(minHeight: 88.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildVipIcon(label: "工作打卡", icon: "pop_qy1".png),
                            _buildVipIcon(label: "修改时间", icon: "pop_qy2".png),
                            _buildVipIcon(label: "编辑地址", icon: "pop_qy3".png),
                            _buildVipIcon(label: "批量加水印", icon: "pop_qy4".png)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        }),
        child: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: 'ic_more'.png.toImage..width = 24.w));
  }

  String get cameraDelayIcon {
    switch (widget.cameraDelay) {
      case CameraDelay.off:
        return 'icon_time_c'.png;
      case CameraDelay.three:
        return 'icon_time_3'.png;
      case CameraDelay.five:
        return 'icon_time_5'.png;
      case CameraDelay.ten:
        return 'icon_time_10'.png;
    }
  }

  String get flashModeIcon {
    switch (widget.flashMode) {
      case FlashMode.off:
        return 'icon_flash_un'.png;
      case FlashMode.torch:
        return 'icon_flash_on'.png;
      case FlashMode.auto:
        return 'icon_flash_on'.png;
      case FlashMode.always:
        return 'icon_flash_on'.png;
    }
  }

  String get resolutionIcon {
    switch (widget.resolution) {
      case ResolutionPreset.low:
        return 'icon_video_1'.png;
      case ResolutionPreset.medium:
        return 'icon_video_2'.png;
      case ResolutionPreset.high:
        return 'icon_video_3'.png;
      case ResolutionPreset.veryHigh:
        return 'icon_video_4'.png;
      case ResolutionPreset.ultraHigh:
        return 'icon_video_5'.png;
      case ResolutionPreset.max:
        return 'icon_video_0'.png;
    }
  }

  Widget _buildPopupActionIcon(
      {required String label, required String icon, Function()? onTap}) {
    return BouncingWidget(
        onTap: onTap,
        child: Column(
          children: [
            icon.toImage
              ..width = 24.w
              ..fit = BoxFit.cover,
            12.verticalSpace,
            label.toText..style = Styles.ts_333333_14
          ],
        ));
  }

  Widget _buildPopupMenuItem(
      {required String label,
      required String icon,
      required bool active,
      String? hint,
      Widget? extra,
      Function(bool value)? onTap}) {
    return Container(
      height: 48.h,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Styles.c_EDEDED))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon.toImage
            ..width = 24.w
            ..fit = BoxFit.cover,
          12.horizontalSpace,
          label.toText..style = Styles.ts_333333_16_medium,
          10.horizontalSpace,
          if (Utils.isNotNullEmptyStr(hint))
            hint!.toText..style = Styles.ts_999999_12,
          if (extra != null) extra,
          if (extra == null)
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                key: Key(label),
                value: active,
                onChanged: (value) {
                  onTap?.call(value);
                },
              ),
            ))
        ],
      ),
    );
  }

  Widget _buildVipIcon({required String label, required String icon}) {
    return Column(
      children: [
        icon.toImage
          ..width = 32.w
          ..fit = BoxFit.cover,
        12.verticalSpace,
        label.toText..style = Styles.ts_333333_12
      ],
    );
  }
}
