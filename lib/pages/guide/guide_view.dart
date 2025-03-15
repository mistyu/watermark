import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/utils/library.dart';

import 'guide_logic.dart';

class GuidePage extends StatelessWidget {
  GuidePage({super.key});

  final GuideLogic logic = Get.put(GuideLogic());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (logic.isInitialized.value) {
        return Scaffold(
            appBar: AppBar(
              title: "水印列表".toText..style = Styles.ts_333333_24_medium,
              bottom: TabBar(
                  controller: logic.tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerHeight: 0,
                  labelStyle:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  tabs:
                      logic.tabs.map((e) => Tab(text: e.title ?? "")).toList()),
            ),
            body: TabBarView(
              controller: logic.tabController,
              children: logic.tabs.map((e) {
                final currentCategoryResources = logic.watermarkResources
                    .where((element) => element.cid == e.id)
                    .toList();
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 6.w,
                      crossAxisSpacing: 6.w,
                      crossAxisCount: 2, // 每行两列
                      childAspectRatio: 16 / 14, // 宽高比
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
                    itemCount: currentCategoryResources.length,
                    itemBuilder: (context, index) {
                      final resource = currentCategoryResources[index];
                      return _buildGridViewItem(resource, onTap: () {
                        logic.onTapWatermarkResource(resource);
                      });
                    });
              }).toList(),
            ));
      }

      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    });
  }

  Widget _buildGridViewItem(WatermarkResource resource, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
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
                              value: loadingProgress.expectedTotalBytes != null
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
                    ));
              }),
            ),
          ),
          12.verticalSpace,
          (resource.title ?? '').toText
            ..style = TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              color: Styles.c_333333,
            )
        ],
      ),
    );
  }
}
