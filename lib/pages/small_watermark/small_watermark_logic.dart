import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../core/controller/watermark_controller.dart';
import '../../core/service/watermark_service.dart';
import '../../models/watermark/watermark.dart';

// import '../../utils/widget_image_util.dart';
import '../camera/camera_logic.dart';

class SmallWatermarkLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<String?> name = ''.obs;
  Rx<String?> camera = ''.obs;
  Rx<Offset> position = const Offset(10, 10).obs;
  Rx<double> mainScale = 1.0.obs;
  Rx<double> antifakeScale = 1.0.obs;
  Rx<double> opacity = Rx<double>(1.0);
  Rxn<RightBottomView> rightBottomView = Rxn<RightBottomView>();
  Rx<String> antifakeText = ''.obs;
  Rx<Offset> antifakePosition = Offset(0.w, 0.h).obs;
  Rx<String> signText = ''.obs;

  final rightBottomKey = GlobalKey();

  final CameraLogic cameraLogic = Get.find<CameraLogic>();

  Rx<BoxConstraints> constraints = const BoxConstraints().obs;
  final watermarkController = Get.find<WaterMarkController>();

  final currentRightBottomResource = Rxn<RightBottomResource>();
  late TabController tabController;
  final tabList = ['水印', '大小', '防伪', '署名', '位置/透明度'];
  final antifakeController = TextEditingController(text: '');
  final signController = TextEditingController(text: '');

  final rightBottomWatermarkController = WidgetsToImageController();

  final originWatermarkSize = Rxn<Size>();
  final RightBottomSize = Rxn<Size>();

  // ScreenshotController();

  List<RightBottomResource> get rightBottomResources =>
      watermarkController.watermarkRightBottomResourceList;

  final activeTab = 0.obs;

//保存右下角水印
  void saveRightBottom() {
    rightBottomWatermarkController.capture().then((rightBottomImageByte) {
      // if (rightBottomImageByte != null) {
      //   cameraLogic.onSavePhoto(rightBottomImageByte);
      // }
      Get.back(result: {
        "rightBottomImageByte": rightBottomImageByte,
        "position": position.value,
        "rightBottomSize": rightBottomKey.currentContext?.size
      });
    });
  }

  void setRightBottomResourceById(int id) {
    currentRightBottomResource.value = watermarkController
        .watermarkRightBottomResourceList
        .firstWhere((element) => element.id == id);
    getRightBottomViewByResource<RightBottomView>(
        currentRightBottomResource.value ?? Get.arguments["rightBottom"]);

    Future.delayed(const Duration(milliseconds: 50), () {
      updateRightBottomSize(isChangeView: true);
    });
  }

  // 通过resource获取RightBottomView
  void getRightBottomViewByResource<T>(Resource resource) {
    WatermarkService.getWatermarkViewByResource<RightBottomView>(resource)
        .then((rightBottom) {
      rightBottomView.value = rightBottom;
      if (rightBottom?.isAntiFack ?? false) {
        antifakeController.text = getRandomString(14);
        antifakeText.value = antifakeController.text;
      }
      setContent(rightBottomView.value);
    });
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

  Future<void> initRightBottom() async {
    final rightBottomResource = Get.arguments["rightBottom"];
    currentRightBottomResource.value = rightBottomResource ??
        watermarkController.firstRightBottomResource.value;
    getRightBottomViewByResource<RightBottomView>(
        currentRightBottomResource.value ?? Get.arguments["rightBottom"]);
  }

//防伪码随机获取
  String getRandomString(int length) {
    final random = Random();
    const availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  void onChangeAntiFack(bool value) {
    rightBottomView.update((val) {
      val?.isAntiFack = value;
    });
  }

  void onChangeSign(bool value) {
    rightBottomView.update((val) {
      val?.isSign = value;
    });
  }

  void onChangeTab(int index) {
    tabController.animateTo(index);
    activeTab.value = index;
  }

  void onChangeAntiFakeScale(double value) {
    antifakeScale.value = value;
    updateRightBottomSize();
  }

  void onChangeMainScale(double value) {
    mainScale.value = value;
    updateRightBottomSize();
  }

  void updateRightBottomSize({bool isChangeView = false}) {
    if (isChangeView) {
      RightBottomSize.value = null;
      originWatermarkSize.value = null;
      return;
    }
    final renderBox =
        rightBottomKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Size renderSize = originWatermarkSize.value ?? renderBox.size;
      RightBottomSize.value = Size(
          renderSize.width * max(mainScale.value, antifakeScale.value),
          renderSize.height * max(mainScale.value, antifakeScale.value));
      originWatermarkSize.value ??= renderSize;
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: tabList.length, vsync: this);
    initRightBottom();
    super.onInit();
  }

  @override
  void onClose() {
    antifakeController.dispose();
    signController.dispose();
    super.onClose();
  }
}
