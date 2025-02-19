import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/core/service/watermark_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_grid/right_bottom_grid_logic.dart';
import 'package:watermark_camera/utils/library.dart';

class RightBottomGridView extends StatelessWidget {
  final RightBottomResource? resource;

  RightBottomGridView({super.key, required this.resource});

  final logic = Get.find<RightBottomGridLogic>();

  // 水印网格视图项
  Widget _buildGridViewItem(RightBottomResource resource,
      {Function()? onTap, bool? isSelected = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage("bg_b".png), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            // 底层内容
            Center(
              child: Container(
                // clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.all(5.w),
                child: resource.cover != '' && resource.cover != null
                    ? Image.network(
                        "${Config.staticUrl}${resource.cover}",
                        // alignment: Alignment.center,
                        fit: BoxFit.contain,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            // 遮罩层
            isSelected == true
                ? Positioned.fill(
                    child: Container(
                      // color: Colors.black.withOpacity(0.5),
                      decoration: BoxDecoration(
                          color: Styles.c_0D0D0D.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(6.r)),
                      child: Center(
                        child: Container(
                            width: 60.w,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                gradient: const LinearGradient(colors: [
                                  Color(0xff76a6ff),
                                  Color(0xff146dfe)
                                ])),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'editico_white'.png,
                                  width: 16.w,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  '编辑',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.white),
                                ),
                              ],
                            )),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(12).w,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 6.w,
                crossAxisSpacing: 6.w,
                crossAxisCount: 4, // 每行4列
              ),
              itemCount: logic.rightBottomList.length,
              // 总共
              itemBuilder: (context, index) {
                final rightBottomResource = logic.rightBottomList[index];
                return FutureBuilder(
                    future: WatermarkService.getWatermarkViewByResource<
                        RightBottomView>(rightBottomResource),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return _buildGridViewItem(rightBottomResource,
                            onTap: () => logic.onChangePreviewWatermark(
                                snap.data!, rightBottomResource),
                            isSelected: logic.selectedRightBottomId.value ==
                                rightBottomResource.id);
                      }
                      return const SizedBox.shrink();
                    });
              }),
        ));
  }
}
