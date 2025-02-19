import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/toast.dart';

class ToastUtil {
  static OverlayEntry? overlay;

  static void show(String message) {
    // 移除现有的overlay
    if (Get.isOverlaysOpen) {
      Get.back();
    }

    overlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: IgnorePointer(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Toast(
                message: message,
                onAnimationComplete: () {
                  overlay?.remove(); // 移除overlay
                },
              ),
            ),
          ),
        ),
      ),
    );

    if (overlay != null) {
      Overlay.of(Get.overlayContext!).insert(overlay!);
    }
  }
}
