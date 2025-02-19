import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhotoSlideLogic extends GetxController {
  late ExtendedPageController controller;
  final _videoControllers = <int, VideoPlayerController>{};
  final _chewieControllers = <int, ChewieController>{};

  int get _currentPage => controller.page?.round() ?? 0;
  AssetEntity get _currentAsset => photos[_currentPage];

  final photos = <AssetEntity>[].obs;
  final offset = 0.obs;
  final pageSize = 25;
  final currentIsVideo = false.obs;

  Future<void> loadPhotos() async {
    // 请求权限
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (permission.hasAccess) {
      // 获取相册列表
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: FilterOptionGroup(
          orders: [
            const OrderOption(
              type: OrderOptionType.createDate,
              asc: false, // false 表示降序，最新的在前
            ),
          ],
        ),
      );

      if (paths.isNotEmpty) {
        // 获取第一个相册（通常是"最近"或"所有照片"）
        final AssetPathEntity recentAlbum = paths.first;

        // 获取相册中的照片
        final List<AssetEntity> photoList = await recentAlbum.getAssetListRange(
          start: offset.value,
          end: offset.value + pageSize,
        );

        photos.value = photoList;
      }
    }
  }

  void pickPhotos() async {
    final assets = await AssetPicker.pickAssets(Get.context!,
        pickerConfig: const AssetPickerConfig(
            maxAssets: 10,
            requestType: RequestType.common,
            themeColor: Styles.c_0C8CE9,
            textDelegate: AssetPickerTextDelegate()));
    if (assets != null && assets.isNotEmpty) {
      // 判断选中的资源里是否是同一类型
      final firstType = assets.first.type;
      final isSameType = assets.every((e) => e.type == firstType);

      if (isSameType) {
        final result = await AppNavigator.startPhotoWithWatermarkSlide(assets,
            type: PhotoAddWatermarkType.batch);

        if (result != null && result.isNotEmpty) {
          for (var i = 0; i < result.length; i++) {
            photos.insert(0, result[i]);
          }
        }
      } else {
        ToastUtil.show("不能同时选择视频和图片！");
      }
    }
  }

  void onTapWatermark() async {
    final result = await AppNavigator.startPhotoWithWatermarkSlide(
        [_currentAsset],
        type: PhotoAddWatermarkType.single);
    if (result != null && result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        photos.insert(0, result[i]);
      }
    }
  }

  void _toEditPage(PhotoEditOpType opType) async {
    final result =
        await AppNavigator.startPhotoEdit(_currentAsset, opType: opType);
    if (result != null) {
      photos.insert(0, result);
    }
  }

  void onTapEdit() {
    _toEditPage(PhotoEditOpType.edit);
  }

  void onTapText() {
    _toEditPage(PhotoEditOpType.text);
  }

  void onTapCrop() {
    _toEditPage(PhotoEditOpType.crop);
  }

  void onTapDelete() async {
    final deletedIds =
        await PhotoManager.editor.deleteWithIds([_currentAsset.id]);
    if (deletedIds.isNotEmpty) {
      final deleted = deletedIds.first;
      photos.removeWhere((e) => e.id == deleted);
      if (photos.isEmpty) {
        Get.back();
      }
    }
  }

  void onTapShare() async {
    final currentIndex = controller.page?.round() ?? 0;
    final asset = photos[currentIndex];
    final file = await asset.file;
    final result = await Share.shareXFiles([XFile(file?.path ?? '')]);
    if (result.status == ShareResultStatus.success) {
      // print('Thank you for sharing my website!');
    }
  }

  //加载视频
  Future<void> _loadVideo({int? index}) async {
    final targetIndex = index ?? _currentPage;

    if (_videoControllers[targetIndex] != null) return;

    try {
      final asset = photos[targetIndex];
      final file = await asset.file;
      if (file == null) return;

      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      _videoControllers[targetIndex] = controller;
      _chewieControllers[targetIndex] = ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: false,
        showControls: true,
        showOptions: false,
        materialProgressColors: ChewieProgressColors(
          handleColor: Styles.c_FFFFFF,
          playedColor: Styles.c_FFFFFF.withOpacity(0.75),
          bufferedColor: Styles.c_FFFFFF.withOpacity(0.25),
          backgroundColor: Colors.black.withOpacity(0.05),
        ),
        cupertinoProgressColors: ChewieProgressColors(
          handleColor: Styles.c_FFFFFF,
          playedColor: Styles.c_FFFFFF.withOpacity(0.75),
          bufferedColor: Styles.c_FFFFFF.withOpacity(0.25),
          backgroundColor: Colors.black.withOpacity(0.05),
        ),
      );

      update(); // 通知UI更新
    } catch (e, s) {
      Logger.print("e: $e, s: $s");
    }
  }

  // 预加载相邻页面的视频
  void _preloadAdjacentVideos(int currentIndex) {
    if (currentIndex > 0) {
      final prevAsset = photos[currentIndex - 1];
      if (prevAsset.type == AssetType.video) {
        _loadVideo(index: currentIndex - 1);
      }
    }

    if (currentIndex < photos.length - 1) {
      final nextAsset = photos[currentIndex + 1];
      if (nextAsset.type == AssetType.video) {
        _loadVideo(index: currentIndex + 1);
      }
    }
  }

  @override
  void onInit() {
    controller = ExtendedPageController(shouldIgnorePointerWhenScrolling: true)
      ..addListener(() {
        final page = controller.page;
        if (page == null || page % 1 != 0) return;

        final cPage = page.toInt();
        final cAsset = photos[cPage];
        if (cAsset.type == AssetType.video) {
          _loadVideo(index: cPage);
          _preloadAdjacentVideos(cPage);
        }
        currentIsVideo.value = cAsset.type == AssetType.video;
      });

    final data = Get.arguments['photos'];
    if (data != null && data.isNotEmpty) {
      photos.value = data;
      offset.value = data.length;

      if (photos.first.type == AssetType.video) {
        _loadVideo(index: 0);
      }

      currentIsVideo.value = photos.first.type == AssetType.video;
    }
    super.onInit();
  }

  @override
  void onClose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    for (var controller in _chewieControllers.values) {
      controller.dispose();
    }
    controller.dispose();
    _videoControllers.clear();
    _chewieControllers.clear();
    super.dispose();
  }

  ChewieController? getChewieController(int index) {
    return _chewieControllers[index];
  }
}
