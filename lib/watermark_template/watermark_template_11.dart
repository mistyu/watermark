import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:collection/collection.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watemark_time.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_weather.dart';
import 'package:watermark_camera/widgets/watermark_template/watermark_custom1.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_altitude.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_coordinate.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_notes.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

class WatermarkTemplate11 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate11({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;
  WatermarkData? get timeData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == watermarkTimeType);

  WatermarkData? get titleData => watermarkView.data
      ?.firstWhereOrNull((data) => (data.type == watermarkTitleType));

  Map<String, WatermarkTable>? get tables => watermarkView.tables;

  DateTime get timeContent {
    if (timeData?.content != '' && timeData?.content != null) {
      return DateTime.parse(timeData?.content! ?? '');
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
    final timeStyle = timeData?.style;
    final fonts = timeStyle?.fonts;
    final font = fonts?['font'];
    List<Map> tableItems = [];
    final c = const Color(0xCC407DC6).opacity;
    final b = const Color(0x80ffffff).opacity;

    return Column(
      children: [
        Container(
          color: const Color(0xCC407DC6),
          child: Column(
            children: [
              _buildWatermarkBox(
                titleData,
                TitleBar(
                  watermarkData: titleData!,
                  resource: resource,
                ),
              ),
              // Visibility(
              //   visible: !(titleData?.isHidden == true),
              //   child: TitleBar(
              //     watermarkData: titleData!,
              //     resource: resource,
              //   ),
              // ),

              Visibility(
                visible: !(timeData?.isHidden == true),
                child: RYWatermarkTime0(
                    watermarkData: timeData!, resource: resource),
              ),
            ],
          ),
        ),

        ...tables!.entries.map((tableMap) {
          bool isHidden(key) => key.isHidden == false;
          final table = tableMap.value;

          if (tableMap.key == 'table1') {
            final customDataList = table.data
                ?.where((data) => data.type == watermarkCustom1Type)
                .toList();

            final dataTypes = {
              watermarkWeatherType: (data) =>
                  RyWatermarkWeather(watermarkData: data!, resource: resource),
              watermarkLocationType: (data) => RyWatermarkLocationBox(
                  watermarkData: data!, resource: resource),
              watermarkAltitudeType: (data) =>
                  YWatermarkAltitude(watermarkData: data!, resource: resource),
              watermarkCoordinateType: (data) => YWatermarkCoordinate(
                  watermarkData: data!,
                  resource: resource,
                  watermarkView: watermarkView),
              watermarkNotesType: (data) =>
                  YWatermarkNotes(watermarkData: data!, resource: resource),
            };

            List<Map> itemList = dataTypes.entries.map((entry) {
              final data = table.data
                  ?.firstWhereOrNull((data) => data.type == entry.key);
              return {
                'data': data,
                'widget': entry.value(data),
              };
            }).toList();

            customDataList?.forEach((customData) {
              tableItems.add({
                'data': customData,
                'widget': WatermarkCustom1Box(
                    watermarkData: customData, resource: resource)
              });
            });

            tableItems.addAll(itemList);
          }
          if (tableMap.key == 'table2') {
            final customDataList = table.data
                ?.where((data) => data.type == watermarkCustom1Type)
                .toList();
            tableItems = [];
            customDataList?.forEach((customData) {
              tableItems.add({
                'data': customData,
                'widget': WatermarkCustom1Box(
                    watermarkData: customData, resource: resource)
              });
            });
          }
          return Container(
            color: tableMap.key == 'table1'
                ? const Color(0xffffffff).withOpacity(0.1)
                // const Color(0x80ffffff)
                : const Color(0xCC407DC6),
            child: Visibility(
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
                    ],
                  );
                }).toList()),
              ),
            ),
          );
        }).toList(),

        // Container(
        //   color: const Color(0x80ffffff),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       ...     ],
        //   ),
        // )
      ],
    );
  }
}

class TitleBar extends StatelessWidget {
  final WatermarkData watermarkData;
  final Resource? resource;
  const TitleBar(
      {super.key, required this.watermarkData, required this.resource});

  int get watermarkId => resource?.id ?? 0;
  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final frame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    var font = fonts?['font'];
    final layout = dataStyle?.layout;

    Widget? imageWidget = const SizedBox.shrink();
    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                padding: EdgeInsets.only(
                    left: (layout?.imageTitleSpace ?? 0).w,
                    top: (layout?.imageTopSpace?.abs() ?? 0).w),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble().w,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }
    return Row(
      children: [
        imageWidget,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
          margin: EdgeInsets.only(left: 3.w),
          child: WatermarkFontBox(
              isBold: watermarkId == 16982153599988,
              textStyle: dataStyle,
              text: watermarkData.content ?? '',
              font: font?.copyWith(size: 14)),
        ),
      ],
    );
  }
}
