import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/services/sse_service.dart';

class VipLogic extends GetxController {
  final isChecked = false.obs;

  // 支付方式的checkbox
  final aliPayisSelected = false.obs;
  final weChatisSelected = false.obs;

  getCheckBoxBorderColor() {
    if (isChecked.value) {
      return Styles.c_DE473E;
    } else {
      return Styles.c_0481DC;
    }
  }

  final vipList = [].obs;
  final currentId = 0.obs;

  final _sseService = Get.find<SSEService>();

  @override
  void onInit() {
    super.onInit();
    // 确保有默认数据
    vipList.value = [
      {"id": 1, "title": "连续包月", "price": 29.9, "originalPrice": 39.9},
      {"id": 2, "title": "连续包年", "price": 79.9, "originalPrice": 99.9},
      {"id": 3, "title": "终身会员", "price": 299.9, "originalPrice": 399.9},
      {"id": 3, "title": "单买一个月", "price": 299.9, "originalPrice": 399.9},
    ];
    // 设置默认选中的会员ID
    if (vipList.isNotEmpty) {
      currentId.value = vipList.first["id"];
    }
  }

  // 处理支付
  Future<void> handlePayment(String orderId) async {
    try {
      // 订阅支付结果
      await _sseService.subscribePaymentResult(orderId);
      
      // 调用支付接口
      // ... 支付相关代码 ...
      
    } catch (e) {
      print('Error handling payment: $e');
      Utils.showToast('支付失败');
    }
  }

  @override
  void onClose() {
    // 页面关闭时取消订阅
    _sseService.unsubscribe();
    super.onClose();
  }
}
