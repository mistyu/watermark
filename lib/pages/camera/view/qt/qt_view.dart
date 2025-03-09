import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:watermark_camera/pages/camera/camera_logic.dart';
import 'package:watermark_camera/utils/styles.dart';

class QtSmall extends StatelessWidget {
  final String type;
  final String sender;
  final String sendTime;
  final CameraLogic cameraController;

  const QtSmall({
    super.key,
    required this.type,
    required this.sender,
    required this.sendTime,
    required this.cameraController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _qtWight(),
          _qtText(),
        ],
      ),
    );
  }

  Widget _qtWight() {
    String qrData = '';
    if (type == '1') {
      qrData = 'type=1&sender=$sender&sendTime=$sendTime';
    } else if (type == '2') {
      qrData = 'type=2&sender=$sender&sendTime=$sendTime';
    } else if (type == '3') {
      qrData = 'type=3&sender=$sender&sendTime=$sendTime';
    }
    return Transform.scale(
      scale: 0.95, // 强制设置缩放
      child: QrImageView(
        data: qrData,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _qtText() {
    String text = '';
    if (type == '1') {
      text = "扫码导航";
    } else if (type == '2') {
      text = "扫码拍照";
    } else if (type == '3') {
      text = "扫码/验真";
    }
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: Text(text,
          style: const TextStyle(
              fontSize: 11,
              color: Styles.c_222222,
              fontWeight: FontWeight.bold)),
    );
  }
}
