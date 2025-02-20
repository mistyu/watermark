import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/utils/utils.dart';

class ActivateCodeLogic extends GetxController {
  final activateCode = ''.obs;
  final isLoading = false.obs;

  // 兑换激活码
  Future<void> exchangeActivateCode() async {
    // 调用后台接口

    Utils.showLoading("兑换中...");
    try {
      final result = await Apis.exchangeActivateCode(activateCode.value);
      if (result != null) {
        Utils.showToast("兑换成功");
      }
    } catch (e) {
      Utils.showToast("兑换失败, 请您重试或者联系客服");
    } finally {
      Utils.dismissLoading();
    }
  }

  @override
  void onClose() {
    activateCode.value = '';
    super.onClose();
  }
}
