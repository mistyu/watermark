import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/db/location/location.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/config.dart';
import 'map_logic.dart';

class MapPage extends GetView<MapLogic> {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 在这里初始化百度地图
    _initBaiduMap();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "地图",
          style: TextStyle(
            fontSize: 16.sp,
            color: Styles.c_0D0D0D,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.saveLocation(),
            child: Text(
              '保存',
              style: TextStyle(
                fontSize: 14.sp,
                color: Styles.c_0C8CE9,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          GestureDetector(
            onTap: () => controller.onSearchTap(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Styles.c_F6F6F6,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20.w, color: Styles.c_999999),
                  SizedBox(width: 8.w),
                  Text(
                    '搜索地点',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Styles.c_999999,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab栏
          TabBar(
            dividerColor: Styles.c_F6F6F6,
            controller: controller.tabController,
            tabs: const [
              Tab(text: '地图'),
              Tab(text: '收藏'),
            ],
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 2.h,
                color: Styles.c_0C8CE9,
              ),
              insets: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            labelColor: Styles.c_0C8CE9,
            unselectedLabelColor: Styles.c_999999,
            indicatorColor: Styles.c_0C8CE9,
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // 地图页面
                GetBuilder<MapLogic>(
                  id: MapLogic.mapBuilderId,
                  builder: (logic) {
                    final location =
                        logic.selectedLocation.value ?? logic.defaultCoordinate;
                    return BMFMapWidget(
                      onBMFMapCreated: logic.onMapCreated,
                      mapOptions: BMFMapOptions(
                        center: location,
                        zoomLevel: 15,
                        mapPadding: BMFEdgeInsets(
                            left: 30, top: 0, right: 30, bottom: 0),
                      ),
                    );
                  },
                ),

                // 收藏列表页面
                Obx(() => ListView.builder(
                      itemCount: controller.favoritePois.length,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemBuilder: (context, index) {
                        final poi = controller.favoritePois[index];
                        return _buildFavoriteItem(poi);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 初始化百度地图
  void _initBaiduMap() {
    // 确保先设置隐私同意
    BMFMapSDK.setAgreePrivacy(true);

    // 然后再设置 API Key 和坐标类型
    BMFMapSDK.setApiKeyAndCoordType(
        Config.baiduMapAndroidApiKey, BMF_COORD_TYPE.BD09LL);
  }

  Widget _buildFavoriteItem(LocationModel poi) {
    return InkWell(
      onTap: () {
        if (poi.location != null) {
          final coords = poi.location!.split(',');
          if (coords.length == 2) {
            final lng = double.parse(coords[0]);
            final lat = double.parse(coords[1]);
            controller.updateMapLocation(BMFCoordinate(lat, lng));
            controller.tabController.animateTo(0); // 切换到地图页面
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Styles.c_EDEDED)),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, size: 24.w),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poi.name ?? '',
                    style: Styles.ts_333333_16_medium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (poi.address != null) ...[
                    6.verticalSpace,
                    Text(
                      poi.address!,
                      style: Styles.ts_666666_14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // 构建Map用于取消收藏
                final poiMap = {
                  'id': poi.poiId,
                  'name': poi.name,
                  'location': poi.location,
                  'address': poi.address,
                };
                controller.toggleFavoritePoi(poiMap);
              },
              icon: Icon(
                Icons.star,
                size: 24.w,
                color: Styles.c_0C8CE9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
