import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart' show md5;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ImageUtil {
  ImageUtil._();

  // 缓存目录名
  static const String _cacheDir = 'network_images';

  // 获取缓存的网络图片
  static Future<File?> getCachedNetworkImage(String url) async {
    try {
      final fileName = _generateFileName(url);
      final dir = await _getCacheDirectory();
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      print('Get cached network image failed: $e');
      return null;
    }
  }

  // 下载并缓存网络图片
  static Future<File> downloadAndCacheNetworkImage(String url) async {
    final fileName = _generateFileName(url);
    final dir = await _getCacheDirectory();
    final file = File('${dir.path}/$fileName');

    // 下载图片
    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    // 保存到缓存
    await file.writeAsBytes(response.data);
    return file;
  }

  // 生成缓存文件名
  static String _generateFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  // 获取缓存目录
  static Future<Directory> _getCacheDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${dir.path}/$_cacheDir');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  // 清理缓存 --- 手动调用这里是图片的缓存
  static Future<void> clearNetworkImageCache() async {
    try {
      final dir = await _getCacheDirectory();
      await dir.delete(recursive: true);
    } catch (e) {
      print('Clear network image cache failed: $e');
    }
  }

  static Widget assetImage(
    String res, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) =>
      Image.asset(
        res,
        width: width,
        height: height,
        fit: fit,
        color: color,
      );

  static Widget networkImage({
    required String url,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = false,
    bool lowMemory = false,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    Border? border,
  }) =>
      ExtendedImage.network(
        url,
        width: width,
        height: height,
        shape: BoxShape.rectangle,
        fit: fit,
        borderRadius: borderRadius,
        border: border,
        cacheWidth: _calculateCacheWidth(width, cacheWidth, lowMemory),
        cacheHeight: _calculateCacheHeight(height, cacheHeight, lowMemory),
        cache: true,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        handleLoadingProgress: true,
        clearMemoryCacheIfFailed: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress =
                    loadingProgress?.expectedTotalBytes != null
                        ? loadingProgress!.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null;

                return SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: loadProgress
                      ? Center(
                          child: SizedBox(
                            width: 15.0,
                            height: 15.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              value: progress,
                            ),
                          ),
                        )
                      : null,
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              state.imageProvider.evict();
              return errorWidget ??
                  ("ic_picture_error".webp.toImage
                    ..width = width
                    ..height = height);
          }
        },
      );

  static Widget fileImage({
    required File file,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = false,
    bool lowMemory = false,
    bool enableSlideOutPage = true,
    Widget Function(Widget child)? heroBuilderForSlidingPage,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    double? loadingSize,
  }) =>
      ExtendedImage.file(
        file,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
        shape: BoxShape.rectangle,
        cacheWidth: _calculateCacheWidth(width, cacheWidth, lowMemory),
        cacheHeight: _calculateCacheHeight(height, cacheHeight, lowMemory),
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        clearMemoryCacheIfFailed: true,
        enableSlideOutPage: enableSlideOutPage,
        heroBuilderForSlidingPage: heroBuilderForSlidingPage,
        mode: ExtendedImageMode.gesture,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress =
                    loadingProgress?.expectedTotalBytes != null
                        ? loadingProgress!.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null;

                return SizedBox(
                  width: loadingSize ?? 12.0,
                  height: loadingSize ?? 12.0,
                  child: loadProgress
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            value: progress,
                          ),
                        )
                      : null,
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              state.imageProvider.evict();
              return errorWidget ?? "ic_picture_error".webp.toImage;
          }
        },
      );

  // 添加这个辅助方法来处理网络图片加载
  static Future<Widget> loadNetworkImage(String url) async {
    // 先尝试从缓存加载
    final cachedFile = await ImageUtil.getCachedNetworkImage(url);
    if (cachedFile != null) {
      return ImageUtil.fileImage(file: cachedFile, fit: BoxFit.cover);
    }

    // 缓存中没有，下载并缓存
    try {
      final file = await ImageUtil.downloadAndCacheNetworkImage(url);
      return ImageUtil.fileImage(file: file, fit: BoxFit.cover);
    } catch (e) {
      print('Download network image failed: $e');
      throw e; // 让 FutureBuilder 处理错误
    }
  }

  static Widget memoryImage({
    required Uint8List imageBytes,
    double? width,
    double? height,
    BoxFit? fit,
    BorderRadius? borderRadius,
    Border? border,
    bool lowMemory = false,
    int? cacheWidth,
    int? cacheHeight,
    bool clearMemoryCacheWhenDispose = false,
    bool enableSlideOutPage = true,
    Widget Function(Widget child)? heroBuilderForSlidingPage,
    Widget? errorWidget,
    double? loadingSize,
    bool loadProgress = true,
  }) =>
      ExtendedImage.memory(
        imageBytes,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
        border: border,
        shape: BoxShape.rectangle,
        cacheWidth: _calculateCacheWidth(width, cacheWidth, lowMemory),
        cacheHeight: _calculateCacheHeight(height, cacheHeight, lowMemory),
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        enableSlideOutPage: enableSlideOutPage,
        heroBuilderForSlidingPage: heroBuilderForSlidingPage,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress =
                    loadingProgress?.expectedTotalBytes != null
                        ? loadingProgress!.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null;

                return SizedBox(
                  width: loadingSize ?? 12.0,
                  height: loadingSize ?? 12.0,
                  child: loadProgress
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            value: progress,
                          ),
                        )
                      : null,
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              state.imageProvider.evict();
              return errorWidget ?? "ic_picture_error".webp.toImage;
          }
        },
      );

  static int? _calculateCacheWidth(
    double? width,
    int? cacheWidth,
    bool lowMemory,
  ) {
    if (!lowMemory) return null;
    if (null != cacheWidth) return cacheWidth;
    final maxW = .6.sw;
    return (width == null ? maxW : (width < maxW ? width : maxW)).toInt();
  }

  static int? _calculateCacheHeight(
    double? height,
    int? cacheHeight,
    bool lowMemory,
  ) {
    if (!lowMemory) return null;
    if (null != cacheHeight) return cacheHeight;
    final maxH = .6.sh;
    return (height == null ? maxH : (height < maxH ? height : maxH)).toInt();
  }

  static Future<void> preloadAssetImage(
      BuildContext context, List<String> images) async {
    await Future.wait(
        images.map((img) => precacheImage(AssetImage(img.png), context)));
  }

  static Future<ui.Image> decodeImageWithNative(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<Uint8List?> cropImage(
      String imagePath, double aspectRatio) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final image = await decodeImageWithNative(bytes);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final imageAspectRatio = image.width / image.height;
      final (cropWidth, cropHeight, startX, startY) = _calculateCropDimensions(
        image.width,
        image.height,
        imageAspectRatio,
        aspectRatio,
      );

      canvas.drawImageRect(
        image,
        Rect.fromLTWH(
            startX, startY, cropWidth.toDouble(), cropHeight.toDouble()),
        Rect.fromLTWH(0, 0, cropWidth.toDouble(), cropHeight.toDouble()),
        Paint(),
      );

      final picture = recorder.endRecording();
      final finalImage = await picture.toImage(cropWidth, cropHeight);
      final byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      Logger.print('Error cropping image: $e');
      return null;
    }
  }

  static (int, int, double, double) _calculateCropDimensions(
    int imageWidth,
    int imageHeight,
    double imageAspectRatio,
    double targetAspectRatio,
  ) {
    late final int cropWidth;
    late final int cropHeight;
    late final double startX;
    late final double startY;

    if (imageAspectRatio > targetAspectRatio) {
      cropHeight = imageHeight;
      cropWidth = (imageHeight * targetAspectRatio).round();
      startX = ((imageWidth - cropWidth) / 2).roundToDouble();
      startY = 0;
    } else {
      cropWidth = imageWidth;
      cropHeight = (imageWidth / targetAspectRatio).round();
      startX = 0;
      startY = ((imageHeight - cropHeight) / 2).roundToDouble();
    }

    return (cropWidth, cropHeight, startX, startY);
  }

  static Future<File?> saveImageBytesToTempFile(Uint8List bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(tempPath);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      Logger.print('Error saving temp file: $e');
      return null;
    }
  }
}
