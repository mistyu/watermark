import 'dart:typed_data';
import 'package:ffmpeg_kit_flutter_min/session.dart';
import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageProcess {
  // 缓存裁剪后的图片
  static Uint8List? _processedImageBytes;

  // 使用 FFmpeg 进行快速裁剪
  static Future<Uint8List> cropImage(
    String imagePath, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath =
          '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // FFmpeg 命令
      final command =
          '-i "$imagePath" -vf "crop=$width:$height:$x:$y" -q:v 2 -y "$outputPath"';

      // 在后台线程执行 FFmpeg
      final session = await compute(_executeFFmpeg, command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        // 读取处理后的图片
        final bytes = await File(outputPath).readAsBytes();

        // 删除临时文件
        await File(outputPath).delete();

        // 缓存结果
        _processedImageBytes = bytes;

        return bytes;
      } else {
        final logs = await session.getLogs();
        throw Exception(
            'FFmpeg process failed with rc: ${returnCode?.getValue()}, logs: $logs');
      }
    } catch (e) {
      print('Error cropping image: $e');
      rethrow;
    }
  }

  // 获取缓存的图片
  static Uint8List? getCachedImage() {
    return _processedImageBytes;
  }

  // 清除缓存
  static void clearCache() {
    _processedImageBytes = null;
  }

  // 在后台线程执行 FFmpeg
  static Future<Session> _executeFFmpeg(String command) async {
    return await FFmpegKit.execute(command);
  }
}
