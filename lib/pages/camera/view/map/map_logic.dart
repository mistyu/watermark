import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/location_controller.dart';
import 'package:watermark_camera/models/db/location/location.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/db_helper.dart';
import 'package:watermark_camera/utils/library.dart';

class MapLogic extends GetxController with GetSingleTickerProviderStateMixin {
  late WatermarkDataItemMap itemMap;
  final locationController = Get.find<LocationController>();

  // TabController
  late TabController tabController;

  // 当前选中的坐标
  final selectedLocation = Rxn<BMFCoordinate>();

  // 默认北京坐标
  final defaultCoordinate = BMFCoordinate(39.917215, 116.380341);

  // Tab 相关
  final currentTabIndex = 0.obs;

  static const String mapBuilderId = 'map_builder';
  BMFMapController? mapController;

  final RxList<LocationModel> favoritePois = <LocationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    itemMap = Get.arguments['itemMap'];

    // 初始化 TabController
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });

    _initLocation();
    _loadFavoritePois(); // 加载收藏列表
  }

  @override
  void onClose() {
    mapController = null;
    tabController.dispose();
    super.onClose();
  }

  // 检查POI是否已收藏
  bool isPoiFavorited(Map<String, dynamic> poi) {
    final poiId = poi['id']?.toString();
    return favoritePois.any((item) => item.poiId == poiId);
  }

  // 收藏/取消收藏POI
  Future<void> toggleFavoritePoi(Map<String, dynamic> poi) async {
    try {
      final poiId = poi['id']?.toString();
      if (poiId == null) return;

      if (isPoiFavorited(poi)) {
        // 取消收藏
        await DBHelper.delete(
          LocationModel().tableName,
          where: 'poiId = ?',
          whereArgs: [poiId],
        );
        favoritePois.removeWhere((item) => item.poiId == poiId);
        Utils.showToast('已取消收藏');
      } else {
        // 添加收藏
        final location = LocationModel(
          name: poi['name'],
          location: poi['location'],
          address: poi['address'],
          poiId: poiId,
          type: LocationType.collect,
        );

        final id = await DBHelper.insertModel(location);
        print('Inserted location with id: $id');

        if (id > 0) {
          favoritePois.add(location);
          Utils.showToast('已收藏');
        } else {
          Utils.showToast('收藏失败');
        }
      }

      // 重新加载收藏列表
      await _loadFavoritePois();
    } catch (e) {
      print('Toggle favorite POI error: $e');
      Utils.showToast('操作失败');
    }
  }

  // 加载收藏的POI
  Future<void> _loadFavoritePois() async {
    try {
      print('Loading favorite POIs...');
      final locations = await DBHelper.queryModels(
        LocationModel(),
        where: 'type = ?',
        whereArgs: [LocationType.collect.index],
        orderBy: 'id DESC',
      );
      print('Loaded favorite POIs: $locations');
      favoritePois.value = locations;
    } catch (e) {
      print('Load favorite POIs error: $e');
    }
  }

  void onSearchTap() async {
    final result = await AppNavigator.startMapSearch();
    if (result != null) {
      final location = result['location'] as String?;
      final coords = location!.split(',');
      final lng = double.parse(coords[0]);
      final lat = double.parse(coords[1]);
      selectedLocation.value = BMFCoordinate(lat, lng);
      //修改地图所在的位置
      updateMapLocation(BMFCoordinate(lat, lng));
      update([mapBuilderId]);
    }
  }

  void _initLocation() {
    // 1. 尝试从 itemMap 获取坐标
    if (itemMap.data.content != null && itemMap.data.content!.isNotEmpty) {
      final coords = itemMap.data.content!.split(',');
      if (coords.length == 2) {
        try {
          final lat = double.parse(coords[0]);
          final lng = double.parse(coords[1]);
          selectedLocation.value = BMFCoordinate(lat, lng);
          return;
        } catch (e) {
          print('Parse coordinates failed: $e');
        }
      }
    }

    // 2. 尝试从 LocationController 获取坐标
    final locationResult = locationController.locationResult.value;
    if (locationResult != null) {
      try {
        final lat = locationResult.latitude?.toString() ?? '0.000000';
        final lng = locationResult.longitude?.toString() ?? '0.000000';
        final latDouble = double.parse(lat);
        final lngDouble = double.parse(lng);
        if (latDouble != 0 && lngDouble != 0) {
          selectedLocation.value = BMFCoordinate(latDouble, lngDouble);
          return;
        }
      } catch (e) {
        print('Parse location failed: $e');
      }
    }

    // 3. 使用默认坐标
    selectedLocation.value = defaultCoordinate;
  }

  void onTabChanged(int index) {
    currentTabIndex.value = index;
    tabController.animateTo(index);
  }

  void saveLocation() {
    if (selectedLocation.value != null) {
      final location =
          '${selectedLocation.value!.latitude},${selectedLocation.value!.longitude}';
      Get.back(result: location);
    }
  }

  void updateSelectedLocation(BMFCoordinate coordinate) {
    selectedLocation.value = coordinate;
  }

  // 更新地图
  void updateMap() {
    update([mapBuilderId]);
  }

  void _addLocationMarker() {
    if (mapController != null && selectedLocation.value != null) {
      // 创建定位标记
      BMFMarker marker = BMFMarker(
        position: selectedLocation.value!, // 标记位置
        icon: 'assets/images/location_icon.png', // 标记图标
        title: '我的位置',
      );
      // _markers.add(marker);
      // 添加标记到地图
      mapController!.addMarker(marker);
      mapController!.setCenterCoordinate(
        selectedLocation.value!, // 目标位置的经纬度
        true, // 是否以动画方式移动
      );
    }
  }

  void updateMapLocation(BMFCoordinate coordinate) {
    if (mapController != null) {
      selectedLocation.value = coordinate;
      // 清除旧标记
      _clearMarkers();

      // 添加新标记
      _addLocationMarker();

      // 移动地图中心点到新位置
      mapController!.setCenterCoordinate(
        coordinate, // 目标位置的经纬度
        true, // 是否以动画方式移动
      );
    }
  }

  void _clearMarkers() {
    if (mapController != null) {
      // 方法 1: 使用 cleanAllMarkers（如果支持）
      mapController!.cleanAllMarkers();
    }
  }

  // 初始化地图控制器
  void onMapCreated(BMFMapController controller) {
    mapController = controller;
    mapController?.showUserLocation(true);
    mapController?.setMapDidLoadCallback(callback: () {
      print('xiaojianjian 地图加载完成');
    });
    _addLocationMarker();
  }
}
