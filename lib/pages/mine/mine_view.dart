import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/pages/home/home_logic.dart';
import 'package:watermark_camera/routes/app_navigator.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/utils/constants.dart';

import 'mine_logic.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.find<MineLogic>();

  @override
  bool get wantKeepAlive => true; // 保持页面状态

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 初始化时检查是否可见
      if (Get.find<HomeLogic>().activeIndex.value == 1) {
        logic.setVisible(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          title: "设置".toText..style = Styles.ts_333333_24_medium,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
          child: Column(
            children: [
              GetBuilder<MineLogic>(
                  id: logic.mineUserInfoId,
                  builder: (logic) {
                    if (logic.userInfo == null) {
                      return const SizedBox.shrink();
                    }
                    return _buildBox(
                      child: Container(
                        decoration: logic.isMember
                            ? const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Assets.vipBg),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )
                            : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.w, horizontal: 10.w),
                          child: Row(
                            children: [
                              logic.avatar != null
                                  ? GestureDetector(
                                      onTap: () {
                                        logic.selectImageAndUpload();
                                      },
                                      // 切成圆形
                                      child: ClipOval(
                                        child: Image.network(logic.avatar!,
                                            width: 40.w,
                                            height: 40.w,
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        logic.selectImageAndUpload();
                                      },
                                      child: "user-avatar".svg.toSvg
                                        ..width = 40.w
                                        ..height = 40.w,
                                    ),
                              12.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () =>
                                              {logic.startChangeNameView()},
                                          child: Text(
                                            logic.nickName,
                                            style: Styles.ts_333333_16_medium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      if (logic.isMember)
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Styles.c_0C8CE9,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              "VIP会员",
                                              style: Styles.ts_FFFFFF_12,
                                            ),
                                          ),
                                        )
                                      else
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Styles.c_0C8CE9,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              logic.userInfo!.userType == 0
                                                  ? "游客身份"
                                                  : "正式用户",
                                              style: Styles.ts_FFFFFF_12,
                                            ),
                                          ),
                                        )
                                    ]),
                                    2.verticalSpace,
                                    if (logic.isMember &&
                                        logic.memberExpireTime != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.h),
                                        child: Text(
                                          "到期时间: ${logic.memberExpireTime!.toString().split(' ')[0]}",
                                          style: Styles.ts_999999_12,
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              16.verticalSpace,
              GetBuilder<MineLogic>(
                  id: logic.mineUserSetting,
                  builder: (logic) {
                    return _buildBox(
                        child: Column(
                      children: [
                        _buildNavItem(
                            title: "照片分辨率",
                            extra: logic.cameraResolutionPreset,
                            onTap: logic.startResolutionView),
                        _buildSwitchItem(
                            title: "右下角水印",
                            hint: "可修改水印防伪名称",
                            value: logic.openRightBottomWatermark,
                            onSwitch: logic.onSwitchRightBottomWatermark),
                        _buildSwitchItem(
                            title: "保存无水印图片",
                            hint: logic.openSaveNoWatermarkImage ? "开启" : "关闭",
                            value: logic.openSaveNoWatermarkImage,
                            onSwitch: logic.onSwitchSaveNoWatermarkImage),
                        _buildNavItem(
                            title: "换取激活码", onTap: logic.startActivateCode),
                        _buildNavItem(
                            title: "联系客服", onTap: logic.startCustomer),
                        logic.userInfo!.isMember == 0
                            ? _buildNavItem(
                                title: "开通vip解锁更多的功能",
                                onTap: logic.startVipView)
                            : _buildNavItem(
                                title: "查看我的vip权益",
                                onTap: logic.startVipAuthority),
                        logic.userInfo?.userType == 0
                            ? _buildNavItem(
                                title: "登入", onTap: logic.startLogin)
                            : _buildNavItem(title: "退出登入", onTap: logic.logout),
                      ],
                    ));
                  }),
              16.verticalSpace,
              GetBuilder<MineLogic>(
                  id: logic.mineUserSetting,
                  builder: (logic) {
                    return _buildBox(
                      child: Column(
                        children: [
                          _buildNavItem(
                              title: "清除缓存",
                              extra: logic.cacheSize.value,
                              onTap: logic.onClearCache),
                          _buildNavItem(
                              title: "隐私政策", onTap: logic.startPrivacyView),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.h, horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                "当前版本".toText
                                  ..style = Styles.ts_333333_16_medium,
                                "v${logic.version}".toText
                                  ..style = Styles.ts_999999_14,
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ));
  }

  Widget _buildNavItem(
      {required String title, String? extra, String? hint, Function()? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                title.toText..style = Styles.ts_333333_16_medium,
                if (hint != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.0.h),
                    child: hint.toText..style = Styles.ts_999999_14,
                  ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (extra != null)
                  extra.toText..style = Styles.ts_666666_14_medium,
                6.horizontalSpace,
                Icon(Icons.arrow_forward_ios,
                    size: 16.r, color: Styles.c_999999),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
      {required String title,
      required bool value,
      String? hint,
      Function(bool value)? onSwitch}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title.toText..style = Styles.ts_333333_16_medium,
              if (hint != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.0.h),
                  child: hint.toText..style = Styles.ts_999999_14,
                ),
            ],
          ),
          Switch(value: value, onChanged: onSwitch),
        ],
      ),
    );
  }

  Widget _buildBox({required Widget child}) {
    return Container(
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
      child: child,
    );
  }
}
