import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class GradientTimeText extends StatefulWidget {
  final String text;
  final String imagePath;
  final TextStyle? textStyle;
  const GradientTimeText(
      {super.key, required this.text, required this.imagePath, this.textStyle});

  @override
  State<GradientTimeText> createState() => _GradientTimeTextState();
}

class _GradientTimeTextState extends State<GradientTimeText> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final ImageProvider provider = AssetImage(widget.imagePath);
    final ImageStream stream = provider.resolve(ImageConfiguration.empty);
    final Completer<ui.Image> completer = Completer<ui.Image>();

    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(info.image);
        setState(() {
          _image = info.image;
        });
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        completer.completeError(exception, stackTrace);
      },
    );

    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle;
    if (_image == null) {
      return Text(
        widget.text,
        style: textStyle,
      );
    }

    return
        // Text(
        //   widget.text,
        //   style: textStyle,
        // );
        ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        final double scaleX = bounds.width / _image!.width;
        final double scaleY = bounds.height / _image!.height;
        // 创建变换矩阵
        final Matrix4 matrix = Matrix4.identity()..scale(scaleX, scaleY);
        return ImageShader(
          _image!,
          TileMode.clamp,
          TileMode.clamp,
          matrix.storage,
        );
      },
      child: Text(
        widget.text,
        style: textStyle?.copyWith(color: Colors.white),
      ),
    );
  }
}
