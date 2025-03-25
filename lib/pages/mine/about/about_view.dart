import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'about_logic.dart';

class AboutAppPage extends StatelessWidget {
  final logic = Get.find<AboutAppLogic>();

  AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('关于我们', style: Styles.ts_333333_18_bold),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Styles.c_333333, size: 20.w),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 应用信息部分
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 应用图标
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: Styles.c_0C8CE9,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        'assets/images/LOGO.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 40.w,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  // 应用名称
                  Obx(() => Text(
                        logic.appName.value.isEmpty
                            ? '万能水印相机'
                            : logic.appName.value,
                        style: Styles.ts_333333_18_bold,
                      )),
                ],
              ),
            ),

            12.verticalSpace,

            // 设置项列表
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // _buildSettingItem(
                  //   title: '用户协议',
                  //   onTap: logic.openUserAgreement,
                  //   showArrow: true,
                  // ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: '隐私政策',
                    onTap: logic.startPrivacyView,
                    showArrow: true,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    title: '当前版本',
                    onTap: logic.openBetaTest,
                    showArrow: true,
                    trailing: Obx(() => Text(
                          logic.appVersion.value.isEmpty
                              ? '3.0.0'
                              : logic.appVersion.value,
                          style: Styles.ts_999999_14,
                        )),
                  ),
                  _buildDivider(),
                  // _buildSettingItem(
                  //   title: '个性化推送',
                  //   showArrow: false,
                  //   trailing: Obx(() => Switch(
                  //         value: false, // 这里可以绑定到逻辑中的状态
                  //         onChanged: logic.togglePersonalizedRecommendation,
                  //         activeColor: Styles.c_0C8CE9,
                  //       )),
                  // ),
                ],
              ),
            ),

            30.verticalSpace,

            // 注销账号按钮 - 红色背景版本
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ElevatedButton(
                onPressed: () {
                  // 显示确认对话框
                  Get.dialog(
                    AlertDialog(
                      title: Text('注销账号', style: Styles.ts_333333_18_bold),
                      content: Text(
                        '确定要注销账号吗？注销后将无法恢复您的账号数据。',
                        style: Styles.ts_666666_16,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('取消', style: Styles.ts_999999_16),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            logic.logout();
                          },
                          child: Text('确定',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 16.sp)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  '注销账号',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            30.verticalSpace,

            // 底部版权信息
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            //   child: Column(
            //     children: [
            //       Text('浙ICP备 20210143212号-4A', style: Styles.ts_999999_12),
            //       8.verticalSpace,
            //       Text('万能水印相机 版权所有 © 2022-2024', style: Styles.ts_999999_12),
            //     ],
            //   ),
            // ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  Text('opyRight©️2018-2024', style: Styles.ts_999999_12),
                  8.verticalSpace,
                  Text('东莞市爱享乐网络科技有限公司版权所有', style: Styles.ts_999999_12),
                ],
              ),
            ),

            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  // 构建设置项
  Widget _buildSettingItem({
    required String title,
    Function()? onTap,
    bool showArrow = true,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Text(title, style: Styles.ts_333333_16),
            Spacer(),
            if (trailing != null) trailing,
            if (showArrow) ...[
              8.horizontalSpace,
              Icon(Icons.arrow_forward_ios, color: Styles.c_999999, size: 16.w),
            ],
          ],
        ),
      ),
    );
  }

  // 构建分割线
  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1.h,
      color: Styles.c_777777,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
