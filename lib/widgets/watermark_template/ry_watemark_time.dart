import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:path/path.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/form.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_template/ry_watermark_location.dart';
import 'package:watermark_camera/widgets/watermark_ui/assert_image_builder.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_frame_box.dart';

import 'package:lunar/lunar.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_general_item.dart';

class RYWatermarkTimeWithSeconds extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTimeWithSeconds({
    super.key,
    required this.watermarkData,
    required this.resource,
  });

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != null && watermarkData.content!.isNotEmpty) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final textColor = textStyle?.textColor;
    final font = fonts?['font'];
    DateTime currentTime = timeContent;
    final String initialFormattedDate = formatDate(
      currentTime,
      [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<DateTime>(
          stream: Stream.periodic(
            const Duration(seconds: 1),
            (count) => timeContent.add(Duration(seconds: count)),
          ),
          builder: (context, snapshot) {
            // 将初始 formattedDate 解析为 DateTime
            DateTime currentTime = DateTime.parse(initialFormattedDate);
            // 每次递增 snapshot.data 秒
            if (snapshot.hasData) {
              currentTime =
                  currentTime.add(Duration(seconds: snapshot.data!.second));
            }

            // 重新格式化为字符串
            final formattedDate = formatDate(
              currentTime,
              [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss],
            );

            return Column(
              children: [
                WatermarkFontBox(
                  text: formattedDate,
                  font: fonts?['font'],
                  textStyle: textStyle,
                  isBold: templateId == 16982153599988,
                  //height: 1,
                ),
              ],
            );
          },
        )
      ],
    );
  }
}

class RYWatermarkTime0 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime0(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final frame = watermarkData.frame;
    final style = watermarkData.style;
    final titleVisible = watermarkData.isWithTitle;

    Widget? imageWidget = const SizedBox.shrink();

    // 时间图片之前的图片信息
    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(templateId.toString(),
              fileName: watermarkData.image),
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
              return formatDate(timeContent, [hh, ':', nn]);
            }),
            builder: (context, snapshot) {
              String title = watermarkData.title!;
              if (resource.id == 1698049875646 && title != null) {
                title += "   ";
              } else {
                title += "：";
              }
              // title可能需要存在对齐的情况

              return WatermarkFrameBox(
                frame: frame,
                style: style,
                watermarkId: templateId,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageWidget ?? const SizedBox.shrink(),
                    Visibility(
                        visible: titleVisible ?? false,
                        child: WatermarkFontBox(
                          text: title,
                          font: fonts?['font'],
                          textStyle: textStyle,
                          //height: 1,
                        )),
                    WatermarkFontBox(
                      text: formatDate(timeContent, [yyyy, '.', mm, '.', dd]),
                      font: fonts?['font'],
                      textStyle: textStyle,
                      isBold: templateId == 16982153599988,
                      //height: 1,
                    ),
                    Visibility(
                      visible: templateId == 1698049456677 ||
                          templateId == 1698049457777,
                      child: WatermarkFontBox(
                        text: formatDate(timeContent, [
                          ' 星期',
                          Lunar.fromDate(timeContent).getWeekInChinese()
                        ]),
                        font: fonts?['font'],
                        textStyle: textStyle,
                        height: 1,
                      ),
                    ),
                    WatermarkFontBox(
                      text: formatDate(timeContent, [' ', HH, ':', nn]),
                      font: fonts?['font'],
                      textStyle: textStyle,
                      isBold: templateId == 16982153599988,
                      //height: 1,
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
  final WatermarkResource resource;

  const RYWatermarkTime1(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WatermarkFontBox(
          text: formatDate(timeContent, [yyyy, '.', mm, '.', dd]),
          font: fonts?['font']?.copyWith(size: 15.5),
          textStyle: textStyle,
          height: 1,
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(timeContent, [HH, ':', nn, ':', ss]);
            }),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return WatermarkFontBox(
                  text: snapshot.data!,
                  font: fonts?['font2'],
                  height: 1,
                  textStyle: textStyle,
                );
              }
              return WatermarkFontBox(
                text: formatDate(timeContent, [HH, ':', nn, ':', ss]),
                font: fonts?['font2'],
                textStyle: textStyle,
                //height: 1,
              );
            })
      ],
    );
  }
}

class RYWatermarkTime2 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime2(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final style = watermarkData.style;
    final frame = watermarkData.frame;

    return StreamBuilder(
        stream: Stream.periodic(const Duration(minutes: 1), (int count) {
          return formatDate(timeContent, [
            yyyy,
            '.',
            mm,
            '.',
            dd,
            ' 星期',
            Lunar.fromDate(timeContent).getWeekInChinese()
          ]);
        }),
        builder: (context, snapshot) {
          return WatermarkFrameBox(
            style: style,
            frame: frame,
            watermarkId: templateId,
            child: WatermarkFontBox(
              text: snapshot.data ??
                  // Text(
                  //   formatDate(timeContent, [
                  //     yyyy,
                  //     '.',
                  //     mm,
                  //     '.',
                  //     dd,
                  //     ' 星期',
                  //     Lunar.fromDate(timeContent).getWeekInChinese()
                  //   ]),
                  //   style: TextStyle(
                  //       color: style?.textColor?.color?.hexToColor(style.textStyle?.alpha?.toDouble()),
                  //       fontSize: fonts?['font']?.size,
                  //       fontFamily: fonts?['font']?.name??defultFontFamily),
                  // ),
                  formatDate(timeContent, [
                    yyyy,
                    '.',
                    mm,
                    '.',
                    dd,
                    ' 星期',
                    Lunar.fromDate(timeContent).getWeekInChinese()
                  ]),
              textStyle: style,
              font: style?.fonts?['font'],
              // height: 1,
            ),
          );
        });
  }
}

