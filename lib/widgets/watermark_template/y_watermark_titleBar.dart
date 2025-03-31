import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';

class YWatermarkTitleBar extends StatelessWidget {
  final WatermarkData watermarkData;
  final WatermarkResource resource;
  final WatermarkView? watermarkView;

  const YWatermarkTitleBar(
      {super.key,
      required this.watermarkData,
      required this.resource,
      required this.watermarkView});
  int get watermarkId => resource.id ?? 0;
  @override
  Widget build(BuildContext context) {
    // WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;

    final fonts = watermarkData.style?.fonts;
    final frame = watermarkData.frame;
    final dataStyle = watermarkData.style;
    final textColor = watermarkData.style?.textColor;
    final backgroundColor = watermarkData.style?.backgroundColor;
    var font = fonts?['font'];
    final viewBgColor = watermarkView?.style?.backgroundColor;
    final layout = dataStyle?.layout;

    Widget? imageWidget = const SizedBox.shrink();
    Widget? circlePoint = const SizedBox.shrink();

    if (watermarkData.image != null && watermarkData.image!.isNotEmpty) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                padding: EdgeInsets.only(
                    left: layout?.imageTitleLayout == "imageLeft"
                        ? layout?.imageTitleSpace ?? 0
                        : 0,
                    right: layout?.imageTitleLayout == "imageRight"
                        ? layout?.imageTitleSpace ?? 0
                        : 0,
                    top: layout?.imageTopSpace?.abs() ?? 0),
                child: Image.file(File(snapshot.data!),
                    width: dataStyle?.iconWidth?.toDouble() ?? 30,
                    fit: BoxFit.cover),
              );
            }

            return const SizedBox.shrink();
          });
    }

    if (viewBgColor != null &&
            watermarkId != 16986607549321 &&
            resource.cid == 4 &&
            watermarkId != 16982153599999 ||
        watermarkId == 1698049811111 ||
        watermarkId == 16983971079955 ||
        watermarkId == 16983971077788) {
      circlePoint = Container(
        margin: EdgeInsets.only(left: watermarkView?.frame?.left ?? 0),
        width: (watermarkId == 1698049811111 ? 8 : 6).w,
        height: (watermarkId == 1698049811111 ? 8 : 6).w,
        decoration: BoxDecoration(
            borderRadius: watermarkId == 1698049811111
                ? BorderRadius.zero
                : BorderRadius.circular(50),
            color:
                viewBgColor?.color?.hexToColor(viewBgColor.alpha?.toDouble())),
      );
    }

    if (watermarkId == 1698049811111) {
      circlePoint = Container(
        margin: EdgeInsets.only(left: watermarkView?.frame?.left ?? 0),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.zero,
            color: Color(int.parse("#fdb900".replaceAll("#", "0xFF")))),
      );
    }

    if (backgroundColor != null && (watermarkId == 16982153599999)) {
      imageWidget = FutureBuilder(
          future: WatermarkService.getImagePath(watermarkId.toString(),
              fileName: watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: backgroundColor.color
                            ?.hexToColor(backgroundColor.alpha?.toDouble())),
                    // child:
                    transform: Matrix4.rotationZ(.8.w),
                    transformAlignment: Alignment.center,
                  ),
                  Positioned(
                    child: Image.file(File(snapshot.data!),
                        width: dataStyle?.iconWidth?.toDouble() ?? 30,
                        fit: BoxFit.cover),
                  )
                ],
              );
            }

            return const SizedBox.shrink();
          });
    }
    print("xiaojianjian 返回这个颜色");
    return Container(
      padding: EdgeInsets.only(left: frame?.left ?? 0),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            dataStyle?.gradient?.colors?[0].color?.hexToColor(
                    dataStyle.gradient?.colors?[0].alpha?.toDouble()) ??
                Colors.transparent,
            dataStyle?.gradient?.colors?[1].color?.hexToColor(
                    dataStyle.gradient?.colors?[1].alpha?.toDouble()) ??
                Colors.transparent
          ]),
          borderRadius:
              BorderRadius.all(Radius.circular(dataStyle?.radius ?? 0).r),
          border: Border(
            left: watermarkId == 1698049354422
                ? BorderSide(
                    color:
                        textColor?.color?.hexToColor(1) ?? Colors.transparent,
                    width: 20)
                : BorderSide.none,
          )),
      child: Stack(
        alignment: layout?.imageTitleLayout == "imageRight"
            ? Alignment.centerRight
            : Alignment.centerLeft,
        children: [
          circlePoint,
          Row(
            mainAxisSize:
                // watermarkId == 1698049443671
                //     ? MainAxisSize.min
                //     :
                MainAxisSize.max,
            mainAxisAlignment: watermarkId == 16983971714930 ||
                    watermarkId == 16982153599999 ||
                    watermarkId == 1698215359120 ||
                    watermarkId == 1698049354422
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              SizedBox(
                width: watermarkId == 16982153599999 ||
                        watermarkId == 1698215359120
                    ? layout?.imageTitleSpace
                    : 0,
              ),
              watermarkId == 1698049354422
                  ? const SizedBox(width: 12)
                  : const SizedBox(),
              WatermarkFontBox(
                textStyle: dataStyle,
                text: watermarkData.content ?? '',
                font: font,
                hexColor: watermarkId == 1698049354422 ? "#25568b" : null,
              ),
            ],
          ),
          imageWidget,
        ],
      ),
    );
  }
}
