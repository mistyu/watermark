import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watermark_camera/models/camera.dart';
import 'package:watermark_camera/utils/library.dart';

class CaptureButton extends StatefulWidget {
  final bool isRecordingVideo;
  final bool isRecordingPaused;
  final CameraMode cameraMode;
  final VoidCallback? onTakePhoto;
  final VoidCallback? onStartRecording;
  final VoidCallback? onStopRecording;
  final bool? ignorePointer;
  final Duration duration;
  const CaptureButton({
    super.key,
    required this.isRecordingVideo,
    required this.isRecordingPaused,
    required this.cameraMode,
    this.onTakePhoto,
    this.onStartRecording,
    this.onStopRecording,
    this.ignorePointer,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton>
    with SingleTickerProviderStateMixin {
  late AnimationController? _animationController;
  late double _scale;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.stop();
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController!.value;

    return IgnorePointer(
      ignoring: widget.ignorePointer == true,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: SizedBox(
          key: const ValueKey('cameraButton'),
          height: 80,
          width: 80,
          child: Transform.scale(
            scale: _scale,
            child: CustomPaint(
              painter: widget.cameraMode == CameraMode.photo
                  ? CameraButtonPainter()
                  : VideoButtonPainter(isRecording: widget.isRecordingVideo),
            ),
          ),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    HapticFeedback.selectionClick();
    _animationController?.forward.call();
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(widget.duration, () {
      _animationController?.reverse.call();
    });

    onTap.call();
  }

  _onTapCancel() {
    _animationController?.reverse.call();
  }

  get onTap => () {
        if (widget.cameraMode == CameraMode.photo) {
          widget.onTakePhoto?.call();
        } else {
          if (!widget.isRecordingVideo) {
            widget.onStartRecording?.call();
          } else {
            widget.onStopRecording?.call();
          }
        }
      };
}

class CameraButtonPainter extends CustomPainter {
  CameraButtonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    var bgPainter = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    var radius = size.width / 2;
    var center = Offset(size.width / 2, size.height / 2);
    bgPainter.color = Colors.blue;
    canvas.drawCircle(center, radius, bgPainter);

    bgPainter.color = Colors.white;
    canvas.drawCircle(center, radius - 5, bgPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class VideoButtonPainter extends CustomPainter {
  final bool isRecording;

  VideoButtonPainter({
    this.isRecording = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var bgPainter = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    var radius = size.width / 2;
    var center = Offset(size.width / 2, size.height / 2);
    bgPainter.color = Styles.c_F1F1F1;
    canvas.drawCircle(center, radius, bgPainter);

    if (isRecording) {
      bgPainter.color = Colors.red;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                17,
                17,
                size.width - (17 * 2),
                size.height - (17 * 2),
              ),
              const Radius.circular(12.0)),
          bgPainter);
    } else {
      bgPainter.color = Colors.red;
      canvas.drawCircle(center, radius - 5, bgPainter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
