import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/platform/image_metadata_platform.dart';

/// 图片水印处理服务
class ImageWatermarkService {
  static Future<Uint8List?> compositeImageWithWatermark(
    String originalImagePath, {
    required Uint8List watermarkImageBytes,
    required Offset watermarkPosition,
    required Size watermarkSize,
    required double aspectRatio,
    Uint8List? watermarkBackgroundImageBytes,
    Uint8List? rightBottomWatermarkImageBytes,
    Size? watermarkBackgroundSize,
    Size? rightBottomWatermarkSize,
    Offset? rightBottomWatermarkPosition,
  }) async {
    try {
      final croppedImageBytes =
          await ImageUtil.cropImage(originalImagePath, aspectRatio);
      if (croppedImageBytes == null) return null;

      final croppedImage =
          await ImageUtil.decodeImageWithNative(croppedImageBytes);
      final watermarkImage =
          await ImageUtil.decodeImageWithNative(watermarkImageBytes);

      ui.Image? watermarkBackgroundImage;
      if (watermarkBackgroundImageBytes != null) {
        watermarkBackgroundImage = await ImageUtil.decodeImageWithNative(
            watermarkBackgroundImageBytes);
      }

      ui.Image? rightBottomWatermarkImage;
      if (rightBottomWatermarkImageBytes != null) {
        rightBottomWatermarkImage = await ImageUtil.decodeImageWithNative(
            rightBottomWatermarkImageBytes);
      }

      final processedImageBytes = await _drawWatermarks(
        croppedImage: croppedImage,
        watermarkImage: watermarkImage,
        watermarkPosition: watermarkPosition,
        watermarkSize: watermarkSize,
        watermarkBackgroundImage: watermarkBackgroundImage,
        watermarkBackgroundSize: watermarkBackgroundSize,
        rightBottomWatermarkImage: rightBottomWatermarkImage,
        rightBottomWatermarkSize: rightBottomWatermarkSize,
        rightBottomWatermarkPosition: rightBottomWatermarkPosition,
      );

      const author = "XGN Watermark Camera";
      const copyright = "copyright 2024 XGN Watermark Camera";
      final imageMetadata = {
        'width': croppedImage.width.toString(),
        'height': croppedImage.height.toString(),
      };

      if (processedImageBytes != null) {
        return await _addMetadata(
          processedImageBytes,
          author: author,
          copyright: copyright,
          customMetadata: imageMetadata,
          width: croppedImage.width,
          height: croppedImage.height,
        );
      }
      return null;
    } catch (e) {
      Logger.print('Error compositing image: $e');
      return null;
    }
  }

  static Future<Uint8List?> _drawWatermarks({
    required ui.Image croppedImage,
    required ui.Image watermarkImage,
    required Offset watermarkPosition,
    required Size watermarkSize,
    ui.Image? watermarkBackgroundImage,
    Size? watermarkBackgroundSize,
    ui.Image? rightBottomWatermarkImage,
    Size? rightBottomWatermarkSize,
    Offset? rightBottomWatermarkPosition,
  }) async {
    final previewToImageRatio = croppedImage.width / 1.sw;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..isAntiAlias = true;

    canvas.drawImage(croppedImage, Offset.zero, Paint());

    if (watermarkBackgroundImage != null && watermarkBackgroundSize != null) {
      _drawWatermarkBackground(
        canvas: canvas,
        image: watermarkBackgroundImage,
        size: watermarkBackgroundSize,
        croppedImage: croppedImage,
        previewToImageRatio: previewToImageRatio,
        paint: paint,
      );
    }

    _drawMainWatermark(
      canvas: canvas,
      image: watermarkImage,
      position: watermarkPosition,
      size: watermarkSize,
      croppedImage: croppedImage,
      previewToImageRatio: previewToImageRatio,
      paint: paint,
    );

    if (rightBottomWatermarkImage != null &&
        rightBottomWatermarkSize != null &&
        rightBottomWatermarkPosition != null) {
      _drawRightBottomWatermark(
        canvas: canvas,
        image: rightBottomWatermarkImage,
        position: rightBottomWatermarkPosition,
        size: rightBottomWatermarkSize,
        croppedImage: croppedImage,
        previewToImageRatio: previewToImageRatio,
        paint: paint,
      );
    }

    final picture = recorder.endRecording();
    final finalImage =
        await picture.toImage(croppedImage.width, croppedImage.height);
    final byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  static void _drawWatermarkBackground({
    required Canvas canvas,
    required ui.Image image,
    required Size size,
    required ui.Image croppedImage,
    required double previewToImageRatio,
    required Paint paint,
  }) {
    canvas.save();
    final backgroundScale = (size.width * previewToImageRatio) / image.width;
    final scaledBackgroundHeight = image.height * backgroundScale;

    canvas.translate(
      (croppedImage.width - image.width * backgroundScale) / 2,
      (croppedImage.height - scaledBackgroundHeight) / 2,
    );
    canvas.scale(backgroundScale);
    canvas.drawImage(image, Offset.zero, paint);
    canvas.restore();
  }

  static void _drawMainWatermark({
    required Canvas canvas,
    required ui.Image image,
    required Offset position,
    required Size size,
    required ui.Image croppedImage,
    required double previewToImageRatio,
    required Paint paint,
  }) {
    canvas.save();
    final scale = (size.width * previewToImageRatio) / image.width;
    final scaledWatermarkHeight = image.height * scale;
    final positionX = position.dx * previewToImageRatio;
    final positionY = position.dy * previewToImageRatio;

    canvas.translate(
      positionX,
      croppedImage.height - scaledWatermarkHeight - positionY,
    );
    canvas.scale(scale);
    canvas.drawImage(image, Offset.zero, paint);
    canvas.restore();
  }

  static void _drawRightBottomWatermark({
    required Canvas canvas,
    required ui.Image image,
    required Offset position,
    required Size size,
    required ui.Image croppedImage,
    required double previewToImageRatio,
    required Paint paint,
  }) {
    canvas.save();
    final scale = (size.width * previewToImageRatio) / image.width;
    final scaledHeight = image.height * scale;
    final positionX = croppedImage.width -
        (size.width * previewToImageRatio) -
        (position.dx * previewToImageRatio);
    final positionY = position.dy * previewToImageRatio;

    canvas.translate(
      positionX,
      croppedImage.height - scaledHeight - positionY,
    );
    canvas.scale(scale);
    canvas.drawImage(image, Offset.zero, paint);
    canvas.restore();
  }

  static Future<Uint8List?> _addMetadata(
    Uint8List imageBytes, {
    int? width,
    int? height,
    String? author,
    String? copyright,
    Map<String, String>? customMetadata,
  }) async {
    try {
      return await ImageMetadataPlatform.addMetadata(
        imageBytes: imageBytes,
        author: author,
        copyright: copyright,
        customMetadata: customMetadata,
        width: width,
        height: height,
      );
    } catch (e) {
      Logger.print('Error adding metadata: $e');
      return imageBytes;
    }
  }
}
