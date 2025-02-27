import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'search_view.dart';

mixin SearchManager {
  OverlayEntry? overlayEntry;
  RxBool isSearching = false.obs;

  void showSearchView() {
    isSearching.value = true;
    if (overlayEntry != null) {
      Overlay.of(Get.context!).insert(overlayEntry!);
    } else {
      overlayEntry = _createOverlayEntry();
      Overlay.of(Get.context!).insert(overlayEntry!);
    }
  }

  void hiddenSearchView() {
    isSearching.value = false;
    Future.delayed(const Duration(milliseconds: 300), () {
      overlayEntry?.remove();
      overlayEntry = null;
    });
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

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Obx(
        () => ZoomIn(
          from: 0.96,
          animate: isSearching.value,
          duration: const Duration(milliseconds: 300),
          child: ZoomOut(
            from: 1,
            animate: !isSearching.value,
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: context.mediaQuerySize.height,
                  child: FadeInUp(
                    animate: isSearching.value,
                    duration: const Duration(milliseconds: 200),
                    from: 24.h,
                    child: FadeOutDown(
                      from: 24.h,
                      animate: !isSearching.value,
                      duration: const Duration(milliseconds: 200),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Styles.c_FFFFFF.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
                SearchView(
                  onBack: hiddenSearchView,
                  onTapPoi: onTapSearchPoi,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
