import 'dart:io';
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
        title: Obx(() => PopupMenuButton<AssetPathEntity>(
              onSelected: controller.switchAlbum,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${controller.currentAlbum.value?.name ?? '选择照片'} ${controller.currentAlbumCount}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 24.w,
                    color: Styles.c_0D0D0D,
                  ),
                ],
              ),
              itemBuilder: (context) {
                return controller.assetPathList.map((album) {
                  return PopupMenuItem(
                    value: album,
                    child: Text(
                        '${album.name} ${controller.getAlbumCount(album)}'),
                  );
                }).toList();
              },
            )),
        actions: [
          Obx(() => TextButton(
                onPressed: controller.selectedAssets.isEmpty
                    ? null
                    : controller.confirmSelection,
                child: Row(
                  children: [
                    Text(
                      '完成',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: controller.selectedAssets.isEmpty
                            ? Styles.c_999999
                            : Styles.c_0C8CE9,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      controller.selectionText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: controller.selectedAssets.isEmpty
                            ? Styles.c_999999
                            : Styles.c_0C8CE9,
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(width: 16.w),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
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
            key: const PageStorageKey('photo_grid'),
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 3.w,
              crossAxisSpacing: 3.w,
              childAspectRatio: 1.0,
            ),
            itemCount: controller.assetList.length,
            itemBuilder: (context, index) {
              final asset = controller.assetList[index];
              return PhotoGridItem(
                key: ValueKey('photo_${asset.id}'),
                asset: asset,
                onTap: () => controller.toggleSelectAsset(asset),
                isSelected: controller.selectedAssets.contains(asset),
                cachedFile: controller.imageCache[asset.id],
              );
            },
          ),
        );
      }),
    );
  }
}

class PhotoGridItem extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onTap;
  final bool isSelected;
  final File? cachedFile;

  const PhotoGridItem({
    Key? key,
    required this.asset,
    required this.onTap,
    required this.isSelected,
    this.cachedFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(),
          Positioned(
            right: 8.w,
            top: 8.w,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Styles.c_0C8CE9 : Colors.white,
                border: Border.all(
                  color: isSelected ? Styles.c_0C8CE9 : Colors.grey,
                  width: 1.w,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 14.w)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (cachedFile != null) {
      return Image.file(
        cachedFile!,
        fit: BoxFit.cover,
        cacheWidth: 300,
        filterQuality: FilterQuality.medium,
      );
    }

    return Container(color: Colors.grey[300]);
  }
}

// // 缩略图组件
// class AssetThumbnail extends StatelessWidget {
//   final AssetEntity asset;
//   final double width;
//   final double height;

//   const AssetThumbnail({
//     Key? key,
//     required this.asset,
//     required this.width,
//     required this.height,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: FutureBuilder<Uint8List?>(
//         future: asset.thumbnailDataWithSize(
//           ThumbnailSize(width.toInt(), height.toInt()),
//           quality: 100,
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done &&
//               snapshot.data != null) {
//             return Image.memory(
//               snapshot.data!,
//               fit: BoxFit.cover,
//               filterQuality: FilterQuality.high,
//               gaplessPlayback: true, // 防止图片加载时闪烁
//             );
//           }
//           return Container(
//             width: width,
//             height: height,
//             color: Colors.grey[300],
//           );
//         },
//       ),
//     );
//   }
// }
