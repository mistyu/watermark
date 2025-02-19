import 'package:get/get.dart';
import 'package:watermark_camera/pages/about/about_binding.dart';
import 'package:watermark_camera/pages/about/about_view.dart';
import 'package:watermark_camera/pages/camera/camera_binding.dart';
import 'package:watermark_camera/pages/camera/view/watermark_proto_brand_logo/binding.dart';
import 'package:watermark_camera/pages/camera/view/watermark_proto_brand_logo/view.dart';
import 'package:watermark_camera/pages/camera/view/watermark_proto_location/binding.dart';

import 'package:watermark_camera/pages/guide/guide_binding.dart';
import 'package:watermark_camera/pages/home/home_binding.dart';
import 'package:watermark_camera/pages/mine/mine_binding.dart';
import 'package:watermark_camera/pages/mine/privacy/privacy_view.dart';
import 'package:watermark_camera/pages/mine/resolution/resolution_view.dart';
import 'package:watermark_camera/pages/photo/photo_batch_preview/binding.dart';
import 'package:watermark_camera/pages/photo/photo_batch_preview/view.dart';
import 'package:watermark_camera/pages/photo/photo_edit/photo_edit_binding.dart';
import 'package:watermark_camera/pages/photo/photo_edit/photo_edit_view.dart';
import 'package:watermark_camera/pages/photo/photo_slide/photo_slide_binding.dart';
import 'package:watermark_camera/pages/photo/photo_slide/photo_slide_view.dart';
import 'package:watermark_camera/pages/photo/photo_with_watermark_slide/binding.dart';
import 'package:watermark_camera/pages/photo/photo_with_watermark_slide/view.dart';
import 'package:watermark_camera/pages/sign/sign_binding.dart';
import 'package:watermark_camera/pages/sign/sign_view.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_antifake/right_bottom_antifake_binding.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_grid/right_bottom_grid_binding.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_sign/right_bottom_sign_binding.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_size/right_bottom_size_binding.dart';
import 'package:watermark_camera/pages/small_watermark/right_bottom_style/right_bottom_style_binding.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_binding.dart';
import 'package:watermark_camera/pages/splash/splash_binding.dart';
import 'package:watermark_camera/pages/vip/vip_binding.dart';
import 'package:watermark_camera/pages/vip/vip_view.dart';
import 'package:watermark_camera/pages/camera/view/watermark_proto_location/view.dart';

import '../pages/camera/camera_view.dart';
import '../pages/home/home_view.dart';
import '../pages/small_watermark/small_watermark_view.dart';
import '../pages/splash/splash_page.dart';
import 'app_routes.dart';
import '../pages/login/login_binding.dart';
import '../pages/login/login_view.dart';

class AppPages {
  static _pageBuilder({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    List<Bindings>? bindings,
    Transition? transition,
    bool preventDuplicates = true,
    bool opaque = true,
    bool fullscreenDialog = false,
  }) =>
      GetPage(
        name: name,
        page: page,
        binding: binding,
        bindings: bindings ?? [],
        preventDuplicates: preventDuplicates,
        transition: transition ?? Transition.cupertino,
        popGesture: true,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
      );

  static final routes = <GetPage>[
    _pageBuilder(
        name: AppRoutes.splash,
        binding: SplashBinding(),
        page: () => SplashPage()),
    _pageBuilder(
        name: AppRoutes.sign, binding: SignBinding(), page: () => SignPage()),
    _pageBuilder(
        name: AppRoutes.home,
        bindings: [
          HomeBinding(),
          GuideBinding(),
          MineBinding(),
          LoginBinding()
        ],
        page: () => HomePage()),
    _pageBuilder(
        name: AppRoutes.camera,
        binding: CameraBinding(),
        page: () => CameraPage()),
    _pageBuilder(
        name: AppRoutes.smallWatermark,
        bindings: [
          SmallWatermarkBinding(),
          RightBottomGridBinding(),
          RightBottomAntifakeBinding(),
          RightBottomSizeBinding(),
          RightBottomSignBinding(),
          RightBottomStyleBinding()
        ],
        page: () => SmallWatermarkPage()),
    _pageBuilder(
        name: AppRoutes.about,
        binding: AboutBinding(),
        page: () => AboutPage()),
    _pageBuilder(
        name: AppRoutes.vip, binding: VipBinding(), page: () => VipPage()),
    _pageBuilder(
      name: AppRoutes.photoSlide,
      binding: PhotoSlideBinding(),
      transition: Transition.downToUp,
      page: () => PhotoSlidePage(),
      // preventDuplicates: true,
      // opaque: false,
      fullscreenDialog: true,
    ),
    _pageBuilder(
      name: AppRoutes.photoEdit,
      binding: PhotoEditBinding(),
      page: () => PhotoEditPage(),
    ),
    _pageBuilder(
      name: AppRoutes.watermarkLocation,
      binding: WatermarkProtoLocationBinding(),
      page: () => WatermarkProtoLocationPage(),
    ),
    _pageBuilder(
      name: AppRoutes.watermarkProtoBrandLogo,
      binding: WatermarkProtoBrandLogoBinding(),
      page: () => WatermarkProtoBrandLogoPage(),
    ),
    _pageBuilder(
      name: AppRoutes.photoWithWatermarkSlide,
      binding: PhotoWithWatermarkSlideBinding(),
      page: () => PhotoWithWatermarkSlidePage(),
    ),
    _pageBuilder(
      name: AppRoutes.photoBatchPreview,
      binding: PhotoBatchPreviewBinding(),
      page: () => PhotoBatchPreviewPage(),
    ),
    _pageBuilder(
      name: AppRoutes.resolution,
      page: () => ResolutionPage(),
    ),
    _pageBuilder(
      name: AppRoutes.privacy,
      page: () => PrivacyPage(),
    ),
    _pageBuilder(
      name: AppRoutes.login,
      binding: LoginBinding(),
      page: () => const LoginView(),
    ),
  ];
}
