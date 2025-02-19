import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/models/watermark/watermark.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/color_extension.dart';
import 'assert_image_builder.dart';
import 'image_slider_thumb.dart';

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

class StyleEdit extends StatefulWidget {
  final int id;
  final WatermarkView? watermarkView;
  final ValueChanged<WatermarkView>? callbackWatermarkView;
  final ValueChanged<bool>? isColorMix;
  const StyleEdit(
      {super.key,
      this.watermarkView,
      required this.id,
      this.callbackWatermarkView,
      this.isColorMix});

  @override
  State<StyleEdit> createState() => _StyleEditState();
}

class _StyleEditState extends State<StyleEdit> {
  final _scalePercent = ValueNotifier(100.0);
  final _widthPercent = ValueNotifier(100.0);

  WatermarkView? _newwatermarkView;
  WatermarkView? _watermarkView;
  double? _maxWatermarkWidth;
  double? _watermarkWidth;
  double? _minWatermarkWidth;
  final pickerColor = ValueNotifier(Color(0xffffffff));
  List<Color> colorHistory = [];
  void changeColorHistory(List<Color> colors) => colorHistory = colors;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    // setState(() => );
    pickerColor.value = color;
    // print(pickerColor.value);
  }

  @override
  void initState() {
    super.initState();
    // _newwatermarkView = context.read<WatermarkCubit>().watermarkView;
    ////浅拷贝
    // _newwatermarkView = widget.watermarkView;
    //深拷贝
    _watermarkView = widget.watermarkView;
    _newwatermarkView = widget.watermarkView?.copyWith();

    _watermarkWidth = (_watermarkView?.frame?.width ?? 100).w;
    _maxWatermarkWidth = (1.sw / _watermarkWidth!) * 100;
    _minWatermarkWidth = 80;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _scalePercent.value = 100;
                _widthPercent.value = 100;
                _newwatermarkView?.frame?.width =
                    (_watermarkView?.frame?.width ?? 0) *
                        (_widthPercent.value / 100);
                widget.callbackWatermarkView!(_newwatermarkView!);
                // initState();
                // setState(() {});
              },
              child: Row(children: [
                Image.asset('pop_rest'.png, width: 20.w, fit: BoxFit.contain),
                Text("重置", style: TextStyle(color: '136cfe'.hex)),
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
                              bottom:
                                  BorderSide(color: "f0f0f0".hex, width: 1.w)),
                        ),
                        child: AssertsImageBuilder('pic_thum'.png,
                            builder: (context, imageInfo) {
                          return ValueListenableBuilder(
                              valueListenable: _scalePercent,
                              builder: (context, k, child) {
                                return SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 5.w,
                                    showValueIndicator:
                                        ShowValueIndicator.never,
                                    valueIndicatorTextStyle:
                                        TextStyle(fontSize: 11),
                                    thumbShape: ImageSliderThumb(
                                        image: imageInfo?.image,
                                        size: const Size(30, 30),
                                        msg: '${k.toInt()}%'),
                                    valueIndicatorColor: Colors.amber,
                                    //气泡颜色
                                    overlayColor: Colors.amber.withAlpha(150),
                                  ),
                                  child: Slider(
                                    // label: '$_progress1%',
                                    divisions: 100,
                                    value: k,
                                    min: 50,
                                    max: 150,
                                    activeColor: "e6e9f0".hex,
                                    inactiveColor: "e6e9f0".hex,
                                    onChanged: (n) {
                                      // print('onChanged:$value');
                                      // setState(() {
                                      _scalePercent.value = n;
                                      // });
                                    },
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
                              bottom:
                                  BorderSide(color: "f0f0f0".hex, width: 1.w)),
                        ),
                        child: AssertsImageBuilder('pic_thum'.png,
                            builder: (context, imageInfo) {
                          return ValueListenableBuilder(
                            valueListenable: _widthPercent,
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
                                  divisions: ((_maxWatermarkWidth ?? 150) -
                                              _minWatermarkWidth!)
                                          .toInt() +
                                      1,
                                  value: key,
                                  min: _minWatermarkWidth!,
                                  max: _maxWatermarkWidth ?? 150,
                                  activeColor: "e6e9f0".hex,
                                  inactiveColor: "e6e9f0".hex,
                                  onChanged: (newValue) {
                                    _widthPercent.value = newValue;
                                    _newwatermarkView?.frame?.width =
                                        (_watermarkView?.frame?.width ?? 0) *
                                            (newValue / 100);
                                    //       //是否共用一个存储空间
                                    // print(identical(
                                    //     _newwatermarkView, _watermarkView));
                                    // print(_maxWatermarkWidth);
                                    // print(
                                    //     "_newwatermarkView:${_newwatermarkView?.frame?.width}");
                                    // print(
                                    //     "widget.watermarkView:${_watermarkView?.frame?.width}");
                                    widget.callbackWatermarkView!(
                                        _newwatermarkView!);
                                  },
                                ),
                              );
                            },
                            // child: ,
                          );
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
                  ValueListenableBuilder(
                      valueListenable: pickerColor,
                      builder: (context, colorValue, child) {
                        return BlockPicker(
                          availableColors: colorsList,
                          pickerColor: colorValue,
                          onColorChanged: changeColor,
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
                                itemExtent: orientation == Orientation.portrait
                                    ? 50.w
                                    : 80,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      widget.isColorMix!(true);
                                      // });
                                    },
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
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
