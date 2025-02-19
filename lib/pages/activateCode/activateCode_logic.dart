import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/utils/toast_util.dart';
import 'package:watermark_camera/utils/utils.dart';

class ActivateCodeLogic extends GetxController {
  final activateCode = ''.obs;
  final isLoading = false.obs;

  // 兑换激活码
  Future<void> exchangeActivateCode() async {
    // isLoading.value = true;

    // 调用后台接口
    final result = await Apis.exchangeActivateCode(activateCode.value);
    print('result: $result');
    Utils.showToast(result);
    // isLoading.value = false;
  }

  @override
  void onClose() {
    activateCode.value = '';
    super.onClose();
  }
}
