import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CameraGestureDetector extends StatefulWidget {
  final Widget child;
  final OnPreviewTapBuilder? onPreviewTapBuilder;
  final OnPreviewScale? onPreviewScale;
  final double initialZoom;

  const CameraGestureDetector({
    super.key,
    required this.child,
    required this.onPreviewScale,
    this.onPreviewTapBuilder,
    this.initialZoom = 0,
  });

  @override
  State<StatefulWidget> createState() {
    return _CameraGestureDetector();
  }
}

class _CameraGestureDetector extends State<CameraGestureDetector> {
  double _zoomScale = 0;
  final double _accuracy = 0.01;
  double? _lastScale;

  Offset? _tapPosition;
  Timer? _timer;

  void _onTapUp() {
    if (widget.onPreviewTapBuilder!.onPreviewTap.tapPainterDuration != null) {
      _onTapCancel();
      _timer = Timer(
          widget.onPreviewTapBuilder!.onPreviewTap.tapPainterDuration!, () {
        debugPrint("time end");
        setState(() {
          _tapPosition = null;
        });
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    debugPrint("details position: ${details.localPosition}");
    _onTapCancel();
    setState(() {
      _tapPosition = details.localPosition;
    });
    widget.onPreviewTapBuilder!.onPreviewTap.onTap(
      _tapPosition!,
      widget.onPreviewTapBuilder!.flutterPreviewSizeGetter(),
      widget.onPreviewTapBuilder!.pixelPreviewSizeGetter(),
    );
  }

  void _onTapCancel() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  @override
  void initState() {
    _zoomScale = widget.initialZoom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        debugPrint("onPointerUp!!!!");
        _onTapUp();
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          if (widget.onPreviewScale != null)
            ScaleGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<ScaleGestureRecognizer>(
              () => ScaleGestureRecognizer()
                ..onStart = (_) {
                  _lastScale = null;
                }
                ..onUpdate = (ScaleUpdateDetails details) {
                  _lastScale ??= details.scale;
                  if (details.scale < (_lastScale! + 0.01) &&
                      details.scale > (_lastScale! - 0.01)) {
                    return;
                  } else if (_lastScale! < details.scale) {
                    _zoomScale += _accuracy;
                  } else {
                    _zoomScale -= _accuracy;
                  }

                  _zoomScale = _zoomScale.clamp(0, 1);
                  widget.onPreviewScale!.onScale(_zoomScale);
                  _lastScale = details.scale;
                },
              (instance) {},
            ),
          if (widget.onPreviewTapBuilder != null)
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer()..onTapDown = _onTapDown,
              // ..onTapUp = (_) {
              //   debugPrint("onTapUp!!!!");
              //   _onTapUp();
              // },
              (instance) {},
            ),
        },
        child: Stack(children: [
          Positioned.fill(child: widget.child),
          if (_tapPosition != null &&
              widget.onPreviewTapBuilder?.onPreviewTap.onTapPainter != null)
            widget
                .onPreviewTapBuilder!.onPreviewTap.onTapPainter!(_tapPosition!),
        ]),
      ),
    );
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
