import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/models/network_brand/network_brand.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/models/watermark_brand/watermark_brand.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

class WatermarkProtoBrandLogoLogic extends GetxController {
  late WatermarkDataItemMap itemMap;

  // 我的品牌logo库
  final myBrandList = <WatermarkBrand>[].obs;
  late RefreshController refreshController;

  // 搜索相关 --- 网络品牌库
  final searchText = ''.obs;
  final networkBrandList = <NetworkBrand>[].obs;

  // 加载状态
  final isLoading = false.obs;

  final currentTab = 0.obs;
  final searchController = TextEditingController();

  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    itemMap = Get.arguments['itemMap'];
    refreshController = RefreshController();
    searchNetworkBrands('nvidia');
  }

  // 加载我的品牌列表
  Future<void> loadMyBrandList() async {
    try {
      isLoading.value = true;
      final result = await Apis.getMyBrandLogoList(pageNum: 1, pageSize: 10);
      myBrandList.value = result;
    } catch (e) {
      print('Error loading my brand list: $e');
      Utils.showToast('加载失败');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> search(String keyWord, int? pageNum, int? pageSize) async {
    if (currentTab.value == 0) {
      searchNetworkBrands(keyWord);
    } else {
      // searchMyBrandList(keyWord);
    }
  }

  // 搜索网络品牌
  Future<void> searchNetworkBrands(String keyword) async {
    print('searchNetworkBrands: $keyword');
    try {
      isLoading.value = true;
      final results = await Apis.searchBrandLogo(keyword);
      networkBrandList.value = results;
    } catch (e) {
      print('Error searching network brands: $e');
      Utils.showToast('搜索失败');
    } finally {
      isLoading.value = false;
    }
  }

  // 上传品牌logo
  Future<void> onUploadBrandLogo() async {
    try {
      final assets = await AssetPicker.pickAssets(
        Get.context!,
        pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
        ),
      );

      if (assets != null && assets.isNotEmpty) {
        final asset = assets.first;
        final bytes = await asset.originBytes;
        final file = await asset.file;

        if (bytes != null && file != null) {
          final ext = file.path.split('.').last;
          final formData = dio.FormData.fromMap({
            'file': dio.MultipartFile.fromBytes(
              bytes,
              filename: "brand_logo.$ext",
            ),
          });

          Utils.showLoading('上传中...');
          final result = await Apis.uploadBrandLogo(formData);

          if (result != null) {
            await loadMyBrandList(); // 重新加载列表
            Utils.showToast('上传成功');
          }
        }
      }
    } catch (e) {
      print('Error uploading brand logo: $e');
      Utils.showToast('上传失败');
    } finally {
      Utils.dismissLoading();
    }
  }

  // 选择品牌logo并返回
  void onSelectBrandPath(String path) {
    Get.back(result: path);
  }

  // 选择网络品牌logo并返回
  void onSelectNetworkBrand(NetworkBrand brand) {
    Get.back(result: brand.logoUrl);
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    // searchNetworkBrands(value);
  }

  void switchTab(int index) {
    currentTab.value = index;
    if (index == 1 && myBrandList.isEmpty) {
      loadMyBrandList();
    }
  }

  void onSearch() {
    searchNetworkBrands(searchController.text);
  }

  Future<void> onLoadMore() async {
    currentPage++;
    try {
      final result = await Apis.getMyBrandLogoList(
        pageNum: currentPage,
        pageSize: 10,
      );
      if (result.isEmpty) {
        refreshController.loadNoData();
      } else {
        myBrandList.addAll(result);
        refreshController.loadComplete();
      }
    } catch (e) {
      refreshController.loadFailed();
      print('Error loading more: $e');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    refreshController.dispose();
    super.onClose();
  }
}
