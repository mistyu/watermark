import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:watermark_camera/utils/color_extension.dart';

const record = "打卡记录";
const time = "09:57";
const date = "2024.07.05";
const address = "南昌市.莱蒙都会111111111111111111111111111111";
const weather = "晴 32℃";
const bottom_text = "水印相机已确保时间不可篡改";
var record_time_top = Colors.blue;
var record_time_bottom = Colors.black;

var watermark3_theme_color = "ffcb58".hex;
const longitude = "28.6908"; //经度
const latitude = "115.8448"; //纬度
const week = "星期一";
const note = "上班打卡";

class WaterMark3 extends StatelessWidget {
  const WaterMark3({
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
        //时间、日期和日期参数、天气
        Row(
          children: [
            //时间
            Container(
              margin: EdgeInsets.all(5.0.w),
              child: Text(
                time,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            //日期和日期参数、天气
            Container(
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(color: watermark3_theme_color, width: 3.0.w),
              )),
              margin: EdgeInsets.only(left: 5.0.w),
              padding: EdgeInsets.only(left: 5.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //日期
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  //日期参数、天气
                  Row(
                    children: [
                      //日期参数
                      Text(
                        week + " ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      //天气
                      Text(
                        weather,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        //地址
        Container(
          margin: EdgeInsets.only(left: 5.0.w),
          child: Text(
            address,
            style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
          ),
        ),
        //经纬度与备注
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0.w),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(193, 193, 193, 0.49),
                Color.fromRGBO(255, 255, 255, 0)
              ], stops: [
                0.0.w,
                0.9.w
              ])),
          padding: EdgeInsets.all(5.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "经纬度：" + longitude + "°N," + latitude + "°E",
                style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
              ),
              Text(
                "备注：" + note,
                style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
              )
            ],
          ),
        )
      ],
    );
  }
}
