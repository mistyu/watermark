import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/pages/photo/photo_gallery/photo_gallery_logic.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';

import 'photo_slide_logic.dart';

class PhotoSlidePage extends StatelessWidget {
  PhotoSlidePage({Key? key}) : super(key: key);

  final PhotoSlideLogic logic = Get.find<PhotoSlideLogic>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Obx(() => ExtendedImageSlidePage(
            slideAxis: SlideAxis.horizontal,
            slideType: SlideType.onlyImage,
            slidePageBackgroundHandler: (Offset offset, Size pageSize) {
              // 计算背景透明度
              double opacity = 1.0;
              if (offset.dx != 0) {
                opacity = 1 - offset.dx.abs() / (pageSize.width / 2.0);
              }
              // 确保透明度在 0-1 之间
              opacity = opacity.clamp(0.0, 1.0);
              return Colors.white.withOpacity(opacity);
            },
            child: Stack(
              children: [
                logic.photos.isNotEmpty == true
                    ? _pageView
                    : const Center(
                        child: Text("您还没有使用本应用进行拍照哦"),
                      ),
                Column(
                  children: [
                    _buildSlideTop(context),
                    const Spacer(),
                    _buildSlideBottom(context)
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Container _buildSlideBottom(BuildContext context) {
    return Container(
      height: context.mediaQueryPadding.bottom + 76.h,
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 6.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        children: [
          _buildActionItem(
              icon: "yin", label: "加水印", onTap: logic.onTapWatermark),
          if (!logic.currentIsVideo.value)
            _buildActionItem(icon: "edit", label: "编辑", onTap: logic.onTapEdit),
          if (!logic.currentIsVideo.value)
            _buildActionItem(icon: "crop", label: "剪切", onTap: logic.onTapCrop),
          _buildActionItem(
              icon: "delete", label: "删除", onTap: logic.onTapDelete),
          _buildActionItem(icon: "share", label: "分享", onTap: logic.onTapShare),
        ],
      ),
    );
  }

  Container _buildSlideTop(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.only(
          left: 8.w, right: 8.w, top: context.mediaQueryPadding.top),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded),
            iconSize: 24.sp,
          ),
          TextButton(
            onPressed: () async {
              // 等待页面跳转完成
              await AppNavigator.startPhotoGallery();
            },
            child: Row(
              children: [
                "image".svg.toSvg
                  ..width = 24.w
                  ..height = 24.w
                  ..color = Styles.c_0C8CE9,
                2.horizontalSpace,
                "批量加水印".toText..style = Styles.ts_0C8CE9_14_medium
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget get _pageView => ExtendedImageGesturePageView.builder(
        controller: logic.controller,
        onPageChanged: (int index) {},
        itemCount: logic.photos.length,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final photo = logic.photos.elementAt(index);
          return FutureBuilder<File?>(
              future: photo.file,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (photo.type == AssetType.video) {
                    return GetBuilder<PhotoSlideLogic>(
                      id: index,
                      builder: (logic) {
                        return FutureBuilder<Uint8List?>(
                          future: photo.thumbnailData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red, size: 40.r),
                                    8.verticalSpace,
                                    Text("无法加载视频预览",
                                        style: Styles.ts_999999_14),
                                  ],
                                ),
                              );
                            }

                            // 显示视频缩略图和播放按钮
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                // 视频缩略图
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: context.mediaQueryPadding.top + 32.h,
                                    bottom:
                                        context.mediaQueryPadding.bottom + 74.h,
                                  ),
                                  child: Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                // 播放按钮
                                Positioned.fill(
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () => logic
                                          .openVideoWithSystemPlayer(index),
                                      child: Container(
                                        width: 80.r,
                                        height: 80.r,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 50.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                  return ImageUtil.fileImage(
                    file: snapshot.data!,
                    fit: BoxFit.contain,
                    enableSlideOutPage: false,
                    // mode: ExtendedImageMode.none,
                    heroBuilderForSlidingPage: (Widget result) {
                      return Hero(
                        tag: snapshot.data!.path,
                        child: result,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              });
        },
      );

  Widget _buildActionItem(
      {required String label, required String icon, Function()? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56.h,
          width: 72.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.svg.toSvg
                ..width = 24.w
                ..height = 24.w,
              6.verticalSpace,
              label.toText..style = Styles.ts_333333_14_medium
            ],
          ),
        ),
      ),
    );
  }
}
