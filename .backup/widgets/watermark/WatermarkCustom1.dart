import 'dart:io';

import 'package:collection/collection.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/resource_cubit.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import 'WatermarkFont.dart';
import 'WatermarkFrame.dart';
import 'WatermarkMark.dart';

import '../../bloc/cubit/watermark_cubit.dart';

class WatermarkCustom1Box extends StatelessWidget {
  final WatermarkData watermarkData;
  const WatermarkCustom1Box({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    final template = context
        .read<ResourceCubit>()
        .templates
        .firstWhereOrNull((e) => e.id == watermarkId);
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final mark = watermarkData.mark;
    final title_visible = watermarkData.isWithTitle;

    final signLine = watermarkData.signLine;
    final signline_style = signLine?.style;
    final signline_frame = signLine?.frame;
    final bgImg = watermarkData.background;
    // final markFrame = mark?.frame;
    // if (mark != null && dataFrame != null && markFrame != null) {
    //   if (dataFrame.left != null &&
    //       markFrame.left != null &&
    //       markFrame.width != null) {
    //     dataFrame.left = dataFrame.left! - markFrame.left! - markFrame.width!;
    //   }
    // }

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
          future: readImage(watermarkId.toString(), item.image),
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

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        mark != null
            ? WatermarkMarkBox(
                mark: mark,
              )
            : const SizedBox.shrink(),
        FutureBuilder(
            future: readImage(watermarkId.toString(), bgImg),
            builder: (context, snapshot) {
              return WatermarkFrameBox(
                frame: dataFrame,
                style: dataStyle,
                watermarkData: watermarkData,
                imagePath: template?.cid == 3 ? null : snapshot.data,
                child: Container(
                  decoration: BoxDecoration(
                      border: watermarkId == 1698059986262
                          ? Border.all(
                              color: dataStyle?.textColor?.color?.hexToColor(
                                      dataStyle.textColor?.alpha?.toDouble()) ??
                                  Colors.transparent,
                              width: 2)
                          : null),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageWidget ?? const SizedBox.shrink(),
                      ...richTextWidgets,
                      Expanded(
                        child: Row(
                          // mainAxisAlignment:
                          //     // WrapAlignment.center,
                          //     watermarkView?.frame?.isCenterX ?? false
                          //         ? MainAxisAlignment.center
                          //         : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: watermarkId == 1698059986262
                                  ? EdgeInsets.symmetric(horizontal: 3)
                                  : EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                color: watermarkId == 1698059986262
                                    ? dataStyle?.textColor?.color?.hexToColor(
                                        dataStyle.textColor?.alpha?.toDouble())
                                    : Colors.transparent,
                              ),
                              child: Visibility(
                                visible: title_visible ?? false,
                                child: Text(
                                  watermarkId == 1698059986262
                                      ? "${watermarkData.title}"
                                      : "${watermarkData.title}：",
                                  style: TextStyle(
                                    color: watermarkId == 1698059986262
                                        ? Colors.white
                                        : dataStyle?.textColor?.color
                                            ?.hexToColor(dataStyle
                                                .textColor?.alpha
                                                ?.toDouble()),
                                    fontSize: dataStyle?.fonts?['font']?.size,
                                    fontFamily: dataStyle?.fonts?['font']?.name,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    watermarkData.title == '打卡标题'
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.start,
                                mainAxisAlignment: watermarkData.title == '打卡标题'
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.start,
                                children: [
                                  watermarkId == 1698059986262
                                      ? Container(
                                          padding: watermarkId == 1698059986262
                                              ? EdgeInsets.symmetric(
                                                  horizontal: 3)
                                              : EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border(
                                                  left: BorderSide(
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
                                          child: Text(
                                            watermarkData.content ?? '',
                                            style: TextStyle(
                                              color: template?.id ==
                                                      16982153599988
                                                  ? Colors.black
                                                  : dataStyle?.textColor?.color
                                                      ?.hexToColor(dataStyle
                                                          .textColor?.alpha
                                                          ?.toDouble()),
                                              fontSize: dataStyle
                                                  ?.fonts?['font']?.size,
                                              fontFamily: dataStyle
                                                  ?.fonts?['font']?.name,
                                            ),
                                            softWrap: true,
                                          ),
                                        )
                                      : Text(
                                          watermarkData.content ?? '',
                                          style: TextStyle(
                                              color: template?.id ==
                                                      16982153599988
                                                  ? Colors.black
                                                  : dataStyle?.textColor?.color
                                                      ?.hexToColor(dataStyle
                                                          .textColor?.alpha
                                                          ?.toDouble()),
                                              fontSize: dataStyle
                                                  ?.fonts?['font']?.size,
                                              fontFamily:
                                                  // 'YouSheBiaoTiHei'
                                                  dataStyle
                                                      ?.fonts?['font']?.name,
                                              height: 1),
                                          softWrap: true,
                                        ),
                                  watermarkId == 16982153599988 ||
                                          watermarkId == 16982153599999
                                      ? Container(
                                          height: 1,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: dataStyle?.textColor?.color
                                                  ?.hexToColor(dataStyle
                                                      .textColor?.alpha
                                                      ?.toDouble())),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      ...endWidgets,
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
