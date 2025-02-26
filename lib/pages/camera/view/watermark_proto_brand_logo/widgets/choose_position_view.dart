import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/camera/camera_logic.dart';
import 'package:watermark_camera/pages/camera/view/watermark_proto_brand_logo/widgets/choose_position_logic.dart';
import 'package:watermark_camera/pages/camera/widgets/main_watermark_builder.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';

class ChoosePositionView extends StatelessWidget {
  final logic = Get.put(ChoosePositionLogic());
  final controller = Get.find<CameraLogic>();

  ChoosePositionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text(
            '编辑品牌图片',
            style: TextStyle(
              color: Styles.c_0D0D0D,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: logic.confirmEdit,
              child: Text(
                '确定',
                style: TextStyle(
                  color: Styles.c_0C8CE9,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 预览区域
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    color: Styles.c_999999,
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    child: FutureBuilder<Widget>(
                      future: ImageUtil.loadNetworkImage(logic.imagePath!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Container(color: Colors.grey[300]);
                        }
                        return snapshot.data!;
                      },
                    )),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: GetBuilder<ChoosePositionLogic>(
                    init: logic,
                    builder: (logic) {
                      return Transform.scale(
                        alignment: Alignment.bottomLeft,
                        scale: 1,
                        child: WatermarkPreview(
                          resource: logic.resource.value!,
                          watermarkView: logic.watermarkView.value,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),

            // 底部选项卡
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tab栏
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Styles.c_EDEDED,
                          width: 1.h,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTab('位置', 0),
                        _buildTab('大小', 1),
                        _buildTab('透明度', 2),
                      ],
                    ),
                  ),

                  // Tab内容区域
                  SizedBox(
                    height: 120.h,
                    child: Obx(() {
                      switch (logic.selectedTab.value) {
                        case 0:
                          return _buildPositionContent();
                        case 1:
                          return _buildSizeContent();
                        case 2:
                          return _buildOpacityContent();
                        default:
                          return const SizedBox();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildTab(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => logic.switchTab(index),
        child: Obx(() {
          final isSelected = logic.selectedTab.value == index;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? Styles.c_0C8CE9 : Colors.transparent,
                  width: 2.h,
                ),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Styles.c_0C8CE9 : Styles.c_999999,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPositionContent() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '拖动图片调整位置',
            style: TextStyle(
              color: Styles.c_999999,
              fontSize: 12.sp,
            ),
          ),
          // TODO: 添加位置调整相关控件
        ],
      ),
    );
  }

  Widget _buildSizeContent() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '调整图片大小',
            style: TextStyle(
              color: Styles.c_999999,
              fontSize: 12.sp,
            ),
          ),
          // TODO: 添加大小调整滑块
        ],
      ),
    );
  }

  Widget _buildOpacityContent() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '调整图片透明度',
            style: TextStyle(
              color: Styles.c_999999,
              fontSize: 12.sp,
            ),
          ),
          // TODO: 添加透明度调整滑块
        ],
      ),
    );
  }
}
