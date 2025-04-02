import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:collection/collection.dart';

class WatermarkTemplate582 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate582({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;
  WatermarkData? get timeDivisionData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTimeDivision');

  WatermarkData? get titleData => watermarkView.data?.firstWhereOrNull(
      (data) => (data.type == 'YWatermarkCustom1' && data.title == '打卡标题'));
  DateTime get timeContent {
    if (timeDivisionData?.content != '' && timeDivisionData?.content != null) {
      return DateTime.parse(timeDivisionData?.content! ?? '');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final timeStyle = timeDivisionData?.style;
    final fonts = timeStyle?.fonts;
    final font = fonts?['font'];
    final gradients = timeStyle?.gradient;
    final colors = gradients?.colors;

    TextStyle? timeTextStyle = TextStyle(
        color: timeStyle?.textColor?.color
            ?.hexToColor(timeStyle.textColor?.alpha?.toDouble()),
        fontFamily: font?.name,
        fontSize: font?.size?.sp,
        fontWeight: FontWeight.bold,
        // height: 1.0,
        // leadingDistribution: TextLeadingDistribution.even,
        shadows: Utils.getViewShadow(
            color: timeStyle?.textColor?.color?.hexToColor(0.5)));

    Widget alignText() {
      return StreamBuilder<String>(
          stream: Stream.periodic(const Duration(seconds: 1), (count) {
            return formatDate(timeContent, [HH, ':', nn]);
          }),
          builder: (context, snap) {
            return Container(
              margin: const EdgeInsets.only(right: 2.0),
              alignment: Alignment.centerRight,
              child: Text(
                snap.data ??
                    formatDate(timeContent, [
                      HH,
                      ':',
                      nn,
                    ]),
                style: timeTextStyle,
              ),
            );
          });
    }

    return FutureBuilder(
        future: WatermarkService.getImagePath582(watermarkId.toString(),
            fileName: timeDivisionData?.background),
        builder: (context, snapshot) {
          print("xiaojianjian snapshot.data = ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                    // borderRadius:
                    //     BorderRadius.circular(timeStyle?.radius ?? 0).r,
                    borderRadius: BorderRadius.circular(1).r,
                    image: DecorationImage(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fill,
                      image: FileImage(File(snapshot.data!)),
                    )),
                child: alignText());
          }
          return const SizedBox.shrink();
        });
  }
}
