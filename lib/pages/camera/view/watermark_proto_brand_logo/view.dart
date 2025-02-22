import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'widgets/my_brand_list.dart';
import 'widgets/network_brand_list.dart';
import 'logic.dart';

class WatermarkProtoBrandLogoPage extends StatelessWidget {
  final logic = Get.find<WatermarkProtoBrandLogoLogic>();

  WatermarkProtoBrandLogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.w),
            onPressed: () => Get.back(),
          ),
          title: Text(
            '品牌图片',
            style: TextStyle(
              fontSize: 16.sp,
              color: Styles.c_0D0D0D,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Column(
          children: [
            // 搜索栏
            Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: logic.onSearchChanged,
                      controller: logic.searchController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: '输入名称查找品牌图片',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Styles.c_999999,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Styles.c_0D0D0D,
                          size: 20.w,
                        ),
                        filled: true,
                        fillColor: Styles.c_F9F9F9,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () => logic.search(logic.searchController.text),
                    child: Text(
                      '搜索',
                      style: TextStyle(
                        color: Styles.c_0C8CE9,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TabBar
            SizedBox(
              height: 45.h,
              child: TabBar(
                dividerColor: Styles.c_F6F6F6,
                onTap: logic.switchTab,
                labelColor: Styles.c_0C8CE9,
                unselectedLabelColor: Styles.c_999999,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2.h,
                    color: Styles.c_0C8CE9,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                tabs: [
                  Tab(
                    height: 45.h,
                    text: '网络品牌图片',
                  ),
                  Tab(
                    height: 45.h,
                    text: '我的品牌图片',
                  ),
                ],
              ),
            ),

            // TabBarView
            Obx(() => Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      logic.isLoadingNet.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : NetworkBrandList(),
                      logic.inLoadingMy.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : MyBrandList(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
