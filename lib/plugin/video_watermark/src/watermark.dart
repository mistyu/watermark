import 'dart:ui';

import 'watermark_source.dart';
import 'watermark_size.dart';

class Watermark {
  final List<WatermarkConfig> watermarks;

  /// Video bitrate
  String bitrate;

  /// Defines the characteristics of watermark image.
  ///
  /// Required parameter [image].
  Watermark({
    required this.watermarks,
    this.bitrate = "1M",
  });

  Future<String> toCommand() async {
    String command = "";
    String inputsCommand = "";
    String filterCommand = "";

    for (int i = 0; i < watermarks.length; i++) {
      final watermark = watermarks[i];
      final watermarkPath = await watermark.image.toCommand();

      inputsCommand += "-i '$watermarkPath' ";

      String baseInput = i == 0 ? "[0:v]" : "[v$i]";

      filterCommand +=
          "[${i + 1}]scale=${watermark.size.width}:${watermark.size.height}[w$i];";

      filterCommand +=
          "$baseInput[w$i]overlay=${watermark.position.dx}:${watermark.position.dy}";

      if (i < watermarks.length - 1) {
        filterCommand += "[v${i + 1}];";
      }
    }

    command = '$inputsCommand-filter_complex "$filterCommand"';

    return '$command -b:v $bitrate';
  }
}

class WatermarkConfig {
  /// Source of image to be added in the video as watermark.
  final WatermarkSource image;

  /// Size of the watermark image
  final WatermarkSize size;

  /// Position of the watermark.
  final Offset position;

  /// Opacity of the watermark image varies between 0.0 - 1.0.
  final double opacity;

  WatermarkConfig({
    required this.image,
    required this.size,
    required this.position,
    this.opacity = 1.0,
  });
}
