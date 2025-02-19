import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PhotoGalleryLogic extends GetxController {
  // 相册列表
  final albums = <AssetPathEntity>[].obs;
  // 当前选中的相册
  final currentAlbum = Rxn<AssetPathEntity>();
  // 当前相册的图片列表
  final images = <AssetEntity>[].obs;
  // 选中的图片
  final selectedImages = <AssetEntity>{}.obs;

  // 分页加载相关
  bool isLoadingMore = false;
  static const int pageSize = 30;
  int currentPage = 0;
  bool hasMore = true;

  bool _isInitialized = false;

  @override
  void onReady() {
    super.onReady();
    initPhotoManager();
  }

  Future<void> initPhotoManager() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      albums.value = paths;
      if (paths.isNotEmpty) {
        currentAlbum.value = paths.first;
        await loadImages(initialLoad: true);
      }
      update();
    } catch (e) {
      print('Init photo manager error: $e');
      _isInitialized = false;
    }
  }

  Future<void> loadImages({bool initialLoad = false}) async {
    if (isLoadingMore || !hasMore || currentAlbum.value == null) return;

    isLoadingMore = true;

    try {
      final int endPage = initialLoad ? 2 : 1;
      for (int i = 0; i < endPage; i++) {
        final List<AssetEntity> newImages =
            await currentAlbum.value!.getAssetListRange(
          start: currentPage * pageSize,
          end: (currentPage + 1) * pageSize,
        );

        if (newImages.isEmpty || newImages.length < pageSize) {
          hasMore = false;
        }

        if (currentPage == 0) {
          images.value = newImages;
        } else {
          images.addAll(newImages);
        }
        currentPage++;
      }
    } catch (e) {
      print('Load images error: $e');
    } finally {
      isLoadingMore = false;
    }
  }

  void onAlbumChanged(AssetPathEntity? album) {
    if (album == null || album == currentAlbum.value) return;

    currentAlbum.value = album;
    images.clear();
    currentPage = 0;
    hasMore = true;
    loadImages(initialLoad: true);
  }

  void toggleImageSelection(AssetEntity image) {
    if (selectedImages.contains(image)) {
      selectedImages.remove(image);
    } else {
      selectedImages.add(image);
    }
    update(); // 通知UI更新
  }

  @override
  void onClose() {
    selectedImages.clear();
    super.onClose();
  }
}
