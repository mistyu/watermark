import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'package:watermark_camera/utils/watermark.dart';
import '../ui/assert_image_builder.dart';
import '../ui/image_slider_thumb.dart';

class RightBottomStyleView extends StatefulWidget {
  final RightBottomView? rightBottomView;
  final ValueChanged<double>? callbackRightBottomOpacity;
  final ValueChanged<Offset>? callbackRightBottomPosition;
  const RightBottomStyleView(
      {super.key,
      required this.rightBottomView,
      this.callbackRightBottomOpacity,
      this.callbackRightBottomPosition});

  @override
  State<RightBottomStyleView> createState() => _RightBottomStyleViewState();
}

class _RightBottomStyleViewState extends State<RightBottomStyleView> {
  final _opacityPercent = ValueNotifier(100.0);
  RightBottomView? _newView;
  final _verticalOffset = ValueNotifier(10);
  final _horizontalOffset = ValueNotifier(10);
  int add(int number) {
    return number += 1;
  }

  int minus(int number) {
    return number -= 1;
  }

  @override
  void initState() {
    _newView = widget.rightBottomView?.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: [
          // 位置
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                Text('竖向位移'),
                Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _verticalOffset.value =
                                minus(_verticalOffset.value);
                            widget.callbackRightBottomPosition!(Offset(
                                _horizontalOffset.value.toDouble(),
                                _verticalOffset.value.toDouble()));
                          },
                          child: Image.asset(
                            'minus_water_img'.png,
                            width: 40.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('下'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        child: ValueListenableBuilder(
                            valueListenable: _verticalOffset,
                            builder: (context, v, child) {
                              return Text(
                                v.toString(),
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              );
                            })),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _verticalOffset.value = add(_verticalOffset.value);
                            widget.callbackRightBottomPosition!(Offset(
                                _horizontalOffset.value.toDouble(),
                                _verticalOffset.value.toDouble()));
                          },
                          child: Image.asset(
                            'add_water_img'.png,
                            width: 40.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('上'),
                      ],
                    ),
                  ],
                )
              ]),
              Column(children: [
                Text('横向位移'),
                Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _horizontalOffset.value =
                                minus(_horizontalOffset.value);
                            widget.callbackRightBottomPosition!(Offset(
                                _horizontalOffset.value.toDouble(),
                                _verticalOffset.value.toDouble()));
                          },
                          child: Image.asset(
                            'minus_water_img'.png,
                            width: 40.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('右'),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        child: ValueListenableBuilder(
                            valueListenable: _horizontalOffset,
                            builder: (context, v, child) {
                              return Text(
                                v.toString(),
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              );
                            })),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _horizontalOffset.value =
                                add(_horizontalOffset.value);
                            widget.callbackRightBottomPosition!(Offset(
                                _horizontalOffset.value.toDouble(),
                                _verticalOffset.value.toDouble()));
                          },
                          child: Image.asset(
                            'add_water_img'.png,
                            width: 40.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text('左'),
                      ],
                    ),
                  ],
                )
              ]),
              GestureDetector(
                onTap: () {
                  _verticalOffset.value = 10;
                  _horizontalOffset.value = 10;
                  try {
                    widget.callbackRightBottomPosition!(Offset(
                        _horizontalOffset.value.toDouble(),
                        _verticalOffset.value.toDouble()));
                  } catch (e) {
                    showErrorDialog(context, e.toString());
                  }
                },
                child: Image.asset(
                  'reset_img'.png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          // 透明度
          Row(
            children: [
              const Text('透明度'),
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
                      // decoration: BoxDecoration(
                      //   border: Border(
                      //       top:
                      //           BorderSide(color: "f0f0f0".hex, width: 1.w)),
                      // ),
                      child: AssertsImageBuilder('pic_thum'.png,
                          builder: (context, imageInfo) {
                        return ValueListenableBuilder(
                          valueListenable: _opacityPercent,
                          builder: (context, key, child) {
                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 5.w,
                                thumbShape: ImageSliderThumb(
                                    image: imageInfo?.image,
                                    size: const Size(30, 30),
                                    msg: '${key.toInt()}%'),
                              ),
                              child: Slider(
                                divisions: 100,
                                value: key,
                                min: 0,
                                max: 100,
                                activeColor: "e6e9f0".hex,
                                inactiveColor: "e6e9f0".hex,
                                onChanged: (newValue) {
                                  _opacityPercent.value = newValue;
                                  try {
                                    widget.callbackRightBottomOpacity!(
                                        _opacityPercent.value);
                                  } catch (e) {
                                    showErrorDialog(context, e.toString());
                                  }
                                },
                              ),
                            );
                          },
                          // child: ,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _opacityPercent.value = 100;
                  // _newView?.viewAlpha =
                  //     (widget.rightBottomView?.viewAlpha ?? 1) *
                  //         (_opacityPercent.value / 100);
                  try {
                    widget.callbackRightBottomOpacity!(_opacityPercent.value);
                  } catch (e) {
                    showErrorDialog(context, e.toString());
                  }
                },
                child: Image.asset(
                  'reset_img'.png,
                  width: 32.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
