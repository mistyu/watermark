import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_antifake/right_bottom_antifake_view.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_grid/right_bottom_grid_view.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_sign/right_bottom_sign_view.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_size/right_bottom_size_view.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_style/right_bottom_style_view.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../models/camera.dart';
import '../../utils/colours.dart';
import '../../widgets/camera_preview.dart';
import '../../widgets/right_bottom_preview.dart';

// import '../../widgets/watermark_ui/WidgetsToImage.dart';
import 'small_watermark_logic.dart';

class SmallWatermarkPage extends StatelessWidget {
  SmallWatermarkPage({Key? key}) : super(key: key);

  final logic = Get.find<SmallWatermarkLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // leading: Text("<"),
        title: Center(
          child: Text(
            '右下角水印',
            style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: logic.saveRightBottom,
            child: const Text(
              "保存",
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body:
          // CameraLayout(
          //     controller: cameraLogic.cameraController!,
          //     aspectRatio: CameraPreviewAspectRatio.ratio_1_1,
          //     rightBottom: //右下角水印
          //       Obx(
          //     () => logic.currentRightBottomResource.value != null
          //         ? Positioned(
          //             // 位置
          //             right: logic.position.value.dx,
          //             bottom: logic.position.value.dy,
          //             child: Transform.scale(
          //               //大小
          //               alignment: Alignment.bottomRight,
          //               scale: logic.scale.value,
          //               child: Opacity(
          //                 //透明度
          //                 opacity: logic.opacity.value,
          //                 child: Visibility(
          //                   visible: cameraLogic.openRightBottomWatermark,
          //                   child: RightBottomPreview(
          //                     rightBottomResource:
          //                         logic.currentRightBottomResource.value!,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           )
          //         : const SizedBox.shrink(),
          //   ),
          //   // 主水印
          //   topActionWidget: const SizedBox.shrink(),
          //   bottomActionWidget: const SizedBox.shrink(),
          //   isCameraInitialized: true,
          //   child: Obx(
          //     () => cameraLogic.currentWatermarkResource.value != null
          //         ? Positioned(
          //             left: 4,
          //             bottom: 4,
          //             child: WatermarkPreview(
          //               resource: cameraLogic.currentWatermarkResource.value!,
          //             ),
          //           )
          //         : const SizedBox.shrink(),
          //   ),
          // ),
          CameraPreviewWidget(
              controller: logic.cameraLogic.cameraController!,
              aspectRatio: CameraPreviewAspectRatio.ratio_9_16,
              rightbottom: //右下角水印
                  Obx(
                () => logic.rightBottomView.value != null
                    ? Positioned(
                        // 位置
                        right: logic.position.value.dx,
                        bottom: 1.sh -
                            1.sw -
                            kToolbarHeight -
                            context.mediaQueryPadding.top +
                            logic.position.value.dy,
                        child: WidgetsToImage(
                          controller: logic.rightBottomWatermarkController,
                          key: logic.rightBottomKey,
                          child: SizedBox(
                            width:
                                // 120,
                                logic.RightBottomSize.value?.width ?? 0.5.sw,
                            height:
                                // 50,
                                logic.RightBottomSize.value?.height ??
                                    (1.sw - logic.position.value.dy),
                            child: Opacity(
                              //透明度
                              opacity: logic.opacity.value,
                              child: RightBottomPreview(
                                rightBottomView: logic.rightBottomView.value!,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // 主水印
              child: Positioned(
                left: 4,
                bottom: 1.sh -
                    1.sw -
                    kToolbarHeight -
                    context.mediaQueryPadding.top +
                    4,
                child: WatermarkPreview(
                  resource: logic.cameraLogic.currentWatermarkResource.value!,
                ),
              )),
      bottomSheet: Obx(() {
        return Container(
          height: 1.sh - 1.sw - kToolbarHeight - context.mediaQueryPadding.top,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.vertical(
                top: Radius.circular(20.r),
              )),
          child: Column(
            children: [
              TabBar(
                controller: logic.tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.only(
                    left: 20.w, right: 8.w, top: 10.w, bottom: 5.w),
                labelStyle: TextStyle(fontSize: 16.sp),
                unselectedLabelStyle: TextStyle(fontSize: 16.sp),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 5.w),
                unselectedLabelColor: Colours.kGrey700,
                tabs: logic.tabList.map((item) {
                  return Tab(
                    height: 30.h,
                    text: item,
                    // style: Theme.of(context).textTheme.titleLarge,
                  );
                }).toList(),
              ),
              Expanded(
                child: TabBarView(controller: logic.tabController, children: [
                  // Placeholder(),
                  RightBottomGridView(
                    resource: logic.currentRightBottomResource.value,
                  ),
                  RightBottomSizeView(
                      // rightBottomView: _rightBottomView,
                      // callbackRightBottomSize: (value) {
                      //   _scaleFactor.value = value * 0.01;
                      // },
                      // callbackRightBottomantiFake: (value) {},
                      ),
                  RightBottomAntifakeView(
                      // rightBottomView: _rightBottomView,
                      ),
                  RightBottomSignView(
                      // rightBottomView: _rightBottomView,
                      ),
                  RightBottomStyleView(
                      // rightBottomView: _rightBottomView,
                      // callbackRightBottomOpacity: (value) {
                      //   _opacity.value = value * 0.01;
                      // },
                      // callbackRightBottomPosition: (v) {
                      //   _rightbottomPosition.value = v;
                      // },
                      ),
                ]),
              )
            ],
          ),
        );
      }),
    );
  }
}
