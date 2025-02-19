import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/core/controller/app_controller.dart';
import 'package:watermark_camera/widgets/title_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPage extends StatelessWidget {
  PrivacyPage({super.key});

  final appLogic = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "隐私协议",
      ),
      body: FutureBuilder(
          future: appLogic.webViewController
              .loadFlutterAsset("assets/html/privacy_policy.html"),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.connectionState == ConnectionState.done) {
              return WebViewWidget(controller: appLogic.webViewController);
            }
            return const SizedBox.shrink();
          }),
    );
  }
}
