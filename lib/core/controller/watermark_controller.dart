import 'dart:async';

import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/models/db/watermark/watermark_settings.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/utils/db_helper.dart';
import 'package:watermark_camera/utils/library.dart';

class WaterMarkController extends GetxController {
  final initialLoading = false.obs;
  final watermarkCategoryList = <Category>[].obs;
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
      await Future.wait([
        _requestCategory(),
        _requestResource(),
        _requestRightBottomResource(),
      ]);

      await initWatermark();
    } catch (e) {
      Logger.print("Get watermark all data error: $e");
    } finally {
      initialLoading.value = false;
    }
  }

  Future<void> initWatermark() async {
    try {
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
}
