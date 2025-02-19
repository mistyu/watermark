import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/plugin/amap_search/amap_seach.dart';
import 'package:watermark_camera/utils/library.dart';

class SearchView extends StatefulWidget {
  final Function()? onBack;
  final Function(AMapPoi poi) onTapPoi;
  const SearchView({super.key, this.onBack, required this.onTapPoi});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<AMapPoi> _poiList = [];

  Future<List<AMapPoi>> _request(String keyword) async =>
      await AmapFlutterSearch.searchKeyword(keyword, page: 1, pageSize: 35);

  void onSearch(String keyword) async {
    final list = await _request(keyword);
    setState(() {
      _poiList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Styles.c_F6F6F6),
            )),
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
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: '输入搜索内容',
                      hintStyle: Styles.ts_333333_16,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                    ),
                  ),
                ),
                8.horizontalSpace
              ],
            ),
          ),
          14.verticalSpace,
          Expanded(
            child: _poiList.isEmpty
                ? Center(
                    child: ('暂无搜索结果'.toText
                      ..style = Styles.ts_333333_16
                      ..textAlign = TextAlign.center),
                  )
                : ListView.builder(
                    itemCount: _poiList.length,
                    itemBuilder: (context, index) {
                      return _buildItem(_poiList[index],
                          onSelect: widget.onTapPoi);
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(AMapPoi poi, {required Function(AMapPoi poi) onSelect}) =>
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
