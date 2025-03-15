import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

class ResolutionPage extends StatelessWidget {
  ResolutionPage({super.key});

  List<ResolutionPreset> resolutionPresets = [
    ResolutionPreset.medium,
    ResolutionPreset.high,
    ResolutionPreset.veryHigh,
    ResolutionPreset.ultraHigh,
    ResolutionPreset.max,
  ];

  final appLogic = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "照片分辨率",
      ),
      body: Obx(() {
        final selectedResolutionPreset = appLogic.cameraResolutionPreset.value;
        return Column(
          children: resolutionPresets
              .map((e) => _buildItemView(e,
                      isSelected: e.name == selectedResolutionPreset,
                      onTap: () {
                    appLogic.setCameraResolutionPreset(e.name);
                    Get.back();
                  }))
              .toList(),
        );
      }),
    );
  }

  Widget _buildItemView(ResolutionPreset resolutionPreset,
      {bool isSelected = false, Function()? onTap}) {
    return BouncingWidget(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            width: 2,
            color: isSelected ? Styles.c_0C8CE9 : Colors.grey,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            resolutionPreset.name.formatReslution.toText
              ..style = isSelected
                  ? Styles.ts_0C8CE9_16_medium
                  : Styles.ts_333333_16_medium,
            Visibility(
              visible: isSelected,
              child: const Icon(
                Icons.check_circle_outline,
                color: Styles.c_0C8CE9,
              ),
            )
          ],
        ),
      ),
    );
  }
}
