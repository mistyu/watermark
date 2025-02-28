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
    try {
      final tempDir = await Utils.getTempDir(dir: "$templateDir/$dir");
      final jsonString =
          await File('${tempDir.path}/$jsonFileName').readAsString();
      final jsonData = jsonDecode(jsonString);

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

  static Future<void> downloadAndExtractZip(String zipUrl) async {
    // print("xiaojianjian downloadAndExtractZip zipUrl = $zipUrl");
    try {
      String url = "${Config.staticUrl}$zipUrl";
      final tempDir = await Utils.getTempDir(dir: templateDir);
      final zipBytes = await NetworkAssetBundle(Uri.parse(url)).load(url);
      final archive = ZipDecoder().decodeBytes(zipBytes.buffer.asUint8List());

      for (final file in archive) {
        if (file.size > 0 && !file.name.contains('.DS_Store')) {
          final fileName = file.name;
          final fileData = file.content as List<int>;
          final filePath = '${tempDir.path}/$fileName';
          final fileDir = Directory(filePath).parent;

          if (!fileDir.existsSync()) {
            fileDir.createSync(recursive: true);
          }

          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileData);
        }
      }
    } catch (e) {
      Logger.print("fn downloadAndExtractZip error = ${e.toString()}");
    }
  }
}
