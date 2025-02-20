import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:watermark_camera/widgets/watermark_ui/watermark_font.dart';

class IntervalDo {
  DateTime? last;
  Timer? lastTimer;

  //call---milliseconds---call
  void run({required Function() fuc, int milliseconds = 0}) {
    DateTime now = DateTime.now();
    if (null == last ||
        now.difference(last ?? now).inMilliseconds > milliseconds) {
      last = now;
      fuc();
    }
  }

  //---milliseconds----milliseconds....---call  在milliseconds时连续的调用会被丢弃并重置milliseconds的时间，milliseconds后才会call
  void drop({required Function() fun, int milliseconds = 0}) {
    lastTimer?.cancel();
    lastTimer = null;
    lastTimer = Timer(Duration(milliseconds: milliseconds), () {
      lastTimer!.cancel();
      lastTimer = null;
      fun.call();
    });
  }
}

class Utils {
  Utils._();

  static Future<Size> getVideoSize(String path) async {
    final video = VideoPlayerController.file(File(path));
    await video.initialize();
    return Size(video.value.size.width, video.value.size.height);
  }

  // Step 1: 使用 VideoPlayerController 获取视频时长
  static Future<double?> getVideoFrameRate(String videoPath) async {
    // Step 1: 使用 VideoPlayerController 获取视频时长
    final controller = VideoPlayerController.file(File(videoPath));
    await controller.initialize();
    final durationInSeconds = controller.value.duration.inSeconds;
    controller.dispose();

    // Step 2: 使用 FFmpeg 获取总帧数
    int? totalFrames;
    await FFmpegKit.execute('-i $videoPath -map 0:v:0 -c copy -f null -')
        .then((session) async {
      final output = await session.getOutput();
      final frameRegex = RegExp(r'frame=\s*(\d+)');
      final match = frameRegex.firstMatch(output ?? '');
      if (match != null) {
        totalFrames = int.tryParse(match.group(1) ?? '');
      }
    });

    // Step 3: 计算帧率
    if (totalFrames != null && durationInSeconds > 0) {
      return totalFrames! / durationInSeconds;
    }
    return null;
  }

  static Future<String> getTempFilePath({
    required String dir,
    required String name,
  }) async {
    final storage = await getTempDir(dir: dir);
    File file = File('${storage.path}/$name');
    if (!(await file.exists())) {
      file.create(recursive: true);
    }
    return file.path;
  }

  static Future<String> getTempFileWithBytes({
    required String dir,
    required String name,
    required List<int> bytes,
  }) async {
    final path = await getTempFilePath(dir: dir, name: name);
    await File(path).writeAsBytes(bytes, flush: true);
    return path;
  }

  static Future<Directory> getTempDir({
    required String dir,
  }) async {
    final tempDir = await getTemporaryDirectory();
    Directory directory = Directory('${tempDir.path}/$dir');
    if (!(await directory.exists())) {
      directory.create(recursive: true);
    }
    return directory;
  }

  /// 删除临时文件
  static deleteTempFile({required String path}) async {
    await File(path).delete();
  }

  /// 删除临时目录
  static deleteTempDir({required String dir}) async {
    await Directory(dir).delete(recursive: true);
  }

  /// 删除临时文件和目录
  static deleteTempFileAndDir(
      {required String path, required String dir}) async {
    try {
      await Directory(path).delete(recursive: true);
      await File(path).delete();
    } catch (e) {
      Logger.print('删除临时文件和目录失败: $e');
    }
  }

  static Future showToast(String msg, {Duration? duration}) {
    if (msg.trim().isNotEmpty) {
      return EasyLoading.showToast(msg, duration: duration);
    } else {
      return Future.value();
    }
  }

  static Future<void> showLoading(String? msg) {
    return EasyLoading.show(status: msg);
  }

  static Future<void> dismissLoading() {
    return EasyLoading.dismiss();
  }

  static String getMimeType(String path) {
    return lookupMimeType(path) ?? 'Unknown';
  }

  static bool isNotNullBoolean(bool? value) => null != value && false != value;

  static String? emptyStrToNull(String? str) =>
      (null != str && str.trim().isEmpty) ? null : str;

  static bool isNotNullEmptyStr(String? str) => null != str && "" != str.trim();

  static bool isNullEmptyStr(String? str) => null == str || "" == str.trim();

