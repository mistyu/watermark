import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import 'WatermarkFont.dart';

class YWatermarkStepNumber extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkStepNumber({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final fonts = dataStyle?.fonts;
    final font = fonts?['font'];
    final textColor = dataStyle?.textColor;

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: readImage(watermarkId.toString(), watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = dataStyle?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right: layout?.imageTitleSpace ?? 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble(), fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            imageWidget,
            SizedBox(width: 8.0.w,),
            WatermarkFontBox(
                text: watermarkData.title ?? '', textStyle: dataStyle),
          ],
        ),
        Container(
          child: Text(
            '21658',
            style: TextStyle(
                fontSize: 28.0.sp,
                color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                fontFamily: font?.name,
                height: 1.8),
          ),
        ),
      ],
    );
  }
}
