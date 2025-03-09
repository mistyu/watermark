import 'package:flutter/material.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:collection/collection.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watemark_time.dart';

class WatermarkTemplate8 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate8({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;

  WatermarkData? get timeData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTime');

  WatermarkData? get shapeData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkShape');

  DateTime get timeContent {
    if (timeData?.content != '' && timeData?.content != null) {
      return DateTime.parse(timeData?.content! ?? '');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //时间
        RYWatermarkTime13(
          watermarkData: timeData,
          resource: resource,
          shapeContent: shapeData?.content ?? '',
        ),
      ],
    );
  }
}
