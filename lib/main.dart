import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watermark_camera/app.dart';

import 'config.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Config.init(() {
    runApp(const WaterMarkCameraApp());
  });
}

