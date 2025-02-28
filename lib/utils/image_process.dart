import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcess {
  static Future<Uint8List> cropImage(
    Uint8List bytes, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    // 解码图片
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Failed to decode image');

    // 裁剪
    final cropped = img.copyCrop(
      image,
      x: x,
      y: y,
      width: width,
      height: height,
    );

    // 编码为 JPEG
    return Uint8List.fromList(img.encodeJpg(cropped, quality: 90));
  }
} 