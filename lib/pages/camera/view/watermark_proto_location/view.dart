import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/models/db/location/location.dart';
import 'package:watermark_camera/plugin/amap_search/amap_seach.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';
import 'package:watermark_camera/widgets/filled_input.dart';
import 'package:watermark_camera/widgets/gradient_button.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

import 'logic.dart';

class WatermarkProtoLocationPage extends StatelessWidget {
  WatermarkProtoLocationPage({Key? key}) : super(key: key);

  final WatermarkProtoLocationLogic logic =
      Get.find<WatermarkProtoLocationLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: "选择地点",
          ),
          body: Column(
            children: [
              _buildSearchButton(),
              _buildContent(),
              _buildTab(),
              Expanded(
                child: TabBarView(
                  controller: logic.tabController,
                  children: [
                    _buildLocationListView(),
                    _buildLocationHistoryView(),
                    _buildLocationCollectView(),
                  ],
                ),
              )
            ],
          ),
          bottomSheet: _buildBottomSheet(context),
        ));
  }

  Widget _buildBottomSheet(BuildContext context) {
    // Logger.print("context.mediaQueryPadding.bottom: ${context.mediaQueryPadding.bottom}");
    return Padding(
      padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: GradientButton(
          height: 44.h,
          tapCallback: logic.onSaveLocation,
          child: '保存地址'.toText..style = Styles.ts_FFFFFF_16_medium,
        ),
      ),
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Stack(
        children: [
          FilledInput(
            controller: logic.textEditingController,
            maxLines: 5,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: TextButton(
              onPressed: logic.onCollectLocation,
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: logic.isCollect
                        ? Icon(
                            Icons.star_rounded,
                            size: 18.w,
                            color: Styles.c_CFAC74,
                          )
                        : Icon(
                            Icons.star_outline,
                            size: 18.w,
                            color: Styles.c_333333,
                          ),
                  ),
                  4.horizontalSpace,
                  (logic.isCollect ? "取消收藏" : "收藏地址").toText
                    ..style = Styles.ts_333333_14
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _buildSearchButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          "当前地址信息".toText..style = Styles.ts_555555_16,
          24.horizontalSpace,
          Expanded(
            child: BouncingWidget(
              onTap: logic.onShowSearchView,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Styles.c_F6F6F6,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Styles.c_EDEDED),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 24.w),
                    8.horizontalSpace,
                    '点击搜索地址'.toText..style = Styles.ts_666666_16,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab() {
    return TabBar(
        controller: logic.tabController,
        tabAlignment: TabAlignment.start,
        dividerColor: Styles.c_EDEDED,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 16.w),
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: Styles.c_999999,
        tabs:
            WatermarkProtoLocationLogic.tabs.map((e) => Tab(text: e)).toList());
  }

  Widget _buildLocationListView() {
    return _KeepAliveWrapper(
      child: SmartRefresher(
        controller: logic.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: logic.onRefresh,
        onLoading: logic.onLoading,
        header: CameraViews.buildHeader(),
        footer: CameraViews.buildFooter(),
        child: ListView.builder(
          itemBuilder: (c, i) => Obx(() =>
              _buildPoiItem(logic.poiList[i], onSelect: logic.onSelectPoi)),
          itemCount: logic.poiList.length,
        ),
      ),
    );
  }

  Widget _buildLocationHistoryView() {
    return _KeepAliveWrapper(
      child: ListView.builder(
        itemBuilder: (c, i) => _buildLocationItem(logic.historyLocationList[i],
            onSelect: logic.onSelectLocation),
        itemCount: logic.historyLocationList.length,
      ),
    );
  }

  Widget _buildLocationCollectView() {
    return _KeepAliveWrapper(
      child: ListView.builder(
        itemBuilder: (c, i) => _buildLocationItem(logic.collectLocationList[i],
            onSelect: logic.onSelectLocation),
        itemCount: logic.collectLocationList.length,
      ),
    );
  }

  Widget _buildLocationItem(LocationModel locationModel,
          {required Function(LocationModel locationModel) onSelect}) =>
      InkWell(
        onTap: () => onSelect(locationModel),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Styles.c_EDEDED))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 24.w,
              ),
              8.horizontalSpace,
              Expanded(
                child: (locationModel.address ?? '').toText
                  ..style = Styles.ts_333333_16_medium
                  ..maxLines = 2
                  ..overflow = TextOverflow.ellipsis,

              ),
            ],
          ),
        ),
      );

  Widget _buildPoiItem(AMapPoi poi,
          {required Function(AMapPoi poi) onSelect}) =>
      InkWell(
        onTap: () => onSelect(poi),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            12.horizontalSpace,
            Icon(
              Icons.location_on_outlined,
              size: 24.w,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Styles.c_EDEDED))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (poi.name ?? '').toText
                      ..style = Styles.ts_333333_16_medium
                      ..overflow = TextOverflow.ellipsis,
                    8.verticalSpace,
                    ('${poi.district}${poi.address}').toText
                      ..style = Styles.ts_666666_14_medium
                      ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              ),
            )
          ],
        ),
      );
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
