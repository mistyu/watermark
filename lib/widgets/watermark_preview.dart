import 'dart:io';

import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/watermark_template/watermark_template_1.dart';
import 'package:watermark_camera/watermark_template/watermark_template_11.dart';
import 'package:watermark_camera/watermark_template/watermark_template_14.dart';
import 'package:watermark_camera/watermark_template/watermark_template_16.dart';
import 'package:watermark_camera/watermark_template/watermark_template_26.dart';
import 'package:watermark_camera/watermark_template/watermark_template_3.dart';
import 'package:watermark_camera/watermark_template/watermark_template_5.dart';
import 'package:watermark_camera/watermark_template/watermark_template_8.dart';
import 'package:watermark_camera/widgets/watermark_template/Y_watermark_general.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watemark_time.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_Altitude_deiv.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_brandlogo.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location_new.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_weather.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_weather_deiv.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_weather_deiv1698317868899.dart';
import 'package:watermark_camera/widgets/watermark_template/watermark_custom1.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_altitude_new.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_coordinate.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_coordinate_show1.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_coordinate_show1_deiv.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_coordinate_show1_two_deiv.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_general_deiv.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_location_deiv.dart';
import 'package:watermark_camera/widgets/watermark_template/y_watermark_notes.dart';
import 'watermark_ui/watermark_data_dynamic.dart';
import 'watermark_ui/watermark_frame_box.dart';

/**
 * 核心：水印预览，预览界面中看到的水印
 * 根据不同的id，生成不同的水印（特调就好了）
 */
class WatermarkPreview extends StatelessWidget {
  final WatermarkResource resource;
  final WatermarkView? watermarkView;

  //对于品牌图将其独立出来进行
  WatermarkData? get logoData => watermarkView?.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkBrandLogo');

  const WatermarkPreview(
      {super.key, required this.resource, this.watermarkView});

  int get templateId => resource.id ?? 0;

