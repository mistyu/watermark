import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/gradient_button.dart';

import 'activateCode_logic.dart';

class ActivateCodePage extends GetView<ActivateCodeLogic> {
  const ActivateCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "激活码兑换",
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "CDK兑换:",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                // CDK输入框
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "请输入您的CDK码 (16位)",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.sp,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                    onChanged: (value) => controller.activateCode.value = value,
                  ),
                ),
                SizedBox(height: 20.h),

                // 验证码输入区域
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入右图验证码",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12.w),
                          ),
                          onChanged: (value) =>
                              controller.captchaCode.value = value,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // 验证码图片
                    Obx(() => GestureDetector(
                          onTap: controller.refreshCaptcha,
                          child: Container(
                            width: 120.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: controller.captchaImage.value.isNotEmpty
                                ? Image.network(
                                    controller.captchaImage.value,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return GestureDetector(
                                        onTap: controller.refreshCaptcha,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.refresh,
                                                  color: Colors.grey[400],
                                                  size: 20.w),
                                              SizedBox(height: 4.h),
                                              Text(
                                                "点击刷新",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : GestureDetector(
                                    onTap: controller.refreshCaptcha,
                                    child: Center(
                                      child: Text(
                                        "加载中...",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        )),
                  ],
                ),

                SizedBox(height: 20.h),

                // 确认兑换按钮
                GradientButton(
                  width: double.infinity,
                  height: 50.h,
                  colors: const [
                    Styles.c_0481DC,
                    Styles.c_0481DC,
                  ],
                  borderRadius: BorderRadius.circular(25.r),
                  tapCallback: controller.exchangeActivateCode,
                  child: Text(
                    "确认兑换",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // CDK兑换使用说明
                Text(
                  "CDK兑换使用说明:",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.h),

                // 使用说明列表
                _buildInstructionItem("1、本兑换页可用于兑换修改牛水印会员，兑换后立即获得相应会员权益。"),
                _buildInstructionItem("2、CDK兑换后，会员会立即到账到您当前登录的账号，请确定好要充值的账号。"),
                _buildInstructionItem(
                    "3、当前已经开通了修改牛水印会员服务的用户，此次兑换的会员时长将会在原来的时间基础上叠加。"),
                _buildInstructionItem("4、请确认好兑换码再进行兑换，多次输入错误可能导致无法兑换，甚至账号封禁。"),
                _buildInstructionItem("5、兑换码为16位，由字母、数字组成，字母区分大小写。"),
                _buildInstructionItem("6、兑换过程遇到问题，请及时联系客服处理。"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }
}
