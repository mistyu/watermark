import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/utils/utils.dart';

class PhotoGalleryLogic extends GetxController {
  final assetPathList = <AssetPathEntity>[].obs;
  final assetList = <AssetEntity>[].obs;
  final selectedAsset = Rxn<AssetEntity>();
  final currentAlbum = Rxn<AssetPathEntity>();

  // 加载状态
  final isLoading = false.obs;

  // 分页控制
  int currentPage = 0;
  int pageSize = 20;
  bool hasMore = true;

  // 刷新控制器
  late RefreshController refreshController;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController();
    loadAlbums();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // 加载相册列表
  Future<void> loadAlbums() async {
    try {
      isLoading.value = true;

      // 请求权限
      final permitted = await PhotoManager.requestPermissionExtend();
      if (!permitted.isAuth) {
        Utils.showToast('请授予相册访问权限');
        return;
      }

      // 获取相册列表
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isEmpty) {
        Utils.showToast('没有找到相册');
        return;
      }

      assetPathList.value = albums;
      // 默认选择第一个相册
      await switchAlbum(albums.first);
    } catch (e) {
      print('Error loading albums: $e');
      Utils.showToast('加载相册失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 切换相册
  Future<void> switchAlbum(AssetPathEntity album) async {
    try {
      currentAlbum.value = album;
      currentPage = 0;
      hasMore = true;
      assetList.clear();

      // 加载第一页
      await loadMoreAssets();
    } catch (e) {
      print('Error switching album: $e');
      Utils.showToast('切换相册失败');
    }
  }

  // 加载更多资源
  Future<void> loadMoreAssets() async {
    if (!hasMore) {
      refreshController.loadNoData();
      return;
    }

    try {
      if (currentAlbum.value == null) return;

      final assets = await currentAlbum.value!.getAssetListPaged(
        page: currentPage,
        size: pageSize,
      );

      if (assets.isEmpty) {
        hasMore = false;
        refreshController.loadNoData();
      } else {
        assetList.addAll(assets);
        currentPage++;
        refreshController.loadComplete();
      }
    } catch (e) {
      print('Error loading more assets: $e');
      refreshController.loadFailed();
    }
  }

  // 选择图片
  void selectAsset(AssetEntity asset) {
    selectedAsset.value = asset;
    Get.back(result: asset);
  }
}
