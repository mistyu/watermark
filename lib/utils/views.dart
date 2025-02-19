import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:watermark_camera/utils/library.dart';

import '../widgets/picture_preview.dart';
import '../widgets/transparent_route.dart';
import '../widgets/video_player_view.dart';

class CameraViews {
  static Widget buildHeader({Color? backgroundColor}) => WaterDropHeader(
        waterDropColor: backgroundColor ?? Styles.c_0C8CE9.withOpacity(0.8),
      );

  static Widget buildFooter() => CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            // body = Text("pull up load");
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            // body = Text("Load Failed!Click retry!");
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.canLoading) {
            // body = Text("release to load more");
            body = const CupertinoActivityIndicator();
          } else {
            body = "没有更多数据".toText..style = Styles.ts_999999_12;
            // body = const SizedBox();
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      );

  static void previewUrlPicture(
    List<String> urls, {
    int currentIndex = 0,
    String? heroTag,
  }) =>
      navigator?.push(TransparentRoute(
        builder: (BuildContext context) => GestureDetector(
          onTap: () => Get.back(),
          child: PicturePreview(
            currentIndex: currentIndex,
            images: urls,
            heroTag: heroTag,
          ),
        ),
      ));

  static void previewVideoPicture(
    List<String> urls, {
    int currentIndex = 0,
    String? heroTag,
  }) =>
      navigator?.push(TransparentRoute(
        builder: (BuildContext context) => GestureDetector(
          onTap: () => Get.back(),
          child: Center(
            child: VideoPlayerView(
              currentIndex: currentIndex,
              videos: urls,
              heroTag: heroTag,
            ),
          ),
        ),
      ));
}
