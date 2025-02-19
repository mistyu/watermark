import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/utils/library.dart';
import 'photo_grid_item.dart';

class PhotoGrid extends StatelessWidget {
  final ScrollController scrollController;
  final List<AssetEntity> images;
  final Set<AssetEntity> selectedImages;
  final Function(AssetEntity) onImageSelected;
  final VoidCallback onLoadMore;

  const PhotoGrid({
    Key? key,
    required this.scrollController,
    required this.images,
    required this.selectedImages,
    required this.onImageSelected,
    required this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200) {
            onLoadMore();
          }
        }
        return true;
      },
      child: GridView.builder(
        controller: scrollController,
        padding: EdgeInsets.only(bottom: 80.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 2.w,
          crossAxisSpacing: 2.w,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return PhotoGridItem(
            key: ValueKey(images[index].id),
            image: images[index],
            isSelected: selectedImages.contains(images[index]),
            onSelected: onImageSelected,
          );
        },
      ),
    );
  }
}
