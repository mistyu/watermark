import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watermark_camera/app.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';

import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FFmpegKitConfig.init();

  await dotenv.load(fileName: ".env");

  Config.init(() {
    runApp(const WaterMarkCameraApp());
  });
}
