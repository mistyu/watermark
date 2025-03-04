import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermark_camera/core/service/media_service.dart';
import 'package:watermark_camera/pages/camera/view/signature/signature_pad.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:image/image.dart' as img;

class SignatureLogic extends GetxController {
  final signatureKey = GlobalKey();

  final List<List<Offset>> strokes = [];
  List<Offset>? currentStroke;

  final signaturePadid = "signaturePadid";

  // 清空签名
  void clearSignature() {
    try {
      strokes.clear();
      currentStroke = null;
      update([signaturePadid]);
    } catch (e) {
      Logger.print('清空签名失败: $e');
    }
  }

  void onPanStart(details) {
    currentStroke = [details.localPosition];
    strokes.add(currentStroke!);
    update([signaturePadid]);
  }

  void onPanUpdate(details) {
    if (currentStroke != null) {
      currentStroke!.add(details.localPosition);
    }
    update([signaturePadid]);
  }

  void onEnd() {
    currentStroke = null;
    update([signaturePadid]);
  }

  // 保存签名为图片
  Future<String?> saveSignature() async {
    try {
      Utils.showLoading("保存签名中...");
      // 获取 RenderRepaintBoundary
      final boundary = signatureKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        Logger.print('获取签名边界失败');
        return null;
      }

      // 捕获签名为图片
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        Logger.print('转换签名图片数据失败');
        return null;
      }

      // 将图片数据转换为image库的Image对象
      final bytes = byteData.buffer.asUint8List();
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        Logger.print('解码签名图片失败');
        return null;
      }

      // 旋转图片-90度，使其恢复正向
      // final rotatedImage = img.copyRotate(originalImage, angle: -90);

      // 获取临时目录
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';

      // 保存旋转后的图片
      final file = File(imagePath);
      await file.writeAsBytes(img.encodePng(originalImage));

      await MediaService.savePhoto(bytes);
      Logger.print('签名保存成功: $imagePath');
      Utils.dismissLoading();
      return imagePath;
    } catch (e) {
      Logger.print('保存签名失败: $e');
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Logger.print('SignatureLogic onInit');
  }

  @override
  void onReady() {
    super.onReady();
    Logger.print('SignatureLogic onReady');
  }

  @override
  void onClose() {
    Logger.print('SignatureLogic onClose');
    super.onClose();
  }
}
