import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/config/router.dart';
import '../../right_bottom_watermark.dart';
import '../../watermark.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import '../../widgets/camera/photo_bottom_actions.dart';
import '../../widgets/camera/photo_top_actions.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class PhotoView extends StatefulWidget {
  final PhotoCameraState state;
  const PhotoView(this.state, {super.key});

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  final WidgetsToImageController _controller = WidgetsToImageController();

  @override
  Widget build(BuildContext context) {
    // initState();
    return Column(
      children: <Widget>[
        PhotoTopActions(state: widget.state),
        Expanded(
            child: Stack(
          children: [
            Watermark(watermarkController: _controller),
            //右下角水印
            Positioned(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RightBottomWatermark()));
                        // AppRouter.router?.goNamed(AppRouter.rightBottomPath);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.w),
                        child: Image.asset(
                          // "R".png,
                          'ic_add_r2'.png,
                          width: 50.w,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ))),
          ],
        )),
        PhotoBottomActions(
          state: widget.state,
          watermarkController: _controller,
        )
      ],
    );
  }
}
