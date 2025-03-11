import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cubit/resource_cubit.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';
import 'package:watermark_camera/utils/watermark.dart';

class YWatermarkTitleBar extends StatelessWidget {
  final WatermarkData watermarkData;
  const YWatermarkTitleBar({
    super.key,
    required this.watermarkData,
  });

  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    WatermarkView? watermarkView = context.read<WatermarkCubit>().watermarkView;
    final template = context
        .read<ResourceCubit>()
        .templates
        .firstWhereOrNull((e) => e.id == watermarkId);
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
          future: readImage(watermarkId.toString(), watermarkData.image),
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
            template?.id != 16986607549321 &&
            (template?.cid == 4 || template?.cid == 1) &&
            template?.id != 16982153599988 &&
            template?.id != 16982153599999 ||
        template?.id == 1698049811111 ||
        template?.id == 16983971079955 ||
        template?.id == 16983971077788) {
      circlePoint = Container(
        margin: EdgeInsets.only(left: watermarkView?.frame?.left ?? 0),
        width: template?.id == 1698049811111 ? 8 : 5,
        height: template?.id == 1698049811111 ? 8 : 5,
        decoration: BoxDecoration(
            borderRadius: template?.id == 1698049811111
                ? BorderRadius.zero
                : BorderRadius.circular(50),
            color:
                viewBgColor?.color?.hexToColor(viewBgColor.alpha?.toDouble())),
      );
    }

    if (template?.id == 1698049811111) {
      circlePoint = Container(
        margin: EdgeInsets.only(left: watermarkView?.frame?.left ?? 0),
        width: template?.id == 1698049811111 ? 8 : 5,
        height: template?.id == 1698049811111 ? 8 : 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.zero
            color:
               Color(int.parse("#fdb900".replaceAll("#", "0xFF")))),
      );
    }
    if (backgroundColor != null &&
        (template?.id == 16982153599988 || template?.id == 16982153599999)) {
      imageWidget = FutureBuilder(
          future: readImage(watermarkId.toString(), watermarkData.image),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: backgroundColor?.color
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
                    color: textColor?.color
                            ?.hexToColor(textColor.alpha?.toDouble()) ??
                        Colors.transparent,
                    width: 15)
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
                    watermarkId == 16982153599988 ||
                    watermarkId == 16982153599999 ||
                    watermarkId == 1698215359120
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              SizedBox(
                width: watermarkId == 16982153599988 ||
                        watermarkId == 16982153599999 ||
                        watermarkId == 1698215359120
                    ? layout?.imageTitleSpace
                    : 0,
              ),
              Text(
                watermarkData.content ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor?.color
                        ?.hexToColor(textColor.alpha?.toDouble()),
                    fontFamily: font?.name,
                    fontSize: font?.size),
              ),
            ],
          ),
          imageWidget,
        ],
      ),
    );
  }
}
