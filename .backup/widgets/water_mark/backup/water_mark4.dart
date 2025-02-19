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
const longitude = "28.6908"; //经度
const latitude = "115.8448"; //纬度
const week = "星期一";
const note = "上班打卡";
const name = "哈哈哈";

var watermark4_theme_color = "06c3a5".hex;

class WaterMark4 extends StatelessWidget {
  const WaterMark4({
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
        // 打卡记录
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(2.0.r)),
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0.w),
            padding: EdgeInsets.all(3.0.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 打卡标题
                Container(
                  decoration: BoxDecoration(
                    color: watermark4_theme_color,
                    borderRadius: BorderRadius.all(Radius.circular(1.5.r)),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 4.w),
                  child: Text(
                    "√ " + record,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
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
                      color: watermark4_theme_color,
                    ),
                  ),
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
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
            //日期参数
            Text(
              week,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ],
        )),

        // 地址、经纬度、昵称等
        Container(
          // padding: EdgeInsets.only(left: 5.0.w),
          constraints: BoxConstraints(maxWidth: 200.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 地址
              Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //圆点
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                    width: 4.0.w,
                    height: 4.0.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4.0.r))),
                  ),
                  Expanded(
                    child: Text(
                      address,
                      style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                    ),
                  )
                ],
              )),
              // 经纬度
              Container(
                  child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                    width: 4.0.w,
                    height: 4.0.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
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
                    margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                    width: 4.0.w,
                    height: 4.0.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
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
      ],
    );
  }
}
