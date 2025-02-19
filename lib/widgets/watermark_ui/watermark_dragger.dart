import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:watermark_camera/utils/constants.dart';

class WatermarkDragger extends StatefulWidget {
  final Widget child;
  final Offset offset;
  final VoidCallback? onTap;
  final VoidCallback? onPanStart;
  final VoidCallback? onPanEnd;
  final Function(Offset)? onChange;
  const WatermarkDragger({
    super.key,
    required this.child,
    required this.offset,
    this.onTap,
    this.onPanStart,
    this.onPanEnd,
    this.onChange,
  });

  @override
  State<WatermarkDragger> createState() => _WatermarkDraggerState();
}

class _WatermarkDraggerState extends State<WatermarkDragger> {
  late Offset _currentOffset;

  bool get isIgnore => widget.onTap == null;

  @override
  void initState() {
    super.initState();
    _currentOffset = widget.offset;
  }

  @override
  void didUpdateWidget(WatermarkDragger oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.offset != widget.offset) {
      _currentOffset = widget.offset;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: _currentOffset.dy,
      left: _currentOffset.dx,
      child: GestureDetector(
        onTap: widget.onTap,
        onPanStart: (_) {
          widget.onPanStart?.call();
        },
        onPanUpdate: isIgnore ? null :  (details) =>  _onDragUpdate(details),
        onPanEnd: (_) => widget.onPanEnd?.call(),
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final stackBox = context.findAncestorRenderObjectOfType<RenderStack>();
    if (stackBox == null) return;
    final stackSize = stackBox.size;
    final watermarkSize = renderBox.size;
    final maxX = max(watermarkMinMargin,
        stackSize.width - watermarkSize.width - watermarkMinMargin);
    final maxY = max(watermarkMinMargin,
        stackSize.height - watermarkSize.height - watermarkMinMargin);
    const minX = watermarkMinMargin;
    const minY = watermarkMinMargin;

    // Calculate new offset with drag delta
    Offset newOffset = _currentOffset.translate(details.delta.dx,
        -details.delta.dy); // Negate dy to fix inverted y-axis

    // Clamp the offset within screen bounds
    double clampedX = newOffset.dx.clamp(minX, maxX);
    double clampedY = newOffset.dy.clamp(minY, maxY);

    setState(() {
      _currentOffset = Offset(clampedX, clampedY);
    });

    widget.onChange?.call(_currentOffset);
  }
}
