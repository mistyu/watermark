import 'dart:io';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/models/network_brand/network_brand.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/models/watermark_brand/watermark_brand.dart';
import 'package:watermark_camera/pages/camera/view/watermark_proto_brand_logo/widgets/input_dialog.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
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
  final isLoadingNet = false.obs;
  final inLoadingMy = false.obs;

  final currentTab = 0.obs;
  late TextEditingController searchController;

  int currentPage = 1;
  int total = 0;
  int totalPage = 0;

  //图片选择上传实例
  final _imagePicker = ImagePicker();

  // 添加网络品牌的刷新控制器
  late RefreshController networkRefreshController;
  late RefreshController myBrandRefreshController;

  @override
  void onInit() {
    super.onInit();
    itemMap = Get.arguments['itemMap'];
    // 初始化控制器
    searchController = TextEditingController();
    networkRefreshController = RefreshController();
    myBrandRefreshController = RefreshController();
    // 初始加载数据
    searchNetworkBrands('北京');
    loadMyBrandList(null);

    //获取一下传入的参数 --- 用不用其实都可以，只需要将
    print("xiaojianjian itemMap: ${itemMap.title}");
  }

  // 加载我的品牌列表
  Future<void> loadMyBrandList(String? keyWord) async {
    print("loadMyBrandList: $keyWord");
    try {
      inLoadingMy.value = true;
      final result = await Apis.getMyBrandLogoList(
          pageNum: 1, pageSize: 10, logoName: keyWord);

      if (result.rows is List) {
        myBrandList.value = (result.rows as List)
            .map((e) => WatermarkBrand.fromJson(e as Map<String, dynamic>))
            .toList();
        total = result.total;
        // 计算总页数
        totalPage = (total / 10).ceil();
        inLoadingMy.value = false;
      } else {
        Utils.showToast('数据格式错误');
      }
    } catch (e) {
      Utils.showToast('加载失败');
    } finally {
      inLoadingMy.value = false;
    }
  }

  Future<void> search(String keyWord) async {
    if (currentTab.value == 0) {
      if (keyWord.isEmpty) {
        searchNetworkBrands("北京");
      } else {
        searchNetworkBrands(keyWord);
      }
    } else {
      loadMyBrandList(keyWord);
    }
  }

  // 搜索网络品牌
  Future<void> searchNetworkBrands(String keyword) async {
    if (keyword.isEmpty) return; // 如果关键词为空，直接返回

    try {
      isLoadingNet.value = true;
      final results = await Apis.searchBrandLogo(keyword);
      networkBrandList.value = results;
    } catch (e) {
      print('Error searching network brands: $e');
      Utils.showToast('搜索失败');
    } finally {
      isLoadingNet.value = false;
    }
  }

  // 上传品牌logo
  Future<void> onUploadBrandLogo() async {
    // 选择图片
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      String? logoName = await showLogoNameDialog();
      if (logoName != null && logoName.isNotEmpty) {
        await trueUploadBrandLogo(logoName, image.path);
      }
    }
  }

  // 显示Logo名称输入对话框
  Future<String?> showLogoNameDialog() async {
    return await Get.dialog<String>(
      InputDialog(
        title: '请输入Logo名称',
        hintText: '请输入Logo名称',
        onCancel: () {
          Navigator.of(Get.context!).pop();
        },
        onConfirm: (text) {
          Navigator.of(Get.context!).pop(text);
        },
      ),
      barrierDismissible: false,
    );
  }

  Future<void> trueUploadBrandLogo(String logoName, String logoPath) async {
    try {
      // 读取文件
      File file = File(logoPath);
      // 获取文件名
      String fileName = logoPath.split('/').last;

      // 构建 FormData
      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
        "logoName": logoName,
      });

      Utils.showLoading('上传中...');
      // 上传图片
      final result = await Apis.uploadBrandLogo(formData);

      if (result != null) {
        await loadMyBrandList(null); // 重新加载列表
        Utils.dismissLoading();
        Utils.showToast('上传成功');
      } else {
        Utils.showToast("上传失败，请重试");
      }
    } catch (e) {
      print('Error uploading brand logo: $e');
      Utils.showToast('上传失败');
    }
  }

  //先进入logo位置选择页面，根据选择页面的结果决定下一步
  void onSelectBrandPath(String path) async {
    final result = await AppNavigator.startWatermarkProtoBrandLogoPosition(
        path: path, itemMap: itemMap);
    if (result != null) {
      // 如果用户完成了编辑并返回结果
      Get.back();
    }
    // 如果用户取消了编辑，不做任何处理
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    // searchNetworkBrands(value);
  }

  void switchTab(int index) {
    currentTab.value = index;
    // 切换到网络品牌时，如果列表为空则加载默认数据
    if (index == 0 && networkBrandList.isEmpty) {
      searchNetworkBrands('北京');
    }
  }

  Future<void> onLoadMore() async {
    // 计算是否可以加载下一页，如果是最后一页就不用加载了
    if (currentPage >= totalPage) {
      myBrandRefreshController.loadNoData();
      return;
    }
    currentPage++;
    try {
      final result = await Apis.getMyBrandLogoList(
        pageNum: currentPage,
        pageSize: 10,
      );
      if (result.isEmpty) {
        myBrandRefreshController.loadNoData();
      } else {
        myBrandList.addAll((result.rows as List)
            .map((e) => WatermarkBrand.fromJson(e as Map<String, dynamic>))
            .toList());
        myBrandRefreshController.loadComplete();
      }
    } catch (e) {
      myBrandRefreshController.loadFailed();
      print('Error loading more: $e');
    }
  }

  @override
  void onClose() {
    // 确保在关闭前检查控制器是否存在
    searchController.dispose();
    networkRefreshController.dispose();
    myBrandRefreshController.dispose();
    super.onClose();
  }

  // 网络品牌下拉刷新
  Future<void> onNetworkRefresh() async {
    try {
      await searchNetworkBrands(
          searchController.text.isEmpty ? '北京' : searchController.text);
      networkRefreshController.refreshCompleted();
    } catch (e) {
      networkRefreshController.refreshFailed();
    }
  }

  // 我的品牌下拉刷新
  Future<void> onMyBrandRefresh() async {
    try {
      currentPage = 1; // 重置页码
      final result = await Apis.getMyBrandLogoList(pageNum: 1, pageSize: 10);
      if (result.rows is List) {
        myBrandList.value = (result.rows as List)
            .map((e) => WatermarkBrand.fromJson(e as Map<String, dynamic>))
            .toList();
        total = result.total;
        totalPage = (total / 10).ceil();
        myBrandRefreshController.refreshCompleted();
      } else {
        myBrandRefreshController.refreshFailed();
      }
    } catch (e) {
      myBrandRefreshController.refreshFailed();
    }
  }
}
