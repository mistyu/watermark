import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watermark_camera/utils/library.dart';

extension StrExt on String {
  ImageView get toImage {
    return ImageView(name: this);
  }

  TextView get toText {
    return TextView(data: this);
  }

  SvgView get toSvg {
    return SvgView(assetName: this);
  }

  double get float => double.parse(this);

  Color hexToColor(double? alpha) {
    var hexString = replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }
    if (hexString.contains("0x")) {
      return Color(int.parse(hexString));
    }
    int colorValue = int.parse(hexString, radix: 16);
    return Color(colorValue).withOpacity(alpha ?? 1);
  }

  Color get hex => Color(int.parse("0xff$this"));

  String get formatReslution {
    if (contains("max")) {
      return "最高";
    } else if (contains("ultraHigh")) {
      return "2160p";
    } else if (contains("veryHigh")) {
      return "1080p";
    } else if (contains("high")) {
      return "720p";
    } else if (contains("medium")) {
      return "480p";
    } else {
      return "最高";
    }
  }
}

class ImageView extends StatelessWidget {
  ImageView(
      {super.key,
      required this.name,
      this.width,
      this.height,
      this.color,
      this.opacity = 1,
      this.fit,
      this.onTap,
      this.onDoubleTap,
      this.repeat,
      this.adpaterDark = false});
  final String name;
  double? width;
  double? height;
  Color? color;
  double opacity;
  BoxFit? fit;
  bool adpaterDark;
  ImageRepeat? repeat;
  Function()? onTap;
  Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    var imgPath = name;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          imgPath,
          width: width,
          height: height,
          color: color,
          repeat: repeat ?? ImageRepeat.noRepeat,
          fit: fit,
        ),
      ),
    );
  }
}

class TextView extends StatelessWidget {
  TextView({
    super.key,
    required this.data,
    this.style,
    this.textAlign,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.onTap,
  });
  final String data;
  TextStyle? style;
  TextAlign? textAlign;
  TextOverflow? overflow;
  double? textScaleFactor;
  int? maxLines;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Text(
        data,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        textScaler: TextScaler.linear(textScaleFactor ?? 1),
        maxLines: maxLines,
      ),
    );
  }
}

class SvgView extends StatelessWidget {
  SvgView(
      {super.key,
      required this.assetName,
      this.width,
      this.height,
      this.color,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center});

  final String assetName;
  double? width;
  double? height;
  BoxFit? fit;
  Color? color;
  AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      alignment: alignment ?? Alignment.center,
      theme: SvgTheme(currentColor: color ?? Styles.c_333333),
    );
  }
}
