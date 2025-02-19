import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';

class Thumbnail extends StatefulWidget {
  final AssetEntity? asset;
  final Function()? onTap;
  final bool? ignorePointer;

  const Thumbnail({
    super.key,
    required this.asset,
    this.onTap,
    this.ignorePointer,
  });

  @override
  _ThumbnailState createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail>
    with SingleTickerProviderStateMixin {
  AssetEntity? _prevAsset;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void didUpdateWidget(Thumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.asset != _prevAsset) {
      _controller.forward(from: 0.0);
    }
    _prevAsset = widget.asset;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: widget.ignorePointer == true ? null : widget.onTap,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 35.w,
          height: 35.w,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 2),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: _buildPictureView(widget.asset?.file),
        ),
      ),
    );
  }

  Widget _buildPictureView(Future<File?>? futureFile) {
    return futureFile != null
        ? FutureBuilder(
            future: futureFile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    width: 8.w,
                    height: 8.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final file = snapshot.data as File;
                final isImage = file.path.isImageFileName;
                if (isImage) {
                  return ImageUtil.fileImage(
                      file: file,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(3.r),
                      loadingSize: 8.w);
                } else {
                  return _buildPictureView(Utils.getVideoThumbnail(file));
                }
              } else {
                return "home_ico_photo".png.toImage..width = 32.w;
              }
            })
        : ("home_ico_photo".png.toImage..width = 32.w);
  }
}
