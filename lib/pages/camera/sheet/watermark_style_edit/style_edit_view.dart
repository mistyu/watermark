import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/resource/resource.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/dialog/watermark_dialog.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_style_edit/style_edit_logic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/widgets/watermark_ui/assert_image_builder.dart';
import 'package:watermark_camera/widgets/watermark_ui/image_slider_thumb.dart';

class StyleEdit extends StatelessWidget {
  final WatermarkView? watermarkView;
  final WatermarkProtoLogic logic;
  final WatermarkResource resource;

  StyleEdit({
    super.key,
    this.watermarkView,
    required this.resource,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              GestureDetector(
                onTap: logic.resetAll,
                child: Row(children: [
                  Image.asset('pop_rest'.png, width: 20.w, fit: BoxFit.contain),
                  4.w.horizontalSpace,
                  Text("重置",
                      style: TextStyle(color: '136cfe'.hex, fontSize: 14.sp)),
                ]),
              ),
              Row(
                children: [
                  Text(
                    '缩放',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          margin: EdgeInsets.only(top: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '小',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              Text(
                                "大",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 20.w,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: "f0f0f0".hex, width: 1.w)),
                          ),
                          child: AssertsImageBuilder('pic_thum'.png,
                              builder: (context, imageInfo) {
                            return Obx(() {
                              // 确保值在有效范围内
                              const minScale = 0.5;
                              const maxScale = 2.0;
                              final currentScale =
                                  (logic.watermarkView.value?.scale ?? 1.0)
                                      .clamp(minScale, maxScale);
                              // print("xiaojianjian 缩放更新: $currentScale");
                              return SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 5.w,
                                  showValueIndicator: ShowValueIndicator.never,
                                  valueIndicatorTextStyle:
                                      const TextStyle(fontSize: 11),
                                  thumbShape: ImageSliderThumb(
                                      image: imageInfo?.image,
                                      size: const Size(30, 30),
                                      msg: '${(currentScale * 100).toInt()}%'),
                                ),
                                child: Slider(
                                  divisions:
                                      ((maxScale - minScale) * 100).toInt(),
                                  value: currentScale,
                                  min: minScale,
                                  max: maxScale,
                                  activeColor: "e6e9f0".hex,
                                  inactiveColor: "e6e9f0".hex,
                                  onChanged: logic.onChangeScale,
                                ),
                              );
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '宽窄',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          margin: EdgeInsets.only(top: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '窄',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              Text(
                                "宽",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 20.w,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: "f0f0f0".hex, width: 1.w)),
                          ),
                          child: AssertsImageBuilder('pic_thum'.png,
                              builder: (context, imageInfo) {
                            return Obx(() {
                              // 确保值在有效范围内
                              const minWidth = 150.0;
                              final maxWidth = 1.sw;
                              final currentWidth =
                                  (logic.watermarkView.value?.frame?.width ??
                                          minWidth)
                                      .clamp(minWidth, maxWidth);

                              return SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 5.w,
                                  thumbShape: ImageSliderThumb(
                                      image: imageInfo?.image,
                                      size: const Size(30, 30),
                                      msg: '${currentWidth.toInt()}宽'),
                                ),
                                child: Slider(
                                  divisions: (maxWidth - minWidth).toInt(),
                                  value: currentWidth,
                                  min: minWidth,
                                  max: maxWidth,
                                  activeColor: "e6e9f0".hex,
                                  inactiveColor: "e6e9f0".hex,
                                  onChanged: logic.onChangeWidth,
                                ),
                              );
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (resource.id == 1698049456677 || resource.id == 1698049457777)
                // 标题透明度滑动条
                _buildTransparencySlider(
                  title: '标题透明度',
                  onChanged: logic.updateTitleAlpha,
                ),
              if (resource.id == 1698049456677 || resource.id == 1698049457777)
                // 底部透明度滑动条
                _buildTransparencySlider(
                  title: '底部透明度',
                  onChanged: logic.updateBackgroundAlpha,
                ),

              // 文字颜色选择器
              _buildColorPicker(
                title: '文字颜色',
                pickerColor: logic.pickerColor.value,
                onColorChanged: logic.updateFontsColor,
                showBottomSheet: logic.showBottomSheetAndUpdateColor,
              ),
              if (resource.id == 1698049456677 || resource.id == 1698049457777)
                // 标题颜色选择器
                _buildColorPicker(
                  title: '标题颜色',
                  pickerColor: logic.titlePickerColor.value,
                  onColorChanged: logic.updateTitleColor,
                  showBottomSheet: logic.showBottomSheetAndUpdateColor,
                ),

              if (resource.id == 1698049456677 || resource.id == 1698049457777)
                // 底部底色选择器
                _buildColorPicker(
                  title: '底部底色',
                  pickerColor: logic.backgroundPickerColor.value,
                  onColorChanged: logic.updateBackgroundColor,
                  showBottomSheet: logic.showBottomSheetAndUpdateColor,
                ),
            ],
          );
        }),
      ),
    );
  }

