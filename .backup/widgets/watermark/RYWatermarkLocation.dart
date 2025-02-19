import 'dart:io';
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/location_builder.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'RYWatermarkTime.dart';
import 'WatermarkFrame.dart';
import 'WatermarkMark.dart';
import '../../../lib/utils/watermark.dart';

class RyWatermarkLocationBox extends StatelessWidget {
  final WatermarkData watermarkData;
  const RyWatermarkLocationBox({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;

    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final mark = watermarkData.mark;
    final signLine = watermarkData.signLine;
    final title_visible = watermarkData.isWithTitle;
    final signline_style = signLine?.style;
    final signline_frame = signLine?.frame;

    // final markFrame = mark?.frame;
    // if (mark != null && dataFrame != null && markFrame != null) {
    //   if (dataFrame.left != null &&
    //       markFrame.left != null &&
    //       markFrame.width != null) {
    //     dataFrame.left = (dataFrame.left! - markFrame.left! - markFrame.width!).abs();
    //   }
    // }

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
                    width: dataStyle?.iconWidth?.toDouble() ?? 0,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return LocationViewBuilder(builder: (context, snapshot) {
      final location1=snapshot.location?['formatted_address'];
      final location = snapshot.location?['addressComponent'];
      // print("location:${snapshot.location}");
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
              signLine: signLine,
              watermarkData: watermarkData,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageWidget ?? const SizedBox.shrink(),
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
                              // height: 1
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: watermarkId == 1698049761079 ||
                                    watermarkId == 1698049776444
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              watermarkId == 1698059986262
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
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
                                                  width:
                                                      signline_frame?.width ??
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
                                        watermarkData.content == null ||
                                                watermarkData.content == ''
                                            ? location1
                                            // "${location['city'].toString()}·${location['district'].toString()}${location['township'].toString()}"
                                            : watermarkData.content ?? '',
                                        style: TextStyle(
                                          color: watermarkId == 16982153599988
                                              ? Colors.black
                                              : dataStyle?.textColor?.color
                                                  ?.hexToColor(dataStyle
                                                      .textColor?.alpha
                                                      ?.toDouble()),
                                          fontSize:
                                              dataStyle?.fonts?['font']?.size,
                                          fontFamily:
                                              dataStyle?.fonts?['font']?.name,
                                          // height: 1
                                        ),
                                        textAlign:
                                            watermarkView?.frame?.isCenterX ??
                                                    false
                                                ? TextAlign.center
                                                : TextAlign.start,
                                        // maxLines: 3,
                                        softWrap: true,
                                      ),
                                    )
                                  : Text(
                                      watermarkData.content == null ||
                                              watermarkData.content == ''
                                          ? location1
                                          // "${location['city'].toString()}·${location['district'].toString()}${location['township'].toString()}"
                                          : watermarkData.content ?? '',
                                      style: TextStyle(
                                        color: watermarkId == 16982153599988
                                            ? Colors.black
                                            : dataStyle?.textColor?.color
                                                ?.hexToColor(dataStyle
                                                    .textColor?.alpha
                                                    ?.toDouble()),
                                        fontSize:
                                            dataStyle?.fonts?['font']?.size,
                                        fontFamily:
                                            dataStyle?.fonts?['font']?.name,
                                        // height: 1
                                      ),
                                      textAlign:
                                          watermarkView?.frame?.isCenterX ??
                                                  false
                                              ? TextAlign.center
                                              : TextAlign.start,
                                      // maxLines: 3,
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
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      );
    });
  }
}
