import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import 'WatermarkFrame.dart';

class YWatermarkHeadline extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkHeadline({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    final fonts = watermarkData.style?.fonts;
    final frame = watermarkData.frame;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    final dataStyle = watermarkData.style;
    final layout = dataStyle?.layout;
    print(
        "watermarkData.content 治安巡逻 YWatermarkHeadline: ${watermarkData.content}");
    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: readImage(watermarkId.toString(), watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                margin: EdgeInsets.only(
                    right: layout?.imageTitleSpace ?? 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble() ?? 30,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return WatermarkFrameBox(
      style: watermarkData.style,
      frame: frame,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: watermarkId == 1698059986262
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          imageWidget,
          Text(
            watermarkData.content + '123' ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
                color:
                    textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                fontFamily: font?.name,
                fontSize: font?.size),
          ),
        ],
      ),
    );
  }
}