class RYWatermarkTime3 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime3(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final frame = watermarkData.frame;
    final style = watermarkData.style;

    Widget? imageWidget = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(templateId.toString(),
              fileName: watermarkData.image),
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
      watermarkId: templateId,
      child: Row(
        children: [
          imageWidget,
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WatermarkFontBox(
                text: formatDate(timeContent, [
                  '星期',
                  Lunar.fromDate(timeContent).getWeekInChinese(),
                  " "
                ]),
                font: fonts?['font'],
                textStyle: textStyle,
                //height: 1,
              ),
              WatermarkFontBox(
                text: formatDate(timeContent, [yyyy, '-', mm, '-', dd]),
                font: fonts?['font'],
                textStyle: textStyle,
                //height: 1,
              )
            ],
          ),
        ],
      ),
    );
  }
}

// WatermarkFontBox
// (
//                 text: formatDate(timeContent, [
//                   yyyy,
//                   '-',
//                   mm,
//                   "-",
//                   dd,
//                   ' ',
//                   '星期',
//                   Lunar.fromDate(timeContent).getWeekInChinese()
//                 ]),
//                 font: fonts?['font'],
//                 textStyle: textStyle,
//                 textAlign: TextAlign.center,
//               ),
class RYWatermarkTime4 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime4(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final backgroundColor = watermarkData.style?.backgroundColor;
    final textStyle = watermarkData.style;
    var font2 = fonts?['font2'];
    var nowDate = Lunar.fromDate(timeContent);

    return Column(
      children: [
        Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: backgroundColor?.color
                      ?.hexToColor(backgroundColor.alpha?.toDouble()) ??
                  "e3615b".hex,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0.w))),
          child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1), (int count) {
                return formatDate(timeContent, [yyyy, '.', mm, '.', dd]);
              }),
              builder: (context, snapshot) {
                return WatermarkFontBox(
                    text: snapshot.data ??
                        formatDate(timeContent, [yyyy, '.', mm, '.', dd]),
                    font: font2,
                    textStyle: textStyle);
              }),
        ),
        Column(
          children: [
            Text(
              '农历${nowDate.getMonthInChinese()}月${nowDate.getDayInChinese()}',
              style: TextStyle(
                fontFamily: fonts?['font']?.name ?? defultFontFamily,
                fontSize: fonts?['font']?.size != null
                    ? (fonts?['font']?.size!.sp)
                    : null,
                color: backgroundColor?.color
                        ?.hexToColor(backgroundColor.alpha?.toDouble()) ??
                    'e3615b'.hex,
              ),
            ),
            Text(
              '${nowDate.getYearInGanZhi()}年 ${nowDate.getMonthInGanZhi()}月 ${nowDate.getDayInGanZhi()}日 星期${nowDate.getWeekInChinese()}',
              style: TextStyle(
                fontFamily: fonts?['font3']?.name ?? defultFontFamily,
                fontSize: fonts?['font3']?.size != null
                    ? (fonts?['font3']?.size!.sp)
                    : null,
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
  final WatermarkResource resource;

  const RYWatermarkTime5(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;

    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: Stream.periodic(const Duration(minutes: 1), (int count) {
                return formatDate(timeContent, [
                  HH,
                  ':',
                  nn,
                ]);
              }),
              builder: (context, snapshot) {
                return WatermarkFontBox(
                  textStyle: textStyle,
                  text: snapshot.data ??
                      formatDate(timeContent, [
                        HH,
                        ':',
                        nn,
                      ]),
                  font: fonts?['font2'],
                  textAlign: TextAlign.center,
                );
                // Text(
                //   snapshot.data ??
                //       formatDate(timeContent, [
                //         HH,
                //         ':',
                //         nn,
                //       ]),
                //   style: TextStyle(
                //       color: templateId == 1698215359120
                //           ? textColor?.color
                //               ?.hexToColor(textColor.alpha?.toDouble())
                //           : Colors.white,
                //       fontFamily: fonts?['font2']?.name ?? defultFontFamily,
                //       fontSize: fonts?['font2']?.size != null
                //           ? (fonts?['font2']?.size!.sp)
                //           : null),
                // );
              }),
          WatermarkFontBox(
            //height: 1,
            text: formatDate(timeContent, [yyyy, '.', mm, '.', dd]),
            font: fonts?['font'],
            textStyle: textStyle,
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime6 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime6(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final textColor = textStyle?.textColor;

    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 找不到一样的字体只找到图片，只能用图片代替文本显示时间
          //  HH:nn
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.h),
            decoration: BoxDecoration(
                color:
                    textColor?.color?.hexToColor(textColor.alpha?.toDouble())),
            child: StreamBuilder(
                stream:
                    Stream.periodic(const Duration(minutes: 1), (int count) {
                  return formatDate(timeContent, [
                    HH,
                    ':',
                    nn,
                  ]);
                }),
                builder: (context, snapshot) {
                  final timeText = snapshot.data ??
                      formatDate(timeContent, [
                        HH,
                        ':',
                        nn,
                      ]);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(timeText.length, (index) {
                      // 处理冒号
                      String spliceText = timeText.split('')[index];
                      if (spliceText == ':') {
                        spliceText = 'colon';
                      }
                      return FutureBuilder(
                          future: WatermarkService.getImagePath(
                              templateId.toString(),
                              fileName: 'white_$spliceText'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Image.file(
                                File(snapshot.data!),
                                fit: BoxFit.fitHeight,
                                height: 12.h,
                              );
                            }
                            return const SizedBox.shrink();
                          });
                    }),
                  );
                  // 这是开始直接使用的文本渲染
                  // WatermarkFontBox(
                  //   textStyle:
                  //       textStyle?.copyWith(textColor: Styles.whiteTextColor),
                  //   text: snapshot.data ??
                  //       formatDate(timeContent, [
                  //         HH,
                  //         ':',
                  //         nn,
                  //       ]),
                  //   font: fonts?['font2']
                  //       ?.copyWith(name: 'Quartz-Medium', size: 14),
                  //   height: 1,
                  //   textAlign: TextAlign.center,
                  // );
                }),
          ),
          // yyyy.mm.dd
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 4.h),
            child: StreamBuilder(
                stream:
                    Stream.periodic(const Duration(minutes: 1), (int count) {
                  return formatDate(timeContent, [yyyy, '.', mm, '.', dd]);
                }),
                builder: (context, snapshot) {
                  final timeText = snapshot.data ??
                      formatDate(timeContent, [yyyy, '.', mm, '.', dd]);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(timeText.length, (index) {
                      // 处理点
                      String spliceText = timeText.split('')[index];
                      if (spliceText == '.') {
                        spliceText = 'point';
                      }
                      return FutureBuilder(
                          future: WatermarkService.getImagePath(
                              templateId.toString(),
                              fileName: 'blue_$spliceText'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Row(children: [
                                Image.file(
                                  File(snapshot.data!),
                                  fit: BoxFit.fill,
                                  width: 4.w,
                                  height: 6.5.h,
                                ),
                                0.5.w.horizontalSpace
                              ]);
                            }
                            return const SizedBox.shrink();
                          });
                    }),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime8 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime8(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;

    return Row(
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(
                  timeContent, [yyyy, '年', mm, '月', dd, '日 ', HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return WatermarkFontBox(
                text: snapshot.data ??
                    formatDate(timeContent,
                        [yyyy, '年', mm, '月', dd, '日 ', HH, ':', nn]),
                font: fonts?['font'],
                textStyle: textStyle,
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime9 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime9(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final textColor = textStyle?.textColor;
    final font = fonts?['font'];
    final font2 = fonts?['font2'];
    final bigFont = 55.sp;
    return Visibility(
      visible: watermarkData.isHidden == false,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1),
                        (int count) {
                      return formatDate(timeContent, [HH]);
                    }),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? formatDate(timeContent, [HH]),
                        style: TextStyle(
                            fontSize: bigFont,
                            fontFamily:
                                fonts?['font']?.name ?? defultFontFamily,
                            color: textColor?.color
                                ?.hexToColor(textColor.alpha?.toDouble())),
                      );
                      // WatermarkFontBox
// (
                      // height:1
                      //   text: snapshot.data ??
                      //       formatDate(timeContent, [nn, ':', ss]),
                      //   font: fonts?['font'],
                      //   textStyle: textStyle,
                      // );
                    }),
                FutureBuilder(
                    future: WatermarkService.getImagePath(templateId.toString(),
                        fileName: 'big_time_dot'),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Container(
                          margin:
                              EdgeInsets.only(left: 6.w, top: 5.h, right: 6.w),
                          child: Image.file(
                            File(snapshot.data!),
                            width: 6.5.w,
                            fit: BoxFit.contain,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                // Text(
                //   ':',
                //   style: TextStyle(
                //       fontSize: bigFont,
                //       fontFamily: fonts?['font']?.name ?? defultFontFamily,
                //       color: "FDCA01".hex),
                // ),
                StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1),
                        (int count) {
                      return formatDate(timeContent, [nn]);
                    }),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? formatDate(timeContent, [nn]),
                        style: TextStyle(
                            fontSize: bigFont,
                            fontFamily:
                                fonts?['font']?.name ?? defultFontFamily,
                            color: textColor?.color
                                ?.hexToColor(textColor.alpha?.toDouble())),
                      );
                    }),
              ],
            ),
          ),
          WatermarkFontBox(
            //height: 1,
            text: formatDate(timeContent, [
              yyyy,
              '年',
              mm,
              "月",
              dd,
              '日 ',
              '星期',
              Lunar.fromDate(timeContent).getWeekInChinese()
            ]),
            font: font2,
            textStyle: textStyle,
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime10 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime10(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final singleLineFrame = watermarkData.signLine?.frame;
    final singleLineStyle = watermarkData.signLine?.style;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WatermarkFontBox(
          //height: 1,
          text: formatDate(timeContent, [
            yyyy,
            '.',
            mm,
            ".",
            dd,
            ' 星期',
            Lunar.fromDate(timeContent).getWeekInChinese()
          ]),
          font: fonts?['font'],
          textStyle: textStyle,
        ),
      ],
    );
  }
}

