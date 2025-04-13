import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;

  List<dynamic> get tabs;

  final activeTab = 1.obs;

  final isInitialized = false.obs;

  void switchTab(int index) {
    activeTab.value = index;
    tabController?.animateTo(index);
  }

  void onChangeTab() {
    activeTab.value = tabController?.index ?? 0;
  }

  void initTabController({int? length}) {
    if (tabs.isNotEmpty) {
      tabController = TabController(length: length ?? tabs.length, vsync: this);
      tabController?.addListener(onChangeTab);
      isInitialized.value = true;
      tabController?.index = 1;
    }
  }

  void disposeTabController() {
    if (tabController != null) {
      tabController?.removeListener(onChangeTab);
      tabController?.dispose();
    }
  }

  @override
  void onClose() {
    disposeTabController();
    super.onClose();
  }
}
