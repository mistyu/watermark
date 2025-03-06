import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/guide/guide_view.dart';
import 'package:watermark_camera/pages/mine/mine_view.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final logic = Get.find<HomeLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: logic.activeIndex.value,
            children: [
              GuidePage(),
              const MinePage(),
            ],
          ),
          floatingActionButton: SizedBox(
            width: 68.w,
            height: 68.w,
            child: FloatingActionButton(
              onPressed: AppNavigator.startCamera,
              backgroundColor: Styles.c_0C8CE9,
              shape: const CircleBorder(),
              child: Icon(Icons.camera_alt, size: 42.sp),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            elevation: 5,
            shadowColor: Styles.c_0C8CE9,
            notchMargin: 4.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            shape: const AutomaticNotchedShape(
                RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  key: "home",
                  title: "水印模版",
                  icon: "yin".svg,
                  isSelected: logic.activeIndex.value == 0,
                  onPressed: () => logic.switchPage(0),
                ),
                _buildNavItem(
                  key: "setting",
                  title: "设置",
                  icon: "setting".svg,
                  isSelected: logic.activeIndex.value == 1,
                  onPressed: () => logic.switchPage(1),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildNavItem({
    required String key,
    required String title,
    required String icon,
    required VoidCallback onPressed,
    bool isSelected = false,
  }) {
    return IconButton(
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: const CircleBorder(),
      ),
      onPressed: onPressed,
      icon: Column(
        children: [
          icon.toSvg
            ..color = isSelected ? Styles.c_0C8CE9 : Styles.c_999999
            ..width = 22.w
            ..height = 22.w,
          title.toText
            ..style = isSelected
                ? Styles.ts_0C8CE9_12_medium
                : Styles.ts_999999_12_medium,
        ],
      ),
    );
  }
}
