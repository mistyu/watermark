import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/bouncing_widget.dart';

class CameraModeSelector extends StatefulWidget {
  final CameraMode cameraMode;
  final Function(CameraMode)? onSelect;
  const CameraModeSelector(
      {super.key, required this.cameraMode, this.onSelect});

  @override
  State<CameraModeSelector> createState() => _CameraModeSelectorState();
}

class _CameraModeSelectorState extends State<CameraModeSelector> {
  late PageController _pageController;

  int _index = 0;

  final cameraModes = [CameraMode.photo, CameraMode.video];

  @override
  void initState() {
    super.initState();
    _index = cameraModes.indexOf(widget.cameraMode);
    _pageController =
        PageController(viewportFraction: 0.25, initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        height: 32.h,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemCount: cameraModes.length,
          onPageChanged: (index) {
            setState(() {
              _index = index;
            });
            widget.onSelect?.call(cameraModes[index]);
          },
          itemBuilder: (context, index) {
            final cameraMode = cameraModes[index];
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: index == _index ? 1 : 0.2,
              child: BouncingWidget(
                child: Center(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      cameraMode.name,
                      style: TextStyle(
                        color: Styles.c_0C8CE9,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        shadows:  [
                          Shadow(
                            blurRadius: 4,
                            color: Styles.c_0C8CE9.withOpacity(0.05),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
