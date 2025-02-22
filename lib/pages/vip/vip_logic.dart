import 'package:get/get.dart';
import 'package:watermark_camera/apis.dart';
import 'package:watermark_camera/models/vip/vip_package.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/services/sse_service.dart';
import 'package:watermark_camera/utils/utils.dart';
import 'package:alipay_kit/alipay_kit.dart';

class VipLogic extends GetxController {
  final isChecked = false.obs;

  // 支付方式的checkbox
  final aliPayisSelected = true.obs;
  final weChatisSelected = false.obs;

  final vipList = <VipPackage>[].obs;
  final currentId = 0.obs;

  final _sseService = Get.find<SSEService>();

  @override
  void onInit() {
    super.onInit();
    getMembershipPackage();
  }

  getCheckBoxBorderColor() {
    return isChecked.value ? Styles.c_DE473E : Styles.c_0481DC;
  }

  /**
   * 获取vip套餐显示
   */
  Future<void> getMembershipPackage() async {
    try {
      final result = await Apis.getMembershipPackage();
      if (result != null) {
        // 将返回的数据转换为 VipPackage 对象列表
        final packages =
            (result as List).map((item) => VipPackage.fromJson(item)).toList();

        // 重新设置里面的originalPrice 是原价 * 1.5
        for (var package in packages) {
          package.originalPrice = package.price * 1.5;
        }

        vipList.value = packages;

        // 设置默认选中的会员ID
        if (vipList.isNotEmpty) {
          currentId.value = vipList.first.id;
        }
      }
    } catch (e) {
      print('Error getting membership packages: $e');
    }
  }

  // 处理支付
  Future<void> handlePayment(String packageId) async {
    print("选择的套餐: $packageId");
    try {
      // 调用支付接口 --- 获得orderId去后续订阅相应的结果
      Utils.showLoading('支付中...');
      final result = await Apis.pay(packageId);
      print("创建支付订单结果: $result");

      if (result != null) {
        // 先进行订阅
        // final orderId = result['orderNo'];
        // await _sseService.subscribePaymentResult(orderId);

        // 调用支付宝支付SDK
        try {
          final payResult = await AlipayKitPlatform.instance.pay(
            orderInfo: result['remark'],
            isShowLoading: true,
          );
        } catch (e) {
          print('支付宝支付错误: $e');
          Utils.showToast('支付失败，请重试');
          _sseService.unsubscribe();
        }
      }
    } catch (e) {
      print('Error handling payment: $e');
      Utils.showToast('出错了，请联系客服处理');
    } finally {
      Utils.dismissLoading();
    }
  }

  @override
  void onClose() {
    // 页面关闭时取消订阅
    _sseService.unsubscribe();
    super.onClose();
  }
}
