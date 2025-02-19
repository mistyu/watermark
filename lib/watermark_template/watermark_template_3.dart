import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

import 'package:collection/collection.dart';

class WatermarkTemplate3 extends StatelessWidget {
  final WatermarkView watermarkView;
  final WatermarkResource resource;

  const WatermarkTemplate3({
    super.key,
    required this.resource,
    required this.watermarkView,
  });

  int get watermarkId => resource.id ?? 0;
  WatermarkData? get timeDivisionData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTimeDivision');
  WatermarkData? get timeData => watermarkView.tables?["table1"]?.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkTime');
  WatermarkData? get logoData => watermarkView.data
      ?.firstWhereOrNull((data) => data.type == 'RYWatermarkBrandLogo');

  DateTime get timeContent {
    if (timeData?.content != '' && timeData?.content != null) {
      return DateTime.parse(timeData?.content! ?? '');
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final fonts = timeDivisionData?.style?.fonts;
    final font = fonts?['font'];
    final font2 = fonts?['font2'];
    final textColor = timeDivisionData?.style?.textColor;

    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1), (int count) {
          return formatDate(timeContent, [
            HH,
            ':',
            nn,
          ]);
        }),
        builder: (context, snapshot) {
          return IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: "19b3ef".hex,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5.0.r)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Center(
                      child: Text(
                        "打卡记录",
                        style: TextStyle(
                            color: const Color(0xccffffff),
                            fontFamily: "MiSans-Regular",
                            fontSize: font?.size?.sp,
                            height: 1),
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(5.0.r)),
                  ),
                  padding: EdgeInsets.only(bottom: 2.5.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      snapshot.data ??
                          formatDate(timeContent, [
                            HH,
                            ':',
                            nn,
                          ]),
                      style: TextStyle(
                        color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()),
                        fontFamily: "MiSans-Medium",
                        // font2?.name,
                        fontSize: font2?.size?.sp,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
