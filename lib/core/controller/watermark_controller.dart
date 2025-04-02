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
import 'package:watermark_camera/utils/dialog.dart';

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

  // int? get firstWatermarkId =>
  //     watermarkResourceList.isNotEmpty ? watermarkResourceList.first.id : null;

  // 默认第一个是1698049556633编号的水印
  int? get firstWatermarkId =>
      watermarkResourceList.isNotEmpty ? 1698049556633 : null;

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

  /**
   * 这里要进行缓存一下
   * 先从缓存中查找，如果缓存中没有，则从网络中下载
   */
  Future<void> initWatermark() async {
    // 创建一个计时器，90秒后强制结束加载
    Timer? timeoutTimer;

    try {
      // 显示进度对话框
      CommonDialog.showProgressDialog(
          title: "正在加载水印资源", message: "首次加载可能需要较长时间，请耐心等待");

      // 设置超时计时器 - 60秒吧
      timeoutTimer = Timer(const Duration(seconds: 60), () {
        // 超时处理
        CommonDialog.dismissProgressDialog();

        // 显示提示
        Utils.showToast("水印资源加载时间较长，已转入后台下载，您可以继续使用应用");

        // 不需要取消下载任务，让它们在后台继续执行
        // 因为 downloadAndExtractZip 会检查是否已下载，所以不会重复下载
      });

      // 创建下载任务列表
      List<Future> downloadTasks = [];
      int totalTasks = 0;
      int completedTasks = 0;

      // 计算总任务数
      if (watermarkResourceList.isNotEmpty &&
          Utils.isNotNullEmptyStr(watermarkResourceList.first.zipUrl)) {
        totalTasks++;
      }

      if (watermarkRightBottomResourceList.isNotEmpty &&
          Utils.isNotNullEmptyStr(
              watermarkRightBottomResourceList.first.zipUrl)) {
        totalTasks++;
      }

      for (var resource in watermarkResourceList.skip(1)) {
        if (Utils.isNotNullEmptyStr(resource.zipUrl)) {
          totalTasks++;
        }
      }

      for (var resource in watermarkRightBottomResourceList.skip(1)) {
        if (Utils.isNotNullEmptyStr(resource.zipUrl)) {
          totalTasks++;
        }
      }

      // 更新初始进度
      CommonDialog.updateProgress(0);

      // 添加心跳检测，确保进度条有变化
      int lastCompletedTasks = 0;
      Timer heartbeatTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) {
        if (completedTasks == lastCompletedTasks &&
            completedTasks < totalTasks) {
          // 5秒内没有新任务完成，增加一点进度以表示仍在工作
          double currentProgress = completedTasks / totalTasks;
          double newProgress = currentProgress + (1 - currentProgress) * 0.05;
          CommonDialog.updateProgress(newProgress);
        }
        lastCompletedTasks = completedTasks;
      });

      // 添加第一个资源的下载任务
      if (watermarkResourceList.isNotEmpty &&
          Utils.isNotNullEmptyStr(watermarkResourceList.first.zipUrl)) {
        downloadTasks.add(WatermarkService.downloadAndExtractZip(
                watermarkResourceList.first.zipUrl ?? '',
                watermarkResourceList.first.id.toString())
            .then((_) {
          firstResource.value = watermarkResourceList.first;
          completedTasks++;
          CommonDialog.updateProgress(completedTasks / totalTasks);
        }));
      }

      // 添加第一个右下角资源的下载任务
      if (watermarkRightBottomResourceList.isNotEmpty &&
          Utils.isNotNullEmptyStr(
              watermarkRightBottomResourceList.first.zipUrl)) {
        downloadTasks.add(WatermarkService.downloadAndExtractZip(
                watermarkRightBottomResourceList.first.zipUrl ?? '',
                watermarkRightBottomResourceList.first.id.toString())
            .then((_) {
          firstRightBottomResource.value =
              watermarkRightBottomResourceList.first;
          completedTasks++;
          CommonDialog.updateProgress(completedTasks / totalTasks);
        }));
      }

      // 添加其余资源的下载任务
      for (var resource in watermarkResourceList.skip(1)) {
        if (Utils.isNotNullEmptyStr(resource.zipUrl)) {
          downloadTasks.add(WatermarkService.downloadAndExtractZip(
                  resource.zipUrl ?? '', resource.id.toString())
              .then((_) {
            completedTasks++;
            CommonDialog.updateProgress(completedTasks / totalTasks);
          }));
        }
      }

      // 添加其余右下角资源的下载任务
      for (var resource in watermarkRightBottomResourceList.skip(1)) {
        if (Utils.isNotNullEmptyStr(resource.zipUrl)) {
          downloadTasks.add(WatermarkService.downloadAndExtractZip(
                  resource.zipUrl ?? '', resource.id.toString())
              .then((_) {
            completedTasks++;
            CommonDialog.updateProgress(completedTasks / totalTasks);
          }));
        }
      }

      // 使用超时处理的Future.wait
      await Future.wait(downloadTasks).timeout(
        const Duration(seconds: 60), // 比总超时稍短，确保有时间处理
        onTimeout: () {
          // 超时时，让任务继续在后台执行
          return [];
        },
      );

      // 查询数据库中的水印设置
      final settings = await DBHelper.queryModels(
        DBHelper.watermarkSettingsModel,
      );

      dbWatermarkSettings.addAll(settings);

      // 取消心跳定时器
      heartbeatTimer.cancel();

      // 取消超时定时器
      timeoutTimer?.cancel();
      timeoutTimer = null;

      // 关闭进度对话框
      CommonDialog.dismissProgressDialog();
    } catch (e) {
      // 取消超时定时器
      timeoutTimer?.cancel();

      // 关闭进度对话框
      CommonDialog.dismissProgressDialog();
      // Logger.print("Init watermark error: $e");

      // 显示错误提示
      // Utils.showToast("水印资源加载出现问题，已转入后台下载，您可以继续使用应用");
    }
  }

  Future<void> initWatermarkAfterClear() async {
    try {
      final settings = await DBHelper.queryModels(
        DBHelper.watermarkSettingsModel,
      );
      dbWatermarkSettings.clear();
      dbWatermarkSettings.addAll(settings);

      // 同时同步下载
      await Future.wait([
        for (var resource in watermarkResourceList)
          if (Utils.isNotNullEmptyStr(resource.zipUrl))
            WatermarkService.downloadAndExtractZip(
                resource.zipUrl ?? '', resource.id.toString()),
        for (var resource in watermarkRightBottomResourceList)
          if (Utils.isNotNullEmptyStr(resource.zipUrl))
            WatermarkService.downloadAndExtractZip(
                resource.zipUrl ?? '', resource.id.toString())
      ]);
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
    // print("xiaojianjian 获取资源结果 = ${watermarkResourceList.value}");
  }

  Future<void> _requestRightBottomResource() async {
    watermarkRightBottomResourceList.value =
        await Apis.getRightBottomResource();
  }

  // 根据 GlobalKey 获取水印截图
  Future<ImageResult?> captureWatermark(GlobalKey key) async {
    try {
      final decodeStartTime = DateTime.now();

      if (key.currentContext == null) {
        // print("xiaojianjian 水印 Widget 未找到 context");
        return null;
      }

      final RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        // print("xiaojianjian 未找到 RenderRepaintBoundary");
        throw Exception;
      }

      // print("xiaojianjian 开始转换为图片");
      final image = await boundary.toImage(pixelRatio: 5);
      // print("xiaojianjian 水印尺寸 width: $width, height: $height");
      // print("xiaojianjian 开始转换为字节数据");
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      // print(
      //     "xiaojianjian 获取水印截图成功 ${DateTime.now().difference(decodeStartTime).inMilliseconds}ms");
      if (byteData != null) {
        return ImageResult(
          image: Uint8List.fromList(byteData.buffer.asUint8List()),
          width: image.width,
          height: image.height,
        );
      } else {
        throw Exception;
      }
    } catch (e) {
      return null;
    }
  }

  Future<ImageResult?> capturePhoto(GlobalKey key) async {
    try {
      final decodeStartTime = DateTime.now();

      if (key.currentContext == null) {
        return null;
      }

      final RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception;
      }

      final image = await boundary.toImage(pixelRatio: 2);

      final width = image.width;
      final height = image.height;
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      if (byteData != null) {
        return ImageResult(
          image: Uint8List.fromList(byteData.buffer.asUint8List()),
          width: width,
          height: height,
        );
      } else {
        return null;
      }
    } catch (e) {
      throw Exception;
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
