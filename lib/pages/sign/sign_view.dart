import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sign_logic.dart';

class SignPage extends StatelessWidget {
  SignPage({super.key});

  final logic = Get.find<SignLogic>();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
