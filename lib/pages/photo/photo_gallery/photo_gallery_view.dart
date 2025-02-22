import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';

import 'photo_gallery_logic.dart';

class PhotoGalleryPage extends GetView<PhotoGalleryLogic> {
  const PhotoGalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final album = controller.currentAlbum.value;
          return Text(
            album?.name ?? '选择照片',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          );
        }),
        actions: [
          // 相册选择下拉菜单
          Obx(() => PopupMenuButton<AssetPathEntity>(
                onSelected: controller.switchAlbum,
                itemBuilder: (context) {
                  return controller.assetPathList.map((album) {
                    return PopupMenuItem(
                      value: album,
                      child: Text(album.name),
                    );
                  }).toList();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Text(
                        controller.currentAlbum.value?.name ?? '相册',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Styles.c_0D0D0D,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 24.w,
                        color: Styles.c_0D0D0D,
                      ),
                    ],
                  ),
                ),
              )),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.assetList.isEmpty) {
              return const Center(child: Text('暂无照片'));
            }

            return SmartRefresher(
              controller: controller.refreshController,
              enablePullDown: false,
              enablePullUp: true,
              footer: const ClassicFooter(
                loadingText: '加载中...',
                noDataText: '没有更多照片了',
                failedText: '加载失败',
                idleText: '上拉加载更多',
                canLoadingText: '松开加载更多',
              ),
              onLoading: controller.loadMoreAssets,
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.w,
                  crossAxisSpacing: 8.w,
                ),
                itemCount: controller.assetList.length,
                itemBuilder: (context, index) {
                  final asset = controller.assetList[index];
                  return GestureDetector(
                    onTap: () => controller.selectAsset(asset),
                    child: AssetThumbnail(asset: asset),
                  );
                },
              ),
            );
          }),

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
                  Obx(() => _buildActionButton(
                        '添加水印',
                        onPressed: controller.selectedAsset.value == null
                            ? null
                            : () {
                                if (controller.selectedAsset.value != null) {
                                  AppNavigator.startPhotoWithWatermarkSlide(
                                    [controller.selectedAsset.value!],
                                    type: PhotoAddWatermarkType.batch,
                                  ).then((_) {
                                    controller.selectedAsset.value = null;
                                    Get.back();
                                  });
                                }
                              },
                      )),
                ],
              ),
            ),
          ),
        ],
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

// 缩略图组件
class AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;

  const AssetThumbnail({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        }
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
