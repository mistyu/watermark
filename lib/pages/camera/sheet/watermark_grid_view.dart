import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/models/db/watermark/watermark_save.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/utils/db_helper.dart';
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
    logic.activeTab.value = 1;
    logic.tabController?.index = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.resource != null) {
        logic.selectedWatermarkId.value = widget.resource!.id;
        logic.initData();
      }
    });
  }

  /// categoryWidges
  List<Widget> _categoryWidges() {
    return [
      Tab(
          child: _buildTabItem("我的收藏",
              isSelected: logic.activeTab.value == 0,
              onTap: () => logic.switchTab(0))),
      ...logic.categories.map((e) {
        return Obx(() {
          final index = logic.categories.indexOf(e);
          return Tab(
            child: _buildTabItem(e.title ?? '',
                isSelected: logic.activeTab.value == index + 1,
                onTap: () => logic.switchTab(index + 1)),
          );
        });
      }).toList()
    ];
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
                        "水印详情".toText..style = Styles.ts_333333_18_medium,
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
                          tabs: _categoryWidges()));
                    }),
                  ),
                  Expanded(
                    child:
                        TabBarView(controller: logic.tabController, children: [
                      // 我的收藏 --- 这里要进行读取数据库
                      FutureBuilder(
                        future: DBHelper.getAllSavedWatermarks(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text("加载失败: ${snapshot.error}"),
                            );
                          }

                          if (snapshot.hasData) {
                            List<WatermarkSaveModel> savedWatermarks =
                                snapshot.data!;
                            print(
                                "xiaojianjian savedWatermarks: $savedWatermarks");

                            if (savedWatermarks.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.bookmark_border,
                                        size: 48.r, color: Styles.c_999999),
                                    16.verticalSpace,
                                    Text("暂无收藏的水印", style: Styles.ts_999999_16),
                                    8.verticalSpace,
                                    Text("您可以收藏常用的水印模板",
                                        style: Styles.ts_999999_14),
                                  ],
                                ),
                              );
                            }

                            return ListView.separated(
                              controller: widget.scrollController,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 16.w),
                              itemCount: savedWatermarks.length,
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1.h, color: Styles.c_EDEDED),
                              itemBuilder: (context, index) {
                                final savedWatermark = savedWatermarks[index];
                                return _buildSavedWatermarkListItem(
                                  savedWatermark,
                                  onTap: () {
                                    // 查找对应的原始水印资源
                                    final resourceId = int.tryParse(
                                            savedWatermark.resourceId) ??
                                        0;
                                    if (resourceId > 0) {
                                      logic.selectWatermark(resourceId);
                                    }
                                  },
                                  onDelete: () async {
                                    // 显示确认删除对话框
                                    final result = await Get.dialog(
                                      AlertDialog(
                                        title: Text("删除收藏",
                                            style: Styles.ts_333333_18_bold),
                                        content: Text("确定要删除这个收藏的水印吗？",
                                            style: Styles.ts_666666_16),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: false),
                                            child: Text("取消",
                                                style: Styles.ts_999999_16),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: true),
                                            child: Text("删除",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.sp)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result == true) {
                                      await DBHelper.deleteSavedWatermark(
                                          savedWatermark.id!);
                                      // 刷新列表
                                      setState(() {});
                                    }
                                  },
                                  isSelected: logic.selectedWatermarkId.value ==
                                      int.tryParse(savedWatermark.resourceId),
                                );
                              },
                            );
                          }

                          return const Center(
                            child: Text("加载中..."),
                          );
                        },
                      ),

                      ...logic.categories.map((e) {
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
                      }).toList()
                    ]),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
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
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: Colors.grey[300]!)),
                        child: Image.network(
                          "${Config.staticUrl}${resource.cover}",
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return GestureDetector(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.error,
                                        color: Colors.grey[400], size: 20.w),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "亲，网络开小差了，请稍后重试",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                              onPressed: logic.exitAndEdit,
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

  // 收藏水印列表项
  Widget _buildSavedWatermarkListItem(
    WatermarkSaveModel savedWatermark, {
    Function()? onTap,
    Function()? onDelete,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Styles.c_0C8CE9.withOpacity(0.05)
              : Colors.transparent,
          border: Border.all(
            width: isSelected ? 1.w : 0,
            color: isSelected ? Styles.c_0C8CE9 : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 左侧水印预览图
            Container(
              width: 120.w,
              height: 80.h,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              clipBehavior: Clip.hardEdge,
              child: savedWatermark.url != null &&
                      savedWatermark.url!.isNotEmpty
                  ? Image.network(
                      "${Config.staticUrl}${savedWatermark.url}",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error,
                                  color: Colors.grey[400], size: 20.w),
                              SizedBox(height: 4.h),
                              Text(
                                "图片加载失败",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_not_supported,
                                color: Colors.grey[400], size: 24.w),
                            SizedBox(height: 4.h),
                            Text(
                              "无预览图",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            // 右侧信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 水印名称
                  Text(
                    savedWatermark.name,
                    style: Styles.ts_333333_16_medium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  8.verticalSpace,

                  // 锁定信息 - 添加空值检查
                  if (savedWatermark.lockTime != null &&
                      savedWatermark.lockTime!.isNotEmpty)
                    _buildInfoRow(
                        Icons.access_time, "时间: ${savedWatermark.lockTime}"),

                  if (savedWatermark.lockAddress != null &&
                      savedWatermark.lockAddress!.isNotEmpty)
                    _buildInfoRow(
                        Icons.location_on, "地址: ${savedWatermark.lockAddress}"),

                  if (savedWatermark.lockCoordinates != null &&
                      savedWatermark.lockCoordinates!.isNotEmpty)
                    _buildInfoRow(Icons.gps_fixed,
                        "坐标: ${savedWatermark.lockCoordinates}"),
                ],
              ),
            ),

            // 删除按钮
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline,
                  color: Colors.red[300], size: 20.w),
              padding: EdgeInsets.all(8.w),
              constraints: BoxConstraints(),
              splashRadius: 24.r,
            ),
          ],
        ),
      ),
    );
  }

  // 构建信息行
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 14.w, color: Styles.c_666666),
          4.horizontalSpace,
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: Styles.c_666666,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
