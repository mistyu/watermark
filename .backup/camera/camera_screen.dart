import 'dart:async';
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'buttons/exposure_slider.dart';
import 'buttons/focus_indicator.dart';
import 'views/photo_view.dart';
import 'views/video_view.dart';

import 'camera_subscription.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraSubscription cameraSubscription;

  @override
  void initState() {
    super.initState();

    cameraSubscription = CameraSubscription(currentBrightness: 0.5);
  }

  @override
  void dispose() {
    super.dispose();
    cameraSubscription.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.custom(
        theme: AwesomeTheme().copyWith(
            bottomActionsBackgroundColor: Colors.white,
            buttonTheme: AwesomeButtonTheme(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue)),
        filters: awesomePresetFiltersList,
        saveConfig: SaveConfig.photoAndVideo(
          photoPathBuilder: (sensors) async {
            final Directory extDir = await getTemporaryDirectory();
            final testDir = await Directory(
              '${extDir.path}/camerawesome',
            ).create(recursive: true);
            if (sensors.length == 1) {
              final String filePath =
                  '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
              return SingleCaptureRequest(filePath, sensors.first);
            }
            // Separate pictures taken with front and back camera
            return MultipleCaptureRequest(
              {
                for (final sensor in sensors)
                  sensor:
                      '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
              },
            );
          },
        ),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          flashMode: FlashMode.auto,
          aspectRatio: CameraAspectRatios.ratio_4_3,
          zoom: 0.0,
        ),
        enablePhysicalButton: true,
        previewFit: CameraPreviewFit.cover,
        // previewAlignment: Alignment.center,
        onPreviewTapBuilder: (state) => OnPreviewTap(
            onTap: (
              position,
              flutterPreviewSize,
              pixelPreviewSize,
            ) {
              state.when(
                onPhotoMode: (photoState) => photoState.focusOnPoint(
                  flutterPosition: position,
                  pixelPreviewSize: pixelPreviewSize,
                  flutterPreviewSize: flutterPreviewSize,
                ),
                onVideoMode: (videoState) => videoState.focusOnPoint(
                  flutterPosition: position,
                  pixelPreviewSize: pixelPreviewSize,
                  flutterPreviewSize: flutterPreviewSize,
                ),
                onVideoRecordingMode: (videoRecState) =>
                    videoRecState.focusOnPoint(
                  flutterPosition: position,
                  pixelPreviewSize: pixelPreviewSize,
                  flutterPreviewSize: flutterPreviewSize,
                ),
                onPreviewMode: (previewState) => previewState.focusOnPoint(
                  flutterPosition: position,
                  pixelPreviewSize: pixelPreviewSize,
                  flutterPreviewSize: flutterPreviewSize,
                ),
              );
            },
            onTapPainter: (position) {
              return Positioned.fill(
                child: Stack(
                  children: [
                    Positioned.fill(child: FocusIndicator(position: position)),
                    Positioned.fill(
                        child: ExposureSlider(
                            position: position,
                            cameraSubscription: cameraSubscription))
                  ],
                ),
              );
            },
            tapPainterDuration: const Duration(seconds: 3)),

        builder: (cameraState, preview) {
          return cameraState.when(
            onPreparingCamera: (state) =>
                const Center(child: CircularProgressIndicator()),
            onPhotoMode: (state) => PhotoView(state),
            onVideoMode: (state) => VideoView(state, recording: false),
            onVideoRecordingMode: (state) => VideoView(state, recording: true),
          );
        },
      ),
    );
  }
}
