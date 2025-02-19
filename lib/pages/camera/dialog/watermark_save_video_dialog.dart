import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:watermark_camera/utils/library.dart';

class WatermarkSaveVideoDialog extends StatefulWidget {
  final File file;

  const WatermarkSaveVideoDialog({super.key, required this.file});

  @override
  State<WatermarkSaveVideoDialog> createState() =>
      _WatermarkSaveVideoDialogState();
}

class _WatermarkSaveVideoDialogState extends State<WatermarkSaveVideoDialog> {
  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
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
  }

  Future<void> initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.file(widget.file);
      await _videoPlayerController.initialize();
      _createChewieController();
      setState(() {});
    } catch (e, s) {
      Logger.print("e: $e, s: $s");
      setState(() {});
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw * 0.98,
      height: 1.sh * 0.75,
      padding: EdgeInsets.symmetric(vertical: 12.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("save_blue_img".webp),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          "录制成功".toText..style = Styles.ts_0C8CE9_20_medium,
          16.verticalSpace,
          Expanded(
              child: _chewieController != null &&
                      _videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    )),
          32.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Styles.c_FFFFFF,
                  ),
                  child: '重 拍'.toText..style = Styles.ts_333333_16,
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Styles.c_0C8CE9,
                    side: BorderSide(color: Styles.c_0C8CE9.withOpacity(0.5)),
                  ),
                  child: '保存视频'.toText..style = Styles.ts_FFFFFF_16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
