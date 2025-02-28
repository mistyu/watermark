import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/loading_view.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  /// Save photo with watermark
  static Future<Uint8List?> savePhotoWithWatermark({
    required String originalPhotoPath,
    required double aspectRatio,
    required Future<Uint8List?> Function() captureWatermark,
    required Size? watermarkSize,
    required Offset watermarkPosition,
    Future<Uint8List?> Function()? captureWatermarkBackground,
    Size? watermarkBackgroundSize,
    Uint8List? rightBottomWatermarkBytes,
    Size? rightBottomWatermarkSize,
    Offset? rightBottomWatermarkPosition,
  }) async {
    try {
      final watermarkBytes =
          await LoadingView.singleton.wrap<Uint8List?>(asyncFunction: () async {
        final watermarkImageBytes = await captureWatermark();
        if (watermarkSize == null || watermarkImageBytes == null) {
          return null;
        }

        Uint8List? watermarkBackgroundImageBytes;
        if (captureWatermarkBackground != null &&
            watermarkBackgroundSize != null) {
          watermarkBackgroundImageBytes = await captureWatermarkBackground();
        }

        return WatermarkService.compositeImageWithWatermark(
          originalPhotoPath,
          aspectRatio: aspectRatio,
          watermarkImageBytes: watermarkImageBytes,
          watermarkPosition: watermarkPosition,
          watermarkSize: watermarkSize,
          watermarkBackgroundImageBytes: watermarkBackgroundImageBytes,
          watermarkBackgroundSize: watermarkBackgroundSize,
          rightBottomWatermarkImageBytes: rightBottomWatermarkBytes,
          rightBottomWatermarkSize: rightBottomWatermarkSize,
          rightBottomWatermarkPosition: rightBottomWatermarkPosition,
        );
      });

      if (watermarkBytes == null) return null;

      return watermarkBytes;
    } catch (e, s) {
      Logger.print("Save photo failed: $e, $s");
      return null;
    }
  }

  /// Save video with watermark
  static Future<String?> saveVideoWithWatermark({
    required String originalVideoPath,
    required Future<Uint8List?> Function() captureWatermark,
    required Size? watermarkSize,
    required Offset watermarkPosition,
    Future<Uint8List?> Function()? captureWatermarkBackground,
    Size? watermarkBackgroundSize,
    Uint8List? rightBottomWatermarkBytes,
    Size? rightBottomWatermarkSize,
    Offset? rightBottomWatermarkPosition,
    void Function(double)? onProgress,
  }) async {
    try {
      final watermarkImageBytes = await captureWatermark();
      if (watermarkSize == null || watermarkImageBytes == null) {
        return originalVideoPath;
      }

      Uint8List? watermarkBackgroundImageBytes;
      if (captureWatermarkBackground != null &&
          watermarkBackgroundSize != null) {
        watermarkBackgroundImageBytes = await captureWatermarkBackground();
      }

      String? processedVideoPath;
      final completer = Completer<void>();

      await WatermarkService.compositeVideoWithWatermark(
        originalVideoPath,
        watermarkImageBytes: watermarkImageBytes,
        watermarkPosition: watermarkPosition,
        watermarkSize: watermarkSize,
        watermarkBackgroundImageBytes: watermarkBackgroundImageBytes,
        watermarkBackgroundSize: watermarkBackgroundSize,
        rightBottomWatermarkImageBytes: rightBottomWatermarkBytes,
        rightBottomWatermarkSize: rightBottomWatermarkSize,
        rightBottomWatermarkPosition: rightBottomWatermarkPosition,
        onProgress: onProgress,
        onSave: (path) {
          processedVideoPath = path;
          completer.complete();
        },
      );

      await completer.future;
      return processedVideoPath;
    } catch (e, s) {
      Logger.print("Save video failed: $e, $s");
    }
    return null;
  }

  /// Save photo to gallery
  static Future<void> savePhoto(Uint8List bytes) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      await PhotoManager.editor.saveImage(
        bytes,
        title: timestamp,
        desc: 'Saved by App',
        relativePath: 'DCIM/Camera',
        filename: '$timestamp.jpg', // 确保文件名包含 .jpg 扩展名
      );
    } catch (e) {
      print('Error saving photo: $e');
      rethrow;
    }
  }

  static Future<AssetEntity> savePhotoWithPath(String path) async {
    return await PhotoManager.editor.saveImageWithPath(
      path,
      title: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  /// Save video to gallery
  static Future<AssetEntity> saveVideo(File file) async {
    return await PhotoManager.editor.saveVideo(
      file,
      title: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }
}
