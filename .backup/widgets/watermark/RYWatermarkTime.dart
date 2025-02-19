import 'dart:io';

import 'package:collection/collection.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lunar/calendar/Lunar.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import '../camera/custom_water_mark_panel.dart';
import 'RYWatermarkLocation.dart';
import 'RyWatermarkWeather.dart';
import 'WatermarkFont.dart';
import 'WatermarkFrame.dart';

class RYWatermarkTime0 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime0({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int templateId = context.read<WatermarkCubit>().watermarkId;
    final template = context
        .read<ResourceCubit>()
        .templates
        .firstWhereOrNull((e) => e.id == templateId);
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    final frame = watermarkData.frame;
    final style = watermarkData.style;
    final titleVisible = watermarkData.isWithTitle;

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: readImage(templateId.toString(), watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = style?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right: layout?.imageTitleSpace ?? 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: style?.iconWidth?.toDouble() ?? 0,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(minutes: 1), (int count) {
              return formatDate(DateTime.now(), [hh, ':', nn]);
            }),
            builder: (context, snapshot) {
              return WatermarkFrameBox(
                frame: frame,
                style: style,
                child: Row(
                  children: [
                    imageWidget ?? const SizedBox.shrink(),
                    Visibility(
                        visible: titleVisible ?? false,
                        child: WatermarkTimeTypeFont(
                          text: "${watermarkData.title}：",
                          font: fonts?['font'],
                          textColor: textColor,
                        )),
                    WatermarkTimeTypeFont(
                      text:
                          formatDate(DateTime.now(), [yyyy, '.', mm, '.', dd]),
                      font: fonts?['font'],
                      textColor: textColor,
                    ),
                    Visibility(
                      visible: templateId == 1698049456677 ||
                          templateId == 1698049457777,
                      child: WatermarkTimeTypeFont(
                        text: formatDate(DateTime.now(), [
                          ' 星期',
                          Lunar.fromDate(DateTime.now()).getWeekInChinese()
                        ]),
                        font: fonts?['font'],
                        textColor: textColor,
                      ),
                    ),
                    WatermarkTimeTypeFont(
                      text: formatDate(DateTime.now(), [' ', hh, ':', nn]),
                      font: fonts?['font'],
                      textColor: textColor,
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime1 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime1({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WatermarkTimeTypeFont(
          text: formatDate(DateTime.now(), [yyyy, '.', mm, '.', dd]),
          font: fonts?['font'],
          textColor: textColor,
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);
            }),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return WatermarkTimeTypeFont(
                  text: snapshot.data!,
                  font: fonts?['font2'],
                  textColor: textColor,
                );
              }
              return WatermarkTimeTypeFont(
                text: formatDate(DateTime.now(), [HH, ':', nn, ':', ss]),
                font: fonts?['font2'],
                textColor: textColor,
              );
            })
      ],
    );
  }
}

class RYWatermarkTime2 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime2({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final style = watermarkData.style;
    final frame = watermarkData.frame;

    return StreamBuilder(
        stream: Stream.periodic(const Duration(minutes: 1), (int count) {
          return formatDate(DateTime.now(), [
            yyyy,
            '.',
            mm,
            '.',
            dd,
            ' 星期',
            Lunar.fromDate(DateTime.now()).getWeekInChinese()
          ]);
        }),
        builder: (context, snapshot) {
          return WatermarkFrameBox(
            style: style,
            frame: frame,
            child: WatermarkFontBox(
              text: snapshot.data ??
                  // Text(
                  //   formatDate(DateTime.now(), [
                  //     yyyy,
                  //     '.',
                  //     mm,
                  //     '.',
                  //     dd,
                  //     ' 星期',
                  //     Lunar.fromDate(DateTime.now()).getWeekInChinese()
                  //   ]),
                  //   style: TextStyle(
                  //       color: style?.textColor?.color?.hexToColor(style.textColor?.alpha?.toDouble()),
                  //       fontSize: fonts?['font']?.size,
                  //       fontFamily: fonts?['font']?.name),
                  // ),
                  formatDate(DateTime.now(), [
                    yyyy,
                    '.',
                    mm,
                    '.',
                    dd,
                    ' 星期',
                    Lunar.fromDate(DateTime.now()).getWeekInChinese()
                  ]),
              textStyle: style,
            ),
          );
        });
  }
}

