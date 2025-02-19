import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({
    super.key,
    this.height,
    this.left,
    this.center,
    this.right,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.showUnderline = false,
    this.primary = true,
  });
  final double? height;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Color? backgroundColor;
  final bool showUnderline;
  final bool primary;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Get.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Container(
        padding: EdgeInsets.only(top: primary ? mq.padding.top : 0),
        decoration: BoxDecoration(
            color: backgroundColor ?? Styles.c_FFFFFF,
            borderRadius: borderRadius,
            border: border),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (null != center) center!,
            Container(
              height: height,
              padding: EdgeInsets.only(left: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (null != left) left!,
                  if (null != right) right!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 44.h);

  TitleBar.back({
    super.key,
    String? title,
    String? leftTitle,
    TextStyle? titleStyle,
    TextStyle? leftTitleStyle,
    String? result,
    Color? backgroundColor,
    Color? backIconColor,
    this.right,
    this.showUnderline = false,
    this.primary = true,
    this.borderRadius,
    this.border,
    Function()? onTap,
  })  : height = 44.h,
        backgroundColor = backgroundColor ?? Styles.c_FFFFFF,
        center = (title ?? '').toText
          ..style = titleStyle ?? Styles.ts_333333_18_medium
          ..textAlign = TextAlign.center,
        left = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap ?? (() => Get.back(result: result)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              "nvbar_ico_back".svg.toSvg
                ..width = 24.w
                ..height = 24.h
                ..color = backIconColor ?? Styles.c_333333,
              if (null != leftTitle)
                leftTitle.toText
                  ..style = (leftTitleStyle ?? Styles.ts_333333_16_medium),
            ],
          ),
        );
}
