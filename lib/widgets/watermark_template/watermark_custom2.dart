import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_mark.dart';

class WatermarkCustom2Box extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const WatermarkCustom2Box(
      {super.key, required this.watermarkData, required this.resource});
  int get watermarkId => resource.id ?? 0;

  @override
  Widget build(BuildContext context) {
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    final mark = watermarkData.mark;
    final titleVisible = watermarkData.isWithTitle;

    final signLine = watermarkData.signLine;
    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;
    final bgImg = watermarkData.background;

    List<Widget> richTextWidgets = [];
    List<Widget> endWidgets = [];
    List<WatermarkRichText> richTextData = dataStyle?.richText ?? [];

    richTextData.sort((a, b) {
      if (a.index == -1) return 1;
      if (b.index == -1) return -1;
      return a.index.compareTo(b.index);
    });

    for (var item in richTextData) {
      var component = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: item.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                margin: item.topSpace >= 0
                    ? EdgeInsets.only(bottom: item.topSpace.abs())
                    : EdgeInsets.only(top: item.topSpace.abs()),
                child: Image.file(
                  File(snapshot.data!),
                  width: dataStyle?.fonts?["font"]?.size?.toDouble(),
                  fit: BoxFit.cover,
                  scale: 0.8,
                ),
              );
            }

            return const SizedBox.shrink();
          });
      if (item.index == -1) {
        endWidgets.add(component);
      } else {
        richTextWidgets.add(component);
      }
    }

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = dataStyle?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right: (layout?.imageTitleSpace?.abs() ?? 0).w,
                    top: (layout?.imageTopSpace?.abs() ?? 0).h),
                child: Image.file(File(snapshot.data!),
                    height: dataStyle?.iconHeight?.toDouble().h,
                    width: dataStyle?.iconWidth?.toDouble().w,
                    fit: BoxFit.fill),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return Stack(
      // alignment: Alignment.centerLeft,
      children: [
        WatermarkFrameBox(
          frame: dataFrame,
          style: dataStyle,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              imageWidget,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible: titleVisible ?? false,
                        child: WatermarkFontBox(
                            //height: 1,
                            textStyle: dataStyle,
                            text: "${watermarkData.title}：",
                            font: font)),
                    Expanded(
                      child: WatermarkFontBox(
                        textStyle: dataStyle,
                        text: watermarkData.content ?? '',
                        font: font,
                        //height: 1,
                      ),
                    )
                  ],
                ),
              ),
              ...endWidgets,
            ],
          ),
        ),
      ],
    );
  }
}
