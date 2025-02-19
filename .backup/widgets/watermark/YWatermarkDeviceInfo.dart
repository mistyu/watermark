import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'WatermarkFrame.dart';

class YWatermarkDeviceInfo extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkDeviceInfo({super.key, required this.watermarkData});

  @override
  Widget build(BuildContext context) {
    final fonts = watermarkData.style?.fonts;
    final textColor = watermarkData.style?.textColor;
    var font = fonts?['font'];

    return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1), (int count) {
          return formatDate(DateTime.now(), [HH, ':', nn]);
        }),
        builder: (context, snapshot) {
          return Text(
            "设备信息" ?? formatDate(DateTime.now(), [HH, ':', nn]),
            // textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor?.color?.hexToColor(textColor.alpha?.toDouble()) ??
                    Colors.white,
                fontFamily: font?.name,
                fontSize: font?.size,
                height: 1),
          );
        });
  }
}
