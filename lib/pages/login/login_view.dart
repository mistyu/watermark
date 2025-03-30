// 登入页面 -- 并没有注册页面（如果没有登入后台直接注册）
// 默认手机号一键登入，可选择验证码登入

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/gradient_button.dart';
import 'login_logic.dart';

class LoginView extends GetView<LoginLogic> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text(
                "手机号登录/注册",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40.h),
              // 手机号输入框
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "+86",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入手机号",
                          counterText: "",
                        ),
                        onChanged: (value) =>
                            controller.phoneNumber.value = value,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              // 验证码输入框
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入验证码",
                          counterText: "",
                        ),
                        onChanged: (value) =>
                            controller.verifyCode.value = value,
                      ),
                    ),
                    Obx(() => TextButton(
                          onPressed: controller.countdown.value > 0
                              ? null
                              : controller.getVerifyCode,
                          child: Text(
                            controller.countdown.value > 0
                                ? "${controller.countdown.value}s后重新获取"
                                : "获取验证码",
                            style: TextStyle(
                              color: controller.countdown.value > 0
                                  ? Colors.grey
                                  : "ff4f18".hex,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              // 登录按钮
              GradientButton(
                width: double.infinity,
                height: 50.h,
                colors: const [
                  Styles.c_0481DC,
                  Styles.c_0481DC,
                ],
                borderRadius: BorderRadius.circular(25.r),
                tapCallback: () => controller.handleLogin(),
                child: Text(
                  "登录/注册",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              // 微信登录按钮
              Center(
                child: Column(
                  children: [
                    Text(
                      "其他登录方式",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: controller.handleWechatLogin,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/wechat_logo.png',
                            width: 50.w,
                            height: 50.w,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "微信登录",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              // 底部协议
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Checkbox(
                        value: controller.agreeToTerms.value,
                        onChanged: (value) =>
                            controller.agreeToTerms.value = value ?? false,
                        activeColor: "ff4f18".hex,
                      )),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "已阅读并同意",
                            style: TextStyle(
                              color: "999999".hex,
                              fontSize: 12.sp,
                            ),
                          ),
                          TextSpan(
                            text: "《用户协议》",
                            style: TextStyle(
                              color: "ff4f18".hex,
                              fontSize: 12.sp,
                            ),
                          ),
                          TextSpan(
                            text: "和",
                            style: TextStyle(
                              color: "999999".hex,
                              fontSize: 12.sp,
                            ),
                          ),
                          TextSpan(
                            text: "《隐私政策》",
                            style: TextStyle(
                              color: "ff4f18".hex,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
