import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/asset_utils.dart';
import 'package:watermark_camera/utils/color_extension.dart';

const record = "打卡记录";
const time = "09:57";
const date = "2024.07.05";
const address = "南昌市.莱蒙都会111111111111111111111111111111";
const weather = "晴 32℃";
const bottom_text = "水印相机已确保时间不可篡改";
var record_time_top = Colors.blue;
var record_time_bottom = Colors.black;
var watermark2_theme_color = "ffcb58".hex;
const longitude = "28.6908"; //经度
const latitude = "115.8448"; //纬度
const week = "星期一";
const note = "上班打卡";

class WaterMark2 extends StatelessWidget {
  const WaterMark2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // VIP
        const Placeholder(fallbackWidth: 30, fallbackHeight: 20),
        // 打卡记录
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(3.0.r)),
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0.w),
            padding: EdgeInsets.symmetric(horizontal: 3.0.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 打卡标题
                Container(
                  decoration: BoxDecoration(
                    color: watermark2_theme_color,
                    borderRadius: BorderRadius.all(Radius.circular(3.0.r)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    record,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // 时间
                Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                  child: Text(
                    time,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [record_time_top, record_time_bottom])
                              .createShader(Rect.fromLTWH(0, 20, 150, 50))),
                  ),
                )
              ],
            )),
        // 日期、日期参数、地址等
        Container(
          decoration: BoxDecoration(
              border: Border(
            left: BorderSide(color: watermark2_theme_color, width: 3.0.w),
          )),
          padding: EdgeInsets.only(left: 5.0.w),
          constraints: BoxConstraints(maxWidth: 200.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 地址
              Container(
                child: Text(
                  address,
                  style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                ),
              ),
              // 经纬度
              Container(
                  child: Row(
                children: [
                  Text(
                    longitude + "°N,",
                    style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                  ),
                  Text(
                    latitude + "°E",
                    style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                  )
                ],
              )),
              // 日期与日期参数
              Container(
                  child: Row(
                children: [
                  //日期
                  Text(
                    date + " ",
                    style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                  ),
                  //日期参数
                  Text(
                    week,
                    style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                  ),
                ],
              )),
              // 天气
              Container(
                child: Text(
                  weather,
                  style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                ),
              ),
            ],
          ),
        ),
        //备注
        Container(
          decoration: BoxDecoration(
              // border: Border.all(
              //     color: Colors.black, width: 3.0.w, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(3.0.w),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(177, 177, 177, 0.494),
                Color.fromRGBO(255, 255, 255, 0)
              ], stops: [
                0.0.w,
                0.5.w
              ])),
          padding: EdgeInsets.all(5.0.w),
          margin: EdgeInsets.only(top: 2.0.w),
          child: Text(
            note,
            style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
          ),
        ),
        // 证
        Container(
            margin: EdgeInsets.only(top: 10.0.w),
            child: Row(
              children: [
                //image
                Container(
                  width: 15.0.w,
                  height: 15.0.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("R".png), fit: BoxFit.fill),
                  ),
                ),
                //文字
                Container(
                  margin: EdgeInsets.only(left: 5.0.w),
                  child: Text(
                    bottom_text,
                    style: TextStyle(color: Colors.white, fontSize: 9.8.sp),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
