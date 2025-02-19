import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:collection/collection.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_template/watermark_custom1.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class WatermarkTemplate14 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate14({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;

  WatermarkData? get timeDivisionData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == watermarkTimeDivisionType);

  Map<String, WatermarkTable>? get tables => watermarkView.tables;

  DateTime get timeContent {
    if (timeDivisionData?.content != '' && timeDivisionData?.content != null) {
      return DateTime.parse(timeDivisionData?.content! ?? '');
    }
    return DateTime.now();
  }

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
    final timeDivisionStyle = timeDivisionData?.style;
    final fonts = timeDivisionStyle?.fonts;
    final font = fonts?['font'];
    final table1 = tables?['table1'];
    final table2 = tables?['table2'];

    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1), (int count) {
          return formatDate(timeContent, [
            yyyy,
            '.',
            mm,
            '.',
            dd,
            ' ',
            '星期',
            Lunar.fromDate(timeContent).getWeekInChinese(),
            ' ',
            HH,
            ':',
            nn
          ]);
        }),
        builder: (context, snapshot) {
          final s = snapshot.data;
          // 具体时间
          final time = snapshot.data ??
              formatDate(timeContent, [
                yyyy,
                '.',
                mm,
                '.',
                dd,
                ' ',
                '星期',
                Lunar.fromDate(timeContent).getWeekInChinese(),
                ' ',
                HH,
                ':',
                nn
              ]);
          final divisionList = time.split(' ');
          // 时间点
          final time1 = divisionList[2];
          // 日期
          final dataTime = divisionList[0];
          // 星期
          final weekday = divisionList[1];

          final dataTypes = {
            watermarkTimeType: (WatermarkData? data) => WatermarkFontBox(
                  text: '$dataTime $weekday',
                  textStyle: data?.style,
                  font: data?.style?.fonts?["font"],
                ),
            watermarkLocationType: (data) => RyWatermarkLocationBox(
                watermarkData: data!, resource: resource),
          };
          List<Map> tableList1 = dataTypes.entries.map((entry) {
            final data = table1?.data
                ?.firstWhereOrNull((data) => data.type == entry.key);
            return {
              'data': data,
              'widget': entry.value(data),
            };
          }).toList();
          final customDataList = table2?.data
              ?.where((data) => data.type == watermarkCustom1Type)
              .toList();

          List<Map> tableList2 = [];
          customDataList?.forEach((customData) {
            tableList2.add({
              'data': customData,
              'widget': WatermarkCustom1Box(
                  watermarkData: customData, resource: resource)
            });
          });

          final dateData = table1?.data
              ?.firstWhereOrNull((data) => data.type == watermarkTimeType);

          final locationData = table1?.data
              ?.firstWhereOrNull((data) => data.type == watermarkLocationType);
          return IntrinsicWidth(
            child: Column(
              children: [
                _buildWatermarkBox(
                    timeDivisionData,
                    WatermarkFontBox(
                      text: time1 ?? formatDate(timeContent, [HH, ':', nn]),
                      textStyle: timeDivisionStyle,
                      font: font,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WatermarkFontBox(
                      text: dataTime != null && weekday != null
                          ? '$dataTime $weekday'
                          : formatDate(timeContent, [HH, ':', nn]),
                      textStyle: dateData?.style,
                      font: dateData?.style?.fonts?["font"],
                    ),
                    _buildWatermarkBox(
                        locationData,
                        RyWatermarkLocationBox(
                            watermarkData: locationData!, resource: resource))
                    // RyWatermarkLocationBox(
                    //     watermarkData: locationData!, resource: resource),
                  ],
                )

                // Row(
                //     children: tableList1.asMap().entries.map((entry) {
                //   final index = entry.key;
                //   final item = entry.value;
                //   final itemData = item['data'] as WatermarkData;
                //   final itemWidget = item['widget'] as Widget;
                //   return itemWidget;
                //   // _buildWatermarkBox(itemData, item['widget']);
                // }).toList()),
                // Row(
                //     children: tableList2.asMap().entries.map((entry) {
                //   final index = entry.key;
                //   final item = entry.value;
                //   final itemData = item['data'] as WatermarkData;
                //   return Text('${item['widget']}');
                //   // _buildWatermarkBox(itemData, item['widget']);
                // }).toList()),
                // ...tables!.entries.map((tableMap) {
                //   bool isHidden(key) => key.isHidden == false;
                //   final table = tableMap.value;
                //   //处理tableItems中的数据
                //   if (tableMap.key == 'table1') {
                //     final dataTypes = {
                //       watermarkTimeType: (WatermarkData? data) => WatermarkFontBox(
                //             text: dataTime != null && weekday != null
                //                 ? '$dataTime $weekday'
                //                 : formatDate(timeContent, [HH, ':', nn]),
                //             textStyle: data?.style,
                //             font: data?.style?.fonts?["font"],
                //           ),
                //       watermarkLocationType: (data) => RyWatermarkLocationBox(
                //           watermarkData: data!, resource: resource),
                //     };

                //     List<Map> itemList = dataTypes.entries.map((entry) {
                //       final data = table.data
                //           ?.firstWhereOrNull((data) => data.type == entry.key);
                //       return {
                //         'data': data,
                //         'widget': entry.value(data),
                //       };
                //     }).toList();

                //     tableItems.addAll(itemList);
                //   }
                //   if (tableMap.key == 'table2') {
                //     final customDataList = table.data
                //         ?.where((data) => data.type == watermarkCustom1Type)
                //         .toList();
                //     tableItems = [];
                //     customDataList?.forEach((customData) {
                //       tableItems.add({
                //         'data': customData,
                //         'widget': WatermarkCustom1Box(
                //             watermarkData: customData, resource: resource)
                //       });
                //     });
                //   }
                //   print(tableItems.length);
                //   return Visibility(
                //       visible: table.data != null && table.data!.any(isHidden),
                //       child: Row(
                //         children: tableItems.asMap().entries.map((entry) {
                //           final index = entry.key;
                //           final item = entry.value;
                //           final itemData = item['data'] as WatermarkData;
                //           return Text('${item['widget']}');
                //           // _buildWatermarkBox(itemData, item['widget']);
                //         }).toList(),
                //       ));
                // }).toList(),
              ],
            ),
          );
        });
  }
}
