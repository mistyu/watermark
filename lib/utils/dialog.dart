import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/service/media_service.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CommonDialog {
  static Future<bool> checkPrivacyPolicy(
      {required WebViewController controller}) async {
    controller.loadFlutterAsset('assets/html/privacy_policy.html');
    final result = await Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 0.w),
      insetPadding: const EdgeInsets.all(24).w,
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(26.0.r))),
      content: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("guide_agreement".webp),
                fit: BoxFit.contain)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            24.verticalSpace,
            "《个人信息保护协议》".toText..style = Styles.ts_333333_24_bold,
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: "为了让您更好的使用修改牛水印相机，请充分阅读并理解 隐私协议".toText
                ..style = Styles.ts_999999_14,
            ),
            8.verticalSpace,
            Container(
              height: 375.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: WebViewWidget(controller: controller),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: "不同意".toText..style = Styles.ts_333333_16),
                  16.horizontalSpace,
                  OutlinedButton(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Styles.c_0C8CE9,
                          shape: const StadiumBorder()),
                      child: "已阅读并同意".toText..style = Styles.ts_FFFFFF_16),
                ],
              ),
            )
          ],
        ),
      ),
    ));
    return result ?? false;
  }

  /// 显示权限请求对话框
  /// [title] 对话框标题
  /// [content] 对话框内容
  /// [permission] 需要请求的权限
  /// 返回值: 如果用户授予了权限则返回true，否则返回false
  static Future<bool> showPermissionDialog({
    required String title,
    required String content,
    required Permission permission,
  }) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid &&
        androidInfo.version.sdkInt <= 32 &&
        permission == Permission.photos) {
      permission = Permission.storage;
    }
    final result = await Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        insetPadding: const EdgeInsets.all(24).w,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
        ),
        title: Text(title, style: Styles.ts_333333_18_bold),
        content: Text(content, style: Styles.ts_666666_14),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text("取消", style: Styles.ts_999999_16),
          ),
          TextButton(
            onPressed: () async {
              Get.back(result: true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Styles.c_0C8CE9,
            ),
            child: Text("去设置", style: Styles.ts_0C8CE9_16),
          ),
        ],
      ),
    );

    if (result == true) {
      openAppSettings();

      // 使用Completer等待应用回到前台
      final completer = Completer<bool>();

      // 设置生命周期监听
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        if (msg == AppLifecycleState.resumed.toString()) {
          // 应用回到前台，检查权限状态
          final isGranted = await permission.isGranted;
          if (!completer.isCompleted) {
            completer.complete(isGranted);
          }
          // 移除监听器
          SystemChannels.lifecycle.setMessageHandler(null);
        }
        return null;
      });

      // 设置超时保护，防止监听器永远不被触发
      Future.delayed(const Duration(seconds: 60), () {
        if (!completer.isCompleted) {
          completer.complete(false);
          // 移除监听器
          SystemChannels.lifecycle.setMessageHandler(null);
        }
      });

      return await completer.future;
    }
    return false;
  }

  /// 显示媒体内容对话框
  /// [title] 对话框标题
  /// [content] 对话框内容描述
  /// [mediaUrl] 媒体URL (图片或视频)
  /// [isVideo] 是否为视频，默认为false (图片)
  static Future<void> showMediaDialog({
    required String title,
    required String content,
    required String mediaUrl,
    bool isVideo = false,
  }) async {
    await Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题和关闭按钮
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: Styles.ts_333333_18_bold),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.close,
                            size: 24.r, color: Styles.c_999999),
                      ),
                    ],
                  ),
                ),

                // 内容描述
                if (content.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      content,
                      style: Styles.ts_666666_14,
                      textAlign: TextAlign.center,
                    ),
                  ),

                16.verticalSpace,

                // 媒体内容 (图片或视频)
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 0.6.sh,
                    maxWidth: 0.8.sw,
                  ),
                  child: isVideo
                      ? _VideoPlayerWidget(videoUrl: mediaUrl)
                      : _NetworkImageWidget(imageUrl: mediaUrl),
                ),

                16.verticalSpace,

                // 图片保存按钮 (仅对图片显示)
                if (!isVideo)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: ElevatedButton(
                      onPressed: () => _saveImageToGallery(mediaUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.c_0C8CE9,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 8.h),
                      ),
                      child: Text("保存图片", style: Styles.ts_FFFFFF_16),
                    ),
                  ),

                if (isVideo) 16.verticalSpace,
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
  }

  // 保存图片到相册
  static Future<void> _saveImageToGallery(String imageUrl) async {
    try {
      // 检查存储权限
      final permission = Platform.isAndroid
          ? await _checkAndroidStoragePermission()
          : await Permission.photos.request();

      if (permission.isGranted) {
        // 显示加载提示

        Utils.showLoading("正在保存图片...");

        // 保存图片 --- 下载图片到临时目录
        final response = await http.get(Uri.parse(imageUrl));
        final bytes = response.bodyBytes;
        await MediaService.savePhoto(bytes);

        // 隐藏加载提示
        Utils.dismissLoading();
        Get.back();
      } else {
        // 权限被拒绝，显示权限对话框
        await showPermissionDialog(
          title: "需要存储权限",
          content: "保存图片需要访问您的存储空间，请在设置中允许此权限",
          permission:
              Platform.isAndroid ? Permission.storage : Permission.photos,
        );
      }
    } catch (e) {
      Get.snackbar(
        "保存失败",
        "发生错误: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        margin: EdgeInsets.all(8),
      );
    }
  }

  // 检查Android存储权限
  static Future<PermissionStatus> _checkAndroidStoragePermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      return Permission.storage.request();
    } else {
      return Permission.photos.request();
    }
  }

  /// 显示确认对话框
  /// [title] 对话框标题
  /// [content] 对话框内容
  /// 返回值: 如果用户点击"确定"则返回true，否则返回false
  static Future<bool> showConfirmDialog({
    required String title,
    required String content,
    String cancelText = "取消",
    String confirmText = "确定",
  }) async {
    final result = await Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        insetPadding: const EdgeInsets.all(24).w,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Styles.ts_333333_18_bold),
            GestureDetector(
              onTap: () => Get.back(result: false),
              child: Icon(Icons.close, size: 24.r, color: Styles.c_999999),
            ),
          ],
        ),
        content: Text(
          content,
          style: Styles.ts_333333_16,
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(result: false),
                  style: TextButton.styleFrom(
                    backgroundColor: Styles.c_F6F6F6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(cancelText, style: Styles.ts_666666_16),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(result: true),
                  style: TextButton.styleFrom(
                    backgroundColor: Styles.c_0C8CE9,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(confirmText, style: Styles.ts_FFFFFF_16),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  /// 显示带进度条的加载对话框
  static OverlayEntry? _progressOverlay;
  static double _currentProgress = 0.0;
  static StreamController<double>? _progressController;

  /// 显示带进度条的加载对话框
  static OverlayEntry showProgressDialog({
    String title = "正在加载",
    String message = "请稍候...",
  }) {
    _currentProgress = 0.0;
    _progressController = StreamController<double>.broadcast();

    final overlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: 280.w,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Styles.ts_333333_18_bold),
                16.verticalSpace,
                Text(message, style: Styles.ts_666666_14),
                20.verticalSpace,
                StreamBuilder<double>(
                  stream: _progressController?.stream,
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: snapshot.data,
                          backgroundColor: Styles.c_F6F6F6,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Styles.c_0C8CE9),
                          minHeight: 6.h,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        8.verticalSpace,
                        Text(
                          "${(snapshot.data! * 100).toInt()}%",
                          style: Styles.ts_666666_14,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    _progressOverlay = overlay;

    // 使用 Get.overlayContext 获取 OverlayState
    final overlayState = Overlay.of(Get.overlayContext!);
    overlayState.insert(overlay);

    return overlay;
  }

  /// 更新进度条
  static void updateProgress(double progress) {
    _currentProgress = progress.clamp(0.0, 1.0);
    _progressController?.add(_currentProgress);
  }

  /// 关闭进度条对话框
  static void dismissProgressDialog() {
    _progressOverlay?.remove();
    _progressOverlay = null;
    _progressController?.close();
    _progressController = null;
  }
}

// 网络图片组件
class _NetworkImageWidget extends StatelessWidget {
  final String imageUrl;

  const _NetworkImageWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Styles.c_0C8CE9,
          strokeWidth: 2.w,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40.r),
            8.verticalSpace,
            Text("图片加载失败", style: Styles.ts_999999_14),
          ],
        ),
      ),
      fit: BoxFit.contain,
    );
  }
}

// 视频播放组件
class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const _VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        alignment: Alignment.center,
        height: 200.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40.r),
            8.verticalSpace,
            Text("视频加载失败", style: Styles.ts_999999_14),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        alignment: Alignment.center,
        height: 200.h,
        child: CircularProgressIndicator(
          color: Styles.c_0C8CE9,
          strokeWidth: 2.w,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),
          GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: _controller.value.isPlaying
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40.r,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
