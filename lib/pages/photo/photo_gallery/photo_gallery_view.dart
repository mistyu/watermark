import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/core/controller/permission_controller.dart';
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
            // padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4.w,
              crossAxisSpacing: 4.w,
              childAspectRatio: 1.0,
            ),
            itemCount: controller.assetList.length,
            itemBuilder: (context, index) {
              final asset = controller.assetList[index];
              return Obx(() => PhotoGridItem(
                    key: ValueKey('photo_${asset.id}'),
                    asset: asset,
                    onTap: () => controller.toggleSelectAsset(asset),
                    isSelected: controller.selectedAssets.contains(asset),
                    cachedFile: controller.imageCache[asset.id],
                  ));
            },
          ),
        );
      }),
    );
  }
}

class PhotoGridItem extends StatefulWidget {
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
  State<PhotoGridItem> createState() => _PhotoGridItemState();
}

class _PhotoGridItemState extends State<PhotoGridItem> {
  Uint8List? thumbnailData;

  @override
  void initState() {
    super.initState();
    if (widget.asset.type == AssetType.video) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    try {
      final data = await widget.asset.thumbnailData;
      if (mounted) {
        setState(() {
          thumbnailData = data;
        });
      }
    } catch (e) {
      print('Error loading thumbnail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(),
          if (widget.asset.type == AssetType.video)
            Positioned(
              left: 8.w,
              bottom: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 16.w,
                    ),
                    4.horizontalSpace,
                    Text(
                      _formatDuration(widget.asset.duration),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            right: 8.w,
            top: 8.w,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.isSelected ? 1.0 : 0.7,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected ? Styles.c_0C8CE9 : Colors.white,
                  border: Border.all(
                    color: widget.isSelected ? Styles.c_0C8CE9 : Colors.grey,
                    width: 1.w,
                  ),
                ),
                child: widget.isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 14.w)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (widget.asset.type == AssetType.video) {
      if (thumbnailData != null) {
        return Image.memory(
          thumbnailData!,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          gaplessPlayback: true,
        );
      }
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: Icon(
            Icons.video_library,
            color: Colors.grey[400],
            size: 24.w,
          ),
        ),
      );
    }

    if (widget.cachedFile != null) {
      return Image.file(
        widget.cachedFile!,
        fit: BoxFit.cover,
        cacheWidth: 300,
        filterQuality: FilterQuality.medium,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.grey[400],
                size: 24.w,
              ),
            ),
          );
        },
      );
    }

    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          widget.asset.type == AssetType.video
              ? Icons.video_library
              : Icons.image,
          color: Colors.grey[400],
          size: 24.w,
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
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
