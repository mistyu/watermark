import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';

import 'package:watermark_camera/models/watermark/watermark.dart';
import '../../brand_logo.dart';
import '../../edit_pic.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../lib/utils/watermark.dart';

class RYWatermarkBrandLogo extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkBrandLogo({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int templateId = context.read<WatermarkCubit>().watermarkId;
    final bgImg1 = watermarkData.background;
    final bgImg2 = watermarkData.background2;
    final image = watermarkData.image;
    final image2 = watermarkData.image2;

    return templateId == 1698049835340
        ? Stack(
            children: [
              FutureBuilder(
                  future: readImage(templateId.toString(), bgImg1),
                  builder: (context, snapshot) {
                    final imagePath = snapshot.data;
                    if (imagePath != null) {
                      return Image.file(
                        File(imagePath!),
                        fit: BoxFit.contain,
                      );
                    }
                    return SizedBox.shrink();
                  }),
              FutureBuilder(
                  future: readImage(templateId.toString(), bgImg2),
                  builder: (context, snapshot) {
                    final imagePath = snapshot.data;
                    if (imagePath != null) {
                      return Image.file(
                        File(imagePath!),
                        fit: BoxFit.contain,
                      );
                    }
                    return SizedBox.shrink();
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
                        Text('物业管理'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                                future: readImage(templateId.toString(), image),
                                builder: (context, snapshot) {
                                  final imagePath = snapshot.data;
                                  if (imagePath != null) {
                                    return Image.file(
                                      height: 12,
                                      File(imagePath),
                                      fit: BoxFit.contain,
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),
                            Text(
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
                        Text(
                          '高品质服务',
                          style: TextStyle(fontSize: 10),
                        ),
                        FutureBuilder(
                            future: readImage(templateId.toString(), image2),
                            builder: (context, snapshot) {
                              final imagePath = snapshot.data;
                              if (imagePath != null) {
                                return Image.file(
                                  width: 45,
                                  File(imagePath),
                                  fit: BoxFit.contain,
                                );
                              }
                              return SizedBox.shrink();
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        : image == null || image == ''
            ? SizedBox.shrink()
            : Container(
                width: 80.w,
                child: FutureBuilder(
                    future: readImage(templateId.toString(), image),
                    builder: (context, snapshot) {
                      final imagePath = snapshot.data;
                      if (imagePath != null) {
                        return Image.file(
                          File(imagePath),
                          fit: BoxFit.contain,
                        );
                      }
                      return SizedBox.shrink();
                    }),
              );
  }
}
