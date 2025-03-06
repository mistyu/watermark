import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/utils/styles.dart';

import '../../../../widgets/title_bar.dart';

class WatermarkLiveShootScale extends StatefulWidget {
  final WatermarkDataItemMap itemMap;
  const WatermarkLiveShootScale({super.key, required this.itemMap});

  @override
  State<WatermarkLiveShootScale> createState() =>
      _WatermarkLiveShootScaleState();
}

class _WatermarkLiveShootScaleState extends State<WatermarkLiveShootScale> {
  double scale = 1.0; // 缩放比例，默认值为 1

  void _onSubmitted() {
    Get.back(result: scale); // 返回缩放比例
  }

  void _resetScale() {
    setState(() {
      scale = 1.0; // 重置缩放比例
    });
  }

  @override
  void initState() {
    super.initState();
    scale = widget.itemMap.data.scale ?? 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 250.h + // 增加高度以适应内容
            context.mediaQueryPadding.bottom +
            (isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0),
        width: double.infinity,
        padding: EdgeInsets.only(
            bottom: context.mediaQueryPadding.bottom +
                (isKeyboardVisible
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 0)),
        decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r))),
        child: Column(
          children: [
            TitleBar.back(
              backgroundColor: Styles.c_F6F6F6,
              primary: false,
              title: "时间",
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
              ),
              border: const Border(
                bottom: BorderSide(color: Styles.c_EDEDED),
              ),
              right: TextButton(
                  onPressed: _onSubmitted,
                  child: "保存".toText..style = Styles.ts_0C8CE9_16_medium),
            ),
            SizedBox(height: 20.h), // 增加间距
            // 显示当前缩放比例（百分比）
            Text(
              "${(scale * 100).toStringAsFixed(0)}%", // 显示为百分比
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Styles.c_333333,
              ),
            ),
            SizedBox(height: 20.h), // 增加间距
            // 滑动条
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Slider(
                value: scale,
                min: 0.1, // 最小缩放比例
                max: 2.0, // 最大缩放比例
                divisions: 19, // 将范围分为 19 个区间（0.1 到 2.0）
                label: "${(scale * 100).toStringAsFixed(0)}%", // 显示当前值
                onChanged: (value) {
                  setState(() {
                    scale = value; // 更新缩放比例
                  });
                },
              ),
            ),
            Spacer(), // 将按钮推到底部
            // 重置按钮
            Padding(
              padding: EdgeInsets.only(right: 20.w, bottom: 20.h),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: _resetScale, // 重置缩放比例
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.c_0481DC, // 按钮背景颜色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    "重置大小",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Styles.c_FFFFFF,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
