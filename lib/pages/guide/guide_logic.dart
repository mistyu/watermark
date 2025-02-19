import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/base_tab_controller.dart';
import 'package:watermark_camera/core/controller/watermark_controller.dart';
import 'package:watermark_camera/models/category/category.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/routes/app_navigator.dart';

class GuideLogic extends BaseTabController {
  final watermarkLogic = Get.find<WaterMarkController>();

  @override
  List<Category> get tabs => watermarkLogic.watermarkCategoryList;

  List<WatermarkResource> get watermarkResources =>
      watermarkLogic.watermarkResourceList;

  void onTapWatermarkResource(WatermarkResource resource) {
    AppNavigator.startCamera(resource: resource);
  }

  @override
  void onInit() {
    super.onInit();
    ever(watermarkLogic.watermarkCategoryList, (list){
      if (list.isNotEmpty){
        initTabController();
      }
    });
  }
}
