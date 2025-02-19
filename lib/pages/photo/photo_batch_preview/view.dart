import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';

import 'logic.dart';

class PhotoBatchPreviewPage extends StatelessWidget {
  PhotoBatchPreviewPage({Key? key}) : super(key: key);

  final PhotoBatchPreviewLogic logic = Get.find<PhotoBatchPreviewLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 204.h,
            padding: EdgeInsets.only(top: context.mediaQueryPadding.top),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage("vip_hint_bg".webp),
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    BackButton(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "${logic.photoPaths.length}".toText
                      ..style = TextStyle(
                          color: Styles.c_FAC576,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600),
                    "张".toText
                      ..style = TextStyle(
                          color: Styles.c_FAC576,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600)
                  ],
                ),
                "批量处理完成!".toText
                  ..style = Styles.ts_CFAC74_16
                  ..textAlign = TextAlign.center
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.w,
                  crossAxisSpacing: 4.w,
                  childAspectRatio: 3 / 4),
              itemCount: logic.photoPaths.length,
              itemBuilder: (context, index) {
                final path = logic.photoPaths[index];
                return Obx(() => BouncingWidget(
                  onTap: () => logic.onTapPhoto(index),
                  child: Stack(
                    children: [
                      Container(
                          color: Styles.c_EDEDED, child: Center(child: _buildImage(path))),
                      Positioned(
                          right: 8.w,
                          top: 8.w,
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Styles.c_0D0D0D.withOpacity(0.2)),
                            child: Center(
                              child: Icon(
                                Icons.expand,
                                color: Styles.c_FFFFFF,
                                size: 16.sp,
                              ),
                            ),
                          ))
                    ],
                  ),
                ));
              },
            ),
          ),
          // 底部保存按钮
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: context.mediaQueryPadding.bottom + 16.h,
              top: 16.h,
            ),
            child: ElevatedButton(
              onPressed: logic.onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '全部保存 (${logic.photoPaths.length}张)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (logic.isVideo) {
      return FutureBuilder(
        future: Utils.getVideoThumbnail(File(path)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ImageUtil.fileImage(
                file: snapshot.data!, fit: BoxFit.cover);
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      );
    }
    return ImageUtil.fileImage(file: File(path), fit: BoxFit.cover);
  }
}
