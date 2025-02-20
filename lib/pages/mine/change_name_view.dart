import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/mine/mine_logic.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/widgets/gradient_button.dart';

//修改用户名
class ChangeNickNamePage extends StatelessWidget {
  ChangeNickNamePage({super.key});
  RxString nickName = "".obs;
  MineLogic mineLogic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("修改昵称", style: Styles.ts_161616_16_bold),
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.phone,
                maxLength: 11,
                decoration: const InputDecoration(
                  hintText: "请您输入新的昵称",
                  counterText: "",
                ),
                onChanged: (value) => nickName.value = value,
              ),
              SizedBox(height: 20.h),
              GradientButton(
                width: double.infinity,
                height: 50.h,
                colors: const [
                  Styles.c_0481DC,
                  Styles.c_0481DC,
                ],
                borderRadius: BorderRadius.circular(25.r),
                tapCallback: () => mineLogic.changeNickName(nickName.value),
                child: Text(
                  "修改昵称",
                  style: TextStyle(
                    color: Styles.c_EDEDED,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
