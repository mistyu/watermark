import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'map_logic.dart';

class MapPage extends GetView<MapLogic> {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onPressed: controller.saveLocation,
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
            // onTap: () => Get.to(() => const MapSearchPage()),
            child: Container(
              // margin: EdgeInsets.all(16.w),
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

          // TabBar
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
                ListView.builder(
                  itemCount: 0, // TODO: 实现收藏列表
                  itemBuilder: (context, index) {
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
