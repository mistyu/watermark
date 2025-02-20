import 'dart:async';

import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/config.dart';
import 'package:watermark_camera/pages/mine/mine_logic.dart';
import 'package:watermark_camera/utils/library.dart';

class SSEService extends GetxService {
  StreamSubscription? _subscription;

  // 订阅支付结果
  Future<void> subscribePaymentResult(String orderId) async {
    try {
      // 取消之前的订阅
      await unsubscribe();

      // 创建新的订阅
      final stream = SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: '${Config.apiUrl}/app/api/payment/subscribe/$orderId',
        header: {
          'Authorization': 'Bearer ${DataSp.token}',
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
        },
      );

      _subscription = stream.listen(
        (event) {
          print('Received SSE event: ${event.event}, data: ${event.data}');
          // 处理服务器发送的事件
          if (event.event == 'payment_success') {
            // 支付成功
            Get.find<MineLogic>().getUserInfo();
            Utils.showToast('支付成功');
            Get.back();
          } else if (event.event == 'payment_failed') {
            // 支付失败
            Utils.showToast('支付失败');
          }
        },
        onError: (error) {
          print('SSE Error: $error');
          Utils.showToast('订阅支付结果失败');
        },
        cancelOnError: true,
      );

      print('Successfully subscribed to payment result for order: $orderId');
    } catch (e) {
      print('Error subscribing to payment result: $e');
      Utils.showToast('订阅支付结果失败');
    }
  }

  // 取消订阅
  Future<void> unsubscribe() async {
    try {
      await _subscription?.cancel();
      _subscription = null;
      print('Successfully unsubscribed from payment result');
    } catch (e) {
      print('Error unsubscribing from payment result: $e');
    }
  }

  @override
  void onClose() {
    unsubscribe();
    super.onClose();
  }
}
