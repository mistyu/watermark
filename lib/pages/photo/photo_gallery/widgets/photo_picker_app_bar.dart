import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

class PhotoPickerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AssetPathEntity? currentAlbum;
  final List<AssetPathEntity> albums;
  final Function(AssetPathEntity?) onAlbumChanged;

  const PhotoPickerAppBar({
    Key? key,
    required this.currentAlbum,
    required this.albums,
    required this.onAlbumChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: DropdownButton<AssetPathEntity>(
          value: currentAlbum,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          items: albums.map((album) {
            return DropdownMenuItem(
              value: album,
              child: FutureBuilder<int>(
                future: album.assetCountAsync,
                builder: (context, snapshot) {
                  return Text(
                    '${album.name} (${snapshot.data ?? 0})',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            );
          }).toList(),
          onChanged: onAlbumChanged,
          underline: const SizedBox(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