class RYWatermarkTime3 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime3({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int templateId = context.read<WatermarkCubit>().watermarkId;
    final template = context
        .read<ResourceCubit>()
        .templates
        .firstWhereOrNull((e) => e.id == templateId);
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    final frame = watermarkData.frame;
    final style = watermarkData.style;
    final titleVisible = watermarkData.isWithTitle;

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: readImage(templateId.toString(), watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final layout = style?.layout;
              return Container(
                padding: EdgeInsets.only(
                    right: layout?.imageTitleSpace ?? 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: style?.iconWidth?.toDouble() ?? 0,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    return WatermarkFrameBox(
      style: style,
      frame: frame,
      child: Row(
        children: [
          imageWidget,
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WatermarkTimeTypeFont(
                text: formatDate(DateTime.now(), [
                  '星期',
                  Lunar.fromDate(DateTime.now()).getWeekInChinese(),
                  " "
                ]),
                font: fonts?['font'],
                textColor: textColor,
              ),
              WatermarkTimeTypeFont(
                text: formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
                font: fonts?['font'],
                textColor: textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// WatermarkTimeTypeFont(
//                 text: formatDate(DateTime.now(), [
//                   yyyy,
//                   '-',
//                   mm,
//                   "-",
//                   dd,
//                   ' ',
//                   '星期',
//                   Lunar.fromDate(DateTime.now()).getWeekInChinese()
//                 ]),
//                 font: fonts?['font'],
//                 textColor: textColor,
//                 textAlign: TextAlign.center,
//               ),
class RYWatermarkTime4 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime4({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final backgroundColor = watermarkData.style?.backgroundColor;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    var font2 = fonts?['font2'];
    var nowDate = Lunar.fromDate(DateTime.now());
    final frame = watermarkData.frame;

    return Column(
      children: [
        Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: backgroundColor?.color
                      ?.hexToColor(backgroundColor.alpha?.toDouble()) ??
                  "e3615b".hex,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0.r))),
          child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1), (int count) {
                return formatDate(DateTime.now(), [yyyy, '.', mm, '.', dd]);
              }),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ??
                      formatDate(DateTime.now(), [yyyy, '.', mm, '.', dd]),
                  style: TextStyle(
                      fontSize: font2?.size,
                      fontFamily: font2?.name,
                      color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble())),
                );
              }),
        ),
        Column(
          children: [
            Text(
              '农历${nowDate.getMonthInChinese()}月${nowDate.getDayInChinese()}',
              style: TextStyle(
                fontFamily: fonts?['font']?.name,
                fontSize: fonts?['font']?.size,
                color: backgroundColor?.color
                        ?.hexToColor(backgroundColor.alpha?.toDouble()) ??
                    'e3615b'.hex,
              ),
            ),
            Text(
              '${nowDate.getYearInGanZhi()}年 ${nowDate.getMonthInGanZhi()}月 ${nowDate.getDayInGanZhi()}日 星期${nowDate.getWeekInChinese()}',
              style: TextStyle(
                fontFamily: fonts?['font3']?.name,
                fontSize: fonts?['font3']?.size,
                color: backgroundColor?.color
                        ?.hexToColor(backgroundColor.alpha?.toDouble()) ??
                    'e3615b'.hex,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RYWatermarkTime5 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime5({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int templateId = context.read<WatermarkCubit>().watermarkId;
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              color: templateId == 1698215359120
                  ? Colors.transparent
                  : textColor?.color?.hexToColor(textColor.alpha?.toDouble())),
          child: StreamBuilder(
              stream: Stream.periodic(const Duration(minutes: 1), (int count) {
                return formatDate(DateTime.now(), [
                  HH,
                  ':',
                  nn,
                ]);
              }),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ??
                      formatDate(DateTime.now(), [
                        HH,
                        ':',
                        nn,
                      ]),
                  style: TextStyle(
                      color: templateId == 1698215359120
                          ? textColor?.color
                              ?.hexToColor(textColor.alpha?.toDouble())
                          : Colors.white,
                      fontFamily: fonts?['font2']?.name,
                      fontSize: fonts?['font2']?.size),
                );
              }),
        ),
        WatermarkTimeTypeFont(
          text: formatDate(DateTime.now(), [yyyy, '.', mm, '.', dd]),
          font: fonts?['font'],
          textColor: textColor,
        ),
      ],
    );
  }
}

class RYWatermarkTime8 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime8({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;

    return Row(
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(
                  DateTime.now(), [yyyy, '年', mm, '月', dd, '日 ', HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ??
                    formatDate(DateTime.now(),
                        [yyyy, '年', mm, '月', dd, '日 ', HH, ':', nn]),
                style: TextStyle(
                    fontSize: fonts?['font']?.size,
                    fontFamily: fonts?['font']?.name,
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble())),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime9 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime9({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;

    return Visibility(
      visible: watermarkData.isHidden == false,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream:
                      Stream.periodic(const Duration(seconds: 1), (int count) {
                    return formatDate(DateTime.now(), [HH]);
                  }),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? formatDate(DateTime.now(), [HH]),
                      style: TextStyle(
                          fontSize: 30.0.sp,
                          fontFamily: fonts?['font']?.name,
                          color: textColor?.color
                              ?.hexToColor(textColor.alpha?.toDouble())),
                    );
                    // WatermarkTimeTypeFont(
                    //   text: snapshot.data ??
                    //       formatDate(DateTime.now(), [nn, ':', ss]),
                    //   font: fonts?['font'],
                    //   textColor: textColor,
                    // );
                  }),
              Text(
                ':',
                style: TextStyle(
                    fontSize: 30.0.sp,
                    fontFamily: fonts?['font']?.name,
                    color: "FDCA01".hex),
              ),
              StreamBuilder(
                  stream:
                      Stream.periodic(const Duration(seconds: 1), (int count) {
                    return formatDate(DateTime.now(), [nn]);
                  }),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? formatDate(DateTime.now(), [nn]),
                      style: TextStyle(
                          fontSize: 30.0.sp,
                          fontFamily: fonts?['font']?.name,
                          color: textColor?.color
                              ?.hexToColor(textColor.alpha?.toDouble())),
                    );
                  }),
            ],
          ),
          WatermarkTimeTypeFont(
            text: formatDate(DateTime.now(), [
              yyyy,
              '年',
              mm,
              "月",
              dd,
              '日 ',
              '星期',
              Lunar.fromDate(DateTime.now()).getWeekInChinese()
            ]),
            font: fonts?['font'],
            textColor: textColor,
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime10 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime10({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    final signLine_frame = watermarkData.signLine?.frame;
    final signline_style = watermarkData.signLine?.style;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WatermarkTimeTypeFont(
          text: formatDate(DateTime.now(), [
            yyyy,
            '.',
            mm,
            ".",
            dd,
            ' 星期',
            Lunar.fromDate(DateTime.now()).getWeekInChinese()
          ]),
          font: fonts?['font'],
          textColor: textColor,
        ),
      ],
    );
  }
}

