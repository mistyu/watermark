import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';

class CameraTopActions extends StatelessWidget {
  final Widget moreActionWidget;
  final CameraPreviewAspectRatio aspectRatio;
  final Function()? onSwitchAspectRatio;
  final Function()? onSwitchCamera;
  final CameraMode cameraMode;
  const CameraTopActions({
    super.key,
    required this.moreActionWidget,
    required this.aspectRatio,
    required this.cameraMode,
    this.onSwitchAspectRatio,
    this.onSwitchCamera,
  });

  String get aspectRatioImage {
    if (aspectRatio == CameraPreviewAspectRatio.ratio_9_16) {
      return 'icon_picture_9_16';
    } else if (aspectRatio == CameraPreviewAspectRatio.ratio_3_4) {
      return 'icon_picture_3_4';
    } else if (aspectRatio == CameraPreviewAspectRatio.ratio_1_1) {
      return 'icon_picture_1_1';
    }
    return 'icon_picture_3_4';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: context.mediaQueryPadding.top),
      child: Container(
        color: Colors.transparent,
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0).w,
              child: Row(
                children: [
                  IconButton.filled(
                    constraints:
                        BoxConstraints(maxWidth: 32.w, maxHeight: 32.w),
                    iconSize: 16.w,
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_outlined),
                    color: Styles.c_FFFFFF,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildIconItem(
                    onPressed: () {
                      AppNavigator.startCustomer();
                    },
                    icon: 'main_kf_img'),
                Visibility(
                  visible: cameraMode == CameraMode.photo,
                  child: _buildIconItem(
                    onPressed: onSwitchAspectRatio,
                    icon: aspectRatioImage,
                  ),
                ),
                _buildIconItem(
                  onPressed: onSwitchCamera,
                  icon: 'icon_switch',
                ),
                10.horizontalSpace,
                moreActionWidget,
                4.horizontalSpace,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem({Function()? onPressed, required String icon}) {
    return BouncingWidget(
      onTap: onPressed,
      child: Container(
        width: 32.w,
        height: 32.w,
        padding: EdgeInsets.all(4.r),
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: icon.png.toImage..width = 24.w,
      ),
    );
  }
}
