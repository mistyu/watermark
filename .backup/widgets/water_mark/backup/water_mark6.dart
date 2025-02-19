import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
List listData = [
  {"title": "经度", "value": longitude},
  {"title": "纬度", "value": latitude},
  {"title": "地址", "value": address},
  {"title": "时间", "value": date + " " + time},
  {"title": "天气", "value": weather},
  {"title": "备注", "value": note},
];

class WaterMark6 extends StatelessWidget {
  const WaterMark6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // VIP
        const Placeholder(fallbackWidth: 30, fallbackHeight: 20),
        //主体
        Container(
          height: 160.0.w,
          child: ListView(
              // padding: EdgeInsets.all(8),
              children: listData.map((obj) {
            return Container(
                child: Text(
              obj["title"] + ": " + obj["value"],
              style: TextStyle(color: Colors.white, fontSize: 14.0.sp),
            ));
          }).toList()),
        )
      ],
    );
  }
}
