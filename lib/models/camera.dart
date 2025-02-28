import 'package:camera/camera.dart';

enum CameraMode {
  photo,
  video,
  videoRecording,
}

extension CameraModeExtension on CameraMode {
  String get name {
    if (this == CameraMode.photo) {
      return '拍照';
    } else if (this == CameraMode.video) {
      return '视频';
    } else if (this == CameraMode.videoRecording) {
      return '录像中';
    }
    return '';
  }
}

enum CameraType {
  front,
  back,
}

enum CameraPreviewAspectRatio {
  ratio_9_16,
  ratio_3_4,
  ratio_1_1,
}

extension CameraPreviewAspectRatioExtension on CameraPreviewAspectRatio {
  double get ratio {
    if (this == CameraPreviewAspectRatio.ratio_9_16) {
      return 9 / 16;
    } else if (this == CameraPreviewAspectRatio.ratio_3_4) {
      return 3 / 4;
    } else if (this == CameraPreviewAspectRatio.ratio_1_1) {
      return 1 / 1;
    }
    return 0;
  }
}

extension ResolutionPresetExt on ResolutionPreset {
  String get text {
    switch (this) {
      case ResolutionPreset.low:
        return '低清';
      case ResolutionPreset.medium:
        return '普清';
      case ResolutionPreset.high:
        return '标清';
      case ResolutionPreset.veryHigh:
        return '高清';
      case ResolutionPreset.ultraHigh:
        return '超高清';
      case ResolutionPreset.max:
        return '推荐';
      default:
        return '未知';
    }
  }

  static ResolutionPreset fromString(String name) {
    return ResolutionPreset.values.firstWhere(
      (preset) => preset.name.toLowerCase() == name.toLowerCase(),
      orElse: () => ResolutionPreset.ultraHigh, // 默认返回推荐分辨率
    );
  }
}

enum CameraDelay {
  off,
  three,
  five,
  ten,
}

extension CameraDelayExtension on CameraDelay {
  int get value {
    switch (this) {
      case CameraDelay.off:
        return 0;
      case CameraDelay.three:
        return 3;
      case CameraDelay.five:
        return 5;
      case CameraDelay.ten:
        return 10;
    }
  }

  String get text {
    switch (this) {
      case CameraDelay.off:
        return '无延迟';
      case CameraDelay.three:
        return '3秒延迟';
      case CameraDelay.five:
        return '5秒延迟';
      case CameraDelay.ten:
        return '10秒延迟';
    }
  }

  static CameraDelay fromString(String name) {
    return CameraDelay.values.firstWhere(
      (delay) => delay.name.toLowerCase() == name.toLowerCase(),
    );
  }
}

extension FlashModeExtension on FlashMode {
  String get text {
    switch (this) {
      case FlashMode.off:
        return '无闪光';
      case FlashMode.torch:
        return '开启闪光';
      case FlashMode.auto:
        return '自动闪光';
      case FlashMode.always:
        return '常亮闪光';
    }
  }
}
