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

class YWatermarkNotes extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkNotes({super.key, required this.watermarkData});

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
        WatermarkFrameBox(
          frame: dataFrame,
          style: dataStyle,
          child: Row(
            children: [
              imageWidget,
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
                    Visibility(
                      visible: title_visible ?? false,
                      child: Text(
                        watermarkId == 1698059986262
                            ? "${watermarkData.title}"
                            : "${watermarkData.title}：",
                        style: TextStyle(
                            color: dataStyle?.textColor?.color?.hexToColor(
                                dataStyle.textColor?.alpha?.toDouble()),
                            fontSize: dataStyle?.fonts?['font']?.size,
                            fontFamily: dataStyle?.fonts?['font']?.name,
                            height: watermarkId == 1698059986262 ? 2.5 : 1.5),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          watermarkId == 1698059986262
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: signline_style
                                                      ?.backgroundColor?.color
                                                      ?.hexToColor(
                                                          signline_style
                                                              .backgroundColor
                                                              ?.alpha
                                                              ?.toDouble()) ??
                                                  Colors.transparent,
                                              width: signline_frame?.width ?? 0,
                                              style: ((signline_frame?.width ==
                                                          null) ||
                                                      (signline_frame?.width ==
                                                          0))
                                                  ? BorderStyle.none
                                                  : BorderStyle.solid))),
                                  child: Text(
                                    watermarkData.content ?? '',
                                    style: TextStyle(
                                        color: template?.id == 16982153599988
                                            ? Colors.black
                                            : dataStyle?.textColor?.color
                                                ?.hexToColor(dataStyle
                                                    .textColor?.alpha
                                                    ?.toDouble()),
                                        fontSize:
                                            dataStyle?.fonts?['font']?.size,
                                        fontFamily:
                                            dataStyle?.fonts?['font']?.name,
                                        height: watermarkId == 1698059986262
                                            ? 2.5
                                            : 1.5),
                                    softWrap: true,
                                  ),
                                )
                              : Text(
                                  watermarkData.content ?? '',
                                  style: TextStyle(
                                    color: template?.id == 16982153599988
                                        ? Colors.black
                                        : dataStyle?.textColor?.color
                                            ?.hexToColor(dataStyle
                                                .textColor?.alpha
                                                ?.toDouble()),
                                    fontSize: dataStyle?.fonts?['font']?.size,
                                    fontFamily: dataStyle?.fonts?['font']?.name,
                                    // height: 1
                                  ),
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
      ],
    );
  }
}
