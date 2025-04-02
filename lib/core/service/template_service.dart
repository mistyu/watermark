import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/library.dart';

/// 模板管理服务
class TemplateService {
  static const String jsonFileName = 'templateData.json';
  static const String templateDir = 'template';

  static Future<T?> getWatermarkViewByResource<T>(Resource resource) async {
    return readTemplateJson<T>(resource.id.toString());
  }

  static Future<T?> getWatermarkViewByResourceId<T>(int id) async {
    return readTemplateJson<T>(id.toString());
  }

  static Future<T?> readTemplateJson<T>(String dir) async {
    // print("xiaojianjian 读取模板 dir = $dir");
    try {
      final tempDir = await Utils.getTempDir(dir: "$templateDir/$dir");
      final jsonString =
          await File('${tempDir.path}/$jsonFileName').readAsString();
      // print("xiaojianjian 开始jsonDecode = $jsonString");
      final jsonData = jsonDecode(jsonString);
      // print("xiaojianjian 模板json结果 = $jsonData");
      final fromJsonMap = {
        WatermarkView: (json) => WatermarkView.fromJson(json),
        RightBottomView: (json) => RightBottomView.fromJson(json)
      };

      final fromJson = fromJsonMap[T];
      return fromJson != null ? fromJson(jsonData) as T : null;
    } catch (e) {
      Logger.print("fn readTemplateJson error = ${e.toString()}");
      return null;
    }
  }

  static Future<void> saveTemplateJson<T>(String dir,
      {required dynamic data}) async {
    final tempDir = await Utils.getTempDir(dir: "$templateDir/$dir");
    final jsonString = jsonEncode(data.toJson());
    await File('${tempDir.path}/$jsonFileName').writeAsString(jsonString);
  }

  static Future<String?> getImagePath(String dir, {String? fileName}) async {
    if (Utils.isNotNullEmptyStr(fileName)) {
      final tempDir = await Utils.getTempDir(dir: "$templateDir/$dir");
      final baseFilePath = '${tempDir.path}/$fileName';
      final suffixes = ['@3x.png', '@2x.png', '.png'];
      for (final suffix in suffixes) {
        final filePath = '$baseFilePath$suffix';
        if (await File(filePath).exists()) {
          return filePath;
        }
      }
    }
    return null;
  }

  static Future<String?> getImagePath582(String dir, {String? fileName}) async {
    if (Utils.isNotNullEmptyStr(fileName)) {
      final tempDir = await Utils.getTempDir(dir: "$templateDir/$dir");
      final baseFilePath = '${tempDir.path}/$fileName';
      final suffixes = ['@2x.png', '.png'];
      for (final suffix in suffixes) {
        final filePath = '$baseFilePath$suffix';
        if (await File(filePath).exists()) {
          return filePath;
        }
      }
    }
    return null;
  }

  static Future<void> downloadAndExtractZip(String zipUrl, String id) async {
    try {
      // 构建完整的URL
      String url = "${Config.staticUrl}$zipUrl";
      // Logger.print("Attempting to download from URL: $url");

      // 获取临时目录
      final tempDir = await Utils.getTempDir(dir: templateDir);
      final targetDir = Directory('${tempDir.path}/$id');
      // print("目标文件夹 = ${targetDir.path}");

      // // 检查目录是否已存在且不为空
      // if (await Utils.isDirectoryExistsAndNotEmpty(targetDir.path)) {
      //   Logger.print("Template $id already exists in ${targetDir.path}");
      //   return;
      // }

      print("xiaojianjian 开始下载 ${zipUrl}");

      // 确保目标目录存在
      if (!targetDir.existsSync()) {
        targetDir.createSync(recursive: true);
      }

      // 下载并解压文件
      final zipBytes = await NetworkAssetBundle(Uri.parse(url)).load(url);
      final archive = ZipDecoder().decodeBytes(zipBytes.buffer.asUint8List());

      for (final file in archive) {
        if (file.isFile && !file.name.contains('.DS_Store')) {
          // 获取文件名（去掉可能存在的路径）
          final fileName = file.name.split('/').last;
          final fileData = file.content as List<int>;
          final filePath = '${targetDir.path}/$fileName';

          // if (id == "1698317868899") {
          //   print("xiaojianjian downloadAndExtractZip fileName = $fileName");
          // }

          // Logger.print("Extracting file: $fileName to $filePath");

          // 直接写入文件到目标目录
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileData);
        }
      }

      Logger.print("Successfully extracted zip to ${targetDir.path}");
    } catch (e) {
      Logger.print("Error in downloadAndExtractZip: ${e.toString()}");
    }
  }
}
