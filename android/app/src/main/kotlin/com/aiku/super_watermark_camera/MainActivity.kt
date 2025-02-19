package com.aiku.super_watermark_camera

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.AmapFlutterSearchPlugin
import io.flutter.plugins.ImageMetadataHandler

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    flutterEngine.plugins.add(AmapFlutterSearchPlugin())
    flutterEngine.plugins.add(ImageMetadataHandler())
  }
}
