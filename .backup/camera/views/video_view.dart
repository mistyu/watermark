import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import '../../watermark.dart';
import '../../widgets/camera/custom_media_preview.dart';
import '../../widgets/camera/photo_bottom_actions.dart';
import '../../widgets/camera/photo_top_actions.dart';
import '../../widgets/camera/video_bottom_actions.dart';
import '../../widgets/camera/video_top_actions.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class VideoView extends StatefulWidget {
  final CameraState state;
  final bool recording;

  const VideoView(this.state, {super.key, required this.recording});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  final WidgetsToImageController _controller = WidgetsToImageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VideoTopActions(state: widget.state),
        Expanded(child: Watermark(watermarkController: _controller)),
        VideoBottomActions(
          state: widget.state,
          watermarkController: _controller,
        )
        // const Spacer(),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        //   child: Row(
        //     children: [
        //       AwesomeCaptureButton(state: widget.state),
        //       const Spacer(),
        //       StreamBuilder(
        //         stream: widget.state.captureState$,
        //         builder: (_, snapshot) {
        //           return SizedBox(
        //             width: 100,
        //             height: 100,
        //             child: CustomMediaPreview(
        //               mediaCapture: snapshot.data,
        //               onMediaTap: (mediaCapture) {
        //                 mediaCapture.captureRequest
        //                     .when(single: (single) => single.file?.openRead());
        //               },
        //             ),
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
