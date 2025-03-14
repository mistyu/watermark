import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/pages/camera/dialog/watermark_dialog.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_proto_logic.dart';
import 'package:watermark_camera/pages/camera/sheet/watermark_style_edit/style_edit_logic.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/custom_ext.dart';
import 'package:watermark_camera/widgets/watermark_ui/assert_image_builder.dart';
import 'package:watermark_camera/widgets/watermark_ui/image_slider_thumb.dart';

const List<Color> colorsList = [
  Color(0xff0050f1),
  Color(0xff19c1bf),
  Color(0xffff8e59),
  Color(0xffcc0106),
  Color(0xffa903ac),
  Color(0xff00a3ff),
  Color(0xff1ce9b5),
  Color(0xff64de16),
  Color(0xfffec432),
  Color(0xfffe5352),
  Color(0xffcd49ff),
  Color(0xff43e8fe),
  Color(0xff64ffda),
  Color(0xff75ff02),
  Color(0xfffef040),
  Color(0xfffeac91),
  Color(0xffeb85fe),
  Color(0xff000000),
  Color(0xffffffff),
  Color(0xffff6735),
];

class StyleEdit extends StatelessWidget {
  final WatermarkView? watermarkView;
  final WatermarkProtoLogic logic;

  StyleEdit({
    super.key,
    this.watermarkView,
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

                        // Divider(
                        //   indent: 12,
                        //   endIndent: 10,
                        //   height: 1.w,
                        //   color: "f0f0f0".hex,
                        // )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '文字颜色',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    BlockPicker(
                      availableColors: colorsList,
                      pickerColor: logic.pickerColor.value,
                      onColorChanged: logic.updateFontsColor,
                      layoutBuilder: (context, colors, child) {
                        Orientation orientation =
                            MediaQuery.of(context).orientation;
                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.w,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: "f0f0f0".hex, width: 1.w)),
                          ),
                          height: 80.w,
                          child: ListView(
                            itemExtent:
                                orientation == Orientation.portrait ? 50.w : 80,
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: logic.showBottomSheetAndUpdateColor,
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
              ),
            ],
          );
        }),
      ),
    );
  }
}