class RYWatermarkTime11 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime11(
      {super.key, required this.watermarkData, required this.resource});

  int get watermarkId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final textColor = watermarkData.style?.textColor;
    final img = watermarkData.background;
    final signLine = watermarkData.signLine;

    return WatermarkFrameBox(
      style: watermarkData.style,
      frame: watermarkData.frame,
      watermarkId: watermarkId,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: watermarkId == 1698049914988 && (img != null || img != ''),
            child: FutureBuilder(
                future: WatermarkService.getImagePath(watermarkId.toString(),
                    fileName: img),
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
            mainAxisAlignment: watermarkId == 16983178686921 ||
                    watermarkId == 16982153599582 ||
                    watermarkId == 16982272012263
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
                          return formatDate(timeContent, [' ', HH, ':', nn]);
                        }),
                        builder: (context, snapshot) {
                          return WatermarkFontBox(
                            text: snapshot.data ??
                                formatDate(timeContent, [' ', HH, ':', nn]),
                            textStyle: textStyle,
                            font: null,
                          );
                        }),
                    WatermarkFrameBox(
                      frame: signLine?.frame,
                      style: signLine?.style,
                      watermarkId: watermarkId,
                    ),
                  ],
                ),
              ),
              WatermarkFontBox(
                //height: 1,
                text: formatDate(timeContent, [
                  yyyy,
                  '/',
                  mm,
                  "/",
                  dd,
                ]),
                font: fonts?['font'],
                textStyle: textStyle,
              ),
              WatermarkFontBox(
                //height: 1,
                text: fonts?['font2'] == null && watermarkId != 16982272012263
                    ? formatDate(timeContent,
                        [' 周', Lunar.fromDate(timeContent).getWeekInChinese()])
                    : formatDate(timeContent, [
                        ' 星期',
                        Lunar.fromDate(timeContent).getWeekInChinese()
                      ]),
                font: fonts?['font2'] ?? fonts?['font'],
                textStyle: textStyle,
              ),
              Visibility(
                visible: watermarkId != 16982153599582 &&
                    watermarkId != 16982272012263,
                child: StreamBuilder(
                    stream: Stream.periodic(const Duration(minutes: 1),
                        (int count) {
                      return formatDate(timeContent, [' ', HH, ':', nn]);
                    }),
                    builder: (context, snapshot) {
                      return WatermarkFontBox(
                        font: fonts?['font'],
                        text: snapshot.data ??
                            formatDate(timeContent, [' ', HH, ':', nn]),
                        textStyle: textStyle,
                      );
                    }),
              ),
            ],
          ),
          Visibility(
            visible: watermarkId == 1698049914988 && (img != null || img != ''),
            child: FutureBuilder(
                future: WatermarkService.getImagePath(watermarkId.toString(),
                    fileName: img),
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
  final WatermarkResource resource;

  const RYWatermarkTime12(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return WatermarkFontBox(
                text: snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                font: fonts?['font2'],
                textStyle: textStyle,
                //
              );
            }),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 10.0.w),
        //   child: StreamBuilder(
        //       stream: Stream.periodic(const Duration(minutes: 1), (int count) {
        //         return formatDate(timeContent, [HH, ':', nn]);
        //       }),
        //       builder: (context, snapshot) {
        //         return Text(
        //           snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
        //           style: TextStyle(
        //               fontSize: fonts?['font2']?.size,
        //               fontFamily: fonts?['font2']?.name??defultFontFamily,
        //               color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
        //               height: 1),
        //         );
        //       }),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WatermarkFontBox(
              text: formatDate(timeContent, [yyyy, '年', mm, "月", dd, "日 "]),
              font: fonts?['font3'],
              textStyle: textStyle,
              //height: 1,
            ),
            WatermarkFontBox(
              text: formatDate(timeContent,
                  ['星期', Lunar.fromDate(timeContent).getWeekInChinese()]),
              font: fonts?['font3'],
              textStyle: textStyle,
              //height: 1,
            ),
          ],
        ),
      ],
    );
  }
}

