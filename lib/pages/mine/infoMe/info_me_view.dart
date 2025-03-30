import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/constants.dart';
import 'info_me_logic.dart';

class InfoMePage extends StatelessWidget {
  final logic = Get.find<InfoMeLogic>();

  InfoMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "个人信息".toText..style = Styles.ts_333333_24_medium,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40.h),
          // Avatar section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: logic.changeAvatar,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Styles.c_0C8CE9, width: 2.w),
                    ),
                    child: Center(
                      child: logic.avatar != null
                          ? ClipOval(
                              child: Image.network(
                                logic.avatar!,
                                width: 90.w,
                                height: 90.w,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Container(
                                      width: 90.w,
                                      height: 90.w,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 50.w,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90.w,
                                    height: 90.w,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.person,
                                      size: 50.w,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              width: 90.w,
                              height: 90.w,
                              child: "user-avatar".svg.toSvg,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "点击更换头像",
                  style: Styles.ts_999999_14,
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          // User info section
          _buildInfoBox(),

          // 添加退出登录按钮
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 40.h),
                  child: ElevatedButton(
                    onPressed: () {
                      // 显示确认对话框
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("确认退出登录"),
                          content: const Text("您确定要退出登录吗？"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("取消"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context); // 先关闭对话框
                                logic.logout(); // 然后执行退出登录
                              },
                              child: const Text("确定"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      "退出登录",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Styles.c_0D0D0D.withOpacity(0.07),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoItem(
            title: "昵称",
            value: logic.nickName,
            onTap: logic.changeName,
          ),
          Divider(height: 1.h, color: Color(0xFFEEEEEE)),
          _buildInfoItem(
            title: "会员状态",
            value: logic.isMember ? "VIP会员" : "普通用户",
          ),
          if (logic.isMember && logic.memberExpireTime != null) ...[
            Divider(height: 1.h, color: Color(0xFFEEEEEE)),
            _buildInfoItem(
              title: "到期时间",
              value: logic.memberExpireTime!.toString().split(' ')[0],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String value,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Styles.ts_333333_16_medium,
            ),
            Row(
              children: [
                Text(
                  value,
                  style: Styles.ts_666666_16,
                ),
                if (onTap != null) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.r,
                    color: Styles.c_999999,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
