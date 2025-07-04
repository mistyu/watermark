import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/core/controller/permission_controller.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/dialog.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'dart:typed_data';
import 'dart:io';

class PhotoGalleryLogic extends GetxController {
  final assetPathList = <AssetPathEntity>[].obs;
  final assetList = <AssetEntity>[].obs;
  final selectedAssets = <AssetEntity>[].obs;
  final currentAlbum = Rxn<AssetPathEntity>();

  // 存储相册数量的映射
  final albumCounts = <AssetPathEntity, int>{}.obs;

  static const int maxSelectCount = 9;

  // 加载状态
  final isLoading = false.obs;

  // 分页控制
  int currentPage = 0;
  int pageSize = 35;
  bool hasMore = true;

  // 使用 RxMap 来存储图片缓存，这样可以触发UI更新
  final imageCache = <String, File>{}.obs;

  // 记录正在加载的图片ID，避免重复加载
  final Set<String> loadingImages = {};

  // 刷新控制器
  late RefreshController refreshController;

  final PermissionController permissionController =
      Get.find<PermissionController>();

  @override
  void onInit() async {
    super.onInit();
    print("xiaojianjian 申请相册权限");

    refreshController = RefreshController();

    loadAlbums();
  }

  @override
  void onClose() {
    refreshController.dispose();
    imageCache.clear();
    super.onClose();
  }

  // 加载相册列表
  Future<void> loadAlbums() async {
    try {
      isLoading.value = true;

      // 请求权限
      final permitted = await PhotoManager.requestPermissionExtend();
      if (!permitted.isAuth) {
        // 没有权限
        bool result = await CommonDialog.showPermissionDialog(
          title: '相册权限',
          content: '请授予应用访问照片和视频的权限，以便查看和选择照片进行水印处理',
          permission: Permission.photos,
        );
        if (result) {
          loadAlbums(); //重新加载
        } else {
          Utils.showToast("您没有授予权限");
          Get.back();
        }
        return;
      }

      // 获取相册列表
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.common,
      );

      if (albums.isEmpty) {
        Utils.showToast('没有找到相册');
        return;
      }

      // 获取每个相册的照片数量
      for (var album in albums) {
        final count = await album.assetCountAsync;
        albumCounts[album] = count;
      }

      assetPathList.value = albums;
      // 默认选择第一个相册
      if (albums.isNotEmpty) {
        await switchAlbum(albums.first);
      }
    } catch (e) {
      Utils.showToast('加载相册失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 加载图片并缓存
  Future<void> loadImage(AssetEntity asset) async {
    if (imageCache.containsKey(asset.id) || loadingImages.contains(asset.id)) {
      return;
    }

    loadingImages.add(asset.id);
    try {
      if (asset.type == AssetType.video) {
        // 对于视频类型，我们只需要获取其封面图的缓存文件
        final file = await asset.thumbnailData;
        if (file != null) {
          imageCache[asset.id] = File.fromRawPath(file);
        }
      } else {
        // 对于图片类型，获取原始文件
        final file = await asset.file;
        if (file != null) {
          imageCache[asset.id] = file;
        }
      }
    } catch (e) {
      print('Error loading image/video: $e');
    } finally {
      loadingImages.remove(asset.id);
    }
  }

  // 加载更多资源
  Future<void> loadMoreAssets() async {
    if (!hasMore) return;

    try {
      if (currentAlbum.value == null) return;

      final newAssets = await currentAlbum.value!.getAssetListPaged(
        page: currentPage,
        size: pageSize,
      );

      if (newAssets.isEmpty) {
        hasMore = false;
        refreshController.loadNoData();
      } else {
        // 先加载图片，再更新列表，避免闪烁
        await Future.wait(
          newAssets.map((asset) => loadImage(asset)),
        );

        assetList.addAll(newAssets);
        currentPage++;
        refreshController.loadComplete();
      }
    } catch (e) {
      print('Error loading more assets: $e');
      refreshController.loadFailed();
    }
  }

  // 切换相册
  Future<void> switchAlbum(AssetPathEntity album) async {
    try {
      currentAlbum.value = album;
      currentPage = 0;
      hasMore = true;
      assetList.clear();
      imageCache.clear();
      loadingImages.clear();
      await loadMoreAssets();
    } catch (e) {
      print('Error switching album: $e');
      Utils.showToast('切换相册失败');
    }
  }

  // 选择/取消选择图片
  void toggleSelectAsset(AssetEntity asset) {
    if (selectedAssets.contains(asset)) {
      selectedAssets.remove(asset);
    } else {
      if (selectedAssets.length >= maxSelectCount) {
        Utils.showToast('最多选择$maxSelectCount张图片');
        return;
      }
      selectedAssets.add(asset);
    }
  }

  // 确认选择并返回
  void confirmSelection() {
    if (selectedAssets.isEmpty) {
      Utils.showToast('请选择图片');
      return;
    }

    //这里判断一下所有asset要么都是图片要么都是视频
    bool isAllImage = true;
    bool isAllVideo = true;
    for (var asset in selectedAssets) {
      if (asset.type == AssetType.image) {
        isAllVideo = false;
      } else {
        isAllImage = false;
      }
    }

    if (!isAllImage && !isAllVideo) {
      Utils.showToast('要么选择图片要么选择视频，不能混合选择');
      return;
    }

    AppNavigator.startPhotoWithWatermarkSlide(
      selectedAssets.toList(),
      type: PhotoAddWatermarkType.batch,
    ).then((value) {
      selectedAssets.clear();
      update();
    });
  }

  // 获取当前相册的图片数量
  String get currentAlbumCount {
    if (currentAlbum.value == null) return '';
    final count = albumCounts[currentAlbum.value] ?? 0;
    return '($count)';
  }

  // 获取选择状态文本
  String get selectionText => '${selectedAssets.length}/$maxSelectCount';

  // 获取指定相册的图片数量
  String getAlbumCount(AssetPathEntity album) {
    final count = albumCounts[album] ?? 0;
    return '($count)';
  }
}
