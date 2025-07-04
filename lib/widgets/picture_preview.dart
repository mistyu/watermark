import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

import 'meta_hero.dart';

class PicturePreview extends StatelessWidget {
  PicturePreview({
    super.key,
    this.currentIndex = 0,
    this.images = const [],
    this.heroTag,
    this.onTap,
    this.onLongPress,
  }) : controller = images.length > 1
            ? ExtendedPageController(initialPage: currentIndex, pageSpacing: 50)
            : null;
  final int currentIndex;
  final List<String> images;
  final String? heroTag;
  final Function()? onTap;
  final Function(String url)? onLongPress;
  final ExtendedPageController? controller;

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.vertical,
      slidePageBackgroundHandler: (offset, pageSize) =>
          defaultSlidePageBackgroundHandler(
        color: Colors.black,
        offset: offset,
        pageSize: pageSize,
      ),
      child: Stack(
        children: [
          MetaHero(
            heroTag: heroTag,
            onTap: onTap ?? () => Get.back(),
            onLongPress: () {
              final index = controller?.page?.round() ?? 0;
              onLongPress?.call(images[index]);
            },
            child: _childView,
          ),
          Positioned(
              left: 12.w,
              right: 12.w,
              bottom: context.mediaQueryPadding.bottom + 12.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Styles.c_FFFFFF.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r)
                    ),
                    child: Center(
                      child: Icon(Icons.close_rounded,color: Styles.c_FFFFFF,size:  24.sp,),
                    ),
                  ),

                ],
              ))
        ],
      ),
    );
  }

  Widget get _childView {
    return images.length == 1 ? _gestureImage(images[0]) : _pageView;
  }

  Widget get _pageView => ExtendedImageGesturePageView.builder(
        controller: controller,
        onPageChanged: (int index) {},
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return _gestureImage(images.elementAt(index));
        },
      );

  Widget _gestureImage(String url) => ExtendedImage.file(
        File(url),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: true,
        clearMemoryCacheIfFailed: true,
        enableSlideOutPage: true,
        compressionRatio: 1,
        initGestureConfigHandler: (ExtendedImageState state) {
          return GestureConfig(
            inPageView: true,
            initialScale: 1.0,
            maxScale: 5.0,
            animationMaxScale: 6.0,
            initialAlignment: InitialAlignment.center,
          );
        },
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress =
                    loadingProgress?.expectedTotalBytes != null
                        ? loadingProgress!.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null;

                return SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Styles.c_0C8CE9,
                      strokeWidth: 1.5,
                      value: progress ?? 0,
                    ),
                  ),
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              state.imageProvider.evict();
              return "ic_picture_error".webp.toImage;
          }
        },
      );
}