  static Future<File> getVideoThumbnail(File file) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(
      file.path,
      quality: 50,
      position: 1,
    );
    return thumbnailFile;
  }

  // 根据图片高度来计算图片宽度
  static Future<double?> calculateImageWidth({
    required String? imagePath,
    required double? height,
  }) async {
    if (imagePath == null || height == null) return null;

    final image =
        await decodeImageFromList(await File(imagePath).readAsBytes());
    return height * (image.width / image.height);
  }

  static Size getTextSize(
      {String? text, TextStyle? textStyle, required BuildContext context}) {
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text ?? '', style: textStyle),
      maxLines: 1,
      locale: Localizations.localeOf(context),
    );
    painter.layout();
    return painter.size;
  }

  static String? color2HEX(Object color) {
    if (color is Color) {
      // 0xFFFFFFFF
      //将十进制转换成为16进制 返回字符串但是没有0x开头
      String temp = color.value.toRadixString(16);
      color = "#${temp.substring(2, 8)}";
    }
    return color.toString();
  }

  static Future<File> downloadFont(String fileName) async {
    try {
      String url = "${Config.staticUrl}/profile/upload/fonts/$fileName";
      String fontPath = await getTempFilePath(dir: 'fonts', name: fileName);
      if (File(fontPath).existsSync()) {
        return File(fontPath);
      }
      await dio.download(url, fontPath);
      return File(fontPath);
    } catch (e) {
      Logger.print('字体下载失败: $e');
      rethrow;
    }
  }

  static Future<void> readFont(String fileName) async {
    try {
      String fontName = fileName.split(".")[0];
      var fontLoader = FontLoader(fontName);
      File fontFile = await downloadFont(fileName);
      // 从本地文件加载字体
      ByteData byteData = await fontFile
          .readAsBytes()
          .then((bytes) => ByteData.view(bytes.buffer));
      fontLoader.addFont(Future.value(byteData));
      await fontLoader.load();

      Logger.print('字体加载成功: $fontName');
    } catch (e) {
      Logger.print('字体加载失败: $e; fileName: $fileName');
    }
  }

  static // 阴影
      List<Shadow> getViewShadow({Color? color}) {
    return [
      Shadow(
        offset: const Offset(0.5, 0.3), // 阴影的偏移量
        blurRadius: 0.5, // 阴影的模糊半径
        color: color ?? Colors.black38, // 阴影的颜色
      )
    ];
  }

// 文字根据宽度两端对齐放置
  static Widget textSpaceBetween(
      {double? width,
      String? text,
      WatermarkStyle? textStyle,
      WatermarkFont? font,
      double? rightSpace,
      int? watermarkId}) {
    if (width == null || width <= 0 || text == null || text == '') {
      return const SizedBox.shrink();
    }
    List<String> textList = text.split('');
    return Container(
      margin: EdgeInsets.only(right: rightSpace ?? 0),
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: textList.map((item) {
          return WatermarkFontBox(
            textStyle: textStyle,
            text: item,
            font: font,
            isBold: watermarkId == 16982153599988,
          );
        }).toList(),
      ),
    );
  }

  static Future<bool> checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String formatBytes(int bytes) {
    int kb = 1024;
    int mb = kb * 1024;
    int gb = mb * 1024;
    if (bytes >= gb) {
      return sprintf("%.1f GB", [bytes / gb]);
    } else if (bytes >= mb) {
      double f = bytes / mb;
      return sprintf(f > 100 ? "%.0f MB" : "%.1f MB", [f]);
    } else if (bytes > kb) {
      double f = bytes / kb;
      return sprintf(f > 100 ? "%.0f KB" : "%.1f KB", [f]);
    } else {
      return sprintf("%d B", [bytes]);
    }
  }

  // 打印函数运行时间
  static void printFunctionRunTime(Function fun) {
    final startTime = DateTime.now();
    fun();
    final endTime = DateTime.now();
    Logger.print('函数运行时间: ${endTime.difference(startTime).inMilliseconds}ms');
  }

  /// 计算最优的批处理大小
  /// [frameWidth] 帧宽度
  /// [frameHeight] 帧高度
  /// 返回建议的批处理大小
  static int calculateOptimalBatchSize({
    int? frameWidth,
    int? frameHeight,
  }) {
    try {
      // 获取可用CPU核心数（预留2个核心给系统）
      final availableCores = Platform.numberOfProcessors - 3;

      // 基础批处理大小：每个核心处理2-3个任务
      final multiplier = Platform.isIOS ? 2 : 2; // iOS设备通常性能更好
      var batchSize = availableCores * multiplier;

      // 如果提供了帧大小，考虑内存限制
      if (frameWidth != null && frameHeight != null) {
        // 估算每帧内存占用（RGBA格式，每像素4字节）
        final frameMemory = frameWidth * frameHeight * 4;

        // 假设设备有2GB可用内存，并预留50%给其他进程
        const availableMemory = 1024 * 1024 * 1024; // 2GB in bytes
        const maxMemoryUsage = availableMemory * 0.2;

        // 计算基于内存的最大批处理大小
        final maxBatchByMemory = (maxMemoryUsage / frameMemory).floor();

        // 使用较小的值作为批处理大小
        batchSize = min(batchSize, maxBatchByMemory);
      }

      // 确保批处理大小在合理范围内
      final adjustedBatchSize = batchSize.clamp(2, 4);

      Logger.print('''
      Batch size calculation:
      - Available cores: $availableCores
      - Base multiplier: $multiplier
      - Initial batch size: ${availableCores * multiplier}
      - Final adjusted batch size: $adjustedBatchSize
      ${frameWidth != null ? '- Frame dimensions: ${frameWidth}x$frameHeight' : ''}
    ''');

      return 2;
    } catch (e) {
      Logger.print('Error calculating batch size: $e');
      return 4; // 返回一个安全的默认值
    }
  }
}
