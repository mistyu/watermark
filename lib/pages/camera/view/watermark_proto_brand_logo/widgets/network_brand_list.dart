import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import '../logic.dart';

class NetworkBrandList extends StatelessWidget {
  final logic = Get.find<WatermarkProtoBrandLogoLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
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
            onTap: () => logic.onSelectNetworkBrand(brand),
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
                      loadingBuilder: (context, child, loadingProgress) {
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
    );
  }
}
