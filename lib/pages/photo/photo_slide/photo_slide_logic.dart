import 'package:better_open_file/better_open_file.dart';
import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class PhotoSlideLogic extends GetxController {
  late ExtendedPageController controller;
  final _videoControllers = <int, ChewieController>{};

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

  Future<void> initVideoController(int index) async {
    try {
      if (_videoControllers[index] != null) {
        return;
      }

      final photo = photos.elementAt(index);
      if (photo.type != AssetType.video) {
        return;
      }

      final file = await photo.file;
      if (file == null) {
        return;
      }
      print("xiaojianjian 视频路径: ${file.path}");

      // 获取视频缩略图
      final thumbData = await photo.thumbnailData;

      // 更新UI，显示视频缩略图和播放按钮
      currentIsVideo.value = true;
      update([index]); // 使用索引作为更新ID
    } catch (e) {
      print("视频控制器初始化失败: $e");
      Utils.showToast("视频预览失败，请尝试其他视频");
    }
  }

  Future<void> openVideoWithSystemPlayer(int index) async {
    try {
      // // 请求存储权限
      // final result = await DialogUtil.showPermissionDialog(
      //   title: "需要存储权限",
      //   content: "需要存储权限才能打开视频",
      //   permission: Permission.storage,
      // );

      final photo = photos.elementAt(index);
      final file = await photo.file;
      if (file == null) {
        Utils.showToast("无法获取视频文件");
        return;
      }

      print("尝试打开视频: ${file.path}");

      // 方法1: 使用 better_open_file
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        print("打开视频失败: ${result.message}");

        // 方法2: 如果方法1失败，尝试复制文件到应用外部存储目录
        try {
          final extDir = await getExternalStorageDirectory();
          if (extDir != null) {
            final fileName = path.basename(file.path);
            final newFile = File('${extDir.path}/$fileName');

            // 复制文件
            if (!await newFile.exists()) {
              await file.copy(newFile.path);
            }

            print("尝试打开复制后的视频: ${newFile.path}");
            final result2 = await OpenFile.open(newFile.path);
            if (result2.type != ResultType.done) {
              Utils.showToast("无法打开视频: ${result2.message}");
            }
          } else {
            Utils.showToast("无法获取外部存储目录");
          }
        } catch (e) {
          print("复制文件失败: $e");
          Utils.showToast("无法打开视频，请尝试其他方式查看");
        }
      }
    } catch (e) {
      print("打开视频异常: $e");
      Utils.showToast("因为水印合成视频特殊格式无法打开视频，因此需要您前往系统相册播放查看");
    }
  }

  // 预加载相邻页面的视频
  void _preloadAdjacentVideos(int currentIndex) {
    if (currentIndex > 0) {
      final prevAsset = photos[currentIndex - 1];
      if (prevAsset.type == AssetType.video) {
        initVideoController(currentIndex - 1);
      }
    }

    if (currentIndex < photos.length - 1) {
      final nextAsset = photos[currentIndex + 1];
      if (nextAsset.type == AssetType.video) {
        initVideoController(currentIndex + 1);
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
          initVideoController(cPage);
          _preloadAdjacentVideos(cPage);
        }
        currentIsVideo.value = cAsset.type == AssetType.video;
      });

    final data = Get.arguments['photos'];
    if (data != null && data.isNotEmpty) {
      photos.value = data;
      offset.value = data.length;

      if (photos.first.type == AssetType.video) {
        initVideoController(0);
      }

      currentIsVideo.value = photos.first.type == AssetType.video;
    }
    super.onInit();
  }

  @override
  void onClose() {
    for (var controller in _videoControllers.values) {
      controller.videoPlayerController.dispose();
      controller.dispose();
    }
    controller.dispose();
    _videoControllers.clear();
    super.dispose();
  }

  ChewieController? getChewieController(int index) {
    return _videoControllers[index];
  }
}
