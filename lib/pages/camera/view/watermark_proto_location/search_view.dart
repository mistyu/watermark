import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/utils/library.dart';

class SearchView extends StatefulWidget {
  final Function()? onBack;
  final Function(Map<String, dynamic> poi) onTapPoi;
  const SearchView({super.key, this.onBack, required this.onTapPoi});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final RefreshController _refreshController = RefreshController();
  final List<dynamic> _poiList = [];
  final _currentPage = 1.obs;
  final _currentKeyword = ''.obs;
  final _isLoading = false.obs;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String keyword) async {
    if (keyword.isEmpty) {
      setState(() => _poiList.clear());
      return;
    }

    _currentKeyword.value = keyword;
    _currentPage.value = 1;
    _isLoading.value = true;

    try {
      final results = await Apis.searchPOIByKeyword(
        keywords: keyword,
        page: _currentPage.value,
      );

      setState(() {
        _poiList.clear();
        _poiList.addAll(results);
      });
    } catch (e) {
      Utils.showToast('搜索失败');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _onLoading() async {
    if (_currentKeyword.value.isEmpty) return;

    try {
      final results = await Apis.searchPOIByKeyword(
        keywords: _currentKeyword.value,
        page: _currentPage.value + 1,
      );

      if (results.isEmpty) {
        _refreshController.loadNoData();
      } else {
        _currentPage.value++;
        setState(() => _poiList.addAll(results));
        _refreshController.loadComplete();
      }
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildSearchHeader(),
          14.verticalSpace,
          Expanded(
            child: Obx(() => _isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildPoiList()),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Styles.c_F6F6F6)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: "nvbar_ico_back".svg.toSvg
              ..width = 24.w
              ..height = 24.h
              ..color = Styles.c_333333,
          ),
          8.horizontalSpace,
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: '输入搜索内容',
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

  Widget _buildPoiList() {
    if (_poiList.isEmpty) {
      return Center(
        child: ('暂无搜索结果'.toText
          ..style = Styles.ts_333333_16
          ..textAlign = TextAlign.center),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: false,
      enablePullUp: true,
      footer: const ClassicFooter(
        loadingText: '加载中...',
        noDataText: '没有更多数据',
        idleText: '上拉加载更多',
        failedText: '加载失败',
        canLoadingText: '松开加载更多',
      ),
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _poiList.length,
        itemBuilder: (context, index) => _buildPoiItem(_poiList[index]),
      ),
    );
  }

  Widget _buildPoiItem(Map<String, dynamic> poi) {
    final name = poi['name'] as String? ?? '';
    final address = poi['address'] as String? ?? '';
    final district = poi['adname'] as String? ?? '';

    return InkWell(
      onTap: () => widget.onTapPoi(poi),
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
          ],
        ),
      ),
    );
  }
}
