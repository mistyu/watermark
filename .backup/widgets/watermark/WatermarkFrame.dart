import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cubit/watermark_cubit.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/extension.dart';

class WatermarkFrameBox extends StatefulWidget {
  final WatermarkFrame? frame;
  final WatermarkStyle? style;
  final String? imagePath;
  final Widget? child;
  final WatermarkSignLine? signLine;
  final WatermarkData? watermarkData;
  const WatermarkFrameBox(
      {super.key,
      this.frame,
      required this.style,
      this.imagePath,
      this.child,
      this.signLine,
      this.watermarkData});
  @override
  State<WatermarkFrameBox> createState() => _WatermarkFrameBoxState();
}

class _WatermarkFrameBoxState extends State<WatermarkFrameBox> {
  @override
  Widget build(BuildContext context) {
    int watermarkId = context.read<WatermarkCubit>().watermarkId;
    final frame = widget.frame;
    final style = widget.style;
    final signLine = widget.signLine;
    final watermarkData = widget.watermarkData;
    final imagePath = widget.imagePath;
    final child = widget.child;

    final width = frame?.width;
    final height = frame?.height;
    final margin_left = frame?.left ?? 0;
    final margin_right = frame?.right ?? 0;
    final margin_top = frame?.top ?? 0;
    final margin_bottom = frame?.bottom ?? 0;
    final padding_left = style?.padding?.left ?? 0;
    final padding_right = style?.padding?.right ?? 0;
    final padding_top = style?.padding?.top ?? 0;
    final padding_bottom = style?.padding?.bottom ?? 0;
    final signline_style = signLine?.style;
    final signline_frame = signLine?.frame;

    BoxDecoration twoBoxDecoration() {
      final gradient = style?.gradient;
      if (gradient != null &&
          gradient.colors != null &&
          watermarkData?.type != 'RYWatermarkTimeDivision') {
        final color1 = gradient.colors?[0];
        final color2 = gradient.colors?[1];
        return BoxDecoration(
          border: Border(
              left: watermarkId == 1698059986262
                  ? BorderSide.none
                  : BorderSide(
                      color: signline_style?.backgroundColor?.color?.hexToColor(
                              signline_style.backgroundColor?.alpha
                                  ?.toDouble()) ??
                          Colors.transparent,
                      width: (signline_frame?.width ?? 0).w,
                      style: ((signline_frame?.width == null) ||
                              (signline_frame?.width == 0))
                          ? BorderStyle.none
                          : BorderStyle.solid),
              bottom: watermarkId == 1698059986262
                  ? BorderSide(
                      color: signline_style?.backgroundColor?.color?.hexToColor(
                              signline_style.backgroundColor?.alpha?.toDouble()) ??
                          Colors.transparent,
                      width: (signline_frame?.width ?? 0).w,
                      style: ((signline_frame?.width == null) || (signline_frame?.width == 0)) ? BorderStyle.none : BorderStyle.solid)
                  : BorderSide.none),
          borderRadius: BorderRadius.circular(style?.radius ?? 0).w,
          image: imagePath != null
              ? DecorationImage(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.contain,
                  image: FileImage(File(imagePath!)))
              : null,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              color1?.color?.hexToColor(color1.alpha?.toDouble()) ??
                  Colors.transparent,
              color2?.color?.hexToColor(color2.alpha?.toDouble()) ??
                  Colors.transparent
            ],
            stops: [gradient.from?["x"] ?? 0.0, gradient.to?["x"] ?? 0.0],
          ),
        );
      }
      return BoxDecoration(
        border: watermarkId == 1698215359120
            ? Border.symmetric(
                vertical: BorderSide(
                    color: signline_style?.backgroundColor?.color?.hexToColor(signline_style.backgroundColor?.alpha?.toDouble()) ??
                        Colors.transparent,
                    width: (signline_frame?.width ?? 0).w,
                    style: ((signline_frame?.width == null) || (signline_frame?.width == 0))
                        ? BorderStyle.none
                        : BorderStyle.solid))
            : Border(
                left: watermarkId == 1698059986262
                    ? BorderSide.none
                    : BorderSide(
                        color: signline_style?.backgroundColor?.color?.hexToColor(signline_style.backgroundColor?.alpha?.toDouble()) ??
                            Colors.transparent,
                        width: (signline_frame?.width ?? 0).w,
                        style: ((signline_frame?.width == null) || (signline_frame?.width == 0))
                            ? BorderStyle.none
                            : BorderStyle.solid),
                bottom: watermarkId == 1698059986262
                    ? BorderSide(
                        color: signline_style?.backgroundColor?.color?.hexToColor(signline_style.backgroundColor?.alpha?.toDouble()) ?? Colors.transparent,
                        width: (signline_frame?.width ?? 0).w,
                        style: ((signline_frame?.width == null) || (signline_frame?.width == 0)) ? BorderStyle.none : BorderStyle.solid)
                    : BorderSide.none),
        borderRadius: BorderRadius.circular(style?.radius ?? 0).w,
        image: imagePath != null
            ? DecorationImage(
                alignment: Alignment.centerLeft,
                fit: BoxFit.contain,
                image: FileImage(File(imagePath!)))
            : null,
        color: (style?.backgroundColor == null) ||
                (watermarkId == 16983723692185) ||
                ((watermarkId == 16982153599988 ||
                        watermarkId == 16982153599999) &&
                    watermarkData?.type == "YWatermarkTitleBar")
            ? Colors.transparent
            : style?.backgroundColor?.color
                ?.hexToColor(style?.backgroundColor?.alpha?.toDouble()),
      );
    }

    Future<double?> loadImageWidth() async {
      if (imagePath != null && height != null) {
        final imageProvider = FileImage(File(imagePath));
        // 完成图片加载的Completer
        final Completer<double> completer = Completer<double>();

        // 定义图片加载监听器
        final ImageStreamListener listener = ImageStreamListener(
          (ImageInfo info, bool synchronousCall) {
            // 图片加载完成，获取图片的宽高比
            final aspectRatio =
                info.image.width.toDouble() / info.image.height.toDouble();
            // 完成completer
            completer.complete(aspectRatio);
          },
          onError: (exception, stackTrace) {
            // 图片加载失败，完成completer并传递异常
            completer.completeError(exception, stackTrace);
          },
        );

        // 获取图片的ImageStream
        final ImageStream stream =
            imageProvider.resolve(const ImageConfiguration());

        // 为ImageStream添加监听器
        stream.addListener(listener);

        final aspectRatio = await completer.future;
        return height * aspectRatio;
      }
      return null;
    }

    return FutureBuilder(
        future: loadImageWidth(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          return Container(
            width: (width ?? snapshot.data),
            height: height != null ? height.w : height,
            margin: EdgeInsets.only(
              left: margin_left.abs().w,
              right: margin_right.abs().w,
              top: margin_top.abs().w,
              bottom: margin_bottom.abs().w,
            ),
            padding: EdgeInsets.only(
              left: padding_left.w,
              right: padding_right.w,
              top: padding_top.w,
              bottom: padding_bottom.w,
            ),
            decoration: twoBoxDecoration(),
            child: child,
          );
        });
  }
}
