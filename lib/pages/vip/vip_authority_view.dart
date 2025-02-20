/**
 * 不用状态只是一个展示页面
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/constants.dart';
import 'package:watermark_camera/utils/styles.dart';

class VipAuthorityView extends StatelessWidget {
  const VipAuthorityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("VIP权限", style: Styles.ts_0481DC_16_bold),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildVipCard(),
            16.verticalSpace,
            _buildAuthorityList(),
          ],
        ),
      ),
    );
  }

  // VIP卡片
  Widget _buildVipCard() {
    //到期时间浮动在右下角
    return Stack(children: [
      Container(
        height: 166.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(Assets.vipBg),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    ]);
  }

  // 权限列表
  Widget _buildAuthorityList() {
    return VipAuthorityItem();
  }
}

class VipAuthorityItem extends StatelessWidget {
  const VipAuthorityItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAuthorityItem(
          imagePath: "assets/vip/vip_logo1.png",
          title: "无限制拍照",
          description: "VIP会员可以无限制拍照，普通用户每天限制10张",
        ),
        _buildAuthorityItem(
          imagePath: "assets/vip/vip_logo2.png",
          title: "自定义水印",
          description: "VIP会员可以自定义水印样式和内容",
        ),
        _buildAuthorityItem(
          imagePath: "assets/vip/vip_logo3.png",
          title: "批量添加水印",
          description: "VIP会员可以批量为照片添加水印",
        ),
        _buildAuthorityItem(
          imagePath: "assets/vip/vip_logo4.png",
          title: "高级水印模板",
          description: "VIP会员可以使用所有高级水印模板",
        ),
        _buildAuthorityItem(
          imagePath: "assets/vip/vip_logo4.png",
          title: "公司logo",
          description: "VIP会员可以添加自定义公司logo",
        ),
      ],
    );
  }

  Widget _buildAuthorityItem({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Styles.c_EDEDED,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 40.w,
            height: 40.w,
            fit: BoxFit.fitWidth,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Styles.ts_333333_18_bold),
                4.verticalSpace,
                Text(
                  description,
                  style: Styles.ts_999999_14,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
