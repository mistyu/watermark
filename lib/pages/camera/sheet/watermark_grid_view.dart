import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';

import 'watermark_grid_logic.dart';

class WatermarkGridView extends StatefulWidget {
  final Function(WatermarkResource? resource)? onSelect;
  final ScrollController? scrollController;
  final WatermarkResource? resource;

  const WatermarkGridView(
      {super.key, this.resource, this.onSelect, this.scrollController});

  @override
  State<WatermarkGridView> createState() => _WatermarkGridViewState();
}

class _WatermarkGridViewState extends State<WatermarkGridView> {
  final WatermarkGridViewLogic logic = Get.find<WatermarkGridViewLogic>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.resource != null) {
        logic.selectedWatermarkId.value = widget.resource!.id;
        logic.initData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (logic.isInitialized.value) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (logic.selectedWatermarkId.value != null)
              Padding(
                padding: const EdgeInsets.all(2.0).w,
                child: DottedBorder(
                  //水印外围虚线
                  strokeWidth: 2.w,
                  color: Colors.white,
                  // padding: EdgeInsets.all(4.w),
                  radius: Radius.circular(4.r),
                  borderType: BorderType.RRect,
                  dashPattern: const [4, 4],
                  padding: const EdgeInsets.all(8.0).w,
                  child: WatermarkPreview(
                    resource: logic.previewWatermarkResource!,
                  ),
                ),
              ),
            Container(
              constraints: BoxConstraints(maxHeight: 1.sh * 0.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r)),
                  color: Styles.c_F6F6F6),
              child: Column(
                children: [
                  Container(
                    height: 56.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: logic.clearPreviewWatermark,
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Styles.c_333333,
                            size: 24.w,
                          ),
                        ),
                        "我的水印".toText..style = Styles.ts_333333_18_medium,
                        GestureDetector(
                          onTap: () {
                            widget.onSelect != null
                                ? widget.onSelect
                                    ?.call(logic.previewWatermarkResource)
                                : logic.exit();
                          },
                          child: Icon(
                            widget.onSelect != null
                                ? Icons.check_rounded
                                : Icons.close_rounded,
                            color: Styles.c_333333,
                            size: 24.w,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Styles.c_FFFFFF,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Obx(() => TabBar(
                          controller: logic.tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          dividerHeight: 0,
                          indicatorColor: Colors.transparent,
                          indicatorWeight: 0,
                          indicator: const BoxDecoration(),
                          labelPadding: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 8.w),
                          tabs: logic.categories.map((e) {
                            return Obx(() {
                              final index = logic.categories.indexOf(e);
                              return Tab(
                                child: _buildTabItem(e.title ?? '',
                                    isSelected: logic.activeTab.value == index,
                                    onTap: () => logic.switchTab(index)),
                              );
                            });
                          }).toList()));
                    }),
                  ),
                  Expanded(
                    child: TabBarView(
                        controller: logic.tabController,
                        children: logic.categories.map((e) {
                          List<WatermarkResource> currentCategoryResources;
                          if (e.id == 0) {
                            currentCategoryResources = logic.watermarkResources;
                          } else {
                            currentCategoryResources = logic.watermarkResources
                                .where((element) => element.cid == e.id)
                                .toList();
                          }
                          return GridView.builder(
                              controller: widget.scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                                crossAxisCount: 2, // 每行两列
                                childAspectRatio: 18 / 14.5, // 宽高比
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 10.w),
                              itemCount: currentCategoryResources.length,
                              itemBuilder: (context, index) => Obx(() {
                                    final resource =
                                        currentCategoryResources[index];
                                    return _buildGridViewItem(resource,
                                        onTap: () {
                                      logic.selectWatermark(resource.id ?? 0);
                                    },
                                        isSelected:
                                            logic.selectedWatermarkId.value ==
                                                resource.id);
                                  }));
                        }).toList()),
                  )
                ],
              ),
            )
          ],
        );
      }

      return const SizedBox.shrink();
    });
  }

  // 水印网格视图项
  Widget _buildGridViewItem(WatermarkResource resource,
      {Function()? onTap, bool? isSelected = false}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  width: 3.w,
                  color: isSelected == true
                      ? Styles.c_0C8CE9.withOpacity(0.9)
                      : Colors.transparent)),
          padding: const EdgeInsets.all(2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r)),
                        child: Image.network(
                          "${Config.staticUrl}${resource.cover}",
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isSelected == true)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Styles.c_0D0D0D.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Center(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(60.w, 24.h),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.w, horizontal: 10.w),
                                  side: BorderSide(
                                      color:
                                          Colors.blueAccent.withOpacity(0.85)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r)),
                                  backgroundColor:
                                      Colors.blueAccent.withOpacity(0.85)),
                              icon: Icon(Icons.edit_rounded,
                                  color: Styles.c_FFFFFF, size: 16.w),
                              label: "编辑".toText
                                ..style = Styles.ts_FFFFFF_14_bold,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                12.verticalSpace,
                (resource.title ?? '').toText
                  ..style = Styles.ts_333333_18_medium
              ],
            ),
          ),
        ));
  }

  // 水印分类标签
  Widget _buildTabItem(String title,
      {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color:
              isSelected ? Styles.c_0C8CE9.withOpacity(0.05) : Styles.c_FFFFFF,
          border: Border.all(
              color: isSelected
                  ? Styles.c_0C8CE9.withOpacity(0.1)
                  : Styles.c_EDEDED),
        ),
        child: title.toText
          ..style = isSelected ? Styles.ts_0C8CE9_14_bold : Styles.ts_333333_14,
      ),
    );
  }
}
