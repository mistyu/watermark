import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';

import 'app_routes.dart';

/**
 * 导航类 -- 本质是使用get包的toNamed方法
 */
class AppNavigator {
  static startSign() => Get.toNamed(AppRoutes.sign);

  static startSplashToMain() =>
      Get.offAllNamed(AppRoutes.home, arguments: {"isAutoCamera": true});

  static startCamera({WatermarkResource? resource}) =>
      Get.toNamed(AppRoutes.camera, arguments: {"resource": resource});

  static startRightBottom(
          {WatermarkResource? resource,
          RightBottomResource? rightBottomResource}) =>
      Get.toNamed(AppRoutes.smallWatermark, arguments: {
        "resource": resource,
        "rightBottom": rightBottomResource
      });

  static startAbout() => Get.toNamed(AppRoutes.about);

  static startVip() => Get.toNamed(AppRoutes.vip);

  static startPhotoSlide({List<AssetEntity>? photos}) =>
      Get.toNamed(AppRoutes.photoSlide, arguments: {"photos": photos});

  static startPhotoEdit(AssetEntity asset, {PhotoEditOpType? opType}) =>
      Get.toNamed(AppRoutes.photoEdit,
          arguments: {"asset": asset, "opType": opType});

  static startWatermarkLocation(WatermarkDataItemMap itemMap) =>
      Get.toNamed(AppRoutes.watermarkLocation, arguments: {"itemMap": itemMap});

  static startWatermarkProtoBrandLogo(WatermarkDataItemMap itemMap) =>
      Get.toNamed(AppRoutes.watermarkProtoBrandLogo,
          arguments: {"itemMap": itemMap});

  static startPhotoWithWatermarkSlide(List<AssetEntity> photos,
          {required PhotoAddWatermarkType type}) =>
      Get.toNamed(AppRoutes.photoWithWatermarkSlide,
          arguments: {"photos": photos, "type": type});

  static startPhotoBatchPreview(
    List<String> photoPaths,
  ) =>
      Get.toNamed(AppRoutes.photoBatchPreview,
          arguments: {"photoPaths": photoPaths});

  static startResolution() => Get.toNamed(AppRoutes.resolution);

  static startPrivacy() => Get.toNamed(AppRoutes.privacy);

  static startLogin() => Get.toNamed(AppRoutes.login);

  static startActivateCode() => Get.toNamed(AppRoutes.activateCode);

  static startPhotoGallery() => Get.toNamed(AppRoutes.photoGallery);
}

enum PhotoEditOpType {
  edit, // 编辑
  text, // 标注
  crop, // 裁剪
  sticker,
}

enum PhotoAddWatermarkType {
  single, // 单个
  batch // 多个
}
