import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../camera_logic.dart';

class ZoomControl extends StatelessWidget {
  const ZoomControl({super.key});

  static const double _height = 170.0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraLogic>(
      id: 'zoom_control',
      builder: (logic) => GestureDetector(
        onVerticalDragStart: (_) => logic.setZoomDragging(true),
        onVerticalDragEnd: (_) => logic.setZoomDragging(false),
        onVerticalDragCancel: () => logic.setZoomDragging(false),
        onVerticalDragUpdate: (details) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final pos = box.globalToLocal(details.globalPosition);
          final validPos = pos.dy.clamp(0.0, _height.h);
          final percent = (1 - (validPos / _height.h)).clamp(0.0, 1.0);
          logic.updateZoom(percent);
        },
        child: Stack(
          children: [
            // 刻度线或点
            GetBuilder<CameraLogic>(
              id: 'zoom_track',
              builder: (_) =>
                  logic.isZoomDragging ? _buildTrackLine() : _buildDots(),
            ),
            // 滑块
            GetBuilder<CameraLogic>(
              id: 'zoom_circle',
              builder: (_) => _buildCircle(logic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackLine() {
    return Center(
      child: Container(
        width: 2.w,
        height: _height.h,
        color: Colors.white.withOpacity(0.3),
      ),
    );
  }

  Widget _buildDots() {
    return SizedBox(
      height: _height.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          3,
          (_) => Center(
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(CameraLogic logic) {
    final circleSize = 35.w;
    final maxOffset = _height.h - circleSize;
    final topPosition = (1.0 - logic.zoomPercent).clamp(0.0, 1.0) * maxOffset;

    return Positioned(
      top: topPosition,
      right: (50.w - circleSize) / 2,
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: logic.isZoomDragging
              ? Colors.white.withOpacity(0.3)
              : Colors.black.withOpacity(0.5),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            '${logic.currentZoom.value.toStringAsFixed(1)}x',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
