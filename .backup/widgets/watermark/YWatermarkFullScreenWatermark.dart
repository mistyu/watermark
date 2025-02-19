import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'WatermarkFrame.dart';
import '../../../lib/utils/watermark.dart';

class YWatermarkFullScreenWatermark extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkFullScreenWatermark({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;

    return Column(
      children: [
        FutureBuilder(
            future: readImage(watermarkId.toString(), watermarkData.image),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return WatermarkFrameBox(
                  style: dataStyle,
                  frame: dataFrame,
                  imagePath: snapshot.data,
                );
              }

              return const SizedBox.shrink();
            })
      ],
    );
  }
}
