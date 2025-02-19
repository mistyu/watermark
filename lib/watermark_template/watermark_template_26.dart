import 'package:flutter/material.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:collection/collection.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watemark_time.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_template/watermark_custom1.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_headline.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_notes.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class WatermarkTemplate26 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate26({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;
  WatermarkData? get timeData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTime');

  WatermarkData? get titleData => watermarkView.data
      ?.firstWhereOrNull((data) => (data.type == 'YWatermarkHeadline'));
  DateTime get timeContent {
    if (timeData?.content != '' && timeData?.content != null) {
      return DateTime.parse(timeData?.content! ?? '');
    }
    return DateTime.now();
  }

  WatermarkSignLine? get signLine => watermarkView.signLine;
  Map<String, WatermarkTable>? get tables => watermarkView.tables;
  Widget _buildWatermarkBox(WatermarkData? data, Widget child) {
    return Visibility(
      visible: !(data?.isHidden == true),
      child: WatermarkFrameBox(
        watermarkId: watermarkId,
        frame: data?.frame,
        style: data?.style,
        watermarkData: data,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map> watermarkItems = [
      {
        'data': titleData,
        'widget':
            YWatermarkHeadline(watermarkData: titleData!, resource: resource)
      },
      {
        'data': timeData,
        'widget': RYWatermarkTime6(watermarkData: timeData!, resource: resource)
      },
    ];

    List<Map> tableItems = [];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: watermarkItems.map((item) {
            return _buildWatermarkBox(item['data'], item['widget']); 
          }).toList(),
        ),
        WatermarkFrameBox(
          frame: signLine?.frame,
          style: signLine?.style,
        ),
        ...tables!.entries.map((tableMap) {
          bool isHidden(key) => key.isHidden == false;
          final table = tableMap.value;

          if (tableMap.key == 'table1') {
            final locationData = table.data?.firstWhereOrNull(
                (data) => data.type == 'RYWatermarkLocation');
            final noteData = table.data
                ?.firstWhereOrNull((data) => data.type == 'YWatermarkNotes');
            tableItems = [
              {
                'data': locationData,
                'widget': RyWatermarkLocationBox(
                    watermarkData: locationData!, resource: resource)
              },
              {
                'data': noteData,
                'widget': YWatermarkNotes(
                  watermarkData: noteData!,
                  resource: resource,
                )
              }
            ];
          }
          if (tableMap.key == 'table2') {
            final customData = tableMap.value.data
                ?.firstWhereOrNull((data) => data.type == 'YWatermarkCustom1');
            tableItems = [
              {
                'data': customData,
                'widget': WatermarkCustom1Box(
                    watermarkData: customData!, resource: resource)
              },
            ];
          }
          return Visibility(
            visible: table.data != null && table.data!.any(isHidden),
            child: WatermarkFrameBox(
              watermarkId: watermarkId,
              frame: table.frame,
              style: table.style,
              child: Column(
                  children: tableItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final itemData = item['data'] as WatermarkData;
                return Column(
                  children: [
                    _buildWatermarkBox(itemData, item['widget']),
                    if (index == 0 && tableMap.key == 'table1')
                      Image.asset('horizontalline'.png),
                    if (index == 0 && tableMap.key == 'table2')
                      WatermarkFrameBox(
                        frame: itemData.signLine?.frame,
                        style: itemData.signLine?.style,
                      ),
                  ],
                );
              }).toList()),
            ),
          );
        }).toList(),
      ],
    );
  }
}
