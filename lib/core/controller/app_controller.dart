import 'dart:async';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:vibration/vibration.dart';

import 'package:watermark_camera/utils/library.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppController extends GetxController {
  final cameras = <CameraDescription>[];
  late WebViewController webViewController;

  final clientIP = ''.obs;

  String? get _cameraResolutionPreset => DataSp.cameraResolutionPreset;
  bool get _openRightBottomWatermark =>
      DataSp.openRightBottomWatermark ?? false;
  bool get _openSaveNoWatermarkImage =>
      DataSp.openSaveNoWatermarkImage ?? false;
  bool get _openCameraShutterSound => DataSp.openCameraShutterSound ?? false;

  final cameraResolutionPreset = ResolutionPreset.max.name.obs;
  final openRightBottomWatermark = true.obs;
  final openSaveNoWatermarkImage = false.obs;
  // final openCameraShutterSound = false.obs;

  final _cameraShutter = "assets/media/camera_shutter.mp3";

  final _audioPlayer = AudioPlayer();

  void _initCameraShutterPlayer() {
    _audioPlayer.setAsset(_cameraShutter);

    _audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          _stopCameraShutterSound();

          break;
      }
    });
  }

  void playCameraShutterSound() async {
    RingerModeStatus ringerStatus = await SoundMode.ringerModeStatus;
    if (!_audioPlayer.playerState.playing &&
        (ringerStatus == RingerModeStatus.normal ||
            ringerStatus == RingerModeStatus.unknown)) {
      _audioPlayer.setAsset(_cameraShutter);
      _audioPlayer.setLoopMode(LoopMode.off);
      _audioPlayer.setVolume(1.0);
      _audioPlayer.play();
    }

    if ((ringerStatus == RingerModeStatus.normal ||
        ringerStatus == RingerModeStatus.vibrate ||
        ringerStatus == RingerModeStatus.unknown)) {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate();
      }
    }
  }

  void _stopCameraShutterSound() async {
    if (_audioPlayer.playerState.playing) {
      _audioPlayer.stop();
    }
  }

  void setCameraResolutionPreset(String value) {
    cameraResolutionPreset.value = value;
    DataSp.putCameraResolutionPreset(value);
  }

  void setOpenRightBottomWatermark(bool value) {
    openRightBottomWatermark.value = value;
    DataSp.putOpenRightBottomWatermark(value);
  }

  void setOpenSaveNoWatermarkImage(bool value) {
    openSaveNoWatermarkImage.value = value;
    DataSp.putOpenSaveNoWatermarkImage(value);
  }

  // void setOpenCameraShutterSound(bool value) {
  //   openCameraShutterSound.value = value;
  //   DataSp.putOpenCameraShutterSound(value);
  // }

  void loadAppFonts() async {
    await Utils.readFont(fontNames[0]);
    unawaited(Future.wait(
        [for (var resource in fontNames.skip(1)) Utils.readFont(resource)]));
  }

  @override
  void onInit() async {
    loadAppFonts();
    webViewController = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          // Logger.print("onPageStarted: $url");
        },
        onPageFinished: (url) {
          // Logger.print("onPageFinished: $url");
        },
      ));

    cameraResolutionPreset.value =
        _cameraResolutionPreset ?? ResolutionPreset.max.name;
    openRightBottomWatermark.value = _openRightBottomWatermark;
    openSaveNoWatermarkImage.value = _openSaveNoWatermarkImage;
    // openCameraShutterSound.value = _openCameraShutterSound;

    _initCameraShutterPlayer();
    cameras.addAll(await availableCameras());
    super.onInit();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
