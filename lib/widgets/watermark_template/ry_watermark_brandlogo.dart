import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';

import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/image_util.dart';

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
      // 判断是否是网络图片
      if (content!.startsWith('http')) {
        return FutureBuilder<Widget>(
          future: _loadNetworkImage(content),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              print('Load network image failed: ${snapshot.error}');
              return Container(color: Colors.grey[300]);
            }
            return snapshot.data!;
          },
        );
      } else {
        // 本地图片
        return ImageUtil.fileImage(file: File(content), fit: BoxFit.cover);
      }
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

  // 添加这个辅助方法来处理网络图片加载
  Future<Widget> _loadNetworkImage(String url) async {
    // 先尝试从缓存加载
    final cachedFile = await ImageUtil.getCachedNetworkImage(url);
    if (cachedFile != null) {
      return ImageUtil.fileImage(file: cachedFile, fit: BoxFit.cover);
    }

    // 缓存中没有，下载并缓存
    try {
      final file = await ImageUtil.downloadAndCacheNetworkImage(url);
      return ImageUtil.fileImage(file: file, fit: BoxFit.cover);
    } catch (e) {
      print('Download network image failed: $e');
      throw e; // 让 FutureBuilder 处理错误
    }
  }
}
