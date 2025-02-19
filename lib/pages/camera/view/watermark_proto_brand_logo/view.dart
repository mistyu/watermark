import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/models/watermark_brand/watermark_brand.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/title_bar.dart';

import 'logic.dart';

class WatermarkProtoBrandLogoPage extends StatelessWidget {
  WatermarkProtoBrandLogoPage({Key? key}) : super(key: key);

  final WatermarkProtoBrandLogoLogic logic =
      Get.put(WatermarkProtoBrandLogoLogic());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: "选择品牌图",
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                child: Column(
                  children: [
                    "我的上传".toText..style = Styles.ts_999999_18_medium,
                    Container(
                      width: 24.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Styles.c_0C8CE9,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 108.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: logic.onUploadBrandLogo,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: "add_route_img".png.toImage
                          ..width = 108.w
                          ..height = 108.h
                          ..fit = BoxFit.cover,
                      ),
                    ),
                    ...List.generate(logic.myBrandList.length, (index) {
                      final brand = logic.myBrandList[index];
                      return Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: GestureDetector(
                          onTap: () => logic.onSelectBrandPath(brand.logoPath!),
                          child: Center(
                            child: Image.network(
                              Config.staticUrl + brand.logoPath!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                child: Column(
                  children: [
                    "网络来源".toText..style = Styles.ts_999999_18_medium,
                    Container(
                      width: 24.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Styles.c_0C8CE9,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: SmartRefresher(
                      controller: logic.refreshController,
                      onRefresh: logic.onRefreshBrandLogoList,
                      onLoading: logic.onLoadingBrandLogoList,
                      enablePullDown: false,
                      enablePullUp: true,
                      header: CameraViews.buildHeader(),
                      footer: CameraViews.buildFooter(),
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 8.w,
                            mainAxisSpacing: 8.w,
                            childAspectRatio: 16 / 9,
                            crossAxisCount: 2),
                        itemBuilder: (c, i) =>
                            _buildBrandLogoItem(logic.commonBrandList[i]),
                        itemCount: logic.commonBrandList.length,
                      )))
            ],
          ),
        ));
  }

  Widget _buildBrandLogoItem(WatermarkBrand brand) {
    return GestureDetector(
      onTap: () => logic.onSelectBrandPath(brand.logoPath!),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.c_EDEDED,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Image.network(
            Config.staticUrl + brand.logoPath!,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
