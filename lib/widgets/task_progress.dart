import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/library.dart';

class TaskProgress extends StatelessWidget {
  final double progress;
  final String? message;
  final VoidCallback? onComplete;

  const TaskProgress({
    Key? key,
    required this.progress,
    this.message,
    this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (progress >= 100 && onComplete != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onComplete!());
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (Utils.isNotNullEmptyStr(message))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                message!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          "视频解析中".toText..style = Styles.ts_333333_14_medium,
          16.verticalSpace,
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Styles.c_F1F1F1,
              valueColor: const AlwaysStoppedAnimation<Color>(Styles.c_0C8CE9),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${progress.toStringAsFixed(1)}%',
              style: const TextStyle(color: Styles.c_999999),
            ),
          ),
        ],
      ),
    );
  }
}