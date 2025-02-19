import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/custom_popup_menu.dart';
import 'package:watermark_camera/utils/extension.dart';

// typedef PopupMenuItemBuilder = Widget Function(PopMenuInfo info);

class PopMenuInfo {
  final String? icon;
  final Widget? iconWidget;
  final String text;
  final Function()? onTap;

  PopMenuInfo({
    this.icon,
    this.iconWidget,
    required this.text,
    this.onTap,
  });
}

class PopButton extends StatelessWidget {
  final List<Widget> menus;
  final Widget child;
  final CustomPopupMenuController? popCtrl;
  final PressType pressType;
  final bool showArrow;
  final Color arrowColor;
  final Color barrierColor;
  final double horizontalMargin;
  final double verticalMargin;
  final double arrowSize;
  final Color? bgColor;
  final double? bgRadius;
  final Color? bgShadowColor;
  final Offset? bgShadowOffset;
  final double? bgShadowBlurRadius;
  final double? bgShadowSpreadRadius;
  final double? menuItemHeight;
  final double? menuItemWidth;
  final EdgeInsetsGeometry? menuItemPadding;
  final TextStyle? menuItemTextStyle;
  final double? menuItemIconWidth;
  final double? menuItemIconHeight;
  final Color? lineColor;
  final double? lineWidth;
  final bool? line;

  const PopButton(
      {Key? key,
      required this.menus,
      required this.child,
      this.popCtrl,
      this.arrowColor = const Color(0xFFFFFFFF),
      this.showArrow = false,
      this.barrierColor = Colors.transparent,
      this.arrowSize = 10.0,
      this.horizontalMargin = 18.0,
      this.verticalMargin = 18.0,
      this.pressType = PressType.singleClick,
      this.bgColor,
      this.bgRadius,
      this.bgShadowColor,
      this.bgShadowOffset,
      this.bgShadowBlurRadius,
      this.bgShadowSpreadRadius,
      this.menuItemHeight,
      this.menuItemWidth,
      this.menuItemTextStyle,
      this.menuItemIconWidth,
      this.menuItemIconHeight,
      this.menuItemPadding,
      this.lineColor,
      this.lineWidth = 1.0,
      this.line})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CopyCustomPopupMenu(
      controller: popCtrl,
      arrowColor: arrowColor,
      showArrow: showArrow,
      barrierColor: barrierColor,
      arrowSize: arrowSize,
      bgRadius: bgRadius,
      verticalMargin: verticalMargin,
      horizontalMargin: horizontalMargin,
      pressType: pressType,
      child: child,
      menuBuilder: () => _buildPopBgView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menus
              .map((e) => _buildPopItemView(
                  child: e, showLine: line ?? menus.lastOrNull != e))
              .toList(),
        ),
      ),
    );
  }

  _clickArea(double dy) {
    for (var i = 0; i < menus.length; i++) {
      if (dy > i * menuItemHeight! && dy <= (i + 1) * menuItemHeight!) {
        // menus.elementAt(i).onTap?.call();
        popCtrl?.hideMenu();
      }
    }
  }

  Widget _buildPopBgView({Widget? child}) => Container(
        padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.black,
          borderRadius: BorderRadius.circular(bgRadius ?? 0),
          boxShadow: [
            BoxShadow(
              color: bgShadowColor ?? Colors.transparent,
              offset: bgShadowOffset ?? Offset(0, 6.h),
              blurRadius: bgShadowBlurRadius ?? 16.r,
              spreadRadius: bgShadowSpreadRadius ?? 1.r,
            )
          ],
        ),
        child: child,
      );
  Widget _buildPopItemView({Widget? child, bool showLine = false}) => Container(
        height: menuItemHeight,
        width: menuItemWidth,
        padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.black,
          // borderRadius: BorderRadius.circular(bgRadius ?? 0),
          border: showLine
              ? BorderDirectional(
                  bottom: BorderSide(
                    color: lineColor ?? Colors.black,
                    width: lineWidth ?? 1,
                  ),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: bgShadowColor ?? Colors.transparent,
              offset: bgShadowOffset ?? Offset(0, 6.h),
              blurRadius: bgShadowBlurRadius ?? 16.r,
              spreadRadius: bgShadowSpreadRadius ?? 1.r,
            )
          ],
        ),
        child: child,
      );
  // Widget _buildPopItemView(PopMenuInfo info, {bool showLine = true}) =>
  //     GestureDetector(
  //       onTap: () {
  //         popCtrl?.hideMenu();
  //         info.onTap?.call();
  //       },
  //       behavior: HitTestBehavior.translucent,
  //       child: Container(
  //         height: menuItemHeight,
  //         width: menuItemWidth,
  //         padding: menuItemPadding,
  //         constraints: BoxConstraints(minWidth: 108.w),
  //         decoration: showLine
  //             ? BoxDecoration(
  //                 border: BorderDirectional(
  //                   bottom: BorderSide(
  //                     color: lineColor ?? Colors.black,
  //                     width: lineWidth ?? 1,
  //                   ),
  //                 ),
  //               )
  //             : null,
  //         child: info.iconWidget != null
  //             ? Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   if (null != info.iconWidget)
  //                     Padding(
  //                       padding: EdgeInsets.only(right: 4.w),
  //                       child: info.iconWidget,
  //                     ),
  //                   info.text.toText
  //                     ..style =
  //                         (menuItemTextStyle ?? TextStyle(color: Colors.black)),
  //                 ],
  //               )
  //             : Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   if (null != info.icon)
  //                     Padding(
  //                       padding: EdgeInsets.only(right: 12.w),
  //                       // child: info.icon!.toImage
  //                       //   ..width = (menuItemIconWidth ?? 20.w)
  //                       //   ..height = (menuItemIconHeight ?? 20.h),
  //                     ),
  //                   info.text.toText
  //                     ..style =
  //                         (menuItemTextStyle ?? TextStyle(color: Colors.black)),
  //                 ],
  //               ),
  //       ),
  //     );
}
