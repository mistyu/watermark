import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/core/service/template_service.dart';
import 'package:watermark_camera/core/service/image_watermark_service.dart';
import 'package:watermark_camera/core/service/video_watermark_service.dart';

/// 主水印服务类，作为对外接口
class WatermarkService {
  static Future<T?> getWatermarkViewByResource<T>(Resource resource) =>
      TemplateService.getWatermarkViewByResource<T>(resource);

  static Future<T?> getWatermarkViewByResourceId<T>(int id) =>
      TemplateService.getWatermarkViewByResourceId<T>(id);

  static Future<T?> readTemplateJson<T>(String dir) =>
      TemplateService.readTemplateJson<T>(dir);

  static Future<void> saveTemplateJson<T>(String dir,
          {required dynamic data}) =>
      TemplateService.saveTemplateJson<T>(dir, data: data);

  static Future<String?> getImagePath(String dir, {String? fileName}) =>
      TemplateService.getImagePath(dir, fileName: fileName);

  static Future<void> downloadAndExtractZip(String zipUrl) =>
      TemplateService.downloadAndExtractZip(zipUrl);

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
  }) =>
      ImageWatermarkService.compositeImageWithWatermark(
        originalImagePath,
        watermarkImageBytes: watermarkImageBytes,
        watermarkPosition: watermarkPosition,
        watermarkSize: watermarkSize,
        aspectRatio: aspectRatio,
        watermarkBackgroundImageBytes: watermarkBackgroundImageBytes,
        rightBottomWatermarkImageBytes: rightBottomWatermarkImageBytes,
        watermarkBackgroundSize: watermarkBackgroundSize,
        rightBottomWatermarkSize: rightBottomWatermarkSize,
        rightBottomWatermarkPosition: rightBottomWatermarkPosition,
      );

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
  }) =>
      VideoWatermarkService.compositeVideoWithWatermark(
        originalVideoPath,
        watermarkImageBytes: watermarkImageBytes,
        watermarkPosition: watermarkPosition,
        watermarkSize: watermarkSize,
        watermarkBackgroundImageBytes: watermarkBackgroundImageBytes,
        rightBottomWatermarkImageBytes: rightBottomWatermarkImageBytes,
        watermarkBackgroundSize: watermarkBackgroundSize,
        rightBottomWatermarkSize: rightBottomWatermarkSize,
        rightBottomWatermarkPosition: rightBottomWatermarkPosition,
        onSave: onSave,
        onProgress: onProgress,
      );
}