class RYWatermarkTime11 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime11({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    final img = watermarkData.background;
    final signLine = watermarkData.signLine;

    return WatermarkFrameBox(
      style: watermarkData.style,
      frame: watermarkData.frame,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: watermarkId == 1698049914988 && (img != null || img != ''),
            child: FutureBuilder(
                future: readImage(watermarkId.toString(), img),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Image.file(
                      File(snapshot.data ?? ''),
                      fit: BoxFit.fitHeight,
                    );
                  }
                  return const SizedBox.shrink();
                }),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: watermarkId == 16983178686921
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Visibility(
                visible: watermarkId == 16982272012263,
                child: Row(
                  children: [
                    StreamBuilder(
                        stream: Stream.periodic(const Duration(minutes: 1),
                            (int count) {
                          return formatDate(DateTime.now(), [' ', HH, ':', nn]);
                        }),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ??
                                formatDate(DateTime.now(), [' ', HH, ':', nn]),
                            style: TextStyle(
                                fontSize: fonts?['font']?.size,
                                fontFamily: fonts?['font']?.name,
                                color: textColor?.color
                                    ?.hexToColor(textColor.alpha?.toDouble()),
                                height: 1),
                          );
                        }),
                    WatermarkFrameBox(
                      frame: signLine?.frame,
                      style: signLine?.style,
                    ),
                  ],
                ),
              ),
              WatermarkTimeTypeFont(
                text: formatDate(DateTime.now(), [
                  yyyy,
                  '/',
                  mm,
                  "/",
                  dd,
                ]),
                font: fonts?['font'],
                textColor: textColor,
              ),
              WatermarkTimeTypeFont(
                text: fonts?['font2'] == null && watermarkId != 16982272012263
                    ? formatDate(DateTime.now(), [
                        ' 周',
                        Lunar.fromDate(DateTime.now()).getWeekInChinese()
                      ])
                    : formatDate(DateTime.now(), [
                        ' 星期',
                        Lunar.fromDate(DateTime.now()).getWeekInChinese()
                      ]),
                font: fonts?['font2'] ?? fonts?['font'],
                textColor: textColor,
              ),
              Visibility(
                visible: watermarkId != 16982153599582 &&
                    watermarkId != 16982272012263,
                child: StreamBuilder(
                    stream: Stream.periodic(const Duration(minutes: 1),
                        (int count) {
                      return formatDate(DateTime.now(), [' ', HH, ':', nn]);
                    }),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ??
                            formatDate(DateTime.now(), [' ', HH, ':', nn]),
                        style: TextStyle(
                            fontSize: fonts?['font']?.size,
                            fontFamily: fonts?['font']?.name,
                            color: textColor?.color
                                ?.hexToColor(textColor.alpha?.toDouble()),
                            height: 1),
                      );
                    }),
              ),
            ],
          ),
          Visibility(
            visible: watermarkId != null &&
                watermarkId == 1698049914988 &&
                (img != null || img != ''),
            child: FutureBuilder(
                future: readImage(watermarkId.toString(), img),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Image.file(
                      File(snapshot.data ?? ''),
                      fit: BoxFit.fitHeight,
                    );
                  }
                  return const SizedBox.shrink();
                }),
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime12 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime12({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                style: TextStyle(
                    fontSize: fonts?['font2']?.size,
                    fontFamily: fonts?['font2']?.name,
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble()),
                    height: 1),
              );
            }),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 10.0.w),
        //   child: StreamBuilder(
        //       stream: Stream.periodic(const Duration(minutes: 1), (int count) {
        //         return formatDate(DateTime.now(), [HH, ':', nn]);
        //       }),
        //       builder: (context, snapshot) {
        //         return Text(
        //           snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
        //           style: TextStyle(
        //               fontSize: fonts?['font2']?.size,
        //               fontFamily: fonts?['font2']?.name,
        //               color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
        //               height: 1),
        //         );
        //       }),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              formatDate(DateTime.now(), [yyyy, '年', mm, "月", dd, "日 "]),
              style: TextStyle(
                  fontFamily: fonts?['font3']?.name,
                  fontSize: fonts?['font3']?.size,
                  color:
                      textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  height: 1),
            ),
            Text(
                formatDate(DateTime.now(),
                    ['星期', Lunar.fromDate(DateTime.now()).getWeekInChinese()]),
                style: TextStyle(
                    fontFamily: fonts?['font3']?.name,
                    fontSize: fonts?['font3']?.size,
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble()),
                    height: 1)),
          ],
        ),
      ],
    );
  }
}

