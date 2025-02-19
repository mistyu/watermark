import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    this.colors,
    this.width,
    this.height,
    this.borderRadius,
    required this.tapCallback,
    required this.child,
    this.disable = false,
  }) : super(key: key);

  final List<Color>? colors; // 渐变色数组
  final double? width; // 按钮 宽
  final double? height; // 按钮 高
  final BorderRadius? borderRadius; // 按钮 圆角

  final GestureTapCallback tapCallback;
  final bool disable; // 禁用

  final Widget child; // 子组件

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<Color> gradientColors = [];
    if (disable) {
      gradientColors = [Colors.grey.withAlpha(100), Colors.grey.withAlpha(100)];
    } else {
      gradientColors = colors ?? [theme.primaryColor, theme.primaryColorDark];
    }

    var buttonBorderRadius = this.borderRadius ?? BorderRadius.circular(24);

    return Container(
      height: height ?? 36,
      width: width,
      decoration: BoxDecoration(
        borderRadius: buttonBorderRadius,
        gradient: LinearGradient(colors: gradientColors),
      ),
      child: Material(
        type: MaterialType.transparency, // 透明材质 用于绘制墨水飞溅和高光
        child: InkWell(
          onTap: disable ? null : tapCallback,
          splashColor: gradientColors.last,
          borderRadius: buttonBorderRadius,
          enableFeedback: !disable, // 是否给予操作反馈
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
