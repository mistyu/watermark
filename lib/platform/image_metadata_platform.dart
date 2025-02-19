import 'dart:async';
import 'package:flutter/services.dart';

class ImageMetadataPlatform {
  static const MethodChannel _channel = MethodChannel('image_metadata_channel');

  /// 添加图片元数据
  static Future<Uint8List?> addMetadata({
    required Uint8List imageBytes,
    String? author,
    String? copyright,
    Map<String, String>? customMetadata,
    int? width,
    int? height,
  }) async {
    try {
      final Map<String, dynamic> metadata = {
        if (author != null) 'artist': author,
        if (copyright != null) 'copyright': copyright,
        'software': 'XGN Watermark Camera App',
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        'datetime': DateTime.now().toIso8601String(),
        if (customMetadata != null) ...customMetadata,
      };

      final result = await _channel.invokeMethod<Uint8List>(
        'addImageMetadata',
        {
          'imageBytes': imageBytes,
          'metadata': metadata,
        },
      );

      return result;
    } catch (e) {
      print('Error adding metadata: $e');
      return null;
    }
  }
}
