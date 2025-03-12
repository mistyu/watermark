import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/pages/camera/dialog/watermark_dialog.dart';
import 'package:watermark_camera/utils/styles.dart';
import 'package:watermark_camera/widgets/camera_button.dart';

class Tutorialindex extends StatelessWidget {
  Tutorialindex({super.key});
  final List<String> messages = [
    "点击水印 -> 进入编辑页面 -> 可以查看到水印修改项 -> 输入水印地址 -> 点击保存即可",
    "点击水印 -> 进入编辑页面 -> 可以查看到水印时间项 -> 输入水印时间 -> 点击保存即可",
    "选择相册 -> 点击批量添加 -> 选择图片 -> 设置水印样式 -> 点击保存即可",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("教程"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              CustomButton(
                text: "怎么修改水印地址",
                textColor: Styles.c_FFFFFF,
                backgroundColor: Styles.c_0C8CE9,
                image: const AssetImage("assets/images/camera_guid.png"),
                onTap: () {
                  WatermarkDialog.showMessageDialog(messages[0]);
                },
              ),
              16.verticalSpace,
              CustomButton(
                text: "怎么修改水印时间",
                textColor: Styles.c_FFFFFF,
                backgroundColor: Styles.c_0C8CE9,
                image: const AssetImage("assets/images/camera_guid.png"),
                onTap: () {
                  WatermarkDialog.showMessageDialog(messages[1]);
                },
              ),
              16.verticalSpace,
              CustomButton(
                text: "怎么给本地图片添加水印",
                textColor: Styles.c_FFFFFF,
                backgroundColor: Styles.c_0C8CE9,
                image: const AssetImage("assets/images/camera_guid.png"),
                onTap: () {
                  WatermarkDialog.showMessageDialog(messages[2]);
                },
              ),
            ],
          ),
        ));
  }
}