class RYWatermarkTime13 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime13({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final font = fonts?['font'];
    final font2 = fonts?['font2'];
    final textColor = watermarkData.style?.textColor;
    final signLine_frame = watermarkData.signLine?.frame;
    final signline_style = watermarkData.signLine?.style;
    final watermark5_gradient = LinearGradient(
      colors: [
        "556172".hex,
        '677893'.hex,
      ],
    );
    final listTime = [HH, nn, ss];
    final content = watermarkData.content;
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: listTime.map((item) {
              return Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.w),
                      gradient: watermark5_gradient,
                    ),
                    margin: EdgeInsets.only(bottom: 6.0.w),
                    child: StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1),
                            (int count) {
                          return formatDate(DateTime.now(), [item]);
                        }),
                        builder: (context, snapshot) {
                          return Center(
                            child: Text(
                              (snapshot.data ??
                                  formatDate(DateTime.now(), [item])),
                              style: TextStyle(
                                fontSize: font2?.size,
                                fontFamily: font?.name,
                                // fontWeight: FontWeight.bold,
                                color: textColor?.color
                                    ?.hexToColor(textColor.alpha?.toDouble()),
                              ),
                            ),
                          );
                        }),
                  ),
                  Visibility(
                    visible: item != ss,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: Text(
                        ":",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          Row(
            children: [
              Baseline(
                baseline: 15.w,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  formatDate(DateTime.now(), [
                    yyyy,
                    '-',
                    mm,
                    "-",
                    dd,
                  ]),
                  style: TextStyle(
                    fontSize: font2?.size,
                    fontFamily: font?.name,
                    // fontWeight: FontWeight.bold,
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble()),
                    // height: 1.5,
                  ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Baseline(
                baseline: 10.w,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  formatDate(DateTime.now(), [
                    '星期',
                    Lunar.fromDate(DateTime.now()).getWeekInChinese()
                  ]),
                  style: TextStyle(
                    fontSize: font?.size,
                    fontFamily: font?.name,
                    // fontWeight: FontWeight.bold,
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble()),
                    // height: 1.5,
                    // textBaseline: TextBaseline.alphabetic
                  ),
                ),
              ),
            ],
          ),
          WatermarkFrameBox(
            frame: signLine_frame,
            style: signline_style,
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime14 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime14({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    final signLine_frame = watermarkData.signLine?.frame;
    final signline_style = watermarkData.signLine?.style;

    return IntrinsicHeight(
      child: Row(
        children: [
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1), (int count) {
                return formatDate(DateTime.now(), [HH, ':', nn]);
              }),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                  style: TextStyle(
                      fontSize: fonts?['font']?.size,
                      fontFamily: fonts?['font']?.name,
                      color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()),
                      height: 1),
                );
              }),
          WatermarkFrameBox(
            frame: signLine_frame,
            style: signline_style,
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WatermarkTimeTypeFont(
                    text: formatDate(DateTime.now(), [
                      yyyy,
                      '-',
                      mm,
                      "-",
                      dd,
                    ]),
                    font: fonts?['font2'],
                    textColor: textColor,
                  ),
                  Row(
                    children: [
                      WatermarkTimeTypeFont(
                        text: formatDate(DateTime.now(), [
                          '星期',
                          Lunar.fromDate(DateTime.now()).getWeekInChinese()
                        ]),
                        font: fonts?['font3'],
                        textColor: textColor,
                      ),
                      Expanded(
                          child:
                              RyWatermarkWeather(watermarkData: watermarkData)),
                    ],
                  ),
                  // Text(
                  //   formatDate(DateTime.now(), [
                  //     yyyy,
                  //     '-',
                  //     mm,
                  //     "-",
                  //     dd,
                  //   ]),
                  //   style: TextStyle(
                  //       color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  //       fontFamily: fonts?['font2']?.name,
                  //       fontSize: fonts?['font2']?.size,
                  //       height: 1),
                  // ),
                  // Text(
                  //   formatDate(DateTime.now(), [
                  //     '星期',
                  //     Lunar.fromDate(DateTime.now()).getWeekInChinese()
                  //   ]),
                  //   style: TextStyle(
                  //       color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  //       fontFamily: fonts?['font3']?.name,
                  //       fontSize: fonts?['font3']?.size),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime15 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime15({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    final signline_frame = watermarkData.signLine?.frame;
    final signline_style = watermarkData.signLine?.style;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                textAlign: TextAlign.center,
                snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                style: TextStyle(
                  fontSize: font?.size,
                  fontFamily: font?.name,
                  color:
                      textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  // height: 1
                ),
              );
            }),
        WatermarkFrameBox(
          style: signline_style,
          frame: signline_frame,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textAlign: TextAlign.center,
                formatDate(DateTime.now(), [
                  yyyy,
                  '/',
                  mm,
                  "/",
                  dd,
                ]),
                style: TextStyle(
                    fontSize: fonts?['font2']?.size,
                    fontFamily: fonts?['font2']?.name,
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble()),
                    height: 1.6),
              ),
              Text(
                formatDate(DateTime.now(), [
                  '星期',
                  Lunar.fromDate(DateTime.now()).getWeekInChinese(),
                ]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: fonts?['font3']?.name,
                    fontSize: fonts?['font3']?.size,
                    height: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RYWatermarkTime16 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime16({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    var font2 = fonts?['font2'];

    return Row(
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: font?.name,
                    fontSize: font?.size,
                    height: 1),
              );
            }),
        SizedBox(
          width: 10.0.w,
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [
                '星期',
                Lunar.fromDate(DateTime.now()).getWeekInChinese(),
                '\n',
                yyyy,
                '年',
                mm,
                '月',
                dd,
                '日'
              ]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ??
                    formatDate(DateTime.now(), [
                      '星期',
                      Lunar.fromDate(DateTime.now()).getWeekInChinese(),
                      '\n',
                      yyyy,
                      '年',
                      mm,
                      '月',
                      dd,
                      '日'
                    ]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: font2?.name,
                    fontSize: font2?.size,
                    height: 1),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime17 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime17({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];

    return StreamBuilder(
        stream: Stream.periodic(const Duration(minutes: 1), (int count) {
          return formatDate(DateTime.now(), [HH, ':', nn]);
        }),
        builder: (context, snapshot) {
          return Align(
            alignment: Alignment.centerRight,
            child: Text(
              snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
              // textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: font?.name,
                  fontSize: font?.size,
                  height: 1),
            ),
          );
        });
  }
}

