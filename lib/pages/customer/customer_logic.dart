import 'dart:convert';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/apis.dart';

class CustomerLogic extends GetxController {
  final messages = <CustomerMessage>[].obs;
  final inputText = ''.obs;
  static const String storageKey = 'customer_service_messages';

  @override
  void onInit() async {
    super.onInit();
    await loadMessages();
    // 加载后自动发送一条客服消息
    messages.add(CustomerMessage(
      content: "您好，我是修改牛水印智能客服，有什么可以帮助您的吗？",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  // 加载本地存储的消息
  Future<void> loadMessages() async {
    try {
      final String? storedMessages = SpUtil().getString(storageKey);
      if (storedMessages != null) {
        final List<dynamic> decoded = json.decode(storedMessages);
        messages.value =
            decoded.map((item) => CustomerMessage.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  // 保存消息到本地存储
  Future<void> saveMessages() async {
    try {
      final List<Map<String, dynamic>> encoded =
          messages.map((msg) => msg.toJson()).toList();
      await SpUtil().putString(storageKey, json.encode(encoded));
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 添加用户消息
    messages.add(CustomerMessage(
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // 清空输入框
    inputText.value = '';

    // 保存消息
    saveMessages();

    try {
      // 调用AI接口
      final response = await Apis.sendMessageToAI(text);

      // 隐藏加载状态
      Utils.dismissLoading();

      if (response.containsKey('choices') && response['choices'].isNotEmpty) {
        // 添加AI回复
        messages.add(CustomerMessage(
          content: response['choices'][0]['message']['content'],
          isUser: false,
          timestamp: DateTime.now(),
        ));

        // 保存消息
        saveMessages();
      } else {
        // 添加错误提示消息
        messages.add(CustomerMessage(
          content: "抱歉，我暂时无法回答您的问题，请稍后再试。",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        saveMessages();
      }
    } catch (e) {
      Utils.dismissLoading();
      print('Error getting AI response: $e');

      // 添加错误提示消息
      messages.add(CustomerMessage(
        content: "网络错误，请检查您的网络连接后重试。",
        isUser: false,
        timestamp: DateTime.now(),
      ));
      saveMessages();
    }
  }

  // 清空聊天记录
  Future<void> clearMessages() async {
    try {
      messages.clear();
      await SpUtil().delete(storageKey);
      Utils.showToast('聊天记录已清空');
    } catch (e) {
      print('Error clearing messages: $e');
      Utils.showToast('清空聊天记录失败');
    }
  }

  // 联系人工客服
  void contactCustomerService() async {
    // 展示微信二维码
    String url = await Apis.getCustomerService();

    CommonDialog.showMediaDialog(
      title: "微信二维码",
      content: "请扫描下方二维码添加客服微信",
      mediaUrl: url,
      isVideo: false, // 默认为 false，可省略
    );
  }
}

class CustomerMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  CustomerMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  // 从JSON转换
  factory CustomerMessage.fromJson(Map<String, dynamic> json) {
    return CustomerMessage(
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
