import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/apis.dart';

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
  final poiList = <Map<String, dynamic>>[].obs;
  final loadingCollect = false.obs;
  final loadingHistory = false.obs;
  final collectLocationList = <LocationModel>[].obs;
  final historyLocationList = <LocationModel>[].obs;
  final page = 1.obs;
  final isLoading = false.obs;

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
  void onTapSearchPoi(Map<String, dynamic> poi) {
    final text = poi['address'] as String? ?? '';
    final province = locationLogic.locationResult.value?.province;

    if (Utils.isNotNullEmptyStr(province)) {
      textEditingController.text = '$province$text';
    } else {
      textEditingController.text = text;
    }

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
  Future<void> getNearbyPOIs() async {
    //小数点最多6位
    final latitude =
        locationLogic.locationResult.value?.latitude?.toStringAsFixed(6);
    final longitude =
        locationLogic.locationResult.value?.longitude?.toStringAsFixed(6);

    if (latitude == null || longitude == null) {
      Utils.showToast('搜索周边失败，请检查是否开启定位权限和定位服务');
      return;
    }

    try {
      isLoading.value = true;
      final response = await Apis.searchNearbyPOI(
        latitude: double.parse(latitude),
        longitude: double.parse(longitude),
        page: page.value,
        pageSize: pageSize,
      );

      if (page.value == 1) {
        poiList.clear();
      }

      // 处理返回数据
      if (response is List) {
        poiList.addAll(response.cast<Map<String, dynamic>>());
        refreshController.loadComplete();
        return;
      }

      if (response is Map<String, dynamic>) {
        final pois = response['pois'];
        if (pois is List) {
          final poisList =
              pois.map((item) => item as Map<String, dynamic>).toList();
          poiList.addAll(poisList);

          // 处理分页
          final totalCount =
              int.tryParse(response['count']?.toString() ?? '0') ?? 0;
          if (poiList.length >= totalCount) {
            refreshController.loadNoData();
          } else {
            refreshController.loadComplete();
          }
          return;
        }
      }

      // 如果没有数据
      if (poiList.isEmpty) {
        Utils.showToast('暂无周边位置信息');
        refreshController.loadNoData();
      }
    } catch (e) {
      print('获取周边位置失败: $e');
      refreshController.loadFailed();
      Utils.showToast('获取周边位置失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 加载更多
  Future<void> onLoading() async {
    page.value++;
    await getNearbyPOIs();
  }

  // 刷新
  Future<void> onRefresh() async {
    page.value = 1;
    await getNearbyPOIs();
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
