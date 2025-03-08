import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/pages/camera/view/searchView/search_logic.dart';
import 'package:watermark_camera/utils/library.dart';

class MapSearchPage extends GetView<SearchLogic> {
  const MapSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            14.verticalSpace,
            Expanded(
              child: Obx(() => controller.isSearchLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSearchResults()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Styles.c_F6F6F6)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: "nvbar_ico_back".svg.toSvg
              ..width = 24.w
              ..height = 24.h
              ..color = Styles.c_333333,
          ),
          8.horizontalSpace,
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: '搜索地点',
                hintStyle: Styles.ts_333333_16,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (controller.searchResults.isEmpty) {
      return Center(
        child: ('暂无搜索结果'.toText
          ..style = Styles.ts_333333_16
          ..textAlign = TextAlign.center),
      );
    }

    return SmartRefresher(
      controller: controller.refreshController,
      enablePullDown: false,
      enablePullUp: true,
      footer: const ClassicFooter(
        loadingText: '加载中...',
        noDataText: '没有更多数据',
        idleText: '上拉加载更多',
        failedText: '加载失败',
        canLoadingText: '松开加载更多',
      ),
      onLoading: controller.onSearchLoadMore,
      child: ListView.builder(
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) =>
            _buildSearchResultItem(controller.searchResults[index]),
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> poi) {
    final name = poi['name'] as String? ?? '';
    final address = poi['address'] as String? ?? '';
    final district = poi['adname'] as String? ?? '';

    return InkWell(
      onTap: () => controller.onPoiSelected(poi),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Styles.c_EDEDED)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 24.w),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Styles.ts_333333_16_medium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (address.isNotEmpty) ...[
                    6.verticalSpace,
                    Text(
                      '$district$address',
                      style: Styles.ts_666666_14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Obx(() => IconButton(
                  onPressed: () =>
                      controller.mapController.toggleFavoritePoi(poi),
                  icon: Icon(
                    controller.mapController.isPoiFavorited(poi)
                        ? Icons.star
                        : Icons.star_border,
                    size: 24.w,
                    color: controller.mapController.isPoiFavorited(poi)
                        ? Styles.c_0C8CE9
                        : Styles.c_999999,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
