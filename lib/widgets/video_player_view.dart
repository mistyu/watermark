import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:watermark_camera/utils/library.dart';

import 'meta_hero.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    this.currentIndex = 0,
    this.videos = const [],
    this.heroTag,
    this.onTap,
    this.onLongPress,
  });

  final int currentIndex;
  final List<String> videos;
  final String? heroTag;
  final Function()? onTap;
  final Function(String url)? onLongPress;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late ExtendedPageController _pageController;
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = ExtendedPageController(
      initialPage: _currentIndex,
      pageSpacing: 50,
    );
    _initVideoPlayer();
  }

  void _initVideoPlayer() {
    _videoController = VideoPlayerController.file(
      File(widget.videos[_currentIndex]),
    )..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: true,
          showControls: true,
          showOptions: false,
          aspectRatio: _videoController.value.aspectRatio,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
        setState(() {});
      });
  }

  void _switchVideo(int index) {
    setState(() {
      _currentIndex = index;
      // 释放旧的控制器
      _chewieController?.dispose();
      _videoController.dispose();

      // 创建新的控制器
      _videoController = VideoPlayerController.file(File(widget.videos[index]))
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: true,
            looping: true,
            aspectRatio: _videoController.value.aspectRatio,
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          );
          setState(() {});
        });
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

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
            heroTag: widget.heroTag,
            onTap: widget.onTap ?? () => Get.back(),
            child: widget.videos.length == 1
                ? _buildVideoPlayer(widget.videos[0])
                : ExtendedImageGesturePageView.builder(
                    controller: _pageController,
                    onPageChanged: _switchVideo,
                    itemCount: widget.videos.length,
                    itemBuilder: (context, index) {
                      return _buildVideoPlayer(widget.videos[index]);
                    },
                  ),
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

  Widget _buildVideoPlayer(String url) {
    if (_chewieController != null) {
      return Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 32,
          bottom: MediaQuery.of(context).padding.bottom + 74,
        ),
        child: Chewie(controller: _chewieController!),
      );
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
