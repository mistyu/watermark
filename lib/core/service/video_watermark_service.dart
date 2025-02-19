import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/plugin/video_watermark/video_watermark.dart';
import 'package:watermark_camera/utils/library.dart';

/// 视频水印处理服务
class VideoWatermarkService {
  static const String tempFramesDir = 'frame';
  static const String tempWatermarkFileName = 'watermark.png';
  static const String tempBackgroundFileName = 'background.png';
  static const String tempRightBottomFileName = 'rightbottom.png';

  static Future<void> compositeVideoWithWatermark(
    String originalVideoPath, {
    required Uint8List watermarkImageBytes,
    required Offset watermarkPosition,
    required Size watermarkSize,
    Uint8List? watermarkBackgroundImageBytes,
    Uint8List? rightBottomWatermarkImageBytes,
    Size? watermarkBackgroundSize,
    Size? rightBottomWatermarkSize,
    Offset? rightBottomWatermarkPosition,
    Function(String? path)? onSave,
    Function(double value)? onProgress,
  }) async {
    try {
      final tempWatermarkImagePath = await Utils.getTempFileWithBytes(
        dir: tempFramesDir,
        name: tempWatermarkFileName,
        bytes: watermarkImageBytes,
      );

      final watermarks = await _prepareWatermarks(
        watermarkImagePath: tempWatermarkImagePath,
        watermarkPosition: watermarkPosition,
        watermarkSize: watermarkSize,
        watermarkBackgroundImageBytes: watermarkBackgroundImageBytes,
        rightBottomWatermarkImageBytes: rightBottomWatermarkImageBytes,
        watermarkBackgroundSize: watermarkBackgroundSize,
        rightBottomWatermarkSize: rightBottomWatermarkSize,
        rightBottomWatermarkPosition: rightBottomWatermarkPosition,
        originalVideoPath: originalVideoPath,
      );

      final saveVideoDir = await Utils.getTempDir(dir: tempFramesDir);

      final watermark = Watermark(
        bitrate: "5M",
        watermarks: watermarks,
      );

      final videoWatermark = VideoWatermark(
        sourceVideoPath: originalVideoPath,
        watermark: watermark,
        savePath: saveVideoDir.path,
        onSave: onSave,
        progress: onProgress,
      );

      await videoWatermark.generateVideo();
    } catch (e) {
      Logger.print('Error processing video: $e');
      return Future.error(e);
    }
  }

  static Future<List<WatermarkConfig>> _prepareWatermarks({
    required String watermarkImagePath,
    required Offset watermarkPosition,
    required Size watermarkSize,
    required String originalVideoPath,
    Uint8List? watermarkBackgroundImageBytes,
    Uint8List? rightBottomWatermarkImageBytes,
    Size? watermarkBackgroundSize,
    Size? rightBottomWatermarkSize,
    Offset? rightBottomWatermarkPosition,
  }) async {
    final watermarks = <WatermarkConfig>[];
    final videoSize = await Utils.getVideoSize(originalVideoPath);
    final adjustedVideoSize = Size(videoSize.height, videoSize.width);
    final previewToImageRatio = adjustedVideoSize.width / 1.sw;

    final watermarkImage = await ImageUtil.decodeImageWithNative(
      await File(watermarkImagePath).readAsBytes(),
    );

    if (watermarkBackgroundImageBytes != null &&
        watermarkBackgroundSize != null) {
      final tempBackgroundPath = await Utils.getTempFileWithBytes(
        dir: tempFramesDir,
        name: tempBackgroundFileName,
        bytes: watermarkBackgroundImageBytes,
      );

      final backgroundImage =
          await ImageUtil.decodeImageWithNative(watermarkBackgroundImageBytes);
      final backgroundScale =
          (watermarkBackgroundSize.width * previewToImageRatio) /
              backgroundImage.width;
      final scaledBackgroundHeight = backgroundImage.height * backgroundScale;

      watermarks.add(WatermarkConfig(
        image: WatermarkSource.file(tempBackgroundPath),
        position: Offset(
          watermarkPosition.dx * previewToImageRatio,
          adjustedVideoSize.height -
              scaledBackgroundHeight -
              watermarkPosition.dy * previewToImageRatio,
        ),
        size: WatermarkSize(
          backgroundImage.width * backgroundScale,
          scaledBackgroundHeight,
        ),
      ));
    }

    final scale =
        (watermarkSize.width * previewToImageRatio) / watermarkImage.width;
    final scaledWatermarkHeight = watermarkImage.height * scale;

    watermarks.add(WatermarkConfig(
      image: WatermarkSource.file(watermarkImagePath),
      position: Offset(
        watermarkPosition.dx * previewToImageRatio,
        adjustedVideoSize.height -
            scaledWatermarkHeight -
            watermarkPosition.dy * previewToImageRatio,
      ),
      size: WatermarkSize(
        watermarkImage.width * scale,
        scaledWatermarkHeight,
      ),
    ));

    if (rightBottomWatermarkImageBytes != null &&
        rightBottomWatermarkSize != null &&
        rightBottomWatermarkPosition != null) {
      final tempRightBottomPath = await Utils.getTempFileWithBytes(
        dir: tempFramesDir,
        name: tempRightBottomFileName,
        bytes: rightBottomWatermarkImageBytes,
      );

      final rightBottomImage =
          await ImageUtil.decodeImageWithNative(rightBottomWatermarkImageBytes);
      final rightBottomScale =
          (rightBottomWatermarkSize.width * previewToImageRatio) /
              rightBottomImage.width;
      final scaledRightBottomHeight =
          rightBottomImage.height * rightBottomScale;
      final rightBottomPositionX = adjustedVideoSize.width -
          (rightBottomWatermarkSize.width * previewToImageRatio) -
          (rightBottomWatermarkPosition.dx * previewToImageRatio);
      final rightBottomPositionY = adjustedVideoSize.height -
          scaledRightBottomHeight -
          rightBottomWatermarkPosition.dy * previewToImageRatio;

      watermarks.add(WatermarkConfig(
        image: WatermarkSource.file(tempRightBottomPath),
        position: Offset(
          rightBottomPositionX,
          rightBottomPositionY,
        ),
        size: WatermarkSize(
          rightBottomImage.width * rightBottomScale,
          scaledRightBottomHeight,
        ),
      ));
    }

    return watermarks;
  }
}
