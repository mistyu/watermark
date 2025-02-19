import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/color_extension.dart';

const record = "打卡记录";
const time = "09:57";
const date = "2024.07.05";
const address = "南昌市.莱蒙都会1111111111111111111111111111111111111";
const weather = "晴 32℃";
const bottom_text = "水印相机已确保时间不可篡改";
var record_time_top = Colors.blue;
var record_time_bottom = Colors.black;

const longitude = "28.6908"; //经度
const latitude = "115.8448"; //纬度
const week = "星期一";
const note = "上班打卡";
const name = "哈哈哈";
List listData = [
  {"title": "经纬度", "value": longitude + "," + latitude, "switch": true},
  {"title": "时间", "value": time, "switch": true},
  {"title": "地址", "value": address, "switch": true},
  {"title": "日期", "value": date, "switch": true},
  {"title": "天气", "value": weather, "switch": true},
  {"title": "备注", "value": note, "switch": true},
];

class CustomWaterMarkPanel extends StatefulWidget {
  final Function(double)? onChanged;
  const CustomWaterMarkPanel({super.key, this.onChanged});

  @override
  State<CustomWaterMarkPanel> createState() => _CustomWaterMarkPanelState();
}

class _CustomWaterMarkPanelState extends State<CustomWaterMarkPanel> {
  int _click = 0;
  double _totalSliderValue = 100.0; //整体大小
  double _addressSliderValue = 100.0; //地址大小
  double _wAndhSliderValue = 100.0; //宽窄

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            //修改水印
            Container(
              height: 50.0.w,
              decoration: BoxDecoration(),
              child: Text(
                "111",
                style: TextStyle(color: Colors.black),
              ),
            ),
            //内容
            Container(
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  //tab
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 20.0.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _click = 0;
                              });
                            },
                            child: Text(
                              "编辑内容",
                              style: TextStyle(
                                  color:
                                      _click == 0 ? Colors.blue : Colors.grey),
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.only(right: 20.0.w),
                        child: Text(
                          "|",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(right: 20.0.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _click = 1;
                              });
                            },
                            child: Text(
                              "颜色/大小/样式",
                              style: TextStyle(
                                  color:
                                      _click == 1 ? Colors.blue : Colors.grey),
                            ),
                          )),
                    ],
                  ),
                  //编辑内容
                  Visibility(
                      visible: _click == 0,
                      child: Container(
                        height: 210.0.w,
                        margin: EdgeInsets.only(top: 20.0.w),
                        child: ListView(
                            children: listData.map((obj) {
                          return SizedBox(
                              height: 60.0.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CupertinoSwitch(
                                        value: obj["switch"] || false,
                                        activeColor: CupertinoColors.activeBlue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            obj["switch"] = value ?? false;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        obj["title"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0.sp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 0.5.sw,
                                        child: Text(
                                          obj["value"],
                                          maxLines: 2,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0.sp),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0.w),
                                        child: Text(">",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0.sp)),
                                      ),
                                    ],
                                  )
                                ],
                              ));
                        }).toList()),
                      )),
                  //颜色大小样式
                  Visibility(
                      visible: _click != 0,
                      child: Container(
                        height: 210.0.w,
                        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                        margin: EdgeInsets.only(top: 10.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // 重置
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0.w, vertical: 4.0.w),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1.0.w,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(5.0.w)),
                              child: Text(
                                "重置",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            //大小
                            Container(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('大小'),
                                  Expanded(
                                    child: SliderTheme(
                                        data: const SliderThemeData(
                                          /// 显示的 label 的背景色
                                          valueIndicatorColor: Colors.white,

                                          /// 显示的 label 的文本样式
                                          valueIndicatorTextStyle: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14.0),

                                          /// 显示的 label 的形状
                                          valueIndicatorShape:
                                              RectangularSliderValueIndicatorShape(),
                                        ),
                                        child: Slider(
                                          min: 80,
                                          max: 120,
                                          value: _totalSliderValue,
                                          divisions: 40,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                          label:
                                              '${_totalSliderValue.round()}%',
                                          onChanged: (value) {
                                            widget.onChanged!(value);
                                            setState(() {
                                              _totalSliderValue = value;
                                            });
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            //地址大小
                            Container(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('地址大小'),
                                  Expanded(
                                    child: SliderTheme(
                                        data: const SliderThemeData(
                                          /// 显示的 label 的背景色
                                          valueIndicatorColor: Colors.white,

                                          /// 显示的 label 的文本样式
                                          valueIndicatorTextStyle: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14.0),

                                          /// 显示的 label 的形状
                                          valueIndicatorShape:
                                              RectangularSliderValueIndicatorShape(),
                                        ),
                                        child: Slider(
                                          min: 80,
                                          max: 120,
                                          value: _addressSliderValue,
                                          divisions: 40,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                          label:
                                              '${_addressSliderValue.round()}%',
                                          onChanged: (value) {
                                            setState(() {
                                              _addressSliderValue = value;
                                            });
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            //宽窄
                            Container(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('宽窄'),
                                  Expanded(
                                    child: SliderTheme(
                                        data: const SliderThemeData(
                                          /// 显示的 label 的背景色
                                          valueIndicatorColor: Colors.white,

                                          /// 显示的 label 的文本样式
                                          valueIndicatorTextStyle: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14.0),

                                          /// 显示的 label 的形状
                                          valueIndicatorShape:
                                              RectangularSliderValueIndicatorShape(),
                                        ),
                                        child: Slider(
                                          min: 80,
                                          max: 120,
                                          value: _wAndhSliderValue,
                                          divisions: 40,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                          label:
                                              '${_wAndhSliderValue.round()}%',
                                          onChanged: (value) {
                                            setState(() {
                                              _wAndhSliderValue = value;
                                            });
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            //收藏
            Container(
              height: 50.0.w,
              // width: 200.0.w,
              decoration: BoxDecoration(
                  // border: Border.all(
                  //     color: Colors.black,
                  //     style: BorderStyle.solid,
                  //     width: 2.0.w)
                  ),
              child: Text(
                "333",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
