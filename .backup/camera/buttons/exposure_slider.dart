import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/camera/SunThumb.dart';
import '../../widgets/camera/SunTrack.dart';

import '../camera_subscription.dart';

class ExposureSlider extends StatefulWidget {
  final Offset position;
  final CameraSubscription cameraSubscription;
  const ExposureSlider(
      {super.key, required this.position, required this.cameraSubscription});

  @override
  State<ExposureSlider> createState() => _ExposureSliderState();
}

class _ExposureSliderState extends State<ExposureSlider> {
  final GlobalKey _sliderKey = GlobalKey(debugLabel: "slider");

  void _updateSliderValue(
      DragUpdateDetails details, CameraSubscription sub, double progress) {
    double sliderValue = progress;
    sliderValue += details.delta.dy / 20;

    if (sliderValue < 0) {
      sliderValue = 0;
    } else if (sliderValue > 100) {
      sliderValue = 100;
    }

    setState(() {
      sub.setBrightness(sliderValue / 100);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.cameraSubscription.brightness * 100;
    final position = widget.position;
    RenderBox? renderBox =
        _sliderKey.currentContext?.findRenderObject() as RenderBox?;
    final sliderSize = renderBox != null ? renderBox.size : const Size(192, 48);
    final sliderPosition =
        Offset(position.dx + 20.w, position.dy - sliderSize.width / 2);
    return GestureDetector(
        onVerticalDragUpdate: (detail) =>
            _updateSliderValue(detail, widget.cameraSubscription, progress),
        child: Container(
          color: Colors.transparent, // 确保有一个背景色，可以是透明的
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: sliderPosition.dx,
                top: sliderPosition.dy,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: IgnorePointer(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          thumbShape: SunSliderThumbShape(thumbRadius: 6.0),
                          thumbColor: Colors.amberAccent,
                          activeTrackColor: Colors.amberAccent,
                          inactiveTrackColor: Colors.amberAccent,
                          trackHeight: 1, //
                          trackShape: SunTrackShape()),
                      child: Slider(
                        key: _sliderKey,
                        min: 0,
                        max: 100,
                        value: progress,
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));

    // return StreamBuilder<double>(
    //     stream: widget.cameraSubscription.brightness$,
    //     builder: (context, snapshot) {
    //       debugPrint("exposure_slider  stream: ${snapshot.requireData}");
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator();
    //       } else if (snapshot.hasError) {
    //         return Text('Error: ${snapshot.error}');
    //       }
    //       if (!snapshot.hasData) {
    //         return const SizedBox.shrink();
    //       }
    //       return GestureDetector(
    //           onVerticalDragUpdate: (detail) =>  _updateSliderValue(detail,widget.cameraSubscription, snapshot.requireData),
    //           child: Container(
    //             color: Colors.transparent,  // 确保有一个背景色，可以是透明的
    //             width: double.infinity,
    //             height: double.infinity,
    //             child: Stack(
    //               children: [
    //                 Positioned(
    //                   left: _sliderPosition.dx,
    //                   top: _sliderPosition.dy,
    //                   child: RotatedBox(
    //                     quarterTurns: 1,
    //                     child: IgnorePointer(
    //                       child: SliderTheme(
    //                         data: SliderTheme.of(context).copyWith(
    //                             thumbShape: SunSliderThumbShape(thumbRadius: 6.0),
    //                             overlayColor: Colors.greenAccent,
    //                             overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
    //                             thumbColor: Colors.amberAccent,
    //                             activeTrackColor: Colors.amberAccent,
    //                             inactiveTrackColor: Colors.amberAccent,
    //                             trackHeight: 1, //
    //                             trackShape: SunTrackShape()
    //                         ),
    //                         child: Slider(key: _sliderKey,min: 0,max: 100, value: snapshot.requireData,onChanged: (_){},),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )
    //       );
    //     }
    // );
  }
}
