import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/location_builder.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import 'package:watermark_camera/utils/weather.dart';
import 'WatermarkFrame.dart';
import 'WatermarkMark.dart';

class RyWatermarkWeather extends StatelessWidget {
  final WatermarkData watermarkData;
  const RyWatermarkWeather({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int templateId = context.read<WatermarkCubit>().watermarkId;
    final template = context
        .read<ResourceCubit>()
        .templates
        .firstWhereOrNull((e) => e.id == templateId);
    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final font = dataStyle?.fonts?['font'];
    final font2 = dataStyle?.fonts?['font2'];
    final font3 = dataStyle?.fonts?['font3'];
    final mark = watermarkData.mark;
    final title_visible = watermarkData.isWithTitle;

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: readImage(templateId.toString(), watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = dataStyle?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right: layout?.imageTitleSpace ?? 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble() ?? 0,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return LocationViewBuilder(builder: (context, snapshot) {
      final location = snapshot.location;
      final liveData = snapshot.weather;
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
                  imageWidget ?? const SizedBox.shrink(),
                  Visibility(
                    visible: title_visible ?? false,
                    child: Text(
                      "${watermarkData.title}：",
                      style: TextStyle(
                        color: dataStyle?.textColor?.color?.hexToColor(
                            dataStyle.textColor?.alpha?.toDouble()),
                        fontSize: dataStyle?.fonts?['font']?.size,
                        fontFamily: dataStyle?.fonts?['font']?.name,
                        // height: 1
                      ),
                    ),
                  ),
                  template?.id == 16983178686921
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              // '20~37℃',
                              watermarkData.content == null ||
                                      watermarkData.content == ''
                                  ? "${liveData?['temperature']}°"
                                  : watermarkData.content ?? '',
                              style: TextStyle(
                                  fontSize: font?.size,
                                  fontFamily: font?.name,
                                  color: dataStyle?.textColor?.color
                                      ?.hexToColor(dataStyle.textColor?.alpha
                                          ?.toDouble()),
                                  height: 1),
                            ),
                            Text(
                              watermarkData.content == null ||
                                      watermarkData.content == ''
                                  ? "${liveData?['weather']}"
                                  : watermarkData.content ?? '',
                              style: TextStyle(
                                  fontSize: font2?.size,
                                  fontFamily: font2?.name,
                                  color: dataStyle?.textColor?.color
                                      ?.hexToColor(dataStyle.textColor?.alpha
                                          ?.toDouble()),
                                  height: 2),
                            ),
                          ],
                        )
                      : Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                watermarkData.content == null ||
                                        watermarkData.content == ''
                                    ? "${liveData?['weather']} ${liveData?['temperature']}℃"
                                    : watermarkData.content ?? '',
                                style: TextStyle(
                                    fontSize: template?.id == 1698049285310 ||
                                            template?.id == 1698049285500
                                        ? font3?.size
                                        : font?.size,
                                    fontFamily: template?.id == 1698049285310 ||
                                            template?.id == 1698049285500
                                        ? font3?.name
                                        : font?.name,
                                    color: template?.id == 16982153599988
                                        ? Colors.black
                                        : dataStyle?.textColor?.color
                                            ?.hexToColor(dataStyle
                                                .textColor?.alpha
                                                ?.toDouble()),
                                    height: 1),

                                // maxLines: 3,
                                softWrap: true,
                              ),
                              template?.id == 16982153599988 ||
                                      template?.id == 16982153599999
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
                        ),
                ],
              ))
        ],
      );
    });
  }
}