class RYWatermarkTime18 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime18({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    final signLine_frame = watermarkData.signLine?.frame;
    final signline_style = watermarkData.signLine?.style;

    return IntrinsicHeight(
      child: Row(
        children: [
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1), (int count) {
                return formatDate(DateTime.now(), [HH, ':', nn]);
              }),
              builder: (context, snapshot) {
                final timeString = snapshot.data;
                if (timeString != null) {
                  return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...timeString
                            .split(':')[0]
                            .split('')
                            .mapIndexed((index, item) {
                          return FutureBuilder(
                              future: readTimeImage(watermarkId.toString(),
                                  'time${index + 1}_${item}_img'),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Image.file(File(snapshot.data!),
                                      height: 25.w, fit: BoxFit.cover);
                                }

                                return const SizedBox.shrink();
                              });
                        }).toList(),
                        FutureBuilder(
                            future: readTimeImage(
                                watermarkId.toString(), 'time_space_img'),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Image.file(File(snapshot.data!),
                                    height: 15.w, fit: BoxFit.cover);
                              }

                              return const SizedBox.shrink();
                            }),
                        ...timeString
                            .split(':')[1]
                            .split('')
                            .mapIndexed((index, item) {
                          return FutureBuilder(
                              future: readTimeImage(watermarkId.toString(),
                                  'time${index + 3}_${item}_img'),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Image.file(File(snapshot.data!),
                                      height: 25.w, fit: BoxFit.cover);
                                }

                                return const SizedBox.shrink();
                              });
                        })
                      ]);
                }
                return const SizedBox.shrink();
              }),
          WatermarkFrameBox(
            frame: signLine_frame,
            style: signline_style,
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WatermarkTimeTypeFont(
                    text: formatDate(DateTime.now(), [
                      yyyy,
                      '-',
                      mm,
                      "-",
                      dd,
                    ]),
                    font: fonts?['font2'],
                    textColor: textColor,
                  ),
                  Row(
                    children: [
                      WatermarkTimeTypeFont(
                        text: formatDate(DateTime.now(), [
                          '星期',
                          Lunar.fromDate(DateTime.now()).getWeekInChinese()
                        ]),
                        font: fonts?['font3'],
                        textColor: textColor,
                      ),
                      Expanded(
                          child:
                              RyWatermarkWeather(watermarkData: watermarkData)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime19 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime19({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    // final textColor = watermarkData.style?.textColor;
    final textColor = Styles.whiteTextColor;
    // WatermarkBackgroundColor(color: "#FFFFFF", alpha: 1);
    var font = fonts?['font'];
    var font2 = fonts?['font2'];

    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(minutes: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                '上午',
                // snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: font2?.name,
                    fontSize: font2?.size,
                    height: 1),
              );
            }),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 3,
            height: 20,
            child:
                DecoratedBox(decoration: BoxDecoration(color: Colors.amber))),
        StreamBuilder(
            stream: Stream.periodic(const Duration(minutes: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: font2?.name,
                    fontSize: font2?.size,
                    height: 1),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime20 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime20({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                textAlign: TextAlign.end,
                snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                style: TextStyle(
                    fontSize: font?.size,
                    fontFamily: font?.name,
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble()),
                    height: 1),
              );
            }),
        SizedBox(
          width: 10.0.sp,
        ),
        Text(
          // textAlign: TextAlign.start,
          formatDate(DateTime.now(), [
            yyyy,
            '.',
            mm,
            ".",
            dd,
          ]),
          style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
              fontSize: fonts?['font2']?.size,
              fontFamily: fonts?['font2']?.name,
              color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
              height: 1.6),
        ),
        // WatermarkTimeTypeFont(
        //   text: formatDate(DateTime.now(), [
        //     yyyy,
        //     '.',
        //     mm,
        //     ".",
        //     dd,
        //   ]),
        //   font: fonts?['font2'],
        //   textColor: textColor,
        // ),
      ],
    );
  }
}

