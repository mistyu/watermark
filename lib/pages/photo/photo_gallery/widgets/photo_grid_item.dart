import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhotoGridItem extends StatelessWidget {
  final AssetEntity image;
  final bool isSelected;
  final Function(AssetEntity) onSelected;

  const PhotoGridItem({
    Key? key,
    required this.image,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Positioned.fill(
            child: AssetEntityImage(
              image,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(200),
              thumbnailFormat: ThumbnailFormat.jpeg,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Icon(Icons.error, color: Colors.grey[400]),
              ),
            ),
          ),
          Positioned(
            top: 4.w,
            right: 4.w,
            child: GestureDetector(
              onTap: () => onSelected(image),
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
                    ? Icon(
                        Icons.check,
                        size: 14.w,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
