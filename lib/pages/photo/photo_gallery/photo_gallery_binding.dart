import 'package:get/get.dart';
import 'photo_gallery_logic.dart';

class PhotoGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PhotoGalleryLogic());
  }
}
