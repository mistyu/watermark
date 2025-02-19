import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import '../watermark/RYWatermarkLocation.dart';
import '../watermark/RYWatermarkTime.dart';
import '../watermark/RyWatermarkWeather.dart';
import '../watermark/WatermarkCustom1.dart';
import '../watermark/WatermarkDataDynamic.dart';
import '../watermark/WatermarkFrame.dart';
import '../watermark/YWatermarkCoordinate.dart';
import '../watermark/YWatermarkNotes.dart';

class WatermarkContent extends StatefulWidget {
  final WatermarkView? watermarkView;
  final Template? template;
  const WatermarkContent({super.key, this.watermarkView, this.template});

  @override
  State<WatermarkContent> createState() => _WatermarkContentState();
}

class _WatermarkContentState extends State<WatermarkContent> {
  final GlobalKey containerKey = GlobalKey();
  Template? _template;

  @override
  void initState() {
    _template = widget.template;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_template != null) {
      // final watermarkView = viewState.watermarkView;
      final watermarkView = widget.watermarkView;
      if (watermarkView != null) {
        final boxFrame = watermarkView.frame;
        final bodyData = watermarkView.data;
        final bodyStyle = watermarkView.style;
        final signLine = watermarkView.signLine;

        final signline_style = signLine?.style;
        final signline_frame = signLine?.frame;

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

        if (_template!.id == 1698049443671 || _template!.id == 1698059986262) {
          direction = Axis.horizontal;
        }

        final decortaion = _template!.cid == 4 &&
                    _template!.id != 16986607549321 &&
                    _template!.id != 16982153599988 &&
                    _template!.id != 16982153599999 ||
                _template!.id == 16983971079955 ||
                _template!.id == 16983971077788
            ? BoxDecoration(
                borderRadius:
                    BorderRadius.circular(bodyStyle?.radius?.toDouble() ?? 0),
                border: Border(
                  left: BorderSide(
                      color: signline_style?.backgroundColor?.color?.hexToColor(
                              signline_style.backgroundColor?.alpha
                                  ?.toDouble()) ??
                          Colors.transparent,
                      width: signline_frame?.width ?? 0,
                      style: ((signline_frame?.width == null) ||
                              (signline_frame?.width == 0))
                          ? BorderStyle.none
                          : BorderStyle.solid),
                ))
            : getDecoration(watermarkView);

        Widget firstRow = const Row(
          children: [SizedBox.shrink()],
        );
        List<Widget> remainingWidgets = [const SizedBox.shrink()];
        if (bodyData!.length >= 3 &&
            (_template!.id == 1698049443671 ||
                _template!.id == 1698049553311)) {
          // 分离出前两个元素
          final List<Widget> firstTwoWidgets = bodyData
              .take(_template!.id == 1698049443671 ? 3 : 2)
              .map((item) => WatermarkDataDynamic(
                    watermarkData: item,
                    templateId:
                        _template!.id ?? 1698049557635, // 假设这里使用相同的templateId
                  ))
              .toList();

          // 如果只有两个或更少元素，则直接将它们包裹在Row中
          if (firstTwoWidgets.length == bodyData.length) {
            return Row(
              children: firstTwoWidgets,
            );
          }

          // 否则，将前两个元素放在Row中，并将剩余的元素作为单独的Widget处理
          firstRow = Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: firstTwoWidgets,
          );

          remainingWidgets = bodyData
              .skip(_template!.id == 1698049443671 ? 3 : 2) // 跳过前两个元素
              .map((item) => WatermarkDataDynamic(
                    watermarkData: item,
                    templateId:
                        _template!.id ?? 1698049557635, // 假设这里使用相同的templateId
                  ))
              .toList();
        }
        List<Widget> watermarkDataDynamic = bodyData
            .skipWhile((item) {
              return item.type == 'RYWatermarkLiveShooting';
            })
            .map((item) => WatermarkDataDynamic(
                  watermarkData: item,
                  templateId: _template!.id ?? 1698049557635,
                ))
            .toList();
        return Container(
          key: containerKey,
          decoration: _template!.id == 1698059986262
              ? BoxDecoration(
                  color: bodyStyle?.backgroundColor?.color?.hexToColor(
                          bodyStyle.backgroundColor?.alpha?.toDouble()) ??
                      Colors.transparent,
                )
              : decortaion,
          width: (boxFrame?.width ?? 0) <= 0
              ? boxAlignment == Alignment.bottomCenter
                  ? 1.sw
                  : null
              : boxFrame?.width?.toDouble(),
          child: Align(
            alignment: boxAlignment,
            child: ClipRRect(
              borderRadius: decortaion.borderRadius ?? BorderRadius.zero,
              child: _template!.id == 16982893664516
                  ? Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        _template!.cid! >= 3
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
                          children: tableWidget(watermarkView.tables, _template)
                                  ?.toList() ??
                              [const SizedBox.shrink()],
                        ),
                      ],
                    )
                  : _template!.id == 1698049451122
                      ? Row(
                          children: [
                            Column(
                              children: watermarkDataDynamic,
                            ),
                            Expanded(
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...tableWidget(
                                          watermarkView.tables, _template) ??
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
                            _template!.cid! >= 3
                                ? (_template!.id == 1698049443671 ||
                                        _template!.id == 1698049553311)
                                    ? Column(children: [
                                        firstRow,
                                        FutureBuilder(
                                            future: readImage(
                                                _template!.id.toString(),
                                                "ryMould_tag"),
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
                                        ...remainingWidgets,
                                      ])
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                signline_style?.padding?.left ??
                                                    0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: signline_style
                                                            ?.backgroundColor
                                                            ?.color
                                                            ?.hexToColor(signline_style
                                                                .backgroundColor
                                                                ?.alpha
                                                                ?.toDouble()) ??
                                                        Colors.transparent,
                                                    width: signline_frame?.width ??
                                                        0,
                                                    style: ((signline_frame
                                                                    ?.width ==
                                                                null) ||
                                                            (signline_frame
                                                                    ?.width ==
                                                                0))
                                                        ? BorderStyle.none
                                                        : BorderStyle.solid))),
                                        child: _template!.id == 1698215359120
                                            ? Stack(
                                                alignment:
                                                    Alignment.centerRight,
                                                children: watermarkDataDynamic,
                                              )
                                            : Flex(
                                                direction: direction,
                                                mainAxisAlignment: _template!
                                                            .id ==
                                                        1698059986262
                                                    ? MainAxisAlignment
                                                        .spaceBetween
                                                    : MainAxisAlignment.center,
                                                // crossAxisAlignment: WrapCrossAlignment.center,
                                                children: watermarkDataDynamic,
                                              ),
                                      )
                                : Stack(
                                    children: watermarkDataDynamic,
                                  ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...tableWidget(
                                        watermarkView.tables, _template) ??
                                    [const SizedBox.shrink()]
                              ],
                            ),
                          ],
                        ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  List<Widget>? tableWidget(
      Map<String, WatermarkTable>? map, Template? _template) {
    return map?.entries.map((entry) {
      final frame = entry.value.frame;
      final boxStyle = entry.value.style;
      final tableData = entry.value.data ?? [];
      final signline = entry.value.signLine;

      bool isHidden(key) => key.isHidden == false;

      return Visibility(
          visible: tableData.any(isHidden),
          child: WatermarkFrameBox(
            frame: frame,
            style: boxStyle,
            signLine: signline,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tableData.where((e) => e.isHidden == false).map((data) {
                if (data.type == 'YWatermarkCustom1') {
                  return WatermarkCustom1Box(
                    watermarkData: data,
                  );
                }

                if (data.type == 'RYWatermarkLocation') {
                  return RyWatermarkLocationBox(
                    watermarkData: data,
                  );
                }
                if (data.type == 'YWatermarkWeather') {
                  return RyWatermarkWeather(watermarkData: data);
                }
                if (data.type == 'YWatermarkCoordinate') {
                  return YWatermarkCoordinate(
                    watermarkData: data,
                  );
                }

                // if (data.type == 'YWatermarkLongitude') {
                //   return YWatermarkLongitude(
                //     watermarkData: data,
                //   );
                // }
                // if (data.type == 'YWatermarkLongitude') {
                //   return YWatermarkLongitude(
                //     watermarkData: data,
                //   );
                // }

                if (data.type == 'YWatermarkNotes') {
                  return YWatermarkNotes(
                    watermarkData: data,
                  );
                }
                if (data.type == 'RYWatermarkTime') {
                  if (data.timeType == 0) {
                    return RYWatermarkTime0(
                      watermarkData: data,
                    );
                  }
                  if (data.timeType == 2) {
                    return RYWatermarkTime2(
                      watermarkData: data,
                    );
                  }
                  if (data.timeType == 8) {
                    return RYWatermarkTime8(
                      watermarkData: data,
                    );
                  }
                  if (data.timeType == 3) {
                    return RYWatermarkTime3(
                      watermarkData: data,
                    );
                  }
                  if (data.timeType == 11) {
                    return RYWatermarkTime11(
                      watermarkData: data,
                    );
                  }
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          ));
    }).toList();
  }

  BoxDecoration getDecoration(WatermarkView watermarkView) {
    final bodyStyle = watermarkView.style;
    final signLine = watermarkView.signLine;

    final signline_style = signLine?.style;
    final signline_frame = signLine?.frame;

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
              BorderRadius.circular(bodyStyle?.radius?.toDouble() ?? 0),
          border: Border(
              left: BorderSide(
                  color: signline_style?.backgroundColor?.color?.hexToColor(
                          signline_style.backgroundColor?.alpha?.toDouble()) ??
                      Colors.transparent,
                  width: signline_frame?.width ?? 0,
                  style: ((signline_frame?.width == null) ||
                          (signline_frame?.width == 0))
                      ? BorderStyle.none
                      : BorderStyle.solid)));
    }
    return BoxDecoration(
        color: bodyStyle?.backgroundColor?.color
                ?.hexToColor(bodyStyle?.backgroundColor?.alpha?.toDouble()) ??
            Colors.transparent,
        borderRadius: BorderRadius.circular(bodyStyle?.radius?.toDouble() ?? 0),
        border: Border(
            left: BorderSide(
                color: signline_style?.backgroundColor?.color?.hexToColor(
                        signline_style.backgroundColor?.alpha?.toDouble()) ??
                    Colors.transparent,
                width: signline_frame?.width ?? 0,
                style: ((signline_frame?.width == null) ||
                        (signline_frame?.width == 0))
                    ? BorderStyle.none
                    : BorderStyle.solid)));
  }
}
