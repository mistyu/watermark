import 'dart:io';
import 'package:flutter/material.dart' show ValueSetter;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:watermark_camera/utils/library.dart';
import 'output_format.dart';
import 'trim_video.dart';
import 'watermark.dart';

class VideoWatermark {
  /// Source video to be added with watermark or trimmed.
  final String sourceVideoPath;

  ///Name of the ouput video file without video format.
  ///
  ///Default filename: `videowatermark_(current time in millisecond)`
  final String? videoFileName;

  /// [Watermark] characteristics of watermark image to be added in video.
  final Watermark? watermark;

  /// [OutputFormat] Video format for the output (converted) video
  ///
  /// Available formats
  /// .mp4,
  /// .mkv,
  /// .mov,
  /// .flv,
  /// .avi,
  /// .wmv,
  /// Deafult format: `.mp4`
  final OutputFormat? outputFormat;

  /// Path where the output video to be saved.
  ///
  /// The default path will be Application Documents Directory
  final String? savePath;

  /// [VideoTrim] For specifying the start and end time of the video to be trimmed.
  final VideoTrim? videoTrim;

  /// Callback triggered when the video convertion completed.
  ///
  /// Return value on successful conversion will be `path of converted video` else will be `null`.
  final ValueSetter<String?>? onSave;

  /// Callback with video conversion completion percentage.
  ///
  /// Value from `0 - 1.0`
  final ValueSetter<double>? progress;

  /// Creates Watermark in video with the image in local storage
  ///
  /// [watermark] defines the characteristics of watermark.
  ///
  /// Required paramater [sourceVideoPath] path of the video to be added watermark.
  const VideoWatermark({
    required this.sourceVideoPath,
    this.videoFileName,
    this.watermark,
    this.outputFormat = OutputFormat.mp4,
    this.savePath,
    this.videoTrim,
    this.onSave,
    this.progress,
  });

  /// Genrates video in the output path.
  Future<void> generateVideo() async {
    String? outputPath = savePath ??
        await getApplicationDocumentsDirectory()
            .then((value) => '${value.path}/');

    int time = DateTime.now().millisecond;

    String trimmedVideo =
        '$outputPath${'trimmed_$time'}.${outputFormat.toString().split(".").last}';

    String? outputVideo =
        '$outputPath/${videoFileName ?? 'videowatermark_$time'}.${outputFormat.toString().split(".").last}';

    if (videoTrim != null) {
      double progress = 0;
      await _trimVideo(
        trimmedVideo,
        (tempVideoSave) {
          if (tempVideoSave) {
            if (watermark != null) {
              _addWatermark(
                trimmedVideo,
                outputVideo,
                (outputVideoSave) {
                  if (outputVideoSave) {
                    File(trimmedVideo).delete();
                    onSave?.call(outputVideo);
                  }
                },
                (p) {
                  this.progress?.call(progress + p / 2);
                },
              );
            } else {
              onSave?.call(trimmedVideo);
            }
          }
        },
        (p) {
          if (watermark != null) {
            progress = p / 2;
          } else {
            progress = p;
          }
          this.progress?.call(progress);
        },
      );
    } else {
      _addWatermark(
        sourceVideoPath,
        outputVideo,
        (outputVideoSave) {
          if (outputVideoSave) {
            onSave?.call(outputVideo);
          }
        },
        progress,
      );
    }
  }

  Future<void> _addWatermark(
    String sourceVideo,
    String outputVideo,
    ValueSetter<bool> onDone,
    ValueSetter<double>? progress,
  ) async {
    // Get input video duration
    // final info = await FFprobeKit.getMediaInformation(sourceVideoPath);
    // final duration = info.getMediaInformation()?.getDuration() ?? '';
    // final videoDuration = Duration(seconds: double.tryParse(duration)?.toInt() ?? 0);
    String watermarkCommand = await watermark!.toCommand();
    String command =
        '-i $sourceVideo $watermarkCommand -c:a aac -b:a 128k -af aresample=async=1 $outputVideo';
    await _runFFmpegCommand(command, onDone, progress);
  }

  Future<void> _trimVideo(
    String outputVideo,
    ValueSetter<bool> onDone,
    ValueSetter<double>? progress,
  ) async {
    String command =
        ' -ss ${videoTrim!.start} -i $sourceVideoPath -t ${videoTrim!.duration} -avoid_negative_ts make_zero $outputVideo';

    await _runFFmpegCommand(command, onDone, progress);
  }

  Future<void> _runFFmpegCommand(
    String command,
    ValueSetter<bool> onDone,
    ValueSetter<double>? progress,
  ) async {
    Duration? videoDuration;

    bool getDuration = false;

    double progress0 = 0;

    await FFmpegKit.executeAsync(
      command,
      (session) async {
        ReturnCode? returnCode = await session.getReturnCode();
        SessionState sessionState = await session.getState();

        Logger.print("Video conversion ${sessionState.name}");
        Logger.print("FFmpeg command: $command");

        if (ReturnCode.isSuccess(returnCode)) {
          onDone.call(true);
        } else {
          String? failureStackTrace = await session.getFailStackTrace();
          Logger.print(
              "Video save failed with return code: ${returnCode?.getValue()}");
          Logger.print("Failure stack trace: $failureStackTrace");
          onSave?.call(null);
          onDone.call(false);
        }
      },
      (log) {
        String out = log.getMessage();
        Logger.print("FFmpeg log: $out");

        if (videoTrim == null) {
          if (videoDuration == null && getDuration) {
            List<String> duration = out.split(':');
            videoDuration = Duration(
              hours: int.parse(duration[0]),
              minutes: int.parse(duration[1]),
              seconds: int.parse(duration[2].split('.').first),
              milliseconds: int.parse(duration[2].split('.').last),
            );
            getDuration = false;
          }
          if (videoDuration == null && out.contains("Duration:")) {
            getDuration = true;
          }
        } else {
          videoDuration = videoTrim?.duration;
        }
      },
      (statistics) {
        progress0 = (statistics.getTime() / videoDuration!.inMilliseconds);
        if (progress0 > 1) {
          progress0 = 1;
        }
        progress?.call(progress0);
      },
    );
  }
}
