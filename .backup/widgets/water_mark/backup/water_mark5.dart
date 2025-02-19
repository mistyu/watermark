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

var watermark5_theme_color = "ffcb58".hex;
const longitude = "28.6908"; //经度
const latitude = "115.8448"; //纬度
const week = "星期一";
const note = "上班打卡";
const name = "哈哈哈";
const watermark5_hour = "17";
const watermark5_minute = "30";
const watermark5_second = "41";
var watermark5_gradient = LinearGradient(
  colors: [
    Color.fromARGB(235, 96, 82, 82),
    Color.fromARGB(235, 113, 113, 113),
  ],
);

class WaterMark5 extends StatelessWidget {
  const WaterMark5({
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
          //品牌图片
          Container(
            width: 100.0.w,
            height: 50.0.w,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("R".png), fit: BoxFit.fill),
            ),
          ),
          //时间
          Container(
            margin: EdgeInsets.fromLTRB(0, 10.0.w, 0, 5.0.w),
            child: Row(
              children: [
                // 时
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0.w),
                    gradient: watermark5_gradient,
                  ),
                  padding: EdgeInsets.all(6.0.w),
                  child: Text(
                    watermark5_hour,
                    style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Text(
                    ":",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // 分
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0.w),
                    gradient: watermark5_gradient,
                  ),
                  padding: EdgeInsets.all(6.0.w),
                  child: Text(
                    watermark5_minute,
                    style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Text(
                    ":",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // 秒
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0.w),
                    gradient: watermark5_gradient,
                  ),
                  padding: EdgeInsets.all(6.0.w),
                  child: Text(
                    watermark5_second,
                    style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
                  ),
                )
              ],
            ),
          ),
          //日期与日期参数
          Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: watermark5_theme_color, width: 3.0.w),
                ),
              ),
              // constraints: BoxConstraints(maxWidth: double.minPositive),
              padding: EdgeInsets.only(bottom: 5.0.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //日期
                  Container(
                    margin: EdgeInsets.only(right: 5.0.w),
                    child: Text(
                      date,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //日期参数
                  Text(
                    week,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          //地址、天气、经纬度、备注等
          Container(
            constraints: BoxConstraints(maxWidth: 200.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 地址
                Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //图片
                    Container(
                      margin: EdgeInsets.fromLTRB(5.0.w, 3.0.w, 8.0.w, 0),
                      width: 10.0.w,
                      height: 10.0.w,
                      child: Image.asset("R".png),
                    ),
                    Expanded(
                      child: Text(
                        address,
                        style:
                            TextStyle(color: Colors.white, fontSize: 12.0.sp),
                      ),
                    )
                  ],
                )),
                //天气
                Container(
                    child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5.0.w, 0, 8.0.w, 0),
                      width: 10.0.w,
                      height: 10.0.w,
                      child: Image.asset("R".png),
                    ),
                    Text(
                      weather,
                      style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                    ),
                  ],
                )),
                // 经纬度
                Container(
                    child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5.0.w, 0, 8.0.w, 0),
                      width: 10.0.w,
                      height: 10.0.w,
                      child: Image.asset("R".png),
                    ),
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
                //备注
                Container(
                    child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5.0.w, 0, 8.0.w, 0),
                      width: 10.0.w,
                      height: 10.0.w,
                      child: Image.asset("R".png),
                    ),
                    Text(
                      note,
                      style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                    ),
                  ],
                )),
                // 昵称
                Container(
                    child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5.0.w, 0, 8.0.w, 0),
                      width: 10.0.w,
                      height: 10.0.w,
                      child: Image.asset("R".png),
                    ),
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                    ),
                  ],
                )),
              ],
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
        ]);
  }
}