// 1698125683355模板的时间显示
class RYWatermarkTime13 extends StatelessWidget {
  final WatermarkData? watermarkData;
  final WatermarkResource resource;
  final String? shapeContent;

  const RYWatermarkTime13(
      {super.key,
      required this.watermarkData,
      required this.resource,
      this.shapeContent});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData?.content != '' && watermarkData?.content != null) {
      return DateTime.parse(watermarkData?.content ?? '');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData?.style?.fonts;
    final font = fonts?['font'];
    final font2 = fonts?['font2'];
    final textStyle = watermarkData?.style;
    WatermarkFrame? textFrame = watermarkData?.frame;
    final textColor = watermarkData?.style?.textColor;
    final singleLineFrame = watermarkData?.signLine?.frame;
    final singleLineStyle = watermarkData?.signLine?.style;

    // final timeShape = watermarkData?.image;
    String timeShape = 'water_23_bg1';
    if (Utils.isNotNullEmptyStr(shapeContent)) {
      timeShape = shapeContent!;
    }
    //默认是1，然后去读入形状的属性content去进行修改

    final watermark5Gradient = LinearGradient(
      colors: [
        "546071".hex,
        '687995'.hex,
      ],
    );
    final listTime = [HH, nn, ss];
    final content = watermarkData?.content;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: listTime.map((item) {
            return Row(
              children: [
                IntrinsicHeight(
                  child: FutureBuilder(
                      future: WatermarkService.getImagePath(
                          templateId.toString(),
                          fileName: timeShape),
                      builder: (context, snapshot) {
                        return FutureBuilder(
                            future: Utils.calculateImageWidth(
                                imagePath: snapshot.data,
                                height: textFrame?.height),
                            builder: (context, s) {
                              final h = textFrame?.height;
                              final w = textFrame?.width;
                              final w2 = s.data;
                              return WatermarkFrameBox(
                                  watermarkId: templateId,
                                  frame: textFrame?.copyWith(width: s.data),
                                  style: textStyle,
                                  imagePath: snapshot.data,
                                  child: Center(
                                    child: StreamBuilder(
                                      stream: Stream.periodic(
                                        const Duration(seconds: 1),
                                      ),
                                      builder: (context, snap) {
                                        return WatermarkFontBox(
                                          textStyle: textStyle,
                                          text: (snap.data ??
                                              formatDate(timeContent, [item])),
                                          font: font2,
                                        );
                                      },
                                    ),
                                  ));
                            });
                      }),
                ),
                Visibility(
                  visible: item != ss,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                    child:
                        // WatermarkFontBox(
                        //     textStyle: textStyle, text: ":", font: font2?.copyWith(size: 21))

                        Text(
                      ":",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: font2?.name,
                          fontSize: font2?.size?.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        6.h.verticalSpace,
        Row(
          children: [
            Baseline(
                baseline: 12.w,
                baselineType: TextBaseline.alphabetic,
                child: WatermarkFontBox(
                  textStyle: textStyle,
                  text: formatDate(timeContent, [
                    yyyy,
                    '-',
                    mm,
                    "-",
                    dd,
                  ]),
                  font: font,
                  //height: 1,
                )
                // Text(
                //   formatDate(timeContent, [
                //     yyyy,
                //     '-',
                //     mm,
                //     "-",
                //     dd,
                //   ]),
                //   style: TextStyle(
                //     fontSize: (font?.size ?? 0).sp,
                //     fontFamily: font?.name ?? defultFontFamily,
                //     // fontWeight: FontWeight.bold,
                //     color: textColor?.color
                //         ?.hexToColor(textColor.alpha?.toDouble()),
                //     // height: 1.5,
                //   ),
                // ),

                ),
            8.w.horizontalSpace,
            Baseline(
              baseline: 10.w,
              baselineType: TextBaseline.alphabetic,
              child: WatermarkFontBox(
                text: formatDate(timeContent,
                    ['星期', Lunar.fromDate(timeContent).getWeekInChinese()]),
                font: font?.copyWith(name: null),
                // fontWeight: FontWeight.bold,
                textStyle: textStyle,
                //height: 1,
              ),
            ),
          ],
        ),
        2.h.verticalSpace,
        WatermarkFrameBox(
          watermarkId: templateId,
          frame: singleLineFrame?.copyWith(height: 2.5.w),
          style: singleLineStyle,
        ),
      ],
    );
  }
}

class RYWatermarkTime14 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime14(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final textColor = watermarkData.style?.textColor;
    final singleLineFrame = watermarkData.signLine?.frame;
    final singleLineStyle = watermarkData.signLine?.style;

    return IntrinsicHeight(
      child: Row(
        children: [
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1), (int count) {
                return formatDate(timeContent, [HH, ':', nn]);
              }),
              builder: (context, snapshot) {
                return WatermarkFontBox(
                  text: snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                  textStyle: textStyle,
                  font: fonts?['font'],
                );
              }),
          WatermarkFrameBox(
            watermarkId: templateId,
            frame: singleLineFrame,
            style: singleLineStyle,
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WatermarkFontBox(
                    //height: 1,
                    text: formatDate(timeContent, [
                      yyyy,
                      '-',
                      mm,
                      "-",
                      dd,
                    ]),
                    font: fonts?['font2'],
                    textStyle: textStyle,
                  ),
                  Row(
                    children: [
                      WatermarkFontBox(
                        //height: 1,
                        text: formatDate(timeContent, [
                          '星期',
                          Lunar.fromDate(timeContent).getWeekInChinese()
                        ]),
                        font: fonts?['font3'],
                        textStyle: textStyle,
                      ),
                      // Expanded(
                      //     child: RyWatermarkWeather(
                      //   watermarkData: watermarkData,
                      //   resource: resource,
                      // )),
                    ],
                  ),
                  // Text(
                  //   formatDate(timeContent, [
                  //     yyyy,
                  //     '-',
                  //     mm,
                  //     "-",
                  //     dd,
                  //   ]),
                  //   style: TextStyle(
                  //       color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  //       fontFamily: fonts?['font2']?.name??defultFontFamily,
                  //       fontSize: fonts?['font2']?.size,
                  //       height: 1),
                  // ),
                  // Text(
                  //   formatDate(timeContent, [
                  //     '星期',
                  //     Lunar.fromDate(timeContent).getWeekInChinese()
                  //   ]),
                  //   style: TextStyle(
                  //       color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  //       fontFamily: fonts?['font3']?.name??defultFontFamily,
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
  final WatermarkResource resource;

  const RYWatermarkTime15(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    final singleLineFrame = watermarkData.signLine?.frame;
    final singleLineStyle = watermarkData.signLine?.style;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                textAlign: TextAlign.center,
                snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                style: TextStyle(
                  fontSize: (font?.size ?? 0).sp,
                  fontFamily: font?.name ?? defultFontFamily,
                  color:
                      textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  // height: 1
                ),
              );
            }),
        WatermarkFrameBox(
          watermarkId: templateId,
          style: singleLineStyle,
          frame: singleLineFrame,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WatermarkFontBox(
                text: formatDate(timeContent, [
                  yyyy,
                  '/',
                  mm,
                  "/",
                  dd,
                ]),
                font: fonts?['font2'],
                textStyle: textStyle,
                height: 1.6,
              ),
              Text(
                formatDate(timeContent, [
                  '星期',
                  Lunar.fromDate(timeContent).getWeekInChinese(),
                ]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: fonts?['font3']?.name ?? defultFontFamily,
                  fontSize: fonts?['font3']?.size != null
                      ? (fonts?['font3']?.size!.sp)
                      : null,
                  //height: 1
                ),
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
  final WatermarkResource resource;

  const RYWatermarkTime16(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

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
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: font?.name ?? defultFontFamily,
                  fontSize: (font?.size ?? 0).sp,
                  //height: 1
                ),
              );
            }),
        SizedBox(
          width: 10.0.w,
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(timeContent, [
                '星期',
                Lunar.fromDate(timeContent).getWeekInChinese(),
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
                    formatDate(timeContent, [
                      '星期',
                      Lunar.fromDate(timeContent).getWeekInChinese(),
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
                  fontFamily: font2?.name ?? defultFontFamily,
                  fontSize: (font2?.size ?? 0).sp,
                  //height: 1
                ),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime17 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime17(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];

    return StreamBuilder(
        stream: Stream.periodic(const Duration(minutes: 1), (int count) {
          return formatDate(timeContent, [HH, ':', nn]);
        }),
        builder: (context, snapshot) {
          return Align(
            alignment: Alignment.centerRight,
            child: Text(
              snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
              // textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    textColor?.color?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.white,
                fontFamily: font?.name ?? defultFontFamily,
                fontSize: (font?.size ?? 0).sp,
                //height: 1
              ),
            ),
          );
        });
  }
}

class RYWatermarkTime18 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final Widget? weatherWidget;

  const RYWatermarkTime18(
      {super.key,
      required this.watermarkData,
      required this.resource,
      this.weatherWidget});

  int get watermarkId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final singleLineFrame = watermarkData.signLine?.frame;
    final singleLineStyle = watermarkData.signLine?.style;

    // final timeSpaceWidget = _buildTimeSpaceWidget();
    return IntrinsicHeight(
      child: Row(
        children: [
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1), (int count) {
                return formatDate(timeContent, [HH, ':', nn]);
              }),
              initialData: formatDate(timeContent, [HH, ':', nn]),
              builder: (context, snapshot) {
                return
                    // GradientTimeText(
                    //   text: snapshot.data ?? '',
                    //   imagePath: "wavyline1b".webp,
                    //   textStyle: TextStyle(
                    //     fontSize: textStyle?.fonts?['font']?.size?.sp,
                    //     // fontWeight: FontWeight.bold,
                    //     fontFamily: "water_111_bottom",
                    //     // textStyle?.fonts?['font']?.name??defultFontFamily,
                    //     height: 1,
                    //     color: Colors.white,
                    //   ),
                    // );

                    AssertsImageBuilder(
                  "wavyline1b".webp,
                  builder: (context, imageInfo) {
                    if (imageInfo == null) {
                      return WatermarkFontBox(
                        text: snapshot.data ?? '',
                        textStyle: textStyle,
                        font: fonts?['font'],
                      );
                    }
                    return ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) {
                        final image = imageInfo.image;
                        final double scaleX = bounds.width / image.width;
                        final double scaleY = bounds.height / image.height;
                        // 创建变换矩阵
                        final Matrix4 matrix = Matrix4.identity()
                          ..scale(scaleX, scaleY);
                        return ImageShader(
                          imageInfo.image,
                          TileMode.clamp,
                          TileMode.clamp,
                          matrix.storage,
                        );
                      },
                      child: WatermarkFontBox(
                        text: snapshot.data ?? '',
                        textStyle: textStyle,
                        font: fonts?['font'],
                      ),
                    );
                  },
                );
              }),

          // StreamBuilder(
          //     stream: Stream.periodic(const Duration(seconds: 15), (int count) {
          //       return formatDate(timeContent, [HH, ':', nn]);
          //     }),
          //     initialData: formatDate(timeContent, [HH, ':', nn]),
          //     builder: (context, snapshot) {
          //       final timeString = snapshot.data;
          //       if (timeString != null) {
          //         return Row(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             children: [
          //               ...timeString
          //                   .split(':')[0]
          //                   .split('')
          //                   .mapIndexed((index, item) {
          //                 return FutureBuilder(
          //                     future: WatermarkService.getImagePath(
          //                         watermarkId.toString(),
          //                         fileName: 'time${index + 1}_${item}_img'),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.data != null) {
          //                         return Image.file(File(snapshot.data!),
          //                             height: 28.w, fit: BoxFit.cover);
          //                       }
          //                       return const SizedBox.shrink();
          //                     });
          //               }).toList(),
          //               timeSpaceWidget,
          //               ...timeString
          //                   .split(':')[1]
          //                   .split('')
          //                   .mapIndexed((index, item) {
          //                 return FutureBuilder(
          //                     future: WatermarkService.getImagePath(
          //                         watermarkId.toString(),
          //                         fileName: 'time${index + 3}_${item}_img'),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.data != null) {
          //                         return Image.file(File(snapshot.data!),
          //                             height: 28.w, fit: BoxFit.cover);
          //                       }
          //                       return const SizedBox.shrink();
          //                     });
          //               })
          //             ]);
          //       }
          //       return const SizedBox.shrink();
          //     }),

          WatermarkFrameBox(
            watermarkId: watermarkId,
            frame: singleLineFrame,
            style: singleLineStyle,
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WatermarkFontBox(
                    //height: 1,
                    text: formatDate(timeContent, [
                      yyyy,
                      '-',
                      mm,
                      "-",
                      dd,
                    ]),
                    font: fonts?['font3'],
                    textStyle: textStyle,
                  ),
                  Row(
                    children: [
                      WatermarkFontBox(
                        text: formatDate(timeContent, [
                          '星期',
                          Lunar.fromDate(timeContent).getWeekInChinese()
                        ]),
                        font: fonts?['font3'],
                        textStyle: textStyle,
                        //height: 1,
                      ),
                      Expanded(child: weatherWidget ?? const SizedBox.shrink()),
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

  Widget _buildTimeSpaceWidget() {
    return FutureBuilder(
        future: WatermarkService.getImagePath(watermarkId.toString(),
            fileName: 'time_space_img'),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Image.file(File(snapshot.data!),
                height: 15.w, fit: BoxFit.cover);
          }

          return const SizedBox.shrink();
        });
  }
}

class RYWatermarkTime19 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime19(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    // final textStyle = watermarkData.style?.textStyle;
    final textColor = Styles.whiteTextColor;
    // WatermarkBackgroundColor(color: "#FFFFFF", alpha: 1);
    var font2 = fonts?['font2'];

    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(minutes: 1), (int count) {
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                '上午',
                // snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: font2?.name ?? defultFontFamily,
                  fontSize: (font2?.size ?? 0).sp,
                  //height: 1
                ),
              );
            }),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            width: 3,
            height: 20,
            child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.amber))),
        StreamBuilder(
            stream: Stream.periodic(const Duration(minutes: 1), (int count) {
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: font2?.name ?? defultFontFamily,
                  fontSize: (font2?.size ?? 0).sp,
                  //height: 1
                ),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime20 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime20(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

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
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                textAlign: TextAlign.end,
                snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                style: TextStyle(
                  fontSize: (font?.size ?? 0).sp,
                  fontFamily: font?.name ?? defultFontFamily,
                  color:
                      textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  //height: 1
                ),
              );
            }),
        SizedBox(
          width: 10.0.sp,
        ),
        Text(
          // textAlign: TextAlign.start,
          formatDate(timeContent, [
            yyyy,
            '.',
            mm,
            ".",
            dd,
          ]),
          style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
              fontSize: fonts?['font2']?.size != null
                  ? (fonts?['font2']?.size!.sp)
                  : null,
              fontFamily: fonts?['font2']?.name ?? defultFontFamily,
              color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
              height: 1.6),
        ),
        // WatermarkFontBox
