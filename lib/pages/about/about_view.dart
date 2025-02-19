import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/utils/library.dart';

import 'about_logic.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final AboutLogic logic = Get.find<AboutLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '关于',
          style: TextStyle(fontSize: 16.0.sp),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          ClipOval(
            child: Image.asset(
              'LOGO'.jpg,
              width: 64.w,
              height: 64.w,
            ),
          ),
          12.verticalSpace,
          Text(
            '东莞市爱享乐网络科技有限公司',
            style: TextStyle(fontSize: 12.0.sp),
          ),
          //列表
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.0.w),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: logic.list.length,
              itemBuilder: (BuildContext content, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // const Icon(Icons.book),
                            SizedBox(
                              width: 5.0.w,
                            ),
                            Text(
                              logic.list[index]["title"],
                              style: TextStyle(fontSize: 12.0.sp),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              logic.list[index]["subtext"] ?? '',
                              style: TextStyle(
                                  color: "a1a1a1".hex,
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Visibility(
                              visible: logic.list[index]["chevron_right"],
                              child: Icon(
                                Icons.chevron_right,
                                color: "a1a1a1".hex,
                                size: 24.0.w,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      height: 22.0.w,
                      thickness: 1.0.w,
                      color: "ececec".hex,
                    ),
                  ],
                );
              },
            ),
          ),

          //版权
          Text(
            'CopyRight©️2018-2024',
            style: TextStyle(color: '999999'.hex, fontSize: 12.0.sp),
          ),
          Text(
            '东莞市爱享乐网络科技有限公司版权所有',
            style: TextStyle(color: '999999'.hex, fontSize: 12.0.sp),
          ),
        ],
      ),
    );
  }
}
