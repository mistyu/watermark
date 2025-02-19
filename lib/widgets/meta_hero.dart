import 'package:flutter/material.dart';

class MetaHero extends StatelessWidget {
  const MetaHero({
    super.key,
    required this.heroTag,
    required this.child,
    this.onTap,
    this.onLongPress,
  });
  final Widget child;
  final String? heroTag;
  final Function()? onTap;
  final Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    final view = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
    return heroTag == null ? view : Hero(tag: heroTag!, child: view);
  }
}
