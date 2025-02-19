import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:watermark_camera/pages/small_watermark/right_bottom_style/right_bottom_style_logic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/custom_ext.dart';

import '../../../widgets/watermark_ui/assert_image_builder.dart';
import '../../../widgets/watermark_ui/image_slider_thumb.dart';

class RightBottomStyleView extends StatelessWidget {
  RightBottomStyleView({super.key});

  final logic = Get.find<RightBottomStyleLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(10.w),
        child: Column(
          children: [
            // 位置
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  const Text('竖向位移'),
                  Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              logic.changePosition(
                                  status: 1,
                                  dx: logic.horizontalOffset.value,
                                  dy: logic.verticalOffset.value);
                            }
                            //     () {
                            //   logic.verticalOffset.value =
                            //       logic.minus(logic.verticalOffset.value);
                            //   logic.changePosition(logic.horizontalOffset.value,
                            //       logic.verticalOffset.value);
                            // }
                            ,
                            child: Image.asset(
                              'minus_water_img'.png,
                              width: 40.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text('下'),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            "${logic.verticalOffset.value.toInt()}",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          )),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              logic.changePosition(
                                  status: 2,
                                  dx: logic.horizontalOffset.value,
                                  dy: logic.verticalOffset.value);
                            },
                            child: Image.asset(
                              'add_water_img'.png,
                              width: 40.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text('上'),
                        ],
                      ),
                    ],
                  )
                ]),
                Column(children: [
                  const Text('横向位移'),
                  Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              logic.changePosition(
                                  status: 3,
                                  dx: logic.horizontalOffset.value,
                                  dy: logic.verticalOffset.value);
                            },
                            child: Image.asset(
                              'minus_water_img'.png,
                              width: 40.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text('右'),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            "${logic.horizontalOffset.value.toInt()}",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          )),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // logic.horizontalOffset.value =
                              //     logic.add(logic.horizontalOffset.value);
                              logic.changePosition(
                                  status: 4,
                                  dx: logic.horizontalOffset.value,
                                  dy: logic.verticalOffset.value);
                            },
                            child: Image.asset(
                              'add_water_img'.png,
                              width: 40.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text('左'),
                        ],
                      ),
                    ],
                  )
                ]),
                GestureDetector(
                  onTap: logic.resetPosition,
                  child: Image.asset(
                    'reset_img'.png,
                    width: 32.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            // 透明度
            Row(
              children: [
                const Text('透明度'),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        margin: EdgeInsets.only(top: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '透明',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text(
                              "不透明",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          bottom: 20.w,
                        ),
                        // decoration: BoxDecoration(
                        //   border: Border(
                        //       top:
                        //           BorderSide(color: "f0f0f0".hex, width: 1.w)),
                        // ),
                        child: AssertsImageBuilder('pic_thum'.png,
                            builder: (context, imageInfo) {
                          return Obx(() {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 5.w,
                                thumbShape: ImageSliderThumb(
                                    image: imageInfo?.image,
                                    size: const Size(30, 30),
                                    msg:
                                        '${logic.opacityPercent.value.toInt()}%'),
                              ),
                              child: Slider(
                                divisions: 100,
                                value: logic.opacityPercent.value,
                                min: 0,
                                max: 100,
                                activeColor: "e6e9f0".hex,
                                inactiveColor: "e6e9f0".hex,
                                onChanged: logic.changeOpacity,
                              ),
                            );
                          });
                        }),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: logic.resetOpacity,
                  child: Image.asset(
                    'reset_img'.png,
                    width: 32.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
