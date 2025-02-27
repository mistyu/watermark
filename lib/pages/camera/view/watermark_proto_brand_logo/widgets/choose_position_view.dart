import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/camera_logic.dart';
import 'package:watermark_camera/pages/camera/view/watermark_proto_brand_logo/widgets/choose_position_logic.dart';
import 'package:watermark_camera/utils/library.dart';
import 'package:watermark_camera/widgets/watermark_preview.dart';

class ChoosePositionView extends StatelessWidget {
  final logic = Get.put(ChoosePositionLogic());

  ChoosePositionView({Key? key}) : super(key: key);

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
            '编辑品牌图片',
            style: TextStyle(
              color: Styles.c_0D0D0D,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: logic.confirmEdit,
              child: Text(
                '确定',
                style: TextStyle(
                  color: Styles.c_0C8CE9,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 预览区域
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    color: Styles.c_999999,
                  ),
                ),
                _logoPostion(),
                _watermarkPreview()
              ],
            ),

            // 底部选项卡
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tab栏
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Styles.c_EDEDED,
                          width: 1.h,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTab('位置', 0),
                        _buildTab('大小', 1),
                        _buildTab('透明度', 2),
                      ],
                    ),
                  ),

                  // Tab内容区域
                  SizedBox(
                    height: 120.h,
                    child: Obx(() {
                      switch (logic.selectedTab.value) {
                        case 0:
                          return _buildPositionContent();
                        case 1:
                          return _buildSizeContent();
                        case 2:
                          return _buildOpacityContent();
                        default:
                          return const SizedBox();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _watermarkPreview() {
    return GetBuilder<ChoosePositionLogic>(
        init: logic,
        id: logic.watermarkUpdateId,
        builder: (logic) {
          return Positioned(
            bottom: 0,
            left: 0,
            child: Transform.scale(
              alignment: Alignment.bottomLeft,
              scale: 1,
              child: WatermarkPreview(
                resource: logic.resource.value!,
                watermarkView: logic.watermarkView.value,
              ),
            ),
          );
        });
  }

  Widget _logoPostion() {
    return GetBuilder<ChoosePositionLogic>(
        init: logic,
        id: logic.logoPositonId,
        builder: (logic) {
          if (logic.logoPostionType == 0) {
            return const SizedBox();
          }
          if (logic.logoPostionType == 1) {
            return Positioned(top: 0, left: 0, child: _LogoWidget());
          }
          if (logic.logoPostionType == 2) {
            return Positioned(top: 0, right: 0, child: _LogoWidget());
          }
          if (logic.logoPostionType == 3) {
            return Positioned(bottom: 0, left: 0, child: _LogoWidget());
          }
          if (logic.logoPostionType == 4) {
            return Positioned(bottom: 0, right: 0, child: _LogoWidget());
          }
          if (logic.logoPostionType == 5) {
            return Positioned(
                top: 0, left: 0, right: 0, bottom: 0, child: _LogoWidget());
          }
          return const SizedBox();
        });
  }

  Widget _buildTab(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => logic.switchTab(index),
        child: Obx(() {
          final isSelected = logic.selectedTab.value == index;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? Styles.c_0C8CE9 : Colors.transparent,
                  width: 2.h,
                ),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Styles.c_0C8CE9 : Styles.c_999999,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPositionContent() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPositionButton('跟随水印', LogoPositionType.follow),
              _buildPositionButton('左上角', LogoPositionType.topLeft),
              _buildPositionButton('右上角', LogoPositionType.topRight),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPositionButton('左下角', LogoPositionType.bottomLeft),
              _buildPositionButton('右下角', LogoPositionType.bottomRight),
              _buildPositionButton('居中', LogoPositionType.center),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionButton(String text, int type) {
    return GetBuilder<ChoosePositionLogic>(
      id: logic.logoPositonId,
      builder: (logic) {
        final isSelected = logic.logoPostionType == type;
        return GestureDetector(
          onTap: () => logic.updatePosition(type),
          child: Container(
            width: 80.w,
            height: 32.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Styles.c_0C8CE9 : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? Styles.c_0C8CE9 : Styles.c_EDEDED,
                width: 1.w,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : Styles.c_999999,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSizeContent() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '大小',
                style: TextStyle(
                  color: Styles.c_999999,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                '${(logic.scale.value * 100).toInt()}%',
                style: TextStyle(
                  color: Styles.c_0C8CE9,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2.h,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.r,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: 16.r,
                    ),
                    activeTrackColor: Styles.c_0C8CE9,
                    inactiveTrackColor: Styles.c_EDEDED,
                    thumbColor: Colors.white,
                    overlayColor: Styles.c_0C8CE9.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: logic.scale.value,
                    min: 0.5,
                    max: 2.0,
                    onChanged: logic.updateScale,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => logic.updateScale(1.0),
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  margin: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Styles.c_0C8CE9),
                  ),
                  child: Icon(
                    Icons.refresh,
                    size: 16.w,
                    color: Styles.c_0C8CE9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpacityContent() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '透明度',
                style: TextStyle(
                  color: Styles.c_999999,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                '${(logic.opacity.value * 100).toInt()}%',
                style: TextStyle(
                  color: Styles.c_0C8CE9,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2.h,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.r,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: 16.r,
                    ),
                    activeTrackColor: Styles.c_0C8CE9,
                    inactiveTrackColor: Styles.c_EDEDED,
                    thumbColor: Colors.white,
                    overlayColor: Styles.c_0C8CE9.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: logic.opacity.value,
                    min: 0.1,
                    max: 1.0,
                    onChanged: logic.updateOpacity,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => logic.updateOpacity(1.0),
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  margin: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Styles.c_0C8CE9),
                  ),
                  child: Icon(
                    Icons.refresh,
                    size: 16.w,
                    color: Styles.c_0C8CE9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final logic = Get.find<ChoosePositionLogic>();

  _LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChoosePositionLogic>(
        id: logic.logoPositonId,
        builder: (logic) {
          return FutureBuilder<Widget>(
            future: ImageUtil.loadNetworkImage(logic.imagePath!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Container(color: Colors.grey[300]);
              }

              // 应用缩放和透明度
              return Opacity(
                opacity: logic.opacity.value,
                child: Transform.scale(
                  scale: logic.scale.value,
                  child: snapshot.data!,
                ),
              );
            },
          );
        });
  }
}
