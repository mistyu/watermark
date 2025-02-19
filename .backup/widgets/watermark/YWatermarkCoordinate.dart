import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit/location_builder.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import 'RYWatermarkTime.dart';
import 'WatermarkFrame.dart';
import 'WatermarkMark.dart';

class YWatermarkCoordinate extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkCoordinate({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;

    final dataFrame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final title_visible = watermarkData.isWithTitle;
    final content = watermarkData.content;
    final mark = watermarkData.mark;
    final isSplit = watermarkData.isSplit;
    final signLine = watermarkData.signLine;
    final signline_style = signLine?.style;
    final signline_frame = signLine?.frame;

    String editLongitude = '';
    String editLatitude = '';
    if (content != null && content != '') {
      List<String> parts = content.split(',');
      editLongitude = parts[0];
      editLatitude = parts[1];
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
                    width: dataStyle?.iconWidth?.toDouble() ?? 0,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }
    return LocationViewBuilder(
      builder: (context, state) {
        final longitude = state.longitude;
        final latitude = state.latitude;
        if ((longitude == null || longitude == '') ||
            (latitude == null || latitude == '')) {
          return Text(
            '未获取到经纬度',
            style: TextStyle(
              color: dataStyle?.textColor?.color
                  ?.hexToColor(dataStyle.textColor?.alpha?.toDouble()),
              fontSize: dataStyle?.fonts?['font']?.size,
              fontFamily: dataStyle?.fonts?['font']?.name,
              // height: 1
            ),
          );
        }

        return Stack(
          alignment: Alignment.topLeft,
          children: [
            mark != null
                ? WatermarkMarkBox(
                    mark: mark,
                  )
                : const SizedBox.shrink(),
            isSplit ?? false
                ? Column(
                    children: [
                      WatermarkFrameBox(
                        watermarkData: watermarkData,
                        style: dataStyle,
                        frame: dataFrame,
                        child: Row(
                          children: [
                            Visibility(
                              visible: title_visible ?? false,
                              child: Text(
                                watermarkId == 1698049443671
                                    ? "经度 "
                                    : (watermarkId == 16983971077788 ||
                                            watermarkId == 16983971079955 ||
                                            watermarkView?.viewType ==
                                                'RYViewTypeFour'
                                        ? "经\u3000\u3000度："
                                        : "经度："),
                                softWrap: true,
                                style: TextStyle(
                                  color: dataStyle?.textColor?.color
                                      ?.hexToColor(dataStyle.textColor?.alpha
                                          ?.toDouble()),
                                  fontSize: dataStyle?.fonts?['font']?.size,
                                  fontFamily: dataStyle?.fonts?['font']?.name,
                                  // height: 1
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    watermarkData.content != null &&
                                            watermarkData.content != ''
                                        ? editLongitude
                                        : longitude.toString(),
                                    softWrap: true,
                                    style: TextStyle(
                                      color: watermarkId == 16982153599988
                                          ? Colors.black
                                          : dataStyle?.textColor?.color
                                              ?.hexToColor(dataStyle
                                                  .textColor?.alpha
                                                  ?.toDouble()),
                                      fontSize: dataStyle?.fonts?['font']?.size,
                                      fontFamily:
                                          // "HarmonyOS_Sans"
                                          // "Wechat_regular"
                                          dataStyle?.fonts?['font']?.name,
                                      // height: 1
                                    ),
                                  ),
                                  watermarkId == 16982153599988
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
                      WatermarkFrameBox(
                        style: dataStyle,
                        frame: dataFrame,
                        watermarkData: watermarkData,
                        child: Row(
                          children: [
                            Visibility(
                                visible: title_visible ?? false,
                                child: WatermarkTimeTypeFont(
                                  text: watermarkId == 1698049443671
                                      ? "纬度 "
                                      : (watermarkId == 16983971077788 ||
                                              watermarkId == 16983971079955||
                                            watermarkView?.viewType ==
                                                'RYViewTypeFour'
                                          ? "纬\u3000\u3000度："
                                          : "纬度："),
                                  font: dataStyle?.fonts?['font'],
                                  textColor: dataStyle?.textColor,
                                )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    watermarkData.content != null &&
                                            watermarkData.content != ''
                                        ? editLatitude
                                        : latitude.toString(),
                                    softWrap: true,
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
                                        height: 1),
                                  ),
                                  watermarkId == 16982153599988
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
                  )
                : WatermarkFrameBox(
                    style: dataStyle,
                    frame: dataFrame,
                    watermarkData: watermarkData,
                    child: Row(
                      children: [
                        imageWidget ?? const SizedBox.shrink(),
                        Expanded(
                          child: Row(
                            children: [
                              Visibility(
                                visible: title_visible ?? false,
                                child: Text(
                                  watermarkId == 1698059986262
                                      ? "${watermarkData.title}"
                                      : "${watermarkData.title}：",
                                  style: TextStyle(
                                    color: dataStyle?.textColor?.color
                                        ?.hexToColor(dataStyle.textColor?.alpha
                                            ?.toDouble()),
                                    fontSize: dataStyle?.fonts?['font']?.size,
                                    fontFamily: dataStyle?.fonts?['font']?.name,
                                    // height: 1
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      watermarkId == 1698049761079 ||
                                              watermarkId == 1698049776444
                                          ? CrossAxisAlignment.center
                                          : CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    watermarkId == 1698059986262
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
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
                                              //   watermarkData.content != null &&
                                              watermarkData.content != ''
                                                  ? watermarkData.content ?? ''
                                                  : '${latitude.toString()}°N,${longitude.toString()}°E',
                                              softWrap: true,
                                              style: TextStyle(
                                                color: watermarkId ==
                                                        16982153599988
                                                    ? Colors.black
                                                    : dataStyle
                                                        ?.textColor?.color
                                                        ?.hexToColor(dataStyle
                                                            .textColor?.alpha
                                                            ?.toDouble()),
                                                fontSize: dataStyle
                                                    ?.fonts?['font']?.size,
                                                fontFamily: dataStyle
                                                    ?.fonts?['font']?.name,
                                                // height: 1
                                              ),
                                              textAlign: watermarkView
                                                          ?.frame?.isCenterX ??
                                                      false
                                                  ? TextAlign.center
                                                  : TextAlign.start,
                                              // maxLines: 3,
                                              // softWrap: true,
                                            ),
                                          )
                                        : Text(
                                            watermarkData.content != null &&
                                                    watermarkData.content != ''
                                                ? watermarkData.content ?? ''
                                                : '${latitude.toString()}°N,${longitude.toString()}°E',
                                            softWrap: true,
                                            style: TextStyle(
                                              color: watermarkId ==
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
                                              // height: 1
                                            ),
                                            textAlign: watermarkView
                                                        ?.frame?.isCenterX ??
                                                    false
                                                ? TextAlign.center
                                                : TextAlign.start,
                                            // maxLines: 3,
                                            // softWrap: true,
                                          ),
                                    watermarkId == 16982153599988 ||
                                            watermarkId == 16982153599999
                                        ? Container(
                                            height: 1,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: dataStyle
                                                    ?.textColor?.color
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
                    ),
                  ),
          ],
        );
      },
    );
  }
}

// class YWatermarkLongitude extends StatelessWidget {
//   final WatermarkData watermarkData;
//   const YWatermarkLongitude({super.key, required this.watermarkData});

//   @override
//   Widget build(BuildContext context) {
//     int watermarkId = context.read<WatermarkCubit>().watermarkId;
//     final dataFrame = watermarkData.frame;
//     final dataStyle = watermarkData.style;
//     final title_visible = watermarkData.isWithTitle;
//     // final longitude = '139.0000';

//     return LocationViewBuilder(builder: (context, snap) {
//       final longitude = snap.location?['longitude'];
//       return WatermarkFrameBox(
//         style: dataStyle,
//         frame: dataFrame,
//         child: Row(
//           children: [
//             Visibility(
//               visible: title_visible ?? false,
//               child: Text(
//                 "${watermarkData.title}：",
//                 softWrap: true,
//                 style: TextStyle(
//                   color: dataStyle?.textColor?.color
//                       ?.hexToColor(dataStyle.textColor?.alpha?.toDouble()),
//                   fontSize: dataStyle?.fonts?['font']?.size,
//                   fontFamily: dataStyle?.fonts?['font']?.name,
//                   // height: 1
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     watermarkData.content != null && watermarkData.content != ''
//                         ? watermarkData.content ?? ''
//                         : longitude.toString(),
//                     softWrap: true,
//                     style: TextStyle(
//                       color: watermarkId == 16982153599988
//                           ? Colors.black
//                           : dataStyle?.textColor?.color?.hexToColor(
//                               dataStyle.textColor?.alpha?.toDouble()),
//                       fontSize: dataStyle?.fonts?['font']?.size,
//                       fontFamily: dataStyle?.fonts?['font']?.name,
//                       // height: 1
//                     ),
//                   ),
//                   watermarkId == 16982153599988
//                       ? Container(
//                           height: 1,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: dataStyle?.textColor?.color?.hexToColor(
//                                   dataStyle.textColor?.alpha?.toDouble())),
//                         )
//                       : const SizedBox.shrink(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class YWatermarkLatitude extends StatelessWidget {
//   final WatermarkData watermarkData;
//   const YWatermarkLatitude({super.key, required this.watermarkData});

//   @override
//   Widget build(BuildContext context) {
//     int watermarkId = context.read<WatermarkCubit>().watermarkId;
//     final dataFrame = watermarkData.frame;
//     final dataStyle = watermarkData.style;
//     final title_visible = watermarkData.isWithTitle;
//     // final latitude = '139.0000';

//     return LocationViewBuilder(builder: (context, snap) {
//       final latitude = snap.latitude;
//       return WatermarkFrameBox(
//         style: dataStyle,
//         frame: dataFrame,
//         child: Row(
//           children: [
//             Visibility(
//                 visible: title_visible ?? false,
//                 child: WatermarkTimeTypeFont(
//                   text: "${watermarkData.title}：",
//                   font: dataStyle?.fonts?['font'],
//                   textColor: dataStyle?.textColor,
//                 )),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     watermarkData.content != null && watermarkData.content != ''
//                         ? watermarkData.content ?? ''
//                         : latitude.toString(),
//                     softWrap: true,
//                     style: TextStyle(
//                         color: watermarkId == 16982153599988
//                             ? Colors.black
//                             : dataStyle?.textColor?.color?.hexToColor(
//                                 dataStyle.textColor?.alpha?.toDouble()),
//                         fontSize: dataStyle?.fonts?['font']?.size,
//                         fontFamily: dataStyle?.fonts?['font']?.name,
//                         height: 1),
//                   ),
//                   watermarkId == 16982153599988
//                       ? Container(
//                           height: 1,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               color: dataStyle?.textColor?.color?.hexToColor(
//                                   dataStyle.textColor?.alpha?.toDouble())),
//                         )
//                       : const SizedBox.shrink(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