class RYWatermarkTime21 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime21({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    final signLine = watermarkData.signLine;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(hours: 1),
                          (int count) {
                        return formatDate(DateTime.now(), [HH]);
                      }),
                      builder: (context, snapshot) {
                        return Text(
                          textAlign: TextAlign.end,
                          snapshot.data ?? formatDate(DateTime.now(), [HH]),
                          style: TextStyle(
                            fontSize: font?.size,
                            fontFamily: font?.name,
                            color: textColor?.color
                                ?.hexToColor(textColor.alpha?.toDouble()),
                            // height: 1
                          ),
                        );
                      }),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: font?.size,
                      fontFamily: font?.name,
                      color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()),
                      // height: 1
                    ),
                  ),
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(minutes: 1),
                          (int count) {
                        return formatDate(DateTime.now(), [nn]);
                      }),
                      builder: (context, snapshot) {
                        return Text(
                          textAlign: TextAlign.end,
                          snapshot.data ?? formatDate(DateTime.now(), [nn]),
                          style: TextStyle(
                            fontSize: font?.size,
                            fontFamily: font?.name,
                            color: textColor?.color
                                ?.hexToColor(textColor.alpha?.toDouble()),
                            // height: 1
                          ),
                        );
                      }),
                ],
              ),
              Text(
                // textAlign: TextAlign.start,
                formatDate(DateTime.now(), [
                  yyyy,
                  '.',
                  mm,
                  ".",
                  dd,
                ]),
                style: TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: fonts?['font2']?.size,
                  fontFamily: fonts?['font2']?.name,
                  color:
                      textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  // height: 1
                ),
              ),
            ],
          ),
          WatermarkFrameBox(
            frame: signLine?.frame,
            style: signLine?.style,
          ),
          // VerticalDivider(
          //   width: signLine?.frame?.width ?? 0,
          //   thickness: signLine?.frame?.width ?? 0,
          //   indent: 0,
          //   endIndent: 0,
          //   color: signLine?.style?.backgroundColor?.color?.hexToColor(
          //           signLine.style?.backgroundColor?.alpha?.toDouble()) ??
          //       Colors.transparent,
          // ),
        ],
      ),
    );
  }
}

