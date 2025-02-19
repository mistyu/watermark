import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/task_progress.dart';

class ProgressUtil {
  static final RxDouble _progress = 0.0.obs;
  static final RxString _message = ''.obs;
  static OverlayEntry? _overlayEntry;

  /// 显示 Overlay 进度条
  static OverlayEntry? show({String? message}) {
    // 如果已有 OverlayEntry，先移除
    if (_overlayEntry != null) {
      dismiss();
    }

    _progress.value = 0;
    _message.value = message ?? '';

    // 创建 OverlayEntry
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Obx(() => TaskProgress(
                  progress: _progress.value,
                  message: _message.value,
                  onComplete: () {
                    if (_progress.value >= 100) {
                      dismiss();
                    }
                  },
                )),
          ),
        ),
      ),
    );

    // 将 OverlayEntry 添加到 Overlay 中
    Overlay.of(Get.context!).insert(_overlayEntry!);

    return _overlayEntry;
  }

  /// 更新进度
  static void updateProgress(double progress) {
    if (_overlayEntry != null) {
      _progress.value = progress.clamp(0, 100);
    }
  }

  /// 移除 OverlayEntry
  static void dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