  Widget _buildChild(WatermarkView watermarkView) {
    final boxFrame = watermarkView.frame;
    final bodyData = watermarkView.data;
    final bodyStyle = watermarkView.style;
    final signLine = watermarkView.signLine;

    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;

    final viewType = watermarkView.viewType;

    var boxAlignment = Alignment.bottomLeft;

    var crossBox = CrossAxisAlignment.start;

    var direction = Axis.vertical;

    if (boxFrame?.isCenterX == true) {
      boxAlignment = Alignment.bottomCenter;
    }

    if (boxFrame?.isCenterY == true) {
      boxAlignment = Alignment.centerLeft;
    }

    if (boxFrame?.isCenterX == true && boxFrame?.isCenterY == true) {
      boxAlignment = Alignment.center;
    }

    if (viewType == "RYViewTypeSeven") {
      crossBox = CrossAxisAlignment.center;
    }

    if (templateId == 1698049443671) {
      direction = Axis.horizontal;
    }

    final decortaion = resource.cid == 4 &&
                templateId != 16986607549321 &&
                templateId != 16982153599988 &&
                templateId != 16982153599999 ||
            templateId == 16983971079955 ||
            templateId == 16983971077788
        ? BoxDecoration(
            borderRadius:
                BorderRadius.circular(bodyStyle?.radius?.toDouble().r ?? 0),
            border: Border(
              left: BorderSide(
                  color: signlineStyle?.backgroundColor?.color?.hexToColor(
                          signlineStyle.backgroundColor?.alpha?.toDouble()) ??
                      Colors.transparent,
                  width: signlineFrame?.width ?? 0,
                  style: ((signlineFrame?.width == null) ||
                          (signlineFrame?.width == 0))
                      ? BorderStyle.none
                      : BorderStyle.solid),
            ))
        : getDecoration(watermarkView);

    // List<Widget> remainingWidgets = [];
    // Widget firstRow = const Row(
    //   children: [],
    // );
    // if (bodyData!.length >= 3 &&
    //     (templateId == 1698049443671 || templateId == 1698049553311)) {
    //   // 分离出前两个元素
    //   final List<Widget> firstTwoWidgets = bodyData
    //       .take(templateId == 1698049443671 ? 3 : 2)
    //       .map((item) => WatermarkDataDynamic(
    //             watermarkView: watermarkView,
    //             watermarkData: item,
    //             resource: resource, // 假设这里使用相同的templateId
    //           ))
    //       .toList();
    //   // 否则，将前两个元素放在Row中，并将剩余的元素作为单独的Widget处理
    //   firstRow = Row(
    //     mainAxisSize: MainAxisSize.max,
    //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: firstTwoWidgets,
    //   );
    // remainingWidgets = bodyData
    //     .skip(templateId == 1698049443671 ? 3 : 2) // 跳过前两个元素
    //     .map((item) => WatermarkDataDynamic(
    //           watermarkView: watermarkView,
    //           watermarkData: item,
    //           resource: resource,
    //         ))
    //     .toList();
    // }

    Widget brandLogo = const SizedBox.shrink();

    final index = bodyData!.indexWhere((e) => e.type == 'RYWatermarkBrandLogo');
    if (index != -1) {
      brandLogo = Visibility(
        visible: !(bodyData[index].isHidden == true),
        child: Padding(
          padding: EdgeInsets.only(bottom: 4.0.w),
          child: WatermarkDataDynamic(
            watermarkView: watermarkView,
            watermarkData: bodyData[index],
            resource: resource,
          ),
        ),
      );
    }

    List<Widget> watermarkDataDynamic = bodyData
        .skipWhile((item) =>
            item.type == 'RYWatermarkLiveShooting' ||
            item.type == 'RYWatermarkBrandLogo')
        .map((item) => WatermarkDataDynamic(
              watermarkView: watermarkView,
              watermarkData: item,
              resource: resource,
            ))
        .toList();

    if (templateId == 1698049285500 || templateId == 1698049285310) {
      return FutureBuilder(
          future: WatermarkService.getImagePath(templateId.toString(),
              fileName: 'bg_watermark'),
          builder: (context, snapshot) {
            return WatermarkFrameBox(
              frame: boxFrame,
              style: bodyStyle,
              watermarkId: templateId,
              imagePath: snapshot.data,
              child: Column(
                children: [
                  //品牌图 --- 并且跟随水印
                  if (logoData != null &&
                      logoData?.isHidden == false &&
                      logoData?.logoPositionType == 0)
                    RYWatermarkBrandLogo(
                      watermarkData: logoData!,
                      resource: resource,
                    ),
                  SizedBox(height: 6.h),
                  Container(
                    margin: EdgeInsets.only(left: 1.w),
                    child: WatermarkTemplate1(
                      resource: resource,
                      watermarkView: watermarkView,
                    ),
                  ),
                  ...tableWidget(watermarkView.tables ?? {}, watermarkView)
                          ?.toList() ??
                      [const SizedBox.shrink()],
                ],
              ),
            );
          });
    }

    // if (templateId == 1698052386153) {
    //   return Text("你好");
    //   // return Stack(
    //   //   children: [
    //   //     Positioned(
    //   //       left: 0,
    //   //       top: 0,
    //   //       child: Text("你好"),
    //   //     ),
    //   //   ],
    //   // );
    // }

    if (templateId == 1698049556633) {
      return WatermarkFrameBox(
        frame: boxFrame,
        style: bodyStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WatermarkTemplate3(
              resource: resource,
              watermarkView: watermarkView,
            ),
            SizedBox(height: 6.h),
            ...tableWidget(watermarkView.tables ?? {}, watermarkView)
                    ?.toList() ??
                [const SizedBox.shrink()],
          ],
        ),
      );
    }

    if (templateId == 1698125672 ||
        templateId == 1698125120 ||
        templateId == 1698125930 ||
        templateId == 16982153599582) {
      print("xiaojianjian WatermarkPreview dawdw templateId ${templateId}");
      return FutureBuilder(
          future: WatermarkService.getImagePath(templateId.toString(),
              fileName: 'water_11_bg'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return WatermarkFrameBox(
                frame: boxFrame,
                style: bodyStyle,
                watermarkId: templateId,
                imagePath: snapshot.data,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (logoData != null &&
                        logoData?.isHidden == false &&
                        logoData?.logoPositionType == 0)
                      RYWatermarkBrandLogo(
                        watermarkData: logoData!,
                        resource: resource,
                      ),
                    SizedBox(height: 6.h),
                    WatermarkTemplate5(
                      resource: resource,
                      watermarkView: watermarkView,
                    ),
                    ...tableWidget(
                          watermarkView.tables ?? {},
                          watermarkView,
                        )?.toList() ??
                        [const SizedBox.shrink()],
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          });
    }
    if (templateId == 1698125683355) {
      return WatermarkFrameBox(
        frame: boxFrame,
        style: bodyStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //品牌图
            if (logoData != null &&
                logoData?.isHidden == false &&
                logoData?.logoPositionType == 0)
              RYWatermarkBrandLogo(
                watermarkData: logoData!,
                resource: resource,
              ),
            SizedBox(height: 6.h),
            WatermarkTemplate8(
              resource: resource,
              watermarkView: watermarkView,
            ),
            ...tableWidget(watermarkView.tables ?? {}, watermarkView)
                    ?.toList() ??
                [const SizedBox.shrink()],
          ],
        ),
      );
    }
    if (templateId == 1698059986262) {
      return FutureBuilder(
          future: WatermarkService.getImagePath(templateId.toString(),
              fileName: 'whitebg'),
          builder: (context, snapshot) {
            return WatermarkFrameBox(
              frame: boxFrame,
              style: bodyStyle,
              watermarkId: templateId,
              imagePath: snapshot.data,
              child: WatermarkTemplate26(
                resource: resource,
                watermarkView: watermarkView,
              ),
            );
          });
    }
    if (templateId == 16982153599988
// ||templateId == 16982153599999
        ) {
      return WatermarkFrameBox(
        frame: boxFrame,
        style: bodyStyle,
        watermarkId: templateId,
        child: WatermarkTemplate11(
          resource: resource,
          watermarkView: watermarkView,
        ),
      );
    }
    if (templateId == 1698049776444) {
      return WatermarkFrameBox(
        frame: boxFrame?.copyWith(width: 1.sw, height: 0.2.sh),
        style: bodyStyle,
        watermarkId: templateId,
        child: WatermarkTemplate14(
          resource: resource,
          watermarkView: watermarkView,
        ),
      );
    }
    // return const SizedBox.shrink();

    if (templateId == 1698317868899) {
      return WatermarkFrameBox(
        frame: boxFrame,
        style: bodyStyle,
        watermarkId: templateId,
        child: Column(
          children: [
            ...tableWidgetNew(watermarkView.tables ?? {}, watermarkView)
                    ?.toList() ??
                [const SizedBox.shrink()],
          ],
        ),
      );
    }

    if (templateId == 16982893664516) {
      return WatermarkFrameBox(
        frame: boxFrame,
        style: bodyStyle,
        watermarkId: templateId,
        child: WatermarkTemplate16(
          resource: resource,
          watermarkView: watermarkView,
        ),
      );
    }

    return WatermarkFrameBox(
        frame: boxFrame,
        style: bodyStyle,
        watermarkId: templateId,
        child: Container(
          decoration: decortaion,
          width: (boxFrame?.width ?? 0) <= 0
              ? boxAlignment == Alignment.bottomCenter
                  ? 1.sw
                  : null
              : boxFrame?.width?.toDouble().w,
          child: Align(
            alignment: boxAlignment,
            child: ClipRRect(
              borderRadius: decortaion.borderRadius ?? BorderRadius.zero,
              child: templateId == 16982893664516
                  ? Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        brandLogo,
                        resource.cid! >= 3
                            ? Flex(
                                direction: direction,
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: WrapCrossAlignment.center,
                                children: watermarkDataDynamic,
                              )
                            : Stack(
                                children: watermarkDataDynamic,
                              ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: tableWidget(
                                      watermarkView.tables ?? {}, watermarkView)
                                  ?.toList() ??
                              [const SizedBox.shrink()],
                        ),
                      ],
                    )
                  : templateId == 1698049451122
                      ? Row(
                          children: [
                            Column(
                              children: watermarkDataDynamic,
                            ),
                            Expanded(
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...tableWidget(watermarkView.tables ?? {},
                                          watermarkView) ??
                                      [const SizedBox.shrink()]
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: crossBox,
                          mainAxisSize: MainAxisSize.min,
                          // fit: StackFit.loose,
                          children: [
                            brandLogo,
                            resource.cid! >= 3
                                ? (templateId == 1698049443671 ||
                                        templateId == 1698049553311)
                                    ? Column(children: [
                                        getFirstRow(watermarkView),
                                        FutureBuilder(
                                            future:
                                                WatermarkService.getImagePath(
                                                    templateId.toString(),
                                                    fileName: "ryMould_tag"),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                            color: "ffef5a".hex,
                                                            width: 1.5),
                                                      ),
                                                    ),
                                                    child: snapshot.data != null
                                                        ? Image.file(
                                                            File(
                                                                snapshot.data!),
                                                            fit: BoxFit.contain,
                                                          )
                                                        : const SizedBox
                                                            .shrink());
                                              }
                                              return const SizedBox.shrink();
                                            }),
                                        ...getRemainWidget(watermarkView),
                                      ])
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                signlineStyle?.padding?.left ??
                                                    0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: signlineStyle
                                                            ?.backgroundColor
                                                            ?.color
                                                            ?.hexToColor(signlineStyle
                                                                .backgroundColor
                                                                ?.alpha
                                                                ?.toDouble()) ??
                                                        Colors.transparent,
                                                    width:
                                                        signlineFrame?.width ??
                                                            0,
                                                    style: ((signlineFrame
                                                                    ?.width ==
                                                                null) ||
                                                            (signlineFrame
                                                                    ?.width ==
                                                                0))
                                                        ? BorderStyle.none
                                                        : BorderStyle.solid))),
                                        child: templateId == 1698215359120
                                            ? Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: watermarkDataDynamic,
                                              )
                                            : Flex(
                                                direction: direction,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                // crossAxisAlignment: WrapCrossAlignment.center,
                                                children: watermarkDataDynamic,
                                              ),
                                      )
                                : Stack(
                                    alignment: templateId == 1698125672 ||
                                            templateId == 1698125120 ||
                                            templateId == 1698125930
                                        ? AlignmentDirectional.centerStart
                                        : AlignmentDirectional.topStart,
                                    children: watermarkDataDynamic,
                                  ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...tableWidget(watermarkView.tables ?? {},
                                        watermarkView) ??
                                    [const SizedBox.shrink()]
                              ],
                            ),
                          ],
                        ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    print("xiaojianjian WatermarkPreview build ${templateId}");
    if (watermarkView == null) {
      return FutureBuilder(
          future: WatermarkView.fromResource(resource),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildChild(snapshot.data!);
            }
            return const SizedBox.shrink();
          });
    }

    return _buildChild(watermarkView!);
  }

  List<Widget>? tableWidget(
      Map<String, WatermarkTable> tables, WatermarkView? watermarkView) {
    final table1 = tables['table1'];
    final table2 = tables['table2'];
    final frame1 = table1?.frame;
    final frame2 = table2?.frame;
    final boxStyle1 = table1?.style;
    final boxStyle2 = table2?.style;
    final tableDatas1 = table1?.data ?? [];
    final tableDatas2 = table2?.data ?? [];
    final signline1 = table1?.signLine;

    bool isHidden(key) => key.isHidden == false;
    if (tables.containsKey("table1") &&
        tables.containsKey("table2") &&
        table1?.signLine?.containTable2 == true) {
      return [
        WatermarkFrameBox(
          frame: frame1,
          style: boxStyle1,
          signLine: signline1,
          watermarkId: templateId,
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: true,
                    child: Column(
                      children: tableDatas1
                          .where((e) => e.isHidden == false)
                          .map((data) {
                        return tableItem(data) ?? const SizedBox.shrink();
                      }).toList(),
                    )),
                Visibility(
                  visible: tableDatas2.any(isHidden),
                  child: WatermarkFrameBox(
                    frame: frame2,
                    style: boxStyle2,
                    watermarkId: templateId,
                    child: Column(
                      children: tableDatas2
                          .where((e) => e.isHidden == false)
                          .map((data) {
                        return tableItem(data) ?? const SizedBox.shrink();
                      }).toList(),
                    ),
                  ),
                )
              ]),
        ),
      ];
    }

    return tables.entries.map((entry) {
      print("xiaojianjian tables.entries.map ${entry.key}");
      final frame = entry.value.frame;
      final boxStyle = entry.value.style;
      final tableData = entry.value.data ?? [];
      final signline = entry.value.signLine;

      return Visibility(
        visible: tableData.any(isHidden),
        child: WatermarkFrameBox(
          frame: frame,
          style: boxStyle,
          signLine: signline,
          watermarkId: templateId,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tableData.where((e) => e.isHidden == false).map((data) {
              return tableItem(data, entry.key) ?? const SizedBox.shrink();
            }).toList(),
          ),
        ),
      );
    }).toList();
  }

  List<Widget>? tableWidgetNew(
      Map<String, WatermarkTable> tables, WatermarkView? watermarkView) {
    final table1 = tables['table1'];
    final table2 = tables['table2'];
    print("xiaojianjian tableWidgetNew table1 = ${table1?.data}");
    print("xiaojianjian tableWidgetNew templateId = ${templateId}");
    print("xiaojianjian tableWidgetNew table2 = ${table2?.data}");
    final frame1 = table1?.frame;
    final frame2 = table2?.frame;
    final boxStyle1 = table1?.style;
    final boxStyle2 = table2?.style;
    final tableDatas1 = table1?.data ?? [];
    final tableDatas2 = table2?.data ?? [];
    final signline1 = table1?.signLine;

    tableDatas1.map((e) => print(
        "xiaojianjian tableWidgetNew ${e.title} ${e.content} ${e.type} ${e.isHidden} ${e.frame}"));

    bool isHidden(key) => key.isHidden == false;

    return tables.entries.map((entry) {
      final frame = entry.value.frame;
      final boxStyle = entry.value.style;
      final tableData = entry.value.data ?? [];
      final signline = entry.value.signLine;

      return Visibility(
        visible: tableData.any(isHidden),
        child: WatermarkFrameBox(
          frame: frame,
          style: boxStyle,
          signLine: signline,
          watermarkId: templateId,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tableData.where((e) => e.isHidden == false).map((data) {
              return tableItemNew(data) ?? const SizedBox.shrink();
            }).toList(),
          ),
        ),
      );
    }).toList();
  }

  Widget? tableItemNew(WatermarkData data) {
    if (data.type == 'YWatermarkCustom1') {
      return WatermarkCustom1Box(
        watermarkData: data,
        resource: resource,
      );
    }

    if (data.type == 'RYWatermarkLocation') {
      if (data.showType == 1) {
        return RyWatermarkLocationBox(
          watermarkData: data,
          resource: resource,
        );
      } else {
        //普通展示 --- 直接一行展示
        return RyWatermarkLocationBoxNew(
          watermarkData: data,
          resource: resource,
        );
      }
    }

    if (data.type == 'YWatermarkWeather') {
      if (resource.id == 1698317868899 || resource.id == 1698049354422) {
        return YWatermarWatherSeparate1698317868899(
          watermarkData: data,
          resource: resource,
        );
      }
      return RyWatermarkWeather(
        watermarkData: data,
        resource: resource,
      );
    }
    if (data.type == watermarkCoordinateType) {
      if (data.coordinateType == 2) {
        //统一展示
        return YWatermarkCoordinate(
          watermarkData: data,
          resource: resource,
          watermarkView: watermarkView,
        );
      } else {
        //分行展示
        return YWatermarkCoordinateShow1(
          watermarkData: data,
          resource: resource,
        );
      }
    }

    if (data.type == watermarkTableGeneralType) {
      if (data.showType == 1) {
        //新建一种Gereral --- title 和 content 分开, 同时title是占满格子大小
        return YWatermarTableGeneralSeparate(
          watermarkData: data,
          resource: resource,
        );
      }
      return YWatermarTableGeneral(
        watermarkData: data,
        resource: resource,
      );
    }

    if (data.type == 'YWatermarkNotes') {
      return YWatermarkNotes(
        watermarkData: data,
        resource: resource,
      );
    }
    if (data.type == 'YWatermarkAltitude') {
      return YWatermarkAltitudeNew(
        watermarkData: data,
        resource: resource,
      );
    }
    if (data.type == 'RYWatermarkTime') {
      if (data.timeType == 0) {
        return RYWatermarkTime0(
          watermarkData: data,
          resource: resource,
        );
      }
      if (data.timeType == 2) {
        return RYWatermarkTime2(
          watermarkData: data,
          resource: resource,
        );
      }
      if (data.timeType == 8) {
        return RYWatermarkTime8(
          resource: resource,
          watermarkData: data,
        );
      }
      if (data.timeType == 3) {
        return RYWatermarkTime3(
          watermarkData: data,
          resource: resource,
        );
      }
      if (data.timeType == 11) {
        return RYWatermarkTime11(
          resource: resource,
          watermarkData: data,
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget? tableItem(WatermarkData data, [String? tableKey]) {
    // print("xiaojianjian tableItem ${data.type}");
    if (data.type == 'YWatermarkCustom1') {
      return WatermarkCustom1Box(
        watermarkData: data,
        resource: resource,
      );
    }

    if (data.type == 'YWatermarkAltitude') {
      if (data.showType == 1) {
        return YWatermarkAltitudeSeparate(
          watermarkData: data,
          resource: resource,
        );
      } else {
        return YWatermarkAltitudeNew(
          watermarkData: data,
          resource: resource,
        );
      }
    }

    if (data.type == 'RYWatermarkLocation') {
      if (data.showType == 1) {
        return RyWatermarkLocationBox(
          watermarkData: data,
          resource: resource,
        );
      } else if (data.showType == 2) {
        // title 和 content 分为两列，title两段对齐
        return YWatermarLoactionSeparate(
          watermarkData: data,
          resource: resource,
        );
      } else {
        //普通展示 - 直接一行字符串展示，没有加任何的样式
        return RyWatermarkLocationBoxNew(
          watermarkData: data,
          resource: resource,
        );
      }
    }

    if (data.type == 'YWatermarkWeather') {
      if (data.showType == 1) {
        return YWatermarWatherSeparate(
          watermarkData: data,
          resource: resource,
        );
      } else {
        if (resource.id == 1698317868899 || resource.id == 1698049354422) {
          return YWatermarWatherSeparate1698317868899(
            watermarkData: data,
            resource: resource,
          );
        }
        return RyWatermarkWeather(
          watermarkData: data,
          resource: resource,
        );
      }
    }
    if (data.type == 'YWatermarkCoordinate') {
      // print("xiaojianjian tableItem ${data.coordinateType}");
      if (data.coordinateType == 2) {
        //统一展示
        // print("xiaojianjian 统一展示 tableItem ${data.coordinateType}");
        return YWatermarkCoordinate(
          watermarkData: data,
          resource: resource,
          watermarkView: watermarkView,
        );
      } else if (data.coordinateType == 3) {
        //统一展示title按两段对齐
        return YWatermarkCoordinateShow1Separate(
          watermarkData: data,
          resource: resource,
        );
      } else if (data.coordinateType == 4) {
        //分行展示title按两段对齐
        return YWatermarkCoordinateShow1TwoDeiv(
          watermarkData: data,
          resource: resource,
        );
      } else {
        //title不是端对齐对齐
        return YWatermarkCoordinateShow1(
          watermarkData: data,
          resource: resource,
        );
      }
    }

    //这里增加一个选项普通的表格
    if (data.type == watermarkTableGeneralType) {
      if (data.showType == 1) {
        //新建一种Gereral --- title 和 content 分开, 同时title是占满格子大小
        return YWatermarTableGeneralSeparate(
          watermarkData: data,
          resource: resource,
          tableKey: tableKey,
        );
      }
      return YWatermarTableGeneral(
        watermarkData: data,
        resource: resource,
      );
    }

    if (data.type == 'YWatermarkNotes') {
      return YWatermarkNotes(
        watermarkData: data,
        resource: resource,
      );
    }

    if (data.type == 'RYWatermarkTime') {
      if (data.timeType == 9) {
        return RYWatermarkTimeWithSeconds(
          watermarkData: data,
          resource: resource,
        );
      }
      if (data.timeType == 0) {
        return RYWatermarkTime0(
          watermarkData: data,
          resource: resource,
        );
      }
      if (data.timeType == 2) {
        return RYWatermarkTime2(
          watermarkData: data,
          resource: resource,
        );
      }
      if (data.timeType == 8) {
        return RYWatermarkTime8(
          resource: resource,
          watermarkData: data,
        );
      }
      if (data.timeType == 3) {
        return RYWatermarkTime3(
          watermarkData: data,
          resource: resource,
        );
      }
      if (data.timeType == 11) {
        return RYWatermarkTime11(
          resource: resource,
          watermarkData: data,
        );
      }
      if (data.timeType == 12) {
        return RYWatermarkTimeTitleSeparate(
          resource: resource,
          watermarkData: data,
        );
      }
    }
    return const SizedBox.shrink();
  }

  BoxDecoration getDecoration(WatermarkView watermarkView) {
    final bodyStyle = watermarkView.style;
    final signLine = watermarkView.signLine;

    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;

    final gradients = bodyStyle?.gradient;
    final color1 = bodyStyle?.gradient?.colors?[0];
    final color2 = bodyStyle?.gradient?.colors?[0];

    if (bodyStyle?.backgroundColor == null ||
        bodyStyle?.backgroundColor?.alpha == 0) {
      return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color1?.color?.hexToColor(color1.alpha?.toDouble()) ??
                  Colors.transparent,
              color2?.color?.hexToColor(color2.alpha?.toDouble()) ??
                  Colors.transparent
            ],
            stops: [gradients?.from?["y"] ?? 0.0, gradients?.to?["y"] ?? 0.0],
          ),
          borderRadius:
              BorderRadius.circular(bodyStyle?.radius?.toDouble().r ?? 0),
          border: Border(
              left: BorderSide(
                  color: signlineStyle?.backgroundColor?.color?.hexToColor(
                          signlineStyle.backgroundColor?.alpha?.toDouble()) ??
                      Colors.transparent,
                  width: signlineFrame?.width ?? 0,
                  style: ((signlineFrame?.width == null) ||
                          (signlineFrame?.width == 0))
                      ? BorderStyle.none
                      : BorderStyle.solid)));
    }
    return BoxDecoration(
        color: bodyStyle?.backgroundColor?.color
                ?.hexToColor(bodyStyle.backgroundColor?.alpha?.toDouble()) ??
            Colors.transparent,
        borderRadius:
            BorderRadius.circular(bodyStyle?.radius?.toDouble().r ?? 0),
        border: Border(
            left: BorderSide(
                color: signlineStyle?.backgroundColor?.color?.hexToColor(
                        signlineStyle.backgroundColor?.alpha?.toDouble()) ??
                    Colors.transparent,
                width: signlineFrame?.width ?? 0,
                style: ((signlineFrame?.width == null) ||
                        (signlineFrame?.width == 0))
                    ? BorderStyle.none
                    : BorderStyle.solid)));
  }

// 两个水印特殊处理：templateId == 1698049443671 || templateId == 1698049553311
// 得到第一行元素
  Widget getFirstRow(WatermarkView watermarkView) {
    final bodyData = watermarkView.data;
    Widget firstRow = const Row(
      children: [],
    );
    if (bodyData!.length >= 3 &&
        (templateId == 1698049443671 || templateId == 1698049553311)) {
      // 分离出前两个元素
      final List<Widget> firstTwoWidgets = bodyData
          .take(templateId == 1698049443671 ? 3 : 2)
          .map((item) => WatermarkDataDynamic(
                watermarkView: watermarkView,
                watermarkData: item,
                resource: resource, // 假设这里使用相同的templateId
              ))
          .toList();

      // 否则，将前两个元素放在Row中，并将剩余的元素作为单独的Widget处理
      firstRow = Row(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: firstTwoWidgets,
      );
    }
    return firstRow;
  }

// 将剩余的元素作为单独的Widget处理
  List<Widget> getRemainWidget(WatermarkView watermarkView) {
    List<Widget> remainingWidgets = [];
    final bodyData = watermarkView.data;
    if (bodyData!.length >= 3 &&
        (templateId == 1698049443671 || templateId == 1698049553311)) {
      remainingWidgets = bodyData
          .skip(templateId == 1698049443671 ? 3 : 2) // 跳过前两个元素
          .map((item) => WatermarkDataDynamic(
                watermarkView: watermarkView,
                watermarkData: item,
                resource: resource,
              ))
          .toList();
    }
    return remainingWidgets;
    // }
  }
}
