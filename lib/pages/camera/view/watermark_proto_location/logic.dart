import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/db/location/location.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/plugin/amap_search/amap_seach.dart';
import 'package:watermark_camera/utils/db_helper.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';

import 'mixin.dart';

class WatermarkProtoLocationLogic extends GetxController
    with GetSingleTickerProviderStateMixin, SearchManager {
  // Controllers
  late TabController tabController;
  late TextEditingController textEditingController;
  late RefreshController refreshController;
  late WatermarkDataItemMap itemMap;

  // Dependencies
  final locationLogic = Get.find<LocationController>();

  // Constants
  static const tabs = ['附近', '历史', '收藏'];
  static const pageSize = 20;

  // Observable state
  final location = ''.obs;
  final poiList = <AMapPoi>[].obs;
  final loadingCollect = false.obs;
  final loadingHistory = false.obs;
  final collectLocationList = <LocationModel>[].obs;
  final historyLocationList = <LocationModel>[].obs;
  final page = 1.obs;

  // Models
  final model = LocationModel();

  // Computed properties
  Location get locationLatLng => Location(
        latitude: locationLogic.locationResult.value?.latitude ?? 0,
        longitude: locationLogic.locationResult.value?.longitude ?? 0,
      );

  bool get isCollect =>
      collectLocationList.isNotEmpty &&
      collectLocationList
              .firstWhereOrNull((e) => e.address == location.value) !=
          null;

  // UI Event handlers
  void onSelectPoi(AMapPoi poi) {
    var text = poi.fullAddress;
    if (Utils.isNotNullEmptyStr(locationLogic.locationResult.value?.province)) {
      text = '${locationLogic.locationResult.value?.province}$text';
    }
    textEditingController.text = text;
  }

  void onSelectLocation(LocationModel locationModel) {
    location.value = locationModel.address ?? '';
    textEditingController.text = locationModel.address ?? '';
  }

  Future<void> onSaveLocation() async {
    await onSaveHistoryLocation();
    Get.back(result: textEditingController.text);
  }

  @override
  void onTapSearchPoi(AMapPoi poi) {
    onSelectPoi(poi);
    super.onTapSearchPoi(poi);
  }

  void onShowSearchView() {
    showSearchView();
  }

  // Location operations
  Future<void> onCollectLocation() async {
    try {
      final text = textEditingController.text.trim();
      if (text.isEmpty) {
        ToastUtil.show('地址不能为空');
        return;
      }
      final locationModel =
          LocationModel(address: text, type: LocationType.collect);
      if (collectLocationList.indexWhere((e) => e.address == text) != -1) {
        await DBHelper.deleteModel(locationModel,
            where: 'address = ? and type = ?',
            whereArgs: [text, LocationType.collect.name]);
        collectLocationList.removeWhere((e) => e.address == text);
        collectLocationList.refresh();
      } else {
        await DBHelper.insertModel(locationModel);
        collectLocationList.insert(0, locationModel);
        collectLocationList.refresh();
        ToastUtil.show('收藏成功');
      }
    } catch (e, s) {
      ToastUtil.show('收藏失败: $e');
      Logger.print("e: $e s: $s");
    }
  }

  Future<void> onSaveHistoryLocation() async {
    final text = textEditingController.text.trim();
    if (text.isEmpty) {
      ToastUtil.show('地址不能为空');
      return;
    }

    final locationModel =
        LocationModel(address: text, type: LocationType.history);

    if (historyLocationList.indexWhere((e) => e.address == text) != -1) {
      return;
    }

    await DBHelper.insertModel(locationModel);
    historyLocationList.insert(0, locationModel);
    historyLocationList.refresh();
    ToastUtil.show('保存成功');
  }

  // Data loading
  Future<void> onLoadCollectLocationList() async {
    try {
      loadingCollect.value = true;
      final result = await DBHelper.queryModels<LocationModel>(
        model,
        where: 'type = ?',
        whereArgs: [LocationType.collect.name],
      );
      collectLocationList
        ..clear()
        ..addAll(result)
        ..refresh();
    } catch (e, s) {
      Logger.print("e: $e s: $s");
    } finally {
      loadingCollect.value = false;
    }
  }

  Future<void> onLoadHistoryLocationList() async {
    try {
      loadingHistory.value = true;
      final result = await DBHelper.queryModels<LocationModel>(
        model,
        where: 'type = ?',
        whereArgs: [LocationType.history.name],
      );
      historyLocationList
        ..clear()
        ..addAll(result)
        ..refresh();
    } catch (e, s) {
      Logger.print("e: $e s: $s");
    } finally {
      loadingHistory.value = false;
    }
  }

  // POI search
  Future<List<AMapPoi>> _request() async {
    return AmapFlutterSearch.searchAround(
      locationLatLng,
      page: page.value,
      pageSize: pageSize,
    );
  }

  Future<void> onRefresh() async {
    try {
      final result = await _request();
      poiList
        ..clear()
        ..addAll(result)
        ..refresh();
      refreshController.refreshCompleted();
    } catch (e, s) {
      Logger.print("e: $e s: $s");
      refreshController.refreshFailed();
    }
  }

  Future<void> onLoading() async {
    try {
      page.value++;
      final result = await _request();
      if (result.isEmpty || result.length < pageSize) {
        refreshController.loadNoData();
      }
      poiList.addAll(result);
      poiList.refresh();
      refreshController.loadComplete();
    } catch (e, s) {
      Logger.print("e: $e s: $s");
      refreshController.loadFailed();
    }
  }

  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    onRefresh();
    itemMap = Get.arguments['itemMap'] as WatermarkDataItemMap;
    String tempLocation = '';
    if (Utils.isNotNullEmptyStr(itemMap.data.content)) {
      tempLocation = itemMap.data.content!;
    }
    tempLocation = locationLogic.fullAddress.value ?? '地址定位中...';
    location.value = tempLocation;
    onLoadCollectLocationList();
    onLoadHistoryLocationList();
    tabController = TabController(length: tabs.length, vsync: this);
    textEditingController = TextEditingController(text: tempLocation);
    refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void onClose() {
    textEditingController.dispose();
    refreshController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