// (
        //   text: formatDate(timeContent, [
        //     yyyy,
        //     '.',
        //     mm,
        //     ".",
        //     dd,
        //   ]),
        //   font: fonts?['font2'],
        //   textStyle: textStyle,
        // ),
      ],
    );
  }
}

class RYWatermarkTime21 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime21(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];
    final signLine = watermarkData.signLine;

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                        return formatDate(timeContent, [HH]);
                      }),
                      builder: (context, snapshot) {
                        return Text(
                          textAlign: TextAlign.end,
                          snapshot.data ?? formatDate(timeContent, [HH]),
                          style: TextStyle(
                            fontSize: (font?.size ?? 0).sp,
                            fontFamily: font?.name ?? defultFontFamily,
                            color: textColor?.color
                                ?.hexToColor(textColor.alpha?.toDouble()),
                            // height: 1
                          ),
                        );
                      }),
                  Text(
                    ':',
                    style: TextStyle(
                      fontWeight: font?.fontWeight,
                      fontSize: (font?.size ?? 0).sp,
                      fontFamily: font?.name ?? defultFontFamily,
                      color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()),
                      // height: 1
                    ),
                  ),
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(minutes: 1),
                          (int count) {
                        return formatDate(timeContent, [nn]);
                      }),
                      builder: (context, snapshot) {
                        return Text(
                          textAlign: TextAlign.end,
                          snapshot.data ?? formatDate(timeContent, [nn]),
                          style: TextStyle(
                            fontWeight: font?.fontWeight,
                            fontSize: (font?.size ?? 0).sp,
                            fontFamily: font?.name ?? defultFontFamily,
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
                formatDate(timeContent, [
                  yyyy,
                  '.',
                  mm,
                  ".",
                  dd,
                ]),
                style: TextStyle(
                  fontWeight: font?.fontWeight,
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: fonts?['font2']?.size != null
                      ? (fonts?['font2']?.size!.sp)
                      : null,
                  fontFamily: fonts?['font2']?.name ?? defultFontFamily,
                  color:
                      textColor?.color?.hexToColor(textColor.alpha?.toDouble()),
                  // height: 1
                ),
              ),
            ],
          ),
          WatermarkFrameBox(
            watermarkId: templateId,
            frame: signLine?.frame,
            style: signLine?.style,
          ),
        ],
      ),
    );
  }
}

