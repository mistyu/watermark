import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/utils/library.dart';
import '../logic.dart';

class NetworkBrandList extends StatelessWidget {
  final logic = Get.find<WatermarkProtoBrandLogoLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => logic.networkBrandList.isEmpty
          ? Container(
              height: 100.h,
              width: double.infinity,
              child: const Center(
                child: Text('暂无数据'),
              ),
            )
          : SmartRefresher(
              controller: logic.networkRefreshController,
              enablePullDown: true,
              header: const WaterDropHeader(
                complete: Text('刷新完成', style: TextStyle(color: Colors.green)),
                failed: Text('刷新失败', style: TextStyle(color: Colors.red)),
              ),
              onRefresh: logic.onNetworkRefresh,
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 13.w,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 1.2,
                ),
                itemCount: logic.networkBrandList.length,
                itemBuilder: (context, index) {
                  final brand = logic.networkBrandList[index];
                  return GestureDetector(
                    onTap: () => logic.onSelectBrandPath(brand.logoUrl),
                    child: Column(
                      children: [
                        Container(
                          height: 90.h,
                          decoration: const BoxDecoration(
                            color: Styles.c_F9F9F9,
                          ),
                          child: Center(
                            child: Image.network(
                              brand.logoUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                            brand.name,
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
              ),
            ),
    );
  }
}
