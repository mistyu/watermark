import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sound_mode/utils/constants.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/utils/library.dart';
import '../logic.dart';

class MyBrandList extends StatelessWidget {
  final logic = Get.find<WatermarkProtoBrandLogoLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 上传按钮
        Padding(
          padding: EdgeInsets.all(16.w),
          child: GestureDetector(
            onTap: logic.onUploadBrandLogo,
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Styles.c_0C8CE9,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  '上传品牌图片',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ),

        // 品牌列表
        Expanded(
          child: Obx(
            () => logic.myBrandList.isEmpty
                ? SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: const Center(
                      child: Text('暂无数据, 请您先上传数据'),
                    ),
                  )
                : SmartRefresher(
                    controller: logic.myBrandRefreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    header: const WaterDropHeader(
                      complete:
                          Text('刷新完成', style: TextStyle(color: Colors.green)),
                      failed: Text('刷新失败', style: TextStyle(color: Colors.red)),
                    ),
                    footer: const ClassicFooter(
                      loadingText: '加载中...',
                      noDataText: '没有更多数据',
                      idleText: '上拉加载更多',
                      failedText: '加载失败',
                      canLoadingText: '松开加载更多',
                    ),
                    onRefresh: logic.onMyBrandRefresh,
                    onLoading: logic.onLoadMore,
                    child: GridView.builder(
                      cacheExtent: 300,
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 13.w,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: logic.myBrandList.length,
                      itemBuilder: (context, index) {
                        final brand = logic.myBrandList[index];
                        return GestureDetector(
                          // onTap: () => logic.onSelectNetworkBrand(brand),
                          child: Column(
                            children: [
                              Container(
                                height: 90.h,
                                decoration: const BoxDecoration(
                                  color: Styles.c_F9F9F9,
                                ),
                                child: Center(
                                  child: Image.network(
                                    Config.apiUrl + brand.logoUrl!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '加载中...',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Styles.c_999999,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  brand.logoName ?? "未命名",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Styles.c_0D0D0D,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
          ),
        ),
      ],
    );
  }
}