class RYWatermarkTime24 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime24(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

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
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: font2?.name ?? defultFontFamily,
                  // 'DINPro-Medium_13936',
                  fontSize: (font2?.size ?? 0).sp,
                  //height: 1
                ),
              );
            }),
        SizedBox(
          width: 5.w,
        ),
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(timeContent, [yyyy, '年', mm, '月', dd, '日']);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ??
                    formatDate(timeContent, [yyyy, '年', mm, '月', dd, '日']),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: font?.name ?? defultFontFamily,
                  fontSize: (font?.size ?? 0).sp,
                  //height: 1
                ),
              );
            }),
      ],
    );
  }
}

class RYWatermarkTime28 extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;

  const RYWatermarkTime28(
      {super.key, required this.watermarkData, required this.resource});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final textColor = textStyle?.textColor;
    var font = fonts?['font'];
    final img = watermarkData.image;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1), (int count) {
              return formatDate(timeContent, [HH, ':', nn]);
            }),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? formatDate(timeContent, [HH, ':', nn]),
                // textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor?.color
                          ?.hexToColor(textColor.alpha?.toDouble()) ??
                      Colors.white,
                  fontFamily: font?.name ?? defultFontFamily,
                  fontSize: 30.sp,
                  //height: 1
                ),
              );
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: WatermarkFontBox(
                text: formatDate(timeContent, [
                  yyyy,
                  '-',
                  mm,
                  "-",
                  dd,
                  ' ',
                  '星期',
                  Lunar.fromDate(timeContent).getWeekInChinese()
                ]),
                font: fonts?['font'],
                textStyle: textStyle,
                //height: 1,
              ),
            ),
            FutureBuilder(
                future: WatermarkService.getImagePath(templateId.toString(),
                    fileName: img),
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
                resource: resource,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RYWatermarkTimeTitleSeparate extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final String? suffix;

  const RYWatermarkTimeTitleSeparate(
      {super.key,
      required this.watermarkData,
      required this.resource,
      this.suffix});

  int get templateId => resource.id ?? 0;

  DateTime get timeContent {
    if (watermarkData.content != '' && watermarkData.content != null) {
      return DateTime.parse(watermarkData.content!);
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textStyle = watermarkData.style;
    final frame = watermarkData.frame;
    final style = watermarkData.style;
    final titleVisible = watermarkData.isWithTitle;
    final titleText = watermarkData.title;
    bool haveColon = FormUtils.haveColon(templateId);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
            minWidth: watermarkData.style?.titleMaxWidth ?? 78.w,
          ),
          child: WatermarkFrameBox(
            watermarkId: templateId,
            frame: watermarkData.frame,
            style: watermarkData.style,
            child: WatermarkGeneralItem(
              watermarkData: watermarkData,
              suffix: suffix,
              templateId: templateId,
              textAlign: TextAlign.justify,
              text: titleText,
            ),
          ),
        ),
        if (haveColon)
          WatermarkFrameBox(
            watermarkId: templateId,
            frame: WatermarkFrame(
                left: 0, top: (watermarkData.frame?.top ?? 0) + 1),
            style: watermarkData.style,
            child: WatermarkGeneralItem(
              watermarkData: watermarkData,
              suffix: suffix,
              templateId: templateId,
              textAlign: TextAlign.justify,
              text: ":",
              // hexColor: "",
            ),
          ),
        // 时间
        Expanded(
            child: StreamBuilder(
                stream:
                    Stream.periodic(const Duration(minutes: 1), (int count) {
                  return formatDate(timeContent, [hh, ':', nn]);
                }),
                builder: (context, snapshot) {
                  String time1 =
                      formatDate(timeContent, [yyyy, '.', mm, '.', dd]);
                  String time2 =
                      formatDate(timeContent, [' ', HH, ':', nn, ':', ss]);

                  // String time3 = formatDate(timeContent,
                  //     [' 星期', Lunar.fromDate(timeContent).getWeekInChinese()]);

                  return WatermarkFrameBox(
                    frame: frame,
                    style: style,
                    watermarkId: templateId,
                    child: Wrap(
                      alignment: WrapAlignment.start, // 主轴方向的对齐方式
                      runAlignment: WrapAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WatermarkFontBox(
                          text: time1,
                          font: fonts?['font'],
                          textStyle: textStyle,
                          isBold: templateId == 16982153599988,
                          //height: 1,
                        ),
                        Visibility(
                          visible: templateId == 1698049456677 ||
                              templateId == 1698049457777,
                          child: WatermarkFontBox(
                            text: formatDate(timeContent, [
                              ' 星期',
                              Lunar.fromDate(timeContent).getWeekInChinese()
                            ]),
                            font: fonts?['font'],
                            textStyle: textStyle,
                            height: 1,
                          ),
                        ),
                        WatermarkFontBox(
                          text: time2,
                          font: fonts?['font'],
                          textStyle: textStyle,
                          isBold: templateId == 16982153599988,
                          //height: 1,
                        ),
                      ],
                    ),
                  );
                })),
      ],
    );
  }
}

// class WatermarkTimeTypeFontBox
//  extends StatelessWidget {
//   final WatermarkFont? font;
//   final WatermarkBackgroundColor? textColor;
//   final TextAlign? textAlign;
//   final String text;
//   final double? textHeight;

//   const WatermarkTimeTypeFontBox
// (
//       {super.key,
//       this.textAlign,
//       required this.font,
//       required this.text,
//       required this.textColor,
//       this.textHeight});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       textAlign: textAlign,
//       style: TextStyle(
//           color: textColor?.color?.hexToColor(textColor?.alpha?.toDouble()),
//           fontFamily:
//               // "water_111_bottom",
//               font?.name ?? defultFontFamily,
//           fontSize: (font?.size ?? 0).sp,
//           height: textHeight),
//     );
//   }
// }
