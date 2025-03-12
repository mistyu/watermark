import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

class ShowMessageDialog extends StatelessWidget {
  final String message;
  const ShowMessageDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
      height: 200.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
        ],
      ),
    );
  }
}
