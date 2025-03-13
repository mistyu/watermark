import 'dart:typed_data';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:exif/exif.dart';
import 'dart:io';

class ImageProcess {
  // 缓存裁剪后的图片
  static Uint8List? _processedImageBytes;

  static const String _tempFileName = 'temp_crop.jpg';
  static String? _tempFilePath;

  // 初始化临时文件路径
  static Future<void> init() async {
    final tempDir = await getTemporaryDirectory();
    _tempFilePath = '${tempDir.path}/$_tempFileName';
  }

  // 使用 FFmpeg 进行快速裁剪
  static Future<Uint8List> cropImage(
    String imagePath, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      // 确保临时文件路径已初始化
      if (_tempFilePath == null) {
        await init();
      }

      // 简化的 FFmpeg 命令
      final command = '-i "$imagePath" '
          '-vf "crop=$width:$height:$x:$y" '
          '-c:v mjpeg '
          '-q:v 2 '
          '-y "$_tempFilePath"';

      // 执行 FFmpeg 命令
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        // 从临时文件读取数据
        final file = File(_tempFilePath!);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          if (_isJpeg(bytes)) {
            _processedImageBytes = bytes;
            return bytes;
          }
          throw Exception(
              'xiaojianjian Invalid JPEG data received from FFmpeg');
        }
        throw Exception('xiaojianjian No output file created by FFmpeg');
      } else {
        final logs = await session.getLogs();
        throw Exception(
            'xiaojianjian FFmpeg failed: ${logs.map((log) => log.getMessage()).join("\n")}');
      }
    } catch (e) {
      print('xiaojianjian Error in cropImage: $e');
      rethrow;
    }
  }

  // 清理临时文件
  static Future<void> cleanup() async {
    if (_tempFilePath != null) {
      final file = File(_tempFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  // 检查文件是否为JPEG格式
  static bool _isJpeg(Uint8List bytes) {
    if (bytes.length < 2) return false;
    // JPEG文件头标识: FF D8
    return bytes[0] == 0xFF && bytes[1] == 0xD8;
  }

  /// 叠加两张图片
  static Future<Uint8List> overlayImages(
    Uint8List baseImage,
    Uint8List overlayImage,
    int baseWidth,
    int baseHeight,
    int overlayWidth,
    int overlayHeight,
  ) async {
    try {
      // final decodeStartTime = DateTime.now();
      final tempDir = await getTemporaryDirectory();

      // 使用 .png 扩展名保存临时文件
      final baseImagePath =
          '${tempDir.path}/base_${DateTime.now().millisecondsSinceEpoch}.png';
      final overlayImagePath =
          '${tempDir.path}/overlay_${DateTime.now().millisecondsSinceEpoch}.png';
      final outputPath =
          '${tempDir.path}/output_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 保存临时文件
      await File(baseImagePath).writeAsBytes(baseImage);
      await File(overlayImagePath).writeAsBytes(overlayImage);

      // print("xiaojianjian 开始读取图片尺寸");

      // print("xiaojianjian 基础图片 baseWidth: $baseWidth, baseHeight: $baseHeight");
      // print(
      //     "xiaojianjian 水印 overlayWidth: $overlayWidth, overlayHeight: $overlayHeight");

      // 计算缩放比例
      final scale = baseWidth / overlayWidth;
      final newOverlayHeight = (overlayHeight * scale).toInt();

      // FFmpeg命令：缩放水印并叠加
      final command = '-i "$baseImagePath" -i "$overlayImagePath" '
          '-filter_complex "[1:v]scale=$baseWidth:$newOverlayHeight[overlay];'
          '[0:v][overlay]overlay=0:0" '
          '-q:v 2 -y "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      // // 清理临时文件
      // await Future.wait([
      //   File(baseImagePath).delete(),
      //   File(overlayImagePath).delete(),
      // ]);

      if (ReturnCode.isSuccess(returnCode)) {
        final resultBytes = await File(outputPath).readAsBytes();
        // await File(outputPath).delete();
        return resultBytes;
      } else {
        final logs = await session.getLogs();
        throw Exception(
            'FFmpeg overlay failed: ${logs.map((log) => log.getMessage()).join("\n")}');
      }
    } catch (e) {
      print('Error overlaying images: $e');
      rethrow;
    }
  }
}
