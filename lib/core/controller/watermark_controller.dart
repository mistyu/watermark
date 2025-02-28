import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/utils/db_helper.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:image/image.dart' as img;

class WaterMarkController extends GetxController {
  final initialLoading = false.obs;
  final watermarkCategoryList = <Category>[].obs;

  /**
   * 所有的水印资源列表 -- 只保存了基本的信息，真正的水印视图需要从资源的url下载中获取
   */
  final watermarkResourceList = <WatermarkResource>[].obs;
  final watermarkRightBottomResourceList = <RightBottomResource>[].obs;

  final firstResource = Rxn<WatermarkResource>();
  final firstRightBottomResource = Rxn<RightBottomResource>();

  final dbWatermarkSettings = <WatermarkSettingsModel>[].obs;

  int? get firstWatermarkId =>
      watermarkResourceList.isNotEmpty ? watermarkResourceList.first.id : null;

  Future<void> getWaterMarkAllData() async {
    try {
      initialLoading.value = true;
      //加载水印的分类、资源、右下角资源，数据中从基础字段信息
      await Future.wait([
        _requestCategory(),
        _requestResource(),
        _requestRightBottomResource(),
      ]);

      //根据url字段信息，下载详细的水印详细数据
      await initWatermark();
    } catch (e) {
      Logger.print("Get watermark all data error: $e");
    } finally {
      initialLoading.value = false;
    }
  }

  Future<void> initWatermark() async {
    try {
      print(
          "xiaojianjian downloadAndExtractZip  ${watermarkResourceList.first.zipUrl}");
      // 单独处理第一个资源的下载和视图获取
      if (watermarkResourceList.isNotEmpty &&
          Utils.isNotNullEmptyStr(watermarkResourceList.first.zipUrl)) {
        await WatermarkService.downloadAndExtractZip(
            watermarkResourceList.first.zipUrl ?? '');
        firstResource.value = watermarkResourceList.first;
      }

      if (watermarkRightBottomResourceList.isNotEmpty &&
          Utils.isNotNullEmptyStr(
              watermarkRightBottomResourceList.first.zipUrl)) {
        await WatermarkService.downloadAndExtractZip(
            watermarkRightBottomResourceList.first.zipUrl ?? '');
        firstRightBottomResource.value = watermarkRightBottomResourceList.first;
      }

      final settings = await DBHelper.queryModels(
        DBHelper.watermarkSettingsModel,
      );

      dbWatermarkSettings.addAll(settings);

      // 后台下载其余资源
      unawaited(Future.wait([
        for (var resource in watermarkResourceList.skip(1))
          if (Utils.isNotNullEmptyStr(resource.zipUrl))
            WatermarkService.downloadAndExtractZip(resource.zipUrl ?? ''),
        for (var resource in watermarkRightBottomResourceList.skip(1))
          if (Utils.isNotNullEmptyStr(resource.zipUrl))
            WatermarkService.downloadAndExtractZip(resource.zipUrl ?? '')
      ]));
    } catch (e) {
      Logger.print("Init watermark error: $e");
    }
  }

  WatermarkSettingsModel? getDbWatermarkByResourceId(int resourceId) {
    return dbWatermarkSettings.firstWhereOrNull(
        (element) => element.resourceId == resourceId.toString());
  }

  Future<void> _requestCategory() async {
    watermarkCategoryList.value = await Apis.getCategory();
  }

  Future<void> _requestResource() async {
    watermarkResourceList.value = await Apis.getResource();
  }

  Future<void> _requestRightBottomResource() async {
    watermarkRightBottomResourceList.value =
        await Apis.getRightBottomResource();
  }

  // 根据 GlobalKey 获取水印截图
  Future<ImageResult?> captureWatermark(GlobalKey key) async {
    try {
      final decodeStartTime = DateTime.now();
      print("xiaojianjian 获取水印截图开始");

      if (key.currentContext == null) {
        print("xiaojianjian 水印 Widget 未找到 context");
        return null;
      }

      final RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        print("xiaojianjian 未找到 RenderRepaintBoundary");
        return null;
      }

      print("xiaojianjian 开始转换为图片");
      final image = await boundary.toImage(pixelRatio: 1.2);

      // 获取图片尺寸
      final width = image.width;
      final height = image.height;

      print("xiaojianjian 水印尺寸 width: $width, height: $height");
      print("xiaojianjian 开始转换为字节数据");
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      print(
          "xiaojianjian 获取水印截图成功 ${DateTime.now().difference(decodeStartTime).inMilliseconds}ms");
      if (byteData != null) {
        return ImageResult(
          image: Uint8List.fromList(byteData.buffer.asUint8List()),
          width: width,
          height: height,
        );
      } else {
        print("xiaojianjian 转换字节数据失败");
        return null;
      }
    } catch (e) {
      print('xiaojianjian Error capturing watermark: $e');
      return null;
    }
  }

  // 根据 GlobalKey 获取水印截图
  Future<ImageResult?> capturePhoto(GlobalKey key) async {
    try {
      final decodeStartTime = DateTime.now();
      print("xiaojianjian 获取图片截图开始");

      if (key.currentContext == null) {
        print("xiaojianjian 图片截图 Widget 未找到 context");
        return null;
      }

      final RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        print("xiaojianjian 未找到 RenderRepaintBoundary");
        return null;
      }

      print("xiaojianjian 开始转换为图片");
      final image = await boundary.toImage(pixelRatio: 2.5);

      // 获取图片尺寸
      final width = image.width;
      final height = image.height;
      print("xiaojianjian 图片尺寸 width: $width, height: $height");

      print("xiaojianjian 开始转换为字节数据");
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      print(
          "xiaojianjian 获取图片截图成功 ${DateTime.now().difference(decodeStartTime).inMilliseconds}ms");
      if (byteData != null) {
        return ImageResult(
          image: Uint8List.fromList(byteData.buffer.asUint8List()),
          width: width,
          height: height,
        );
      } else {
        print("xiaojianjian 转换字节数据失败");
        return null;
      }
    } catch (e) {
      print('xiaojianjian Error capturing watermark: $e');
      return null;
    }
  }
}

class ImageResult {
  final Uint8List image;
  final int width;
  final int height;

  ImageResult({
    required this.image,
    required this.width,
    required this.height,
  });
}
