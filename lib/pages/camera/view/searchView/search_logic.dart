import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/models/db/location/location.dart';
import 'package:watermark_camera/pages/camera/view/map/map_logic.dart';
import 'package:watermark_camera/utils/db_helper.dart';
import 'package:watermark_camera/utils/library.dart';

class SearchLogic extends GetxController {
  final List<dynamic> searchResults = [];
  final isSearchLoading = false.obs;
  final currentPage = 1.obs;
  final currentKeyword = ''.obs;
  final refreshController = RefreshController();

  final mapController = Get.find<MapLogic>();


  @override
  void onInit() {
    super.onInit();
  }

  // 搜索输入变化
  void onSearchChanged(String keyword) async {
    if (keyword.isEmpty) {
      searchResults.clear();
      return;
    }

    currentKeyword.value = keyword;
    currentPage.value = 1;
    isSearchLoading.value = true;

    try {
      final results = await Apis.searchPOIByKeyword(
        keywords: keyword,
        page: currentPage.value,
      );
      if (results.isEmpty) {
        refreshController.loadNoData();
      } else {
        currentPage.value++;
        searchResults.addAll(results);
        refreshController.loadComplete();
      }
    } catch (e) {
      print('Search error: $e');
      Utils.showToast('搜索失败：${e.toString()}');
    } finally {
      isSearchLoading.value = false;
    }
  }

  // 加载更多搜索结果
  void onSearchLoadMore() async {
    if (currentKeyword.value.isEmpty) return;

    try {
      final results = await Apis.searchPOIByKeyword(
        keywords: currentKeyword.value,
        page: currentPage.value + 1,
      );

      if (results.isEmpty) {
        refreshController.loadNoData();
      } else {
        currentPage.value++;
        searchResults.addAll(results);
        refreshController.loadComplete();
      }
    } catch (e) {
      print('Load more error: $e');
      refreshController.loadFailed();
    }
  }

  // 选择POI点
  void onPoiSelected(Map<String, dynamic> poi) {
    try {
      Get.back(result: poi);
    } catch (e) {
      Utils.showToast('选择地点失败');
    }
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
