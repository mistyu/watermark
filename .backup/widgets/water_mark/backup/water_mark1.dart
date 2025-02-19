import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/color_extension.dart';

const record = "打卡记录";
const time = "09:57";
const date = "2024.07.05";
const address = "南昌市.莱蒙都会";
const weather = "晴 32℃";
const bottom_text = "水印相机已确保时间不可篡改";
const longitude = "28.6908"; //经度
const latitude = "115.8448"; //纬度
const week = "星期一";
const note = "上班打卡";
var record_time_top = Colors.blue;
var record_time_bottom = Colors.black;
var watermark1_theme_color = "18b4ef".hex;

class WaterMark1 extends StatelessWidget {
  const WaterMark1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // VI
        // 打卡记录
        Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 打卡记录文字
            Container(
              decoration: BoxDecoration(
                color: watermark1_theme_color,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(5.0.r)),
              ),
              padding: EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 8.0.w),
              child: Text(
                record,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
            // 打卡记录时间
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(5.0.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Text(
                time,
                style: TextStyle(color: Colors.black, fontSize: 21.sp),
              ),
            )
          ],
        )),
        // 时间、地址、天气等
        Container(
          // color: Colors.red,
          decoration: BoxDecoration(),
          margin: EdgeInsets.only(top: 10.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 日期与日期参数
              Container(
                  child: Row(
                children: [
                  //日期
                  Text(
                    date + " ",
                    style: TextStyle(color: Colors.white, fontSize: 9.8.sp),
                  ),
                  //日期参数
                  Text(
                    week,
                    style: TextStyle(color: Colors.white, fontSize: 9.8.sp),
                  ),
                ],
              )),
              // 地址
              Container(
                child: Text(
                  address,
                  style: TextStyle(color: Colors.white, fontSize: 9.8.sp),
                ),
              ),
              // 经纬度
              Container(
                  child: Row(
                children: [
                  Text(
                    longitude + "°N,",
                    style: TextStyle(color: Colors.white, fontSize: 9.8.sp),
                  ),
                  Text(
                    latitude + "°E",
                    style: TextStyle(color: Colors.white, fontSize: 9.8.sp),
                  )
                ],
              )),
              // 天气
              Container(
                child: Text(
                  weather,
                  style: TextStyle(color: Colors.white, fontSize: 9.8.sp),
                ),
              ),
            ],
          ),
        ),
        // 证
        Container(
            margin: EdgeInsets.only(top: 10.0.w),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white,
                          width: 0.5.w,
                          style: BorderStyle.solid),
                    ),
                    padding: EdgeInsets.all(0.3.w),
                    child: Container(
                      // 圆
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 0.5.w,
                            style: BorderStyle.solid),
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: Text(
                        "证",
                        style: TextStyle(color: Colors.white, fontSize: 5.sp),
                      ),
                    )),
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
