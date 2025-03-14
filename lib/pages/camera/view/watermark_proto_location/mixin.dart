import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'search_view.dart';

mixin SearchManager {
  RxBool isSearching = false.obs;

  void showSearchView() {
    isSearching.value = true;
    Get.dialog(
      PopScope(
        canPop: true,
        child: Material(
          color: Colors.transparent,
          child: FadeInUp(
            animate: true,
            duration: const Duration(milliseconds: 200),
            from: 24,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Styles.c_FFFFFF.withOpacity(0.8),
                child: SearchView(
                  onBack: hiddenSearchView,
                  onTapPoi: onTapSearchPoi,
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void hiddenSearchView() {
    isSearching.value = false;
    Get.back();
  }

  void onTapSearchPoi(Map<String, dynamic> poi) {
    // 处理选中的POI数据
    final name = poi['name'] as String? ?? '';
    final address = poi['address'] as String? ?? '';
    final district = poi['adname'] as String? ?? '';

    // 这里可以处理POI数据，例如更新UI或保存数据
    print('Selected POI: $name, $address, $district');

    hiddenSearchView();
  }
}
