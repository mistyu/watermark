import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/small_watermark/small_watermark_logic.dart';

import '../../../core/service/watermark_service.dart';
import '../../../models/watermark/watermark.dart';

class RightBottomDialogLogic extends GetxController {
  final rightBottomLogic = Get.find<SmallWatermarkLogic>();
  final dialogController = TextEditingController(text: '');
  Rxn<String> name = Rxn<String>();
  Rxn<String> camera = Rxn<String>();

  Rxn<String> name1 = Rxn<String>();
  Rxn<String> camera1 = Rxn<String>();

  Rxn<RightBottomView> rightBottomView = Rxn();
  Rxn<RightBottomView> rightBottomCopy = Rxn();

  Future<void> initRightBottom() async {
    // 将外面的右下角水印传过来
    if (rightBottomLogic.rightBottomView.value != null) {
      rightBottomCopy.value = rightBottomLogic.rightBottomView.value;
    }
    print('xiaojianjian 右下角水印编号：${rightBottomCopy.value?.id}');
    print("xiaojianjian 右下角水印内容：${rightBottomCopy.value?.content}");
    // dialogController.text = '';
    dialogController.text = rightBottomCopy.value?.content ?? '';
    setContent(rightBottomCopy.value);
    // 左边原始数据
    WatermarkService.getWatermarkViewByResource<RightBottomView>(
            rightBottomLogic.currentRightBottomResource.value ??
                Get.arguments["rightBottom"])
        .then((rightBottom) {
      rightBottomView.value = rightBottom;

      setContent1(rightBottomView.value);
    });
  }

  void dialogPreviewRightBottomView() {
    rightBottomCopy.update((view) {
      view?.content = dialogController.text;
    });
    setContent(rightBottomCopy.value);
    update();
  }

  void setContent(RightBottomView? view) {
    final content = view?.content;

    if (view?.type == 0 || view?.type == null) {
      name.value = content?.substring(0, content.length - 2);
      camera.value = content?.substring(content.length - 2, content.length);
    } else if (view?.type == 4 || view?.type == 1) {
      name.value = content;
      camera.value = '';
    } else if (view?.type == 3) {
      name.value = content?.substring(0, content.length - 4);
      camera.value = content?.substring(content.length - 4, content.length);
    }
  }

  void setContent1(RightBottomView? view) {
    final content = view?.content;

    if (view?.type == 0 || view?.type == null) {
      name1.value = content?.substring(0, content.length - 2);
      camera1.value = content?.substring(content.length - 2, content.length);
    } else if (view?.type == 4 || view?.type == 1) {
      name1.value = content;
      camera1.value = '';
    } else if (view?.type == 3) {
      name1.value = content?.substring(0, content.length - 4);
      camera1.value = content?.substring(content.length - 4, content.length);
    }
  }

  void saveEditRightBottom() {
    //关闭对话框并返回值
    rightBottomLogic.rightBottomView.update((view) {
      view?.content = dialogController.text;
    });
    rightBottomLogic.setContent(rightBottomLogic.rightBottomView.value);

    Get.back();
  }

  @override
  void onInit() {
    // rightBottomLogic.originWatermarkSize.value = null;
    // WidgetsBinding.instance.addPersistentFrameCallback((_) async {
    //   Future.delayed(const Duration(milliseconds: 250), () {
    //     final renderBox = rightBottomLogic.rightBottomKey.currentContext
    //         ?.findRenderObject() as RenderBox?;
    //     if (renderBox != null) {
    //       Size? renderSize = rightBottomLogic.originWatermarkSize.value;
    //       renderSize ??= renderBox.size;
    //       rightBottomLogic.RightBottomSize.value = Size(
    //           renderSize.width *
    //                       (max(rightBottomLogic.mainScale.value,
    //                           rightBottomLogic.antifakeScale.value)) <
    //                   1
    //               ? 1
    //               : max(rightBottomLogic.mainScale.value,
    //                   rightBottomLogic.antifakeScale.value),
    //           renderSize.height *
    //               max(rightBottomLogic.mainScale.value,
    //                   rightBottomLogic.antifakeScale.value));
    //       rightBottomLogic.originWatermarkSize.value ??= renderSize;
    //     }
    //   });
    // });
    initRightBottom();
    super.onInit();
  }

  @override
  void onClose() {
    dialogController.text = '';
    dialogController.dispose();
    super.onClose();
  }
}