class RYWatermarkTime24 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime24({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    var font2 = fonts?['font2'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(minutes: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: font2?.name,
                    // 'DINPro-Medium_13936',
                    fontSize: font2?.size,
                    height: 1),
              );
            }),
        SizedBox(
          width: 5.w,
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [yyyy, '年', mm, '月', dd, '日']);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ??
                    formatDate(DateTime.now(), [yyyy, '年', mm, '月', dd, '日']),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: font?.name,
                    fontSize: font?.size,
                    height: 1),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime28 extends StatelessWidget {
  final WatermarkData watermarkData;
  const RYWatermarkTime28({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    int templateId = context.read<WatermarkCubit>().watermarkId;
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    final img = watermarkData.image;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(DateTime.now(), [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(DateTime.now(), [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                    fontFamily: font?.name,
                    fontSize: 30.sp,
                    height: 1),
              );
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: WatermarkTimeTypeFont(
                text: formatDate(DateTime.now(), [
                  yyyy,
                  '-',
                  mm,
                  "-",
                  dd,
                  ' ',
                  '星期',
                  Lunar.fromDate(DateTime.now()).getWeekInChinese()
                ]),
                font: fonts?['font'],
                textColor: textColor,
                textAlign: TextAlign.center,
              ),
            ),
            FutureBuilder(
                future: readImage(templateId.toString(), img),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Image.file(
                      File(snapshot.data ?? ''),
                      fit: BoxFit.fitHeight,
                      height: 20.w,
                    );
                  }
                  return const SizedBox.shrink();
                }),
            Expanded(
              child: RyWatermarkLocationBox(
                watermarkData: watermarkData,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WatermarkTimeTypeFont extends StatelessWidget {
  final WatermarkFont? font;
  final WatermarkBackgroundColor? textColor;
  final TextAlign? textAlign;
  final String text;

  const WatermarkTimeTypeFont(
      {super.key,
      this.textAlign,
      required this.font,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: textColor?.color?.hexToColor(textColor?.alpha?.toDouble()),
          fontFamily: font?.name,
          fontSize: font?.size,
          height: 1),
    );
  }
}
