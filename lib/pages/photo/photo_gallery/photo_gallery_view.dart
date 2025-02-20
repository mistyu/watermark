import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';

import 'photo_gallery_logic.dart';
import 'widgets/photo_grid.dart';
import 'widgets/photo_picker_app_bar.dart';

class PhotoGalleryPage extends GetView<PhotoGalleryLogic> {
  PhotoGalleryPage({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GetBuilder<PhotoGalleryLogic>(
          builder: (_) => PhotoPickerAppBar(
            currentAlbum: _.currentAlbum.value,
            albums: _.albums,
            onAlbumChanged: _.onAlbumChanged,
          ),
        ),
      ),
      body: GetBuilder<PhotoGalleryLogic>(
        builder: (_) => Stack(
          children: [
            PhotoGrid(
              scrollController: _scrollController,
              images: _.images,
              selectedImages: _.selectedImages,
              onImageSelected: _.toggleImageSelection,
              onLoadMore: () => _.loadImages(),
            ),
            // 底部操作栏
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      '添加水印',
                      onPressed: _.selectedImages.isEmpty
                          ? null
                          : () {
                              // 跳转到水印页面并传入选中的图片
                              AppNavigator.startPhotoWithWatermarkSlide(
                                _.selectedImages.toList(),
                                type: PhotoAddWatermarkType.batch,
                              ).then((_) {
                                // 返回后清理选中状态
                                _.selectedImages.clear();
                                _.update();
                                // 返回到上一页
                                Get.back();
                              });
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Styles.c_0C8CE9,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
      child: Text(text),
    );
  }
}