  // 提取颜色选择器为单独的方法
  Widget _buildColorPicker({
    required String title,
    required Color pickerColor,
    required ValueChanged<Color> onColorChanged,
    required VoidCallback showBottomSheet,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp),
          ),
          BlockPicker(
            availableColors: logic.colorsList,
            pickerColor: pickerColor,
            onColorChanged: onColorChanged,
            layoutBuilder: (context, colors, child) {
              Orientation orientation = MediaQuery.of(context).orientation;
              return Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12.w,
                ),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: "f0f0f0".hex, width: 1.w)),
                ),
                height: 80.w,
                child: ListView(
                  itemExtent: orientation == Orientation.portrait ? 50.w : 80,
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: showBottomSheet,
                      child: Padding(
                        padding: EdgeInsets.all(6.0.w),
                        child: Image.asset(
                          'mixer'.png,
                        ),
                      ),
                    ),
                    for (Color color in colors) child(color)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 提取透明度滑动条为单独的方法
  Widget _buildTransparencySlider({
    required String title,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                margin: EdgeInsets.only(top: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '透明',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      "不透明",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 20.w,
                ),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: "f0f0f0".hex, width: 1.w)),
                ),
                child: AssertsImageBuilder('pic_thum'.png,
                    builder: (context, imageInfo) {
                  return Obx(() {
                    // 根据滑块类型获取当前值
                    double currentValue;
                    if (title == '标题透明度') {
                      currentValue =
                          (logic.titleData?.style?.backgroundColor?.alpha ??
                                  1.0)
                              .toDouble();
                    } else {
                      currentValue =
                          (logic.table2Data?.style?.backgroundColor?.alpha ??
                                  1.0)
                              .toDouble();
                    }

                    return SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5.w,
                        showValueIndicator: ShowValueIndicator.never,
                        valueIndicatorTextStyle: const TextStyle(fontSize: 11),
                        thumbShape: ImageSliderThumb(
                            image: imageInfo?.image,
                            size: const Size(30, 30),
                            msg: '${(currentValue * 100).toInt()}%'),
                      ),
                      child: Slider(
                          divisions: 100,
                          value: currentValue,
                          min: 0.0,
                          max: 1.0,
                          activeColor: "e6e9f0".hex,
                          inactiveColor: "e6e9f0".hex,

                          // 使用节流方式处理滑动事件
                          onChanged: onChanged),
                    );
                  });
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSilder(
    String title,
    Function(double value) onChangedEnd,
    double min,
    double max,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                margin: EdgeInsets.only(top: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '小',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      "大",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 20.w,
                ),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: "f0f0f0".hex, width: 1.w)),
                ),
                child: AssertsImageBuilder('pic_thum'.png,
                    builder: (context, imageInfo) {
                  return Obx(() {
                    final current = (logic.watermarkView.value?.scale ?? 1.0)
                        .clamp(min, max);

                    return SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5.w,
                        thumbShape: ImageSliderThumb(
                            image: imageInfo?.image,
                            size: const Size(30, 30),
                            msg: '$current'),
                      ),
                      child: Slider(
                        divisions: 100,
                        value: current,
                        min: min,
                        max: max,
                        activeColor: "e6e9f0".hex,
                        inactiveColor: "e6e9f0".hex,
                        onChanged: (value) {},
                        onChangeEnd: onChangedEnd,
                      ),
                    );
                  });
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
