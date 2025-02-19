import 'dart:io';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/core/service/media_service.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/widgets/loading_view.dart';

class PhotoBatchPreviewLogic extends GetxController {
  final photoPaths = <String>[].obs;

  bool get isVideo => Utils.getMimeType(photoPaths.first).contains('video');

  void onSave() async {
    final assets = <AssetEntity>[];
    await LoadingView.singleton.wrap(asyncFunction: () async {
      for (var i = 0; i < photoPaths.length; i++) {
        final path = photoPaths[i];
        final asset = isVideo
            ? await MediaService.saveVideo(File(path))
            : await MediaService.savePhotoWithPath(path);
        assets.add(asset);
      }
    });
    ToastUtil.show("全部保存成功");
    Get.back(result: assets);
  }

  void onTapPhoto(int index) {
    if (isVideo) {
      CameraViews.previewVideoPicture(photoPaths, currentIndex: index);
    } else {
      CameraViews.previewUrlPicture(photoPaths, currentIndex: index);
    }
  }

  @override
  void onInit() {
    super.onInit();
    photoPaths.value = Get.arguments["photoPaths"];
  }
}
