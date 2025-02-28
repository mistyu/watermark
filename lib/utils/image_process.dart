import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageProcess {
  static final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  // 缓存裁剪后的图片
  static Uint8List? _processedImageBytes;
  static String? _cachedImagePath;

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
          '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // FFmpeg 裁剪命令
      final command =
          '-i $imagePath -vf crop=$width:$height:$x:$y -y $outputPath';

      // 在后台线程执行 FFmpeg
      final result = await compute(
          _executeFFmpeg, {'ffmpeg': _flutterFFmpeg, 'command': command});

      if (result != 0) {
        throw Exception('FFmpeg process failed with rc: $result');
      }

      // 读取裁剪后的图片
      final bytes = await File(outputPath).readAsBytes();

      // 更新缓存
      _processedImageBytes = bytes;
      _cachedImagePath = outputPath;

      return bytes;
    } catch (e) {
      print('Error cropping image: $e');
      rethrow;
    }
  }

  // 获取缓存的图片
  static Uint8List? getCachedImage() {
    return _processedImageBytes;
  }

  // 获取缓存图片路径
  static String? getCachedImagePath() {
    return _cachedImagePath;
  }

  // 清除缓存
  static void clearCache() {
    _processedImageBytes = null;
    if (_cachedImagePath != null) {
      File(_cachedImagePath!).delete().ignore();
      _cachedImagePath = null;
    }
  }

  // 在后台线程执行 FFmpeg
  static Future<int> _executeFFmpeg(Map<String, dynamic> params) async {
    final ffmpeg = params['ffmpeg'] as FlutterFFmpeg;
    final command = params['command'] as String;
    return await ffmpeg.execute(command);
  }
}
