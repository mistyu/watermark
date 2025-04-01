import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/core/service/media_service.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_sheet.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';

class PhotoEditLogic extends GetxController {
  final watermarkLogic = Get.find<WaterMarkController>();
  late ScrollController bottomBarScrollCtrl;
  late ScrollController paintingBottomBarScrollCtrl;
  late ScrollController cropBottomBarScrollCtrl;

  late AssetEntity asset;
  late PhotoEditOpType opType;

  final editorKey = GlobalKey<ProImageEditorState>();

  /// Holds the edited image bytes after the editing is complete.
  final editedBytes = Rxn<Uint8List>();

  /// The time it took to generate the edited image in milliseconds.
  final _generationTime = Rxn<double>();

  final startEditingTime = Rxn<DateTime>();

  final currentWatermarkResource = Rxn<WatermarkResource>();
  final currentWatermarkView = Rxn<WatermarkView>();
  double assetAspectRatio = 1.0;
  bool isFirst = true;

  void initWatermark() {
    currentWatermarkResource.value = watermarkLogic.firstResource.value;
    setWatermarkViewByResource(currentWatermarkResource.value);
  }

  Future<void> onSelectWatermark(
      WatermarkResource? resource, Function(Widget) setLayer) async {
    if (resource != null) {
      currentWatermarkResource.value = resource;
      final view = await setWatermarkViewByResource(resource);
      if (view != null) {
        setLayer(WatermarkPreview(resource: resource, watermarkView: view));
      }
    }
  }

  void setWatermarkResourceById(int id) {
    currentWatermarkResource.value = watermarkLogic.watermarkResourceList
        .firstWhere((element) => element.id == id);
    setWatermarkViewByResource(currentWatermarkResource.value);
  }

  Future<WatermarkView?> setWatermarkViewByResource(
      WatermarkResource? resource) async {
    if (resource != null) {
      final result = await WatermarkView.fromResource(resource);
      currentWatermarkView.value = result;
      return result;
    }
    return null;
  }

  Future<void> onImageEditingStarted() async {
    startEditingTime.value = DateTime.now();
  }

  Future<void> onImageEditingComplete(Uint8List bytes) async {
    editedBytes.value = bytes;
    setGenerationTime();
  }

  void onStartCloseSubEditor() {
    editorKey.currentState?.setState(() {});
  }

  void setGenerationTime() {
    if (startEditingTime.value != null) {
      _generationTime.value = DateTime.now()
          .difference(startEditingTime.value!)
          .inMilliseconds
          .toDouble();
    }
  }

  void onCloseEditor({
    bool showThumbnail = false,
    ui.Image? rawOriginalImage,
    final ImageGenerationConfigs? generationConfigs,
  }) async {
    if (editedBytes.value != null) {
      // Pre-cache the edited image to improve display performance.
      await precacheImage(MemoryImage(editedBytes.value!), Get.context!);

      // Navigate to the preview page to display the edited image.
      editorKey.currentState?.disablePopScope = true;
      final asset = await MediaService.savePhoto(editedBytes.value!);
      editedBytes.value = null;
      _generationTime.value = null;
      startEditingTime.value = null;
      Get.back();
    }

    // Close the editor if no image editing is done.
    Get.back();
  }

  void openStickerEditor() async {
    final result = await WatermarkSheet.showWatermarkGridSheet(
        resource: currentWatermarkResource.value);
    if (result != null) {
      setWatermarkResourceById(result.selectedWatermarkId!);
      if (result.showEdit == true) {
        // onEditTap(); // 直接进入编辑页面
      }
    }
  }

  void onHandleOpType() {
    if (isFirst) {
      final type = opType;
      switch (type) {
        case PhotoEditOpType.edit:
          break;
        case PhotoEditOpType.text:
          editorKey.currentState?.openTextEditor();
          break;
        case PhotoEditOpType.crop:
          editorKey.currentState?.openCropRotateEditor();
          break;
        case PhotoEditOpType.sticker:
          initWatermark();
          break;
      }
    }
    isFirst = false;
  }

  void onMainEditorAfterInit() {
    onHandleOpType();
  }

  void updateEditorState() {
    editorKey.currentState?.setState(() {});
  }

  @override
  void onInit() {
    bottomBarScrollCtrl = ScrollController();
    paintingBottomBarScrollCtrl = ScrollController();
    cropBottomBarScrollCtrl = ScrollController();
    asset = Get.arguments['asset'];
    opType = Get.arguments['opType'] ?? PhotoEditOpType.edit;
    assetAspectRatio = asset.width / asset.height;
    super.onInit();
  }

  @override
  void onClose() {
    bottomBarScrollCtrl.dispose();
    paintingBottomBarScrollCtrl.dispose();
    cropBottomBarScrollCtrl.dispose();
    editorKey.currentState?.dispose();
    super.onClose();
  }
}
