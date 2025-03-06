import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/pages/camera/camera_logic.dart';

class RyWatermarkLiveshoot extends StatelessWidget {
  final CameraLogic controller;
  final WatermarkResource resource;
  const RyWatermarkLiveshoot(
      {super.key, required this.controller, required this.resource});

  Future<String?> getImagePath() async {
    String? imagePath = await WatermarkService.getImagePath(
        resource.id.toString(),
        fileName: controller.liveShootData?.image);
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraLogic>(
        init: controller,
        id: controller.watermarkLiveShootUpdateMain,
        builder: (logic) {
          // 找到图片地址
          return FutureBuilder(
            future: getImagePath(),
            builder: (context, snapshot) {
              final imagePath = snapshot.data;
              if (imagePath != null) {
                return Align(
                  alignment: Alignment.center, // 水平和垂直居中
                  child: Transform.scale(
                    scale: logic.liveShootData?.scale ?? 1,
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      width: 1.sw / 2 + 40.w,
                      height: 125.h,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        });
  }
}
