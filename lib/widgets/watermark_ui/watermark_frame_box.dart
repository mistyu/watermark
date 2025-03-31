import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

class WatermarkFrameBox extends StatelessWidget {
  final String? imagePath;
  final WatermarkFrame? frame;
  final WatermarkStyle? style;
  final Widget? child;
  final WatermarkSignLine? signLine;
  final WatermarkData? watermarkData;
  final int? watermarkId;
  final bool? isAdaptTextWidth; //是否需要适应文字宽度
  const WatermarkFrameBox(
      {super.key,
      this.watermarkId,
      this.frame,
      this.style,
      this.imagePath,
      this.child,
      this.signLine,
      this.watermarkData,
      this.isAdaptTextWidth});

  @override
  Widget build(BuildContext context) {
    final width = frame?.width;
    double? height = frame?.height;
    final marginLeft = frame?.left ?? 0;
    final marginRight = frame?.right ?? 0;
    final marginTop = frame?.top ?? 0;
    // print("xiaojianjian watermarkFrameBox marginTop ${marginTop}");
    final marginBottom = frame?.bottom ?? 0;
    final paddingLeft = style?.padding?.left ?? 0;
    final paddingRight = style?.padding?.right ?? 0;
    final paddingTop = style?.padding?.top ?? 0;
    final paddingBottom = style?.padding?.bottom ?? 0;
    final signlineStyle = signLine?.style;
    final signlineFrame = signLine?.frame;

    final gradient = style?.gradient;
    final color1 = gradient?.colors?[0];
    final color2 = gradient?.colors?[1];

    final hasGradient = gradient != null &&
        gradient.colors != null &&
        watermarkData?.type != 'RYWatermarkTimeDivision';

    final contentTextSize = Utils.getTextSize(
        text: watermarkData?.content ?? "1",
        textStyle: TextStyle(
          fontSize: watermarkData?.style?.fonts?['font']?.size?.sp,
          // 13.sp,
        ),
        context: context);

    BoxDecoration generalBoxDecoration() {
      BorderSide getSignLineBorderSide() {
        return BorderSide(
            color: signlineStyle?.backgroundColor?.color?.hexToColor(
                    signlineStyle.backgroundColor?.alpha?.toDouble()) ??
                Colors.transparent,
            width: (signlineFrame?.width ?? 0).w,
            style:
                ((signlineFrame?.width == null) || (signlineFrame?.width == 0))
                    ? BorderStyle.none
                    : BorderStyle.solid);
      }

      Border getBorderStyle() {
        if (watermarkId == 1698215359120) {
          return Border.symmetric(vertical: getSignLineBorderSide());
        }

        return Border(
            left: watermarkId == 1698059986262
                ? BorderSide.none
                : getSignLineBorderSide(),
            bottom: watermarkId == 1698059986262
                ? getSignLineBorderSide()
                : BorderSide.none);
      }

      bool shouldShowBackground() {
        if (style?.backgroundColor == null) return false;
        if (watermarkId == 16983723692185) return false;
        if ((watermarkId == 16982153599988 || watermarkId == 16982153599999) &&
            watermarkData?.type == "YWatermarkTitleBar") {
          return false;
        }
        return true;
      }

      DecorationImage? getImage() {
        //背景图片
        if (imagePath == null) return null;
        final file = File(imagePath!);
        if (!file.existsSync()) return null;

        final isSpecialWatermark = watermarkId == 1698125672 ||
            watermarkId == 1698125120 ||
            watermarkId == 1698125930 ||
            watermarkId == 1698049285500 ||
            watermarkId == 1698049285310 ||
            watermarkId == 1698059986262;

        return DecorationImage(
          alignment: Alignment.centerLeft,
          fit: isSpecialWatermark ? BoxFit.fill : BoxFit.contain,
          image: FileImage(file),
        );
      }
    
      return BoxDecoration(
        border: getBorderStyle(),
        borderRadius: BorderRadius.circular(style?.radius ?? 0).r,
        image: getImage(),
        color: !(getImage() == null && hasGradient) && shouldShowBackground()
            ? style?.backgroundColor?.color?.hexToColor(style?.backgroundColor?.alpha?.toDouble())
            : null,
        gradient: getImage() == null && hasGradient // 当图片不存在且有渐变配置时显示渐变
            ? LinearGradient(
                colors: [
                  color1?.color?.hexToColor(color1.alpha?.toDouble()) ??
                      Colors.transparent,
                  color2?.color?.hexToColor(color2.alpha?.toDouble()) ??
                      Colors.transparent
                ],
                stops: [gradient.from?["x"] ?? 0.0, gradient.to?["x"] ?? 0.0],
              )
            : null,
      );
    }

    //仅特殊处理id为1698125672、1698125120、1698125930的三个水印
    Future<double?> loadImageWidth() async {
      if ((watermarkId == 1698125672 ||
              watermarkId == 1698125120 ||
              watermarkId == 1698125930) &&
          (watermarkData?.title == "时间")) {
        height = contentTextSize.height;
        if (imagePath != null && height != null) {
          final imageProvider = FileImage(File(imagePath!));
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
          return height! * aspectRatio;
        }
        return null;
      }

      return null;
    }

    return Container(
      width: watermarkId == 1698125683355 ? width : width?.w,
      // isAdaptTextWidth ==
      //         true //仅特殊处理id为1698125672、1698125120、1698125930的三个水印
      //     ? contentTextSize.width.w
      //     : (width != null || snapshot.hasData)
      //         ? ((width ?? snapshot.data)!.w)
      //         : null,
      height: watermarkId == 1698125683355 ? height : height?.w,
      margin: EdgeInsets.only(
        left: marginLeft.abs().w ?? 0.w,
        right: marginRight.abs().w ?? 0.w,
        top: marginTop.abs().w ?? 0.w,
        bottom: marginBottom.abs().w ?? 0.w,
      ),
      padding: EdgeInsets.only(
        left: paddingLeft.w,
        right: paddingRight.w,
        top: paddingTop.w,
        bottom: paddingBottom.w,
      ),
      decoration: generalBoxDecoration(),
      // foregroundDecoration: hasGradient ? gradientBoxDecoration() : null,
      child: child,
    );
  }
}
