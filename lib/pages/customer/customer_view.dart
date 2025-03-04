import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';
import 'customer_logic.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({Key? key}) : super(key: key);

  final logic = Get.find<CustomerLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '在线客服',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: logic.messages.length,
                  itemBuilder: (context, index) {
                    final message = logic.messages[index];
                    return _buildMessageItem(message);
                  },
                )),
          ),
          _buildBottomInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(CustomerMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!message.isUser)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      '万能相机',
                      style: TextStyle(
                        color: Styles.c_999999,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: message.isUser ? Styles.c_0C8CE9 : Styles.c_F6F6F6,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/LOGO.png',
          width: 30.w,
          height: 30.w,
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Icon(
        Icons.person,
        size: 24.w,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildBottomInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // 功能按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildFunctionButton(
                title: '人工客服',
                icon: Icons.support_agent,
                onTap: logic.contactCustomerService,
              ),
              SizedBox(width: 12.w),
              _buildFunctionButton(
                title: '清空记录',
                icon: Icons.delete_outline,
                onTap: () {
                  Get.defaultDialog(
                    title: '提示',
                    middleText: '确定要清空聊天记录吗？',
                    textConfirm: '确定',
                    textCancel: '取消',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      logic.clearMessages();
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // 输入框行
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Styles.c_F6F6F6,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: TextField(
                    onChanged: (value) => logic.inputText.value = value,
                    decoration: InputDecoration(
                      hintText: '请输入内容',
                      hintStyle: TextStyle(
                        color: Styles.c_999999,
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () => logic.sendMessage(logic.inputText.value),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Styles.c_0C8CE9,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '发送',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Styles.c_F6F6F6,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.w, color: Styles.c_0C8CE9),
            SizedBox(width: 4.w),
            Text(
              title,
              style: TextStyle(
                color: Styles.c_0C8CE9,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
