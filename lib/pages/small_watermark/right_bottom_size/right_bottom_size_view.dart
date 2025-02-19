import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_size/right_bottom_size_logic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/custom_ext.dart';

import '../../../widgets/watermark_ui/assert_image_builder.dart';
import '../../../widgets/watermark_ui/image_slider_thumb.dart';

class RightBottomSizeView extends StatelessWidget {
  RightBottomSizeView({super.key});

  final logic = Get.find<RightBottomSizeLogic>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          Row(
            children: [
              const Column(
                children: [Text('水印'), Text('大小')],
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.only(top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '小',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          Text(
                            "大",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 20.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: "f0f0f0".hex, width: 1.w)),
                      ),
                      child: AssertsImageBuilder('pic_thum'.png,
                          builder: (context, imageInfo) {
                        return Obx(() {
                          return SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 5,
                              thumbShape: ImageSliderThumb(
                                  image: imageInfo?.image,
                                  size: const Size(30, 30),
                                  msg: '${logic.sizePercent.value.toInt()}%'),
                            ),
                            child: Slider(
                              divisions: 200,
                              value: logic.sizePercent.value,
                              min: 0,
                              max: 200,
                              activeColor: "e6e9f0".hex,
                              inactiveColor: "e6e9f0".hex,
                              onChanged: logic.changeSize,
                            ),
                          );
                        });
                      }),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: logic.resetSize,
                child: Image.asset(
                  'reset_img'.png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('防伪码'), Text('大小')],
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      margin: EdgeInsets.only(top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '小',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          Text(
                            "大",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 20.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: "f0f0f0".hex, width: 1.w)),
                      ),
                      child: AssertsImageBuilder('pic_thum'.png,
                          builder: (context, imageInfo) {
                        return Obx(() {
                          return SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 5,
                              thumbShape: ImageSliderThumb(
                                  image: imageInfo?.image,
                                  size: const Size(30, 30),
                                  msg: '${logic.antiFakePercent.value.toInt()}%'),
                            ),
                            child: Slider(
                              divisions: 200,
                              value: logic.antiFakePercent.value,
                              min: 0,
                              max: 200,
                              activeColor: "e6e9f0".hex,
                              inactiveColor: "e6e9f0".hex,
                              onChanged: logic.changeAntiFake,
                            ),
                          );
                        });
                      }),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: logic.resetAntiFake,
                child: Image.asset(
                  'reset_img'.png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
