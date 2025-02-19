import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';

import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

class RYWatermarkBrandLogo extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkBrandLogo(
      {super.key, required this.watermarkData, required this.resource});
  int get templateId => resource.id ?? 0;
  @override
  Widget build(BuildContext context) {
    final bgImg1 = watermarkData.background;
    final bgImg2 = watermarkData.background2;
    final image = watermarkData.image;
    final image2 = watermarkData.image2;
    final content = watermarkData.content;

    if (templateId == 1698049835340) {
      return Stack(
        children: [
          FutureBuilder(
              future: WatermarkService.getImagePath(templateId.toString(),
                  fileName: bgImg1),
              builder: (context, snapshot) {
                final imagePath = snapshot.data;
                if (imagePath != null) {
                  return Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                  );
                }
                return const SizedBox.shrink();
              }),
          FutureBuilder(
              future: WatermarkService.getImagePath(templateId.toString(),
                  fileName: bgImg2),
              builder: (context, snapshot) {
                final imagePath = snapshot.data;
                if (imagePath != null) {
                  return Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                  );
                }
                return const SizedBox.shrink();
              }),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('物业管理'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: WatermarkService.getImagePath(
                                templateId.toString(),
                                fileName: image),
                            builder: (context, snapshot) {
                              final imagePath = snapshot.data;
                              if (imagePath != null) {
                                return Image.file(
                                  height: 12,
                                  File(imagePath),
                                  fit: BoxFit.contain,
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                        const Text(
                          '全天候守护',
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '高品质服务',
                      style: TextStyle(fontSize: 10),
                    ),
                    FutureBuilder(
                        future: WatermarkService.getImagePath(
                            templateId.toString(),
                            fileName: image2),
                        builder: (context, snapshot) {
                          final imagePath = snapshot.data;
                          if (imagePath != null) {
                            return Image.file(
                              width: 45,
                              File(imagePath),
                              fit: BoxFit.contain,
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (Utils.isNotNullEmptyStr(content)) {
      return ImageUtil.fileImage(file: File(content!), fit: BoxFit.cover);
    }

    if (Utils.isNullEmptyStr(image)) {
      return SizedBox(
        width: 80.w,
        child: FutureBuilder(
            future: WatermarkService.getImagePath(templateId.toString(),
                fileName: image),
            builder: (context, snapshot) {
              final imagePath = snapshot.data;
              if (imagePath != null) {
                return Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                );
              }
              return const SizedBox.shrink();
            }),
      );
    }

    return const SizedBox.shrink();
  }
}
